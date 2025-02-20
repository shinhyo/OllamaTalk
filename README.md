<p align="center">
  <img src="https://github.com/shinhyo/OllamaTalk/blob/v0.1.0/assets/images/app_icon_light.png?raw=true" height="128">
  <h1 align="center">OllamaTalk</h1>
</p>

OllamaTalk is a fully **local, cross-platform AI chat application** that runs seamlessly on macOS,
Windows, Linux, Android, and iOS. All AI processing happens entirely **on your device**, ensuring a
secure and private chat experience without relying on external servers or cloud services. This
design guarantees complete control over your data while delivering a unified experience across all
major platforms.

## Screenshot

<p align="center">
  <img src="https://github.com/shinhyo/OllamaTalk/blob/develop/.github/art/screenshot.png?raw=true" width="90%">
</p>

## Cross-Platform Support

- macOS
- Windows
- Linux
- Web
- Android
- iOS

## Installation

### Step 1: Install Ollama Server

- Download and install Ollama from the [official download page](https://ollama.com/download).

### Step 2: Download AI Models

- Browse and download your preferred models from
  the [Ollama Model Hub](https://ollama.com/search).  
  Examples: deepseek-r1, llama, mistral, qwen, gemma2, llava, and more.

### Step 3: Start Ollama Server

#### Default Local Setup

```bash
ollama serve  # Defaults to http://localhost:11434
```

#### Cross-Device Access Setup

```bash
OLLAMA_HOST=0.0.0.0:11434 ollama serve  # Enables access from mobile devices
```

**Mobile Device Configuration**:

- When using OllamaTalk on mobile devices (Android/iOS):
  1. Use the cross-device access configuration on your server
  2. In the OllamaTalk mobile app settings:

  - Navigate to settings
  - Enter server IP as: `http://<server-ip>:11434`
  - Replace `<server-ip>` with your server's local network IP

**Network Requirements**:

- Server and mobile device must be on the same local network

### Step 4: Run the Application

1. Visit the [OllamaTalk Releases](https://github.com/shinhyo/OllamaTalk/releases) page.
2. Download the latest version for your platform

### Step 5: Launch OllamaTalk

1. Open the installed application.
2. Connect to your local Ollama server.
3. Start chatting with AI.

> **Note:** Ensure that the Ollama server is running before launching the application.

## License

This project is licensed under the MIT License.

## Support

- Report bugs and suggest features through GitHub Issues.
- Contributions via Pull Requests are welcome!