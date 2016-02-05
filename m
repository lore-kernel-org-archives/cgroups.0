From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Suspected bug with memory controller with kernel 4.2.3
Date: Fri, 5 Feb 2016 19:15:04 +0200
Message-ID: <CAGXs5wUFE0obngO7qTzLmwLqdM6tW-NU0WQCpQ3Em6rbGxozzw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=MPhXvmaNecC5ouzy7b8ysJ2tgUgmvsQpkKCC0a2zOi4=;
        b=wBm3VYPtYUlPaGQeRvGgimcPRyHu1MFB8UWKlCEIoNsWvnoqmCkeYdFt593nqtMizN
         pNm7N9qjUjTUI8lv+Av1SguqUNtandfIpgebl0p5Qr+JCS6E1ETZggBsdgKHYJgi0bmK
         YryOXIDzmo2AArGV8wBdSWwDXiR7PV19B9mzDBjIWE6YusFdZ/6jewXDzTgHfiS+vTmg
         y9iNcEJ7vRfYYth7ZtnKFObWSZgoSvMWRno1o6WFbQsahYSgzmwMZb2pslP9S+lDBQgS
         Fu7AsVMnAW2mQHtSsWHc8njiu7X0v6HAw94VHp7OtWGPpblpWnVYChc7gZ1Q+ogcZT5q
         rlUA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I have Fedora 23 with kernel  4.2.3-300.fc23.x86_64 out of the box.

Sytsemd mounts the memory controller on /sys/fs/cgroup/memory
I am trying the following sequence:
mkdir /memCgroupTest1
mount -t cgroup -o memory memtest1 /memCgroupTest1

It succeeds. Also after creating subfolders in /memCgroupTest1, the
set of control files
for memory controller + the generic files is created.
 Mounting the memory controller again on other folders under /
also succeeds.
When I try it with other controllers like cpu/net_prio it fails.

It seems to me that we should not be permitted to mount the memory
controller more than once while it is mounted also elsewhere.
Is this a BUG or an expected behavior ?

Regards,
Kevin
