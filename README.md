<p align="center">
  <img src="https://github.com/shinhyo/OllamaTalk/blob/v0.1.0/assets/images/app_icon_light.png?raw=true" height="128">
  <h1 align="center">OllamaTalk</h1>
</p>

OllamaTalk is a fully **local, cross-platform AI chat application** that runs seamlessly on macOS,
Windows, Linux, Android, and iOS. All AI processing happens entirely **on your device**, ensuring a
secure and private chat experience without relying on external servers or cloud services. This
design guarantees complete control over your data while delivering a unified experience across all
major platforms.

<p align="center">
  <img src="/.github/art/0.gif" width="49%">
  <img src="/.github/art/1.gif" width="49%">
</p>

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

  - select the model you want to download and select the parameters value according to your system specifications. 

  - Copy the bash command from the ollama model hub and run it on your terminal to download the model to your local system.
  - for example :
    ```bash
    ollama run deepseek-r1:14b
    ```

### Step 3: Start Ollama Server

#### Default Local Setup

```bash
ollama serve  # Defaults to http://localhost:11434
```

#### Verify Ollama is running or not 
navigate to `http://localhost:11434` and check whether the ollama is running or not.

#### In Case Of:
If your system shows error like this : 

```bash
Error: listen tcp 127.0.0.1:11434: bind: Only one usage of each socket address (protocol/network address/port) is normally permitted.
```

it means ollama is already running, if you still can't able to access your ollama model, try to restart your system and run the ```ollama serve```  again.

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

<br/>
<hr>
<br/>


### **Steps to Run the Application in Windows/Mac/Linux** 

#### **1. Install Flutter (if not installed)**

- Download and install Flutter: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Verify the installation:
    
    ```sh
    flutter --version
    ```
    

#### **2. Navigate to the Project Folder**

```sh
cd /mnt/data/OllamaTalk/OllamaTalk-0.1.0
```

#### **3. Install Dependencies**

```sh
flutter pub get
```

#### **4. Run the Application**


- **For iOS (Mac only):**
    
    ```sh
    flutter run
    ```
    
    _(Requires Xcode installed.)_
- **For Web:**
    
    ```sh
    flutter run -d chrome
    ```
    
- **For Windows/Linux/macOS Desktop:**
    
    ```sh
    flutter run -d windows  # for Windows
    flutter run -d linux    # for Linux
    flutter run -d macos    # for macOS
    ```



> **Note:** Ensure that the Ollama server is running before launching the application.

## License

This project is licensed under the MIT License.

## Support

- Report bugs and suggest features through GitHub Issues.
- Contributions via Pull Requests are welcome!
