From: Youfu Zhang <zhangyoufu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [BUG] blk-throttle panic on 32bit machine after startup
Date: Mon, 18 Oct 2021 15:08:53 +0800
Message-ID: <CAEKhA2x1Qi3Ywaj9fzdsaChabqDSMe2m2441wReg_V=39_Cuhg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=O/OZJC0HIUE3DNP74CA6ob2Ysy1RgHmyhS2ZxyEPXFQ=;
        b=SSUOD1uC9IodrXjZW/i5EdgxkEgrD955N9s4FpbRkuCr8XDDCmVTbVqRPHDNRSENmQ
         iz9t4oURkPyAIYFZ3pF4/7pS+eNQ6jTzoIb8Ev4KENA7b6ItNIiOxdYyMocXP4myvfsj
         15woTtJGjmSTDkC3/6mQkEhMkSU7psQwGbmQfHehlpJMH3yHUwtWBcHFxxkAXVoKt9Ts
         nBaKJ59mpV+je8EW4XMdc2rrfQz96tlTmC0TJu+NT3nZuvW7kx11mUXZ9afwkITGFFTH
         VJ4YFQqqQCqqqoGqQaTuKHkzbE+8N/bVbWwHgsEX8SSO9yDK5OStQK0VbKm5QKeo1bcd
         is/g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I ran into a kernel bug related to blk-throttle on CentOS 7 AltArch for i386.
Userspace programs may panic the kernel if they hit the I/O limit
within 5 minutes after startup.

Root cause:
1. jiffies was initialized to -300HZ during boot on 32bit machines
2. enable blkio cgroup hierarchy
   __DEVEL__sane_behavior for cgroup v1 or default hierarchy for cgroup v2
   EL7 kernel modified throtl_pd_init and always enable hierarchical throttling
3. enable & trigger blkio throttling within 5 minutes after startup
   bio propagated from child tg to parent
4. enter throtl_start_new_slice_with_credit
   if(time_after_eq(start, tg->slice_start[rw]))
   aka. time_after_eq(0xFFFxxxxx, 0) does not hold
   parent tg->slice_start[rw] was zero-initialized and not updated
5. enter throtl_trim_slice
   BUG_ON(time_before(tg->slice_end[rw], tg->slice_start[rw]))
   aka. time_before(0xFFFxxxxx, 0) triggers a panic

Reproducer: (tested on Alpine Linux x86 kernel 5.10.X)
#!/bin/sh
CGROUP_PATH="$(mktemp -d)"
mount -t cgroup2 none "$CGROUP_PATH"
echo +io >"$CGROUP_PATH/cgroup.subtree_control"
mkdir "$CGROUP_PATH/child"
echo "7:0 riops=2" >"$CGROUP_PATH/child/io.max"
echo 0 >"$CGROUP_PATH/child/cgroup.procs"
echo 3 >/proc/sys/vm/drop_caches
dd if=/dev/loop0 of=/dev/null count=3
