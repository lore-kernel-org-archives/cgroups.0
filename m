From: =?UTF-8?Q?Kamil_Kami=C5=84ski?= <kwb.kot-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Cgroups, burst
Date: Thu, 27 Apr 2017 11:13:22 +0200
Message-ID: <CACf67ttiCBpmQEmz-MRhfJasCgs4DDLo2geCZ7i=0D2kXcY-ow@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=edMNWJ+RJyjcDcaMyMJ5DCqLrKyxe+Rf0mqhHn4Rbrk=;
        b=LmFzKoiSDGsM/tp5EYTUZyOTWPcSKyK0ABy6c/L7JSxgBDms91ru/YLYpwLYaFLZy1
         GfhPK1IoX3zgOPI69H7QY6g52TV2GP1k9+5rKZnp6dEjPwXnIhVIG+PEFArjDk7gV/F8
         h5EXWRU69jWBNxaGKLQaUDfk239q3Rv3KCwXXFqYvxUH9cZ/C9kfU7TRXe8NSXumkksl
         /QXE+SKRPnSV1hwyynv06kcSnHyF8wiDUgLjS8Xu7WVff5VbhiA3g7SvBz936HLf23JJ
         itcmixi4iy3xraRYQHZ7Q31O2RxpATMggxu8LsNBXKpPOAKHQt0bRPIHA29pGaSLHBn3
         D6Eg==
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hey,

Is there an easy way to burst CPU resources with cgroups when needed?
For example I want to restrict 20% of CPU per process and for example
i want to allow process to use 100% of CPU for 30 sec (burst).

I mean i want restrict CPU usage at 20% per process, not per group.
Restrict resources per group I can do this way:

echo 10000 > cpu.cfs.quota_us
echo 50000 > cpu.cfs_period_us

But I want to restrict usage per process, and if there is a
possibility to burst it.

Or maybe is there a function that will indicate when app will consume
all resources? Then I will just switch her PID to another cgroup (that
will have 100% CPU) for 30 seconds and then back to previous cgroup.
