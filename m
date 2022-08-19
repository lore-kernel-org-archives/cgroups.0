From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: data-race in cgroup_get_tree / proc_cgroup_show
Date: Fri, 19 Aug 2022 09:22:56 +0200
Message-ID: <20220819072256.fn7ctciefy4fc4cu@wittgenstein>
References: <CAEHB249jcoG=sMGLUgqw3Yf+SjZ7ZkUfF_M+WcyQGCAe77o2kA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660893784;
        bh=K9+P7h5q0PmWOPO+ARUr893KkCchsaHz1glvXYWe8wQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V4zptkXT1wl0ArPwz9SGtpJZy0ko2FIZbpeeeEPWj2Pxj3BNFvSj4plhk2sETGqW/
         RnAH1/UMUPZwBvKgJiG1wkAOkEk1oKUj6iVxRDt4RYR9BgsL1YDPEguAu/CpfKwqXV
         11zlA22ypdLJxDDsgJJ2aHZ7IN8NZgwg1QnP4zkxy0Z8ZBBQo5dbCkqW6BrDY48LFy
         FtgFxI1sEgH58lErElCYqeHR1AOUzo3zOwRpyKOv2pDIFw+5RYi4jVi3rkVIVosLQh
         SO2Ai8opHivy/bGsjwTESK1nEYT2G0IwW+VcPxwYJre9n3AHhjt1wyotzA6vwj5mNR
         /mBaJA/cPTxdw==
Content-Disposition: inline
In-Reply-To: <CAEHB249jcoG=sMGLUgqw3Yf+SjZ7ZkUfF_M+WcyQGCAe77o2kA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Abhishek Shah <abhishek.shah-WLbs8XpHrcb2fBVCVOL8/A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, Gabriel Ryan <gabe-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>

On Thu, Aug 18, 2022 at 07:24:00PM -0400, Abhishek Shah wrote:
> Hi all,
> 
> We found the following data race involving the *cgrp_dfl_visible *variable.
> We think it has security implications as the racing variable controls the
> contents used in /proc/<pid>/cgroup which has been used in prior work
> <https://www.cyberark.com/resources/threat-research-blog/the-strange-case-of-how-we-escaped-the-docker-default-container>
> in container escapes. Please let us know what you think. Thanks!

One straightforward fix might be to use
cmpxchg(&cgrp_dfl_visible, false, true) in cgroup_get_tree()
and READ_ONCE(cgrp_dfl_visible) in proc_cgroup_show() or sm like that.
I'm not sure this is an issue though but might still be nice to fix it.

> 
> *-----------------------------Report--------------------------------------*
> *write* to 0xffffffff881d0344 of 1 bytes by task 6542 on cpu 0:
>  cgroup_get_tree+0x30/0x1c0 kernel/cgroup/cgroup.c:2153
>  vfs_get_tree+0x53/0x1b0 fs/super.c:1497
>  do_new_mount+0x208/0x6a0 fs/namespace.c:3040
>  path_mount+0x4a0/0xbd0 fs/namespace.c:3370
>  do_mount fs/namespace.c:3383 [inline]
>  __do_sys_mount fs/namespace.c:3591 [inline]
>  __se_sys_mount+0x215/0x2d0 fs/namespace.c:3568
>  __x64_sys_mount+0x67/0x80 fs/namespace.c:3568
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> *read* to 0xffffffff881d0344 of 1 bytes by task 6541 on cpu 1:
>  proc_cgroup_show+0x1ec/0x4e0 kernel/cgroup/cgroup.c:6017
>  proc_single_show+0x96/0x120 fs/proc/base.c:777
>  seq_read_iter+0x2d2/0x8e0 fs/seq_file.c:230
>  seq_read+0x1c9/0x210 fs/seq_file.c:162
>  vfs_read+0x1b5/0x6e0 fs/read_write.c:480
>  ksys_read+0xde/0x190 fs/read_write.c:620
>  __do_sys_read fs/read_write.c:630 [inline]
>  __se_sys_read fs/read_write.c:628 [inline]
>  __x64_sys_read+0x43/0x50 fs/read_write.c:628
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 6541 Comm: syz-executor2-n Not tainted 5.18.0-rc5+ #107
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> 04/01/2014
> 
> 
> *Reproducing Inputs*
> Input CPU 0:
> r0 = fsopen(&(0x7f0000000000)='cgroup2\x00', 0x0)
> fsconfig$FSCONFIG_CMD_CREATE(r0, 0x6, 0x0, 0x0, 0x0)
> fsmount(r0, 0x0, 0x83)
> 
> Input CPU 1:
> r0 = syz_open_procfs(0x0, &(0x7f0000000040)='cgroup\x00')
> read$eventfd(r0, &(0x7f0000000080), 0x8)
