From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: failed to setups device_weight for bio device (/dev/mdxxx)
Date: Tue, 18 Dec 2012 16:33:47 +0400
Message-ID: <CACaajQtd_CF+EBaDGZXH3mdHVKUsii9YTJOXvKyT7WcfqvLq7g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=selfip.ru; s=google;
        h=mime-version:sender:x-originating-ip:from:date:x-google-sender-auth
         :message-id:subject:to:content-type;
        bh=i+/RDvIKcBLUQDWR2193TwoO9+bRKV4yLwfvXogRplo=;
        b=M1o+JBlj731RJrRR87nK3bLpFGbPVr39ENUO3evp00MsvMbqkxxTj+YbxisM1p5bkq
         RwmQdxE1kkRUKDvuqaBYjAaUnoz29A0YTK4d+3PFh70YLVhX7qQs4duFZjpeC64Mhpzx
         vRn8DrJ5cDVMw6MH6qVE4SBRiKv8aVc3dJclw=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Does anobody can helps me?
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
