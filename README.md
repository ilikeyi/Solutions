<a name="readme-top"></a>
Yi’s soultions
-
It consists of multiple parts: encapsulation script, packaging tutorial, video tutorial, deployment engine: fully automatically adds Windows installed languages, Yi’s Suite, etc.

To help you solve the difficult problem of packaging multilingual versions, the production method provided by Yi and the deployment engine can perfectly solve this problem. You can initiate this packaging journey at will and end this "unpackageable journey".

<br>

QUICK DOWNLOAD GUIDE
-

Open "Terminal" or "PowerShell ISE" as an administrator, paste the following command line into the "Terminal" dialog box, and press Enter to start running;

<br>

Open "Terminal" or "PowerShell ISE" as an administrator, set PowerShell execution policy: Bypass, PS command line:
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

<br>

a) Prioritize downloading from Github node
```
curl https://github.com/ilikeyi/Solutions/raw/main/get.ps1 -o get.ps1; .\get.ps1;
wget https://github.com/ilikeyi/Solutions/raw/main/get.ps1 -O get.ps1; .\get.ps1;
iwr https://github.com/ilikeyi/Solutions/raw/main/get.ps1 -out get.ps1; .\get.ps1;
Invoke-WebRequest https://github.com/ilikeyi/Solutions/raw/main/get.ps1 -OutFile get.ps1; .\get.ps1;
```

<br>

b) Prioritize downloading from Yi node
```
curl https://fengyi.tel/gs -o get.ps1; .\get.ps1;
wget https://fengyi.tel/gs -O get.ps1; .\get.ps1;
iwr https://fengyi.tel/gs -out get.ps1; .\get.ps1;
Invoke-WebRequest https://fengyi.tel/gs -OutFile get.ps1; .\get.ps1;
```

<p>After running the installation script, users can customize the installation interface: specify the download link, specify the installation location, add routing functions, add context to obtain ownership, and go to: package scripts, create templates, create deployment engine upgrade packages, backup, etc.</p>
<p>You can choose either: interactive experience installation and custom installation to suit different installation requirements.</p>

Learn
 * [How to customize the installation script interactive experience](https://github.com/ilikeyi/Solutions/blob/main/_Learn/Get/Get.pdf)

<br>

Detailed introduction
-

 * United States - English | <a href="https://github.com/ilikeyi/Solutions/blob/main/_Learn/Readme/Readme.Detailed.pdf">Github</a> | <a href="https://1drv.ms/b/s!AvzHt7zW9SRZqwT_T2mia6W8CUFF?e=Kg9xRp">OneDrive</a> | <a href="https://drive.google.com/file/d/1-si261nU8mcRel1YXCCGqiJmXAaHWazt/view?usp=sharing">Google Docs</a> | <a href="https://fengyi.tel/download/solutions/_Learn/Readme/Readme.Detailed.pdf">Yi</a>
 
 * 简体中文 - 中国 | <a href="https://github.com/ilikeyi/Solutions/blob/main/_Learn/Readme/Readme.Detailed.zh-CN.pdf">Github</a> | <a href="https://1drv.ms/b/c/5924f5d6bcb7c7fc/EfzHt7zW9SQggFmFFQAAAAABhwznt_oCeq6C_5-E_ORJWA?e=33RMSL">OneDrive</a> | <a href="https://drive.google.com/file/d/1mBFfuXqAEehzIVcH4aayy8TXoy5SGID1/view?usp=sharing">Google Docs</a> | <a href="https://fengyi.tel/download/solutions/_Learn/Readme/Readme.Detailed.zh-CN.pdf">Yi</a>

<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You are viewing part of the introduction, please view the full version for more information.</p>

<br>

<details open>
    <summary>Screenshots</summary>

1. Image.Sources
![Image.Sources](https://github.com/ilikeyi/Solutions/raw/refs/heads/main/_Learn/Screenshots/Image.Sources_en-US.webp)

2. Setting
![Image.Sources](https://github.com/ilikeyi/Solutions/raw/refs/heads/main/_Learn/Screenshots/Setting_en-US.webp)

3. API
![Image.Sources](https://github.com/ilikeyi/Solutions/raw/refs/heads/main/_Learn/Screenshots/Api_en-US.webp)

4. ISO
![Image.Sources](https://github.com/ilikeyi/Solutions/raw/refs/heads/main/_Learn/Screenshots/ISO_en-US.webp)

5. Main Menu: No primary key selected
![Image.Sources](https://github.com/ilikeyi/Solutions/raw/refs/heads/main/_Learn/Screenshots/Menu_en-US.webp)

6. Main Menu: Primary key set
![Image.Sources](https://github.com/ilikeyi/Solutions/raw/refs/heads/main/_Learn/Screenshots/Menu.Sel_en-US.webp)

7. Shortcuts User Guide
![Image.Sources](https://github.com/ilikeyi/Solutions/raw/refs/heads/main/_Learn/Screenshots/Shortcut_en-US.webp)

<ol>Vector original file, document version Illustator 2020, open it with Adobe Illustrator 2024 or higher</ol>
<ol><a href="https://github.com/ilikeyi/Solutions/raw/refs/heads/main/_Learn/Screenshots/Shortcut.ai">Github</a> | <a href="https://fengyi.tel/download/solutions/Screenshots/Shortcut.ai">Yi</a></ol>
</details>

<br>

<details open>
  <summary>Component</summary>

<h4><pre>A.&nbsp;&nbsp;Packaging Tutorial</pre></h4>
<ol>The packaging tutorial written by Yi can optionally start the packaging journey of Windows 11 24H2, 23H2, Windows 10 22H2, and Windows Server 2025, 2022. Different packaging versions are available.</ol>

<ul>
  <p>Different versions are provided: a full version and a simplified version. The formats provided are: .Docx document format, .Pdf document format. Version differences:</p>
  <dl>
    <dd>1.&nbsp;&nbsp;Complete version, no deleted content;</dd>
    <dd>2.&nbsp;&nbsp;The streamlined version does not include: reports, notes, etc.;</dd>
  </dl>

<br>
  <p>Tutorials available for the packaging journey include: </p>
  <dl>
    <dd>Optional language versions: Simplified Chinese version, American English version (Google Translate: Chinese to English), download the complete package to get all documents: <code>[Compressed package]:\_Learn\Packaging.tutorial</code>, or go to https://github.com/ilikeyi/solutions/tree/main/_Learn/Packaging.tutorial and select it.</dd>
  </dl>
</ul>

<br>

<h4><pre>B.&nbsp;&nbsp;Encapsulation Script</pre></h4>
<ol>Developed using the PowerShell language, it follows an open source license and can be distributed arbitrarily without copyright restrictions.</ol>

<ul>
<details>
  <summary>Function Introduction</summary>
  <ul>
    <dd>
      <p>1.&nbsp;&nbsp;The main functions of the encapsulated script</p>
      <dl>
        <dd>1.1.&nbsp;&nbsp;Check for updates: In order to better stay up to date with the latest version, you can check whether the latest version is available at any time</dd>
        <dd>1.2.&nbsp;&nbsp;Hot refresh all modules: In the main interface, you can enter: R = fast hot refresh, R'R = include other when hot refresh</dd>
        <dd>1.3.&nbsp;&nbsp;Multi-language packs</dd>
        <dd>1.4.&nbsp;&nbsp;Shortcut command: When there is an available shortcut command, you can quickly enter and activate the corresponding instruction set</dd>
        <dd>1.5.&nbsp;&nbsp;API: Application Programming Interface</dd>
        <dd>1.6.&nbsp;&nbsp;Event mode: automatic driving, custom assigned events, manual operation</dd>
        <dd>1.7.&nbsp;&nbsp;Descending order: Automatically identify ARM64, x64, and x86 architectures, and automatically select dependent programs in descending order according to the architecture.</dd>
        <dd>1.8.&nbsp;&nbsp;ISO: Automatically identify ISO tag names and initialize rules (supports inclusion class matching), decompress, mount, pop up, verify hash, display corresponding ISO files according to rules, search, automatically classify: files, language packages, function packages , InBox Apps</dd>
        <dd>1.9.&nbsp;&nbsp;Fix</dd>
        <dd>1.10.&nbsp;&nbsp;Mount points</dd>
      </dl>
    </dd>
  
<br>
    <dd>
      <p>2.&nbsp;&nbsp;For the main functions of the image source</p>
      <p>&nbsp;&nbsp;&nbsp;&nbsp;Aimed at encapsulating the main functions of the Windows operating system, it supports batch operations of main items and extensions.</p>

<br>
      <dl>
        <dd>2.1.&nbsp;&nbsp;Event

<br>
          <dl>
            <dd>For example, when operating WinRE.wim, you need to mount Install.wim before mounting WinRe.wim to perform the corresponding tasks for WinRE.</dd>
            <dd>What are the files within the image? For example, Install.wim contains the WinRE.wim file. After mounting install.wim, events can be assigned to process WinRe.wim.</dd>
            <dd>Main functions: Mounted or unmounted events can be assigned. The main trigger events can be assigned: </dd>
          </dl>
        </dd>

<br>
        <dd>
          <p>2.2.&nbsp;&nbsp;Event handling</p>
          <p>&nbsp;&nbsp;&nbsp;&nbsp;Event processing is divided into several options: no need to mount the image, item mode that requires the image to be mounted, and support for main image and batch processing within the image.</p>
          <dl>
            <dd>2.2.1.&nbsp;&nbsp;No need to mount image
              <dl>
                <dd>2.2.1.1.&nbsp;&nbsp;Add, delete, update files within the image, extract, rebuild, apply</dd>
                <dd>2.2.1.2.&nbsp;&nbsp;Extract language pack</dd>
                <dd>2.2.1.3.&nbsp;&nbsp;Interchange Esd, Wim</dd>
                <dd>2.2.1.4.&nbsp;&nbsp;Split Install.wim into Install.swm</dd>
                <dd>2.2.1.5.&nbsp;&nbsp;Merge install.swm to install.wim</dd>
                <dd>2.2.1.6.&nbsp;&nbsp;Generate ISO</dd>
              </dl>
            </dd>

<br>
            <dd>2.2.2.&nbsp;&nbsp;You need to mount the image before you can operate the item
              <dl>
                <dd>2.2.2.1.&nbsp;&nbsp;Language pack</dd>
                <dd>2.2.2.2.&nbsp;&nbsp;Local Language Experience Packages (LXPs)</dd>
                <dd>2.2.2.3.&nbsp;&nbsp;InBox Apps</dd>
                <dd>2.2.2.4.&nbsp;&nbsp;Cumulative updates</dd>
                <dd>2.2.2.5.&nbsp;&nbsp;Drive</dd>
                <dd>2.2.2.6.&nbsp;&nbsp;Windows features</dd>
                <dd>2.2.2.7.&nbsp;&nbsp;Run a PowerShell function</dd>
                <dd>2.2.2.8.&nbsp;&nbsp;Solution: Generate</dd>
                <dd>2.2.2.9.&nbsp;&nbsp;Generate report</dd>
                <dd>2.2.2.10.&nbsp;&nbsp;Pop up</dd>
              </dl>
            </dd>
          </dl>
        </dd>
      </dl>
    </dd>
  </dl>
  </ul>
</details>
</ul>

<br>

<ul>
<details>
  <summary>Prerequisites</summary>
  <ul>
  <dl>
    <p>1.&nbsp;&nbsp;Require</p>
    <dd>
      <p>PowerShell Version</p>
      <dl>
        <dd>
          <p>PowerShell 5.1</p>
          <dl><dd>Requires Windows 11, Windows 10, Windows Server 2022, Windows Server vNext or the 5.1 version that comes with the system by default. You can optionally upgrade to the latest version of PowerShell 7.</dd></dl>
        </dd>

<br>
        <dd>
          <p>PowerShell 7</p>
          <dl><dd>To get the latest version, go to https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows, select the version you want to download, download and install.</dd></dl>
        </dd>
      </dl>
    </dd>
  </dl>

<br>

<br>
  <p>2.&nbsp;&nbsp;Command Line</p>
  <dl>
    <p>2.1.&nbsp;&nbsp;You can choose "Terminal" or "PowerShell ISE". If "Terminal" is not installed, please go to https://github.com/microsoft/terminal/releases to download;</p>
    <p>2.2.&nbsp;&nbsp;Open "Terminal" or "PowerShell ISE" as an administrator, set PowerShell execution policy: Bypass, PS command line:

```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

</p>
    <dd>2.3.&nbsp;&nbsp;In this article, the green part belongs to the PS command line. Please copy it, paste it into the "Terminal" dialog box, and press Enter to start running;</dd>
    <dd>2.4.&nbsp;&nbsp;When there is .ps1, right-click the file and select Run as PowerShell, or copy the path and paste it into "Terminal" or "PowerShell ISE" to run. For the path with a colon, add the & character in the command line, example: <code>& "D:\YiSolutions\_Encapsulation\_SIP.ps1"</code></dd>

</ul>
</details>
</ul>

<br>

<ul>
<details>
  <summary>Get the package script</summary>
 <ul>
<p>   After using the quick download guide</p>

<br>
  <p>1.&nbsp;&nbsp;PowerShell script</p>
  <dl>
    <dd>
      <p>1.1.&nbsp;&nbsp;Encapsulation Script</p>

```
D:\Yi.Solutions\_Encapsulation\_SIP.ps1
```

<p>After entering the main interface of the packaging script, you can add the routing function to the system variable. After adding it, run <code>Yi</code> in the PowerShell terminal next time to enter the boot interface, or enter <code>Yi -sip</code> to directly enter the packaging interface without entering the full path of the script. run.</p>
    </dd>

<br>
    <dd>
      <p>1.2.&nbsp;&nbsp;Other items</p>
      <dl>
        <dd>
          <p>1.2.1.&nbsp;&nbsp;Backup, when routing function is available: <code>Yi -unpack</code>
            <dl>
              <dd>&nbsp;&nbsp;&nbsp;&nbsp;<code>D:\YiSolutions\_Encapsulation\_Unpack.ps1</code></dd>
              <dd>&nbsp;&nbsp;&nbsp;&nbsp;When the package script performs a check for updates, the backed-up file can be used as an upgrade package.</dd>
            </dl>
          </p>

<br>
          <p>1.2.2.&nbsp;&nbsp;Create a deployment engine upgrade package, when routing function is available: <code>Yi -Ceup</code>
            <dl>
              <dd>&nbsp;&nbsp;&nbsp;&nbsp;<code>D:\YiSolutions\_Encapsulation\_Create.Custom.Engine.upgrade.package.ps1</code></dd>
            </dl>
          </p>

<br>
          <p>1.2.3.&nbsp;&nbsp;Convert all software into compressed packages, when routing function is available: <code>Yi -Zip</code>
            <dl>
              <dd>&nbsp;&nbsp;&nbsp;&nbsp;<code>D:\YiSolutions\_Encapsulation\_Zip.ps1</code></dd>
            </dl>
          </p>

<br>
          <p>1.2.4.&nbsp;&nbsp;Create templates, when routing function is available: <code>Yi -CT</code>
            <dl>
              <dd>&nbsp;&nbsp;&nbsp;&nbsp;<code>D:\YiSolutions\_Encapsulation\_Create.Template.ps1</code></dd>
            </dl>
          </p>
        </dd>
      </dl>
    </dd>
  </dl>
  </ul>
</details>
</ul>

<br>

<h4><pre>C.&nbsp;&nbsp;Video Tutorial</pre></h4>
<ol>The video tutorial includes different packaging methods: custom allocation of packaging events, automatic driving, manual packaging, and introduction to packaging scripts.</ol>
<ol>Explain how to encapsulate multi-language processes in an offline state. Task objectives include: extracting language packs, installing language packs, installing InBox Apps, adding cumulative updates, generating solutions, etc. All predetermined goals can be easily achieved through learning.</ol>

<ul>
  <dl>
    <dd>
      <p>1.&nbsp;&nbsp;Packaging tutorial</p>
      <dl>
        <dd>1.1.&nbsp;&nbsp;Windows 11 24H2: Practical packaging tutorial, offline packaging multi-language
            <dl>
               <dd>

[Youtube](https://youtu.be/BICApBc7wlY) | [Bilibili](https://www.bilibili.com/video/BV1cyymYsEHe/) | [Tencent Video](https://v.qq.com/x/page/i35683hz3yj.html) | [iQiyi](http://www.iqiyi.com/v_1rfq8du8qho.html) | [Sohu](http://my.tv.sohu.com/us/201441345/586031095.shtml) | [YouKu](https://v.youku.com/v_show/id_XNjQzMzQxMTcxMg==.html)
               </dd>
            </dl>
         </dd>
      </dl>
    </dd>

<br>
    <dd>
      <p>2. Custom encapsulated events</p>
      <dl>
         <dd>2.1.&nbsp;&nbsp;Windows 11 24H2: Custom encapsulated events, offline packaging multi-language
            <dl>
               <dd>

[Youtube](https://youtu.be/rs9IBLcZFUc) | [Bilibili](https://www.bilibili.com/video/BV1Uj1sYMEiR/) | [Tencent Video](https://v.qq.com/x/page/z3568356sdn.html) | [iQiyi](https://www.iqiyi.com/v_1va9thxbrpk.html) | [Sohu](http://my.tv.sohu.com/us/201441345/586048434.shtml) | [YouKu](https://v.youku.com/v_show/id_XNjQzMzQwODUxNg==.html)
               </dd>
            </dl>
         </dd>
      </dl>
    </dd>

<br>
    <dd>
      <p>3.&nbsp;&nbsp;Autopilot</p>
      <dl>
        <dd>3.1.&nbsp;&nbsp;Windows 11 24H2: Autopilot encapsulation, offline packaging multi-language
            <dl>
               <dd>

[Youtube](https://youtu.be/OK-5-y_dOTg) | [Bilibili](https://www.bilibili.com/video/BV1krymYxELk/) | [Tencent Video](https://v.qq.com/x/page/g3568so5957.html) | [iQiyi](http://www.iqiyi.com/v_1gduum87i2o.html) | [Sohu](http://my.tv.sohu.com/us/201441345/586041313.shtml) | [YouKu](https://v.youku.com/v_show/id_XNjQzMzQxMTk3Mg==.html)
               </dd>
            </dl>
         </dd>
      </dl>
    </dd>
  </dl>
</ul>

<br>

<h4><pre>D.&nbsp;&nbsp;Local Language Experience Packs (LXPs) Downloader</pre></h4>
<ol>Solve the problem of batch downloading of "Local Language Experience Packages (LXPs)" installation packages, and you can filter or download all.</ol>
<ol>Project address: https://github.com/ilikeyi/LXPs, included in the full version: <code>\_Encapsulation\_Custom\Engine\LXPs</code></ol>

<br>

<h4><pre>E.&nbsp;&nbsp;Deployment engine: fully automatically adds Windows installed languages</pre></h4>
<ol>Automatically obtain installed languages and add them automatically, support full deployment tags, customize the deployment process, and not include others.</ol>
<ol>Project address: https://github.com/ilikeyi/Multilingual, included in the full version: <code>\_Encapsulation\_Custom\Engine\Multilingual</code></ol>

<br>

<h4><pre>F.&nbsp;&nbsp;Yi’s Suite</pre></h4>
<ol>Automatically obtain installed languages and automatically add them, support full deployment tags, and customize the deployment process, including:</ol>
<ol>Optimization scripts, common software installation, software installation, system optimization, service optimization, UWP uninstallation, changing folder location, etc.</ol>
<ol>Project address: https://github.com/ilikeyi/YiSuite, included in the full version: <code>\_Encapsulation\_Custom\Engine\Yi.Suite</code></ol>

</details>

<br>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<br>

## License

Distributed under the MIT License. See `LICENSE` for more information.

<br>

## Contact

Yi - [https://fengyi.tel](https://fengyi.tel) - 775159955@qq.com

Project Link: [https://github.com/ilikeyi/solutions](https://github.com/ilikeyi/solutions)
