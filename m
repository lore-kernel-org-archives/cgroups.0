From: Wangda Tan <wheeleast-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Questions about change resource limits / moving process when process
 is running
Date: Mon, 21 Apr 2014 12:05:24 -0700
Message-ID: <CAD++eC=BW53LheCwxBEJ4rDv1RXRv6Tq3zsWmsM8vQ26BXcBZQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=61vo5tKtUBNG419tZN+75j+TKz46NvMPWbzaJtI1yQE=;
        b=DgRMOkrAA5PPvv0ATNZ9nuI3r8YMAWH6EHeXPRV1XjD2HwmDhLHPyYBG99xfGerDWL
         pKPb1XEV9OeJgMiBgElPE6NzdUNrVIqh5jjig+bcPNLZY0VFsK/l4GSVNxL2hHKDyovI
         sZ3NL9YeMnvPtPFrSxvPj4gxAB+o8HNoQcX7mIp6RvdWNYvft356Z0bzQz6K1MGZn93N
         meQ1WnOhy/06tEVnVMUmm4tLZ5HtAYbzomB7wHSyuAbU9sv15NUy1tQZOgtTLeYtKzQ5
         c2YVtFvt+RTjxGkLWWdwHpgwXyc/YM6FEtyicqL3nvjUeSia01XW+MUBbUOwFd5WRbFr
         dz4w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi all,
I've two quick question on cgroups,
Question #1, Does cgroups support change limitation (like
memory.limit_in_bytes/cpu.shares) when process is running?
I've tested in my local environment (Linux Centos 6.5
2.6.32-431.11.2.el6.x86_64), it seems not work.

Question #2, Does cgroups supports moving a running process from one
cgroup to another?

Thanks in advance!
--
Best regards,
Wangda Tan
