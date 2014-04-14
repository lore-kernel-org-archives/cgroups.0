From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: A problem with memory.oom_control
Date: Mon, 14 Apr 2014 14:54:23 +0300
Message-ID: <CAGXs5wUdhEYQ-kGEPSD2A=OceZuA1tovLs04gPcRcqBPagQJCw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=azX9wl6xlRhTbuf9fotl12xKL5huCwo/ycIWlRKDrcM=;
        b=gREtJVCgnHPDcrjyLg5qOGGCoSE7W5xOfJ43w7h9q9coMjoG7/XSNWFbhx5O7idqPg
         jdHTu6z3LC7Pv25YAoMSI9cNRpDnl3zBFXMWoeVFKffx2al924ZPXR0FupbHeywGjVSF
         neHvlec4uV5aDHNrCQH4m1J2Fo6xP3+E+ACo3L1b0hMPu8hm51M0uOGJIPoqLcv6KKyv
         niKhHzsOwh4lkK3001ZnQzB62RCT9WF5Sx+kEU9LscDBsoLdyYLdSJf4CLyiZJ8idgO0
         +5RKTIO9VRDiQ0eNsIAkfQbk5Yi0YNiuvWrVaUK4XHKrxkPzq+HhABWjUOgxAzL3TKea
         HU4g==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

First I hope this mailing list is the proper one for asking the
following question:
I do the following, as root,  on Fedora 20 with 3.12.7-300.fc20.x86_64 kernel:

create a cgroup called "0"
/sys/fs/cgroup/memory/0

run:

echo "1" > /sys/fs/cgroup/memory/0/memory.oom_control
bash: echo: write error: Invalid argument

Why am I having this error  ?

According to the documentation:

http://lxr.free-electrons.com/source/Documentation/cgroups/memory.txt
this should work.

Regards,
Kevin
