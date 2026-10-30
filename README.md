# Neotys Training Chat

The chat application used by the NeoLoad training exercise **RB_Chat** (RealBrowser user path): log in with a nickname, enter the **NeoLoad** room, wait until the trainer posts **"Hello"**, answer **"Hi"**, then log out.

It is the free "Chat Application using JSP and Servlets" written in 2003 by **Sukhwinder Singh** (ssruprai@hotmail.com, [Web Tech India](https://www.web-tech-india.com/software/jsp_chat.php)), which the author allows to be used freely as long as the author information stays in the files. Changes from the original:

- Branding: "S2R Chat" becomes "Neotys Training Chat".
- Rooms (`webapp/WEB-INF/chat.properties`): NeoLoad, Collaborative, Cloud, RIA.
- Rooms are listed in file order (the original used a `HashMap`, so the order was random). NeoLoad is always the first radio button, which the recorded XPaths rely on.
- Served at `/neotys-chat`, like the original training server.

## Pages

| Page | What it does |
|---|---|
| `/neotys-chat` | 302 to `/neotys-chat/`, the login page (Nickname, Sex, Submit) |
| `servlet/login` | Logs in, redirects to `listrooms.jsp` |
| `listrooms.jsp` | Room list with radio buttons and a **Start** button |
| `start.jsp` | Enters the room, redirects to `chat.jsp` |
| `chat.jsp` | Frameset: frame 1 `displayMessages.jsp` (messages, reloads every 10 s), frame 2 `sendMessage.jsp` (message box, Send, Logout) |
| `logout.jsp` | Logs out |

Messages are kept in memory (last 25 per room). A user only sees messages posted after they entered the room, so the trainer should post "Hello" once the trainees' scripts are waiting.

## Deploy on Render (free)

**New → Web Service → Public Git Repository**, paste this repository's URL, keep **Docker**, choose **Free**, and deploy. The chat is then at `https://<service>.onrender.com/neotys-chat`.

The free instance sleeps after 15 minutes without traffic and takes about a minute to wake up, so open the URL before the exercise. A restart clears all users and messages.

## Run locally

```
docker build -t neotys-chat .
docker run -p 8083:8080 neotys-chat
```

Then open http://localhost:8083/neotys-chat.
