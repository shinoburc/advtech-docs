---
sidebar_position: 4
---

# Layout

以下の構成でシステム全体のレイアウトを実装します。

- Layoutコンポーネント: 全体のレイアウトを決めるコンポーネント。 Menu コンポーネントを読み込んで表示するのも Layout コンポーネントで行う。
- Menuコンポーネント: システムメニューを設定するコンポーネント。
- AccountInfoコンポーネント: ログイン中のユーザ情報を表示する。ログアウトを行う「Sign out」ボタンも AccountInfo コンポーネントにて行う。

本来、Next.js には Layouts と呼ばれる仕組みがあり、それを利用した方がより柔軟で良い設計となりますが、今回は利用していません。

[Next.js - Layouts](https://nextjs.org/docs/basic-features/layouts)

## Menu コンポーネントの実装

プロジェクト直下に「layout」というディレクトリを作成し、その中にレイアウト関連コンポーネントを配置します。

今後、メニューを追加する場合はこのコンポーネントを変更してください。

layoutディレクトリを作成し、まずは Menu コンポーネントを以下のように実装してください。

```tsx title="layout/Menu.tsx"
import * as React from "react";
import Link from "next/link";
import ListItemButton from "@mui/material/ListItemButton";
import ListItemIcon from "@mui/material/ListItemIcon";
import ListItemText from "@mui/material/ListItemText";
import ListSubheader from "@mui/material/ListSubheader";
import DashboardIcon from "@mui/icons-material/Dashboard";
import ShoppingCartIcon from "@mui/icons-material/ShoppingCart";
import PeopleIcon from "@mui/icons-material/People";
import BarChartIcon from "@mui/icons-material/BarChart";
import LayersIcon from "@mui/icons-material/Layers";
import AssignmentIcon from "@mui/icons-material/Assignment";

export const mainMenu = (
  <React.Fragment>
    <Link href="/" passHref>
      <ListItemButton>
        <ListItemIcon>
          <DashboardIcon />
        </ListItemIcon>
        <ListItemText primary="ThanksCard" />
      </ListItemButton>
    </Link>
    <Link href="/user" passHref>
      <ListItemButton>
        <ListItemIcon>
          <PeopleIcon />
        </ListItemIcon>
        <ListItemText primary="User" />
      </ListItemButton>
    </Link>
    <ListItemButton>
      <ListItemIcon>
        <BarChartIcon />
      </ListItemIcon>
      <ListItemText primary="Reports" />
    </ListItemButton>
    <ListItemButton>
      <ListItemIcon>
        <LayersIcon />
      </ListItemIcon>
      <ListItemText primary="Integrations" />
    </ListItemButton>
  </React.Fragment>
);

export const secondaryMenu = (
  <React.Fragment>
    <ListSubheader component="div" inset>
      Saved reports
    </ListSubheader>
    <ListItemButton>
      <ListItemIcon>
        <AssignmentIcon />
      </ListItemIcon>
      <ListItemText primary="Current month" />
    </ListItemButton>
    <ListItemButton>
      <ListItemIcon>
        <AssignmentIcon />
      </ListItemIcon>
      <ListItemText primary="Last quarter" />
    </ListItemButton>
    <ListItemButton>
      <ListItemIcon>
        <AssignmentIcon />
      </ListItemIcon>
      <ListItemText primary="Year-end sale" />
    </ListItemButton>
  </React.Fragment>
);
```

## AccountInfo コンポーネントの実装

ログイン中のユーザ情報を表示し、「Sign out」ボタンを描画する AccountInfo コンポーネントを実装します。

layoutディレクトリ以下に以下のように実装してください。

```tsx title="layout/AccountInfo.tsx"
import React from "react";
import Button from "@mui/material/Button";

import { useSession, signIn, signOut } from "next-auth/react";
import PersonIcon from "@mui/icons-material/Person";

const AccountInfo = () => {
  const { data: session, status } = useSession();
  return (
    <>
      {status === "authenticated" && (
        <>
          <PersonIcon />
          <span>Signed in as {session?.user?.name}</span>
          <Button
            onClick={() => signOut()}
            variant="contained"
            color="secondary"
          >
            Sign out
          </Button>
        </>
      )}
      {status !== "authenticated" && (
        <Button onClick={() => signIn()} variant="contained" color="secondary">
          Sign in
        </Button>
      )}
    </>
  );
};

export default AccountInfo;
```

## Layout コンポーネントの実装

全体のレイアウトを決めるコンポーネント Layout コンポーネントを実装します。 Menu コンポーネントを読み込んで表示するのも Layout コンポーネントで行います。

かなり複雑な設定がされていますが、material-ui が提供していくれている「Dashboard template」をほぼそのまま活用しています。

[material-ui Dashboard template](https://github.com/mui/material-ui/tree/v5.10.2/docs/data/material/getting-started/templates/dashboard)

layoutディレクトリ以下に以下のように実装してください。

```tsx title="layout/Layout.tsx"
// reference: https://github.com/mui/material-ui/tree/v5.10.2/docs/data/material/getting-started/templates/dashboard

import * as React from "react";
import { ReactElement } from "react";
import { styled, createTheme, ThemeProvider } from "@mui/material/styles";
import CssBaseline from "@mui/material/CssBaseline";
import MuiDrawer from "@mui/material/Drawer";
import Box from "@mui/material/Box";
import MuiAppBar, { AppBarProps as MuiAppBarProps } from "@mui/material/AppBar";
import Toolbar from "@mui/material/Toolbar";
import List from "@mui/material/List";
import Typography from "@mui/material/Typography";
import Divider from "@mui/material/Divider";
import IconButton from "@mui/material/IconButton";
import Badge from "@mui/material/Badge";
import Container from "@mui/material/Container";
import Grid from "@mui/material/Grid";
import Paper from "@mui/material/Paper";
import Link from "@mui/material/Link";
import MenuIcon from "@mui/icons-material/Menu";
import ChevronLeftIcon from "@mui/icons-material/ChevronLeft";
import NotificationsIcon from "@mui/icons-material/Notifications";
import { mainMenu, secondaryMenu } from "./Menu";
import AccountInfo from "./AccountInfo";
/*
import Chart from "./Chart";
import Deposits from "./Deposits";
import Orders from "./Orders";
*/

function Copyright(props: any) {
  return (
    <Typography
      variant="body2"
      color="text.secondary"
      align="center"
      {...props}
    >
      {"Copyright © "}
      <Link color="inherit" href="https://mui.com/">
        Your Website
      </Link>{" "}
      {new Date().getFullYear()}
      {"."}
    </Typography>
  );
}

const drawerWidth: number = 240;

interface AppBarProps extends MuiAppBarProps {
  open?: boolean;
}

const AppBar = styled(MuiAppBar, {
  shouldForwardProp: (prop) => prop !== "open",
})<AppBarProps>(({ theme, open }) => ({
  zIndex: theme.zIndex.drawer + 1,
  transition: theme.transitions.create(["width", "margin"], {
    easing: theme.transitions.easing.sharp,
    duration: theme.transitions.duration.leavingScreen,
  }),
  ...(open && {
    marginLeft: drawerWidth,
    width: `calc(100% - ${drawerWidth}px)`,
    transition: theme.transitions.create(["width", "margin"], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  }),
}));

const Drawer = styled(MuiDrawer, {
  shouldForwardProp: (prop) => prop !== "open",
})(({ theme, open }) => ({
  "& .MuiDrawer-paper": {
    position: "relative",
    whiteSpace: "nowrap",
    width: drawerWidth,
    transition: theme.transitions.create("width", {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
    boxSizing: "border-box",
    ...(!open && {
      overflowX: "hidden",
      transition: theme.transitions.create("width", {
        easing: theme.transitions.easing.sharp,
        duration: theme.transitions.duration.leavingScreen,
      }),
      width: theme.spacing(7),
      [theme.breakpoints.up("sm")]: {
        width: theme.spacing(9),
      },
    }),
  },
}));

const mdTheme = createTheme({
  /*
  palette: {
    mode: "light",
    primary: {
      main: "#d87274",
      light: "#ffa2a3",
      dark: "#a34449",
    },
  },
  */
});

type LayoutProps = Required<{
  readonly children: ReactElement;
}>;

export default function Layout({ children }: LayoutProps) {
  const [open, setOpen] = React.useState(true);
  const toggleDrawer = () => {
    setOpen(!open);
  };

  return (
    <ThemeProvider theme={mdTheme}>
      <Box sx={{ display: "flex" }}>
        <CssBaseline />
        <AppBar position="absolute" open={open}>
          <Toolbar
            sx={{
              pr: "24px", // keep right padding when drawer closed
            }}
          >
            <IconButton
              edge="start"
              color="inherit"
              aria-label="open drawer"
              onClick={toggleDrawer}
              sx={{
                marginRight: "36px",
                ...(open && { display: "none" }),
              }}
            >
              <MenuIcon />
            </IconButton>
            <Typography
              component="h1"
              variant="h6"
              color="inherit"
              noWrap
              sx={{ flexGrow: 1 }}
            >
              ThanksCard
            </Typography>
            <AccountInfo />
            <IconButton color="inherit">
              <Badge badgeContent={4} color="secondary">
                <NotificationsIcon />
              </Badge>
            </IconButton>
          </Toolbar>
        </AppBar>
        <Drawer variant="permanent" open={open}>
          <Toolbar
            sx={{
              display: "flex",
              alignItems: "center",
              justifyContent: "flex-end",
              px: [1],
            }}
          >
            <IconButton onClick={toggleDrawer}>
              <ChevronLeftIcon />
            </IconButton>
          </Toolbar>
          <Divider />
          <List component="nav">
            {mainMenu}
            <Divider sx={{ my: 1 }} />
            {secondaryMenu}
          </List>
        </Drawer>
        <Box
          component="main"
          sx={{
            backgroundColor: (theme) =>
              theme.palette.mode === "light"
                ? theme.palette.grey[100]
                : theme.palette.grey[900],
            flexGrow: 1,
            height: "100vh",
            overflow: "auto",
          }}
        >
          <Toolbar />
          <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
            <Grid container spacing={3}>
              {/* Chart */}
              <Grid item xs={12} md={8} lg={18}>
                <Paper
                  sx={{
                    p: 2,
                    display: "flex",
                    flexDirection: "column",
                    height: 600,
                  }}
                >
                  {children}
                  {/*<Chart />*/}
                </Paper>
              </Grid>
              {/* Recent Deposits */}
              <Grid item xs={12} md={4} lg={3}>
                <Paper
                  sx={{
                    p: 2,
                    display: "flex",
                    flexDirection: "column",
                    height: 140,
                  }}
                >
                  <span>deposits</span>
                  {/*<Deposits />*/}
                </Paper>
              </Grid>
              {/* Recent Orders */}
              <Grid item xs={12}>
                <Paper sx={{ p: 2, display: "flex", flexDirection: "column" }}>
                  <span>orders</span>
                  {/*<Orders />*/}
                </Paper>
              </Grid>
            </Grid>
            <Copyright sx={{ pt: 4 }} />
          </Container>
        </Box>
      </Box>
    </ThemeProvider>
  );
}
```

## Layout の適用

実際に Layout コンポーネントをシステム全体に適用します。

Next.js では必ず「pages/_app.tsx」から画面が作られるため、 _app.tsx に変更を加えます。

今回新たに利用している「SessionProvider コンポーネント」は next-auth が提供しているコンポーネントで、「ユーザがログイン中かどうか」や「ログイン中のユーザ情報」を Session として提供してくれます。AccountInfo コンポーネントでは、この Session を利用してログイン中のユーザ情報を表示しています。

以下のように _app.tsx を変更してください。

```tsx title="pages/_app.tsx"
import "../styles/globals.css";
import type { AppProps } from "next/app";
import React from "react";
import { Session } from "next-auth";
import { SessionProvider } from "next-auth/react";
import Layout from "../layout/Layout";

//function MyApp({ Component, pageProps: { session, ...pageProps } }: AppProps) {
function MyApp({ Component, pageProps }: AppProps<{ session: Session }>) {
  return (
    <SessionProvider session={pageProps.session}>
      <Layout>
        <Component {...pageProps} />
      </Layout>
    </SessionProvider>
  );
}

export default MyApp;
```