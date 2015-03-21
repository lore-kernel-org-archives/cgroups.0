From: Nobin Mathew <nobin.mathew-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: LXC/cgroups process group scheduling in linux 3.18+
Date: Sat, 21 Mar 2015 12:43:05 +0530
Message-ID: <CAJgSC2Mj8kavUvJOPJujLpmpLwQpPk-9QaaUxAuCvZtfB23Y5w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=RI+CI3o57zzDETc0Csxew0CLIdeXg6l3gcLivN3c79s=;
        b=FgYQPSyD7JRYTX6NnEMizjcywUTsEBNq9gK8ZSH4Yw+7bOBSsDot68odjcDMZqW8O0
         q0Y8Zwrh+QADhmLGdVBvCvsM66p93sNJ+hZ3lXFtlBXTk7/Tay6fak4jPJ5wZSTx2YMP
         76cXOCtBhrLwX91vnYLf4unyqKP2gNnKEVVcgpS2ckGnqvBjGaUFnxA4mBxTshbQowWN
         tcUH14Qjn+o6cdXfwWuF4LKI1XHIIHmiclhvevUCyDUdxNP4QxfN/xiRcYlETNM8qytH
         8p7U00P1E7MmqCQluC1Lkkhquwm1UuB3PGhCa9Ec2AJrdvSatUVHFzNZCNDKQComSXqs
         BWLA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I asked in the kernel newbies list and lxc-users list, no response. So
asking here.

Apologises if I am asking a dump question.


Is there any support for container(lxc/cgroups) scheduling in linux
scheduler(3.18+). I want to use only unprivileged containers.

Basically I want to give more priority to processes in a
container(basically to app in the container). Can we use RT scheduling?.

one more question is how process scheduling happens inside the
container(lxc/cgroups), is it like for some time(till the next container is
selected), only processes inside container(lxc/cgroups) is scheduled?

Thanks
