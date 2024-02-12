  -- Base
import XMonad
import System.Directory
import System.IO (hClose, hPutStr, hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M
    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns


    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

import Colors.GruvboxDark
import XMonad.Actions.Launcher (LauncherConfig(browser))
import XMonad.Actions.Submap (submap)

myTerminal :: String
myTerminal = "alacritty"

myEditor :: String
myEditor = myTerminal ++ " -e nvim "

myMusicPlayer :: String
myMusicPlayer = myTerminal ++ " -e cmus"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth = 2

myModMask :: KeyMask
myModMask = mod4Mask

myAltMask :: KeyMask
myAltMask = mod1Mask

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
           $ limitWindows 5
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ simplestFloat
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def {
                  activeColor         = color15,
                  inactiveColor       = color08,
                  activeBorderColor   = color15,
                  inactiveBorderColor = colorBack,
                  activeTextColor     = colorBack,
                  inactiveTextColor   = color16
                 }

myLayoutHook = avoidStruts
               $ mouseResize
               $ windowArrange
               $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout = withBorder myBorderWidth tall
                                           ||| noBorders monocle
                                           ||| floats
                                           ||| noBorders tabs
myWorkspaces = [" dev ", " www ", " chat ", " mus ", " vid ", " VI ", " VII ", " VIII ", "sys"]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y),

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myNormalBorderColor :: String
myNormalBorderColor  = "#af3a03"

myFocusedBorderColor :: String
myFocusedBorderColor = "#fe8019"

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
  { swn_font              = "xft:Ubuntu:bold:size=60",
   swn_fade              = 1.0,
   swn_bgcolor           = "#1c1f24",
   swn_color             = "#ffffff"
  }

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm ,xK_Return), spawn myTerminal),

    -- launch browsers
     ((modm, xK_b ), submap . M.fromList $
       [
          ((0, xK_q), spawn "qutebrowser"),
          ((0, xK_b), spawn "brave"),
          ((0, xK_f), spawn "firefox")
       ]),

    -- start sound programs
     ((modm ,xK_comma), spawn "blueberry & pavucontrol"),

    -- launch music player
     ((modm ,xK_m), spawn myMusicPlayer),

    -- launch the best text editor ever created
     ((modm ,xK_i), spawn myEditor),

    -- close focused window
     ((modm .|. shiftMask, xK_q), kill),

     -- Rotate through the available layout algorithms
     ((modm               ,xK_Tab ), sendMessage NextLayout),

    --  Reset the layouts on the current workspace to default
     ((modm .|. shiftMask ,xK_Tab ), setLayout $ XMonad.layoutHook conf),


    -- Resize viewed windows to the correct size
     ((modm               ,xK_n     ), refresh),

    -- Move focus to the next window
     ((modm               ,xK_j     ), windows W.focusDown),

    -- Move focus to the previous window
     ((modm               ,xK_k     ), windows W.focusUp  ),

    -- Swap the focused window with the next window
     ((modm .|. shiftMask ,xK_j), windows W.swapDown),

    -- Swap the focused window with the previous window
     ((modm .|. shiftMask ,xK_k), windows W.swapUp),

    -- Shrink the master area
     ((modm               ,xK_h     ), sendMessage Shrink),

    -- Expand the master area
     ((modm               ,xK_l     ), sendMessage Expand),

    -- Push window back into tiling
     ((modm               ,xK_t     ), withFocused $ windows . W.sink),

    -- Deincrement the number of windows in the master area
     ((modm               ,xK_period), prevScreen ),

    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- Toggle the status bar gap
    -- See also the statusBar function from Hooks.DynamicLog.

     ((modm               ,xK_f     ), sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts),

    -- Restart xmonad
     ((modm .|. shiftMask ,xK_c), spawn "xmonad --recompile; xmonad --restart"),

    -- Resize Windows
     ((myAltMask .|. controlMask ,xK_j), decWindowSpacing 4),
     ((myAltMask .|. controlMask ,xK_k), incWindowSpacing 4),
     ((myAltMask .|. controlMask ,xK_h), decScreenSpacing 4),
     ((myAltMask .|. controlMask ,xK_l), incScreenSpacing 4),

    -- Dmenu scripts
     ((modm ,xK_d), spawn "dmenu_run"),

    -- Screenshot
     ((modm, xK_p), spawn "maim | xclip -selection clipboard -t image/png"),
     ((modm .|. shiftMask, xK_p), spawn "maim -s | xclip -selection clipboard -t image/png")
    ]
    ++
    --
    -- mod-[1..9] Switch to workspace N,
    -- mod-shift-[1..9] Move client to workspace N,
    --


    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{wer}, Switch to physical/Xinerama screens 1, 2, or 3,
    -- mod-shift-{we,r}, Move client to screen 1, 2, or 3,
    --

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList

    -- mod-button1 Set the window to floating mode and move by dragging,
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)),

    -- mod-button2, Raise the window to the top of the stack
     ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),

    -- mod-button3, Set the window to floating mode and resize by dragging
     ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [
     className =? "java-lang-Thread"    --> doCenterFloat,
     className =? "Blueberry.py"   --> doCenterFloat,
     className =? "brave-browser"  --> doShift ( myWorkspaces !! 1 ),
     className =? "firefox"  --> doShift ( myWorkspaces !! 7 ),
     className =? "qutebrowser"  --> doShift ( myWorkspaces !! 7 ),
     className =? "vlc"            --> doShift ( myWorkspaces !! 4 ),
     className =? "discord"        --> doShift ( myWorkspaces !! 2 ),
     className =? "TelegramDesktop"        --> doShift ( myWorkspaces !! 2 ),
     isFullscreen --> doFullFloat
    ]

myStartupHook :: X ()
myStartupHook = do
  spawn "setxkbmap -option caps:escape"
  spawn "killall xmobar &"
  spawn "syncthing --no-browser"
  spawnOnce "redshift -l 48.159228:17.122007 &"
  spawnOnce "~/.fehbg &"
  spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 2 --transparent true --alpha 0 " ++ colorTrayer ++ " --height 22")

  setWMName "XMonad"


main :: IO ()
main = do
  xmproc0 <- spawnPipe ("xmobar -x 0 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc")
  xmproc1 <- spawnPipe ("xmobar -x 1 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc")

  xmonad $ ewmh $ docks $ def
    { manageHook         = myManageHook <+> manageDocks,
     modMask            = myModMask,
     terminal           = myTerminal,
     startupHook        = myStartupHook,
     layoutHook         = showWName' myShowWNameTheme myLayoutHook,
     workspaces         = myWorkspaces,
     borderWidth        = myBorderWidth,
     keys               = myKeys,
     normalBorderColor  = myNormalBorderColor,
     focusedBorderColor = myFocusedBorderColor,
     logHook = dynamicLogWithPP $  filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
        { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
                        >> hPutStrLn xmproc1 x,   -- xmobar on monitor 2
         ppCurrent = xmobarColor color06 "" . wrap
        ("[<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>]",
          -- Visible but not current workspace
         ppVisible = xmobarColor color06 "" . clickable,
          -- Hidden workspace
         ppHidden = xmobarColor color05 "" . wrap
                     ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>" . clickable,
          -- Hidden workspaces (no windows)
         ppHiddenNoWindows = xmobarColor color05 ""  . clickable,
          -- Title of active window
         ppTitle = xmobarColor color16 "" . shorten 60,
          -- Separator character
         ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>",
          -- Urgent workspace
         ppUrgent = xmobarColor color02 "" . wrap "!" "!",
          -- Adding # of windows on current workspace to the bar
         ppExtras  = [windowCount],
          -- order of things in xmobar
         ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
        }
    }
