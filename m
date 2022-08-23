From: =?utf-8?B?TWF4aW0g4oCcTUFYUEFJTuKAnSBNYWthcm92?= 
        <maxpain177-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroups v2 cpuset partition bug
Date: Tue, 23 Aug 2022 15:13:30 +0300
Message-ID: <C98773C9-F5ED-4664-BED1-5C03351130D4@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc;
        bh=EcTgTAfb8gcBa+/RPqk1oum9uIB6i+UE26rEpiqDJWw=;
        b=Sfqz9MwyqtEoqDdxxOaY232OchkRDJcRvZsqBzMVVMcIK11JnJEki4JBfUhz8b2nhW
         eIgy6EufDNDLhD5U57r8F6/Thmw2Qxr5rrYWgpNS5mfGyPk1FdTe1YQdfTzplXAHAl2g
         HVXAgSBSGNEjve1bOuCt+SxWPTmsVqA0FuSxazA54mYJ3D/J7LEYfHLHlvYnmoD5ZD3E
         ictZwOVsV/Vt8g7TpZH8c8MPpsV9jp529DTsavyst4DIQ6aCbqq84KJ+b4YqWOZEpRCQ
         /mgjxjBVJ1cw36UvlxggYxTkfMFFbafh73hBhSypFAwtEEyXDW2QXqSixN9+eT7904TJ
         pgNA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello. I have no idea where I can ask questions about cgroups v2. I have =
a problem with cpuset partitions.
Could you please, check this question?
=
https://unix.stackexchange.com/questions/714454/cgroups-v2-cpuset-doesnt-t=
ake-an-effect-without-process-restart=
