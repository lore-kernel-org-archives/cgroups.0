From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: failed to setups device_weight for bio device (/dev/mdxxx)
Date: Mon, 17 Dec 2012 16:57:36 +0400
Message-ID: <CACaajQtJp96QJaPs66zcH+4vuD7UmYzBXRWxyj5A2KWoXObbMg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=selfip.ru; s=google;
        h=mime-version:sender:x-originating-ip:from:date:x-google-sender-auth
         :message-id:subject:to:content-type;
        bh=W7OmvcZNjK7wlicd/yHgBB7olfyA9x4khy/7d3RCvwI=;
        b=UfmbR7sBQft3yuyJJ/fvS+i9dkSm4ohYdXeQuzZEoWXQmh5Fx+7fPxlgtLK4xERP7j
         nsGwzPATjWaTc/v4xFDeE4kZzUAhET8Kb/taddpHYGk24cJWDeLIPkRimPcX/f6/Ff/i
         RrA6h9WvmBUjhQCxQlTcaqHtUJcHF8uohZtBI=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello. I'm newbie with cgroups (try to use blkio cgroups).
I need to shape disk activity on xen vps.
Each xen domU have block device that is software raid 1.
This raid have two devices that is lvm volume lies on srp (infiniband)
attached disk.

How can i limit disk usage in this configuration with cgroups?

P.S. Some log:

:~ # ls -alo /dev/md116
brw-rw---- 1 root 9, 116 Dec 17 15:44 /dev/md116
:~ # /bin/echo 9:116 0 > /cgroups/blkio.weight_device
/bin/echo: write error: Invalid argument

/dev/md116 consist:
/dev/dm-30 and /dev/dm-31

:~ # /bin/echo 253:30 14 > /cgroups/blkio.weight_device
/bin/echo: write error: Invalid argument
:~ # /bin/echo 253:31 14 > /cgroups/blkio.weight_device
/bin/echo: write error: Invalid argument


--
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
