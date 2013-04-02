From: David Shwatrz <dshwatrz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cpuset filesystems - a (short) doubt
Date: Tue, 2 Apr 2013 17:17:21 +0300
Message-ID: <CAJJAcocYoD2ZoUBXNa7jHMnhcwHBKNUKt5AKUUBkXH=-SRr5ZA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:date:message-id:subject:from:to
         :content-type;
        bh=yDWddWk0h2cfjgrQSvvOM3wSv3ssKfHAmvsn7qfIdqY=;
        b=pjbLS0POK4V/L3L7mtfB6Q2KcVFwxlntvWgwu7kF2+nqii3lJuPbY/haEnqO7zpDoB
         C00qbMYLI1L76abpUPHEdaiaVZC4Jx7iWwHKZ0WvnSwUFsDZliiRzzZTgC8D5+Kpo+Hd
         EP21cvwwVlC875erli9ykSp4WijijSxpvSkDPIAbwVJwxpfZb/ulw2aOqnapWwUNSyxc
         /NC8OzjkfGOAH0/hJZm6Klt8QRg6xulG8yWboae66lc3hqnZpbjY0BxD6dxjfbyBht5F
         FnMyuCHoop1lIUcxp2pOYV9cp4TlxqaPvo7E2wWTRxzJ6WDGdfpUdC7nFYQkUoJoI9IY
         RInw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
I have a question about cpuset filesystem - is it needed ?

In the cpuset example given in:
http://lxr.free-electrons.com/source/Documentation/cgroups/cgroups.txt
we do not use the cpuset filesystsm but the cgroup filesystsm.
(mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset)

On my distro, which uses systemd + cgroups:
mount | grep "type cpuset"
gives nothing.

On the other hands, mount | grep "type cgroup" | wc -l
gives: 9

I looked in the code of other subsystems (like blk cgroup and  memcg -
memory control groups) and there is no filesystsm in the code; see
block/blk-cgroup.c
mm/memcontrol.c

so is the cpuset filesystsm really needed ?


DS
