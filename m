From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix missing cpus_read_{lock,unlock}() in
 cgroup_transfer_tasks()
Date: Mon, 22 May 2023 08:45:09 -1000
Message-ID: <ZGu4NW-lPhqa3Rwe@slm.duckdns.org>
References: <20230517074545.2045035-1-qi.zheng@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684781112; x=1687373112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GPEdOjaln13eDkr1qkN349p3zj4aR3vg58cbN+JoRYk=;
        b=pw1TCbAM/9X7C4aNn9jkVVcJZLM2CSvFZAOHfIxRjiHX55nbX+GF9K/lD/zzJcsFkK
         gWvVWipuH89kaaOo7I9QmOgkSI2TVKk4R6++qB/8Wd73IMxUIwLlPAyuOUp6cDTivj1G
         CKYXjQXD7DlvopChbyi40wquu/zmDeHrqD57gpKspr9vXxr02t3YKcaXwK/znJ/DJDpb
         iYVNEt/OenjvbEuvz5bD3eRVlT9VoO9zOxwhMTL0IikBrPHgRWOM2iMc21pfI7u/VEiN
         Dq5F4E/kskoV++jz3iKpF97Ape1+7BeHQaSzBTmxEB7iSU/i2BBqgu/fUQ5LQa0fPpdT
         vNKw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230517074545.2045035-1-qi.zheng-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qi Zheng <qi.zheng-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, Qi Zheng <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Zhao Gongyi <zhaogongyi-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Wed, May 17, 2023 at 07:45:45AM +0000, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> The commit 4f7e7236435c ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock()
> deadlock") fixed the deadlock between cgroup_threadgroup_rwsem and
> cpus_read_lock() by introducing cgroup_attach_{lock,unlock}() and removing
> cpus_read_{lock,unlock}() from cpuset_attach(). But cgroup_transfer_tasks()
> was missed and not handled, which will cause th following warning:
> 
>  WARNING: CPU: 0 PID: 589 at kernel/cpu.c:526 lockdep_assert_cpus_held+0x32/0x40
>  CPU: 0 PID: 589 Comm: kworker/1:4 Not tainted 6.4.0-rc2-next-20230517 #50
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>  Workqueue: events cpuset_hotplug_workfn
>  RIP: 0010:lockdep_assert_cpus_held+0x32/0x40
>  <...>
>  Call Trace:
>   <TASK>
>   cpuset_attach+0x40/0x240
>   cgroup_migrate_execute+0x452/0x5e0
>   ? _raw_spin_unlock_irq+0x28/0x40
>   cgroup_transfer_tasks+0x1f3/0x360
>   ? find_held_lock+0x32/0x90
>   ? cpuset_hotplug_workfn+0xc81/0xed0
>   cpuset_hotplug_workfn+0xcb1/0xed0
>   ? process_one_work+0x248/0x5b0
>   process_one_work+0x2b9/0x5b0
>   worker_thread+0x56/0x3b0
>   ? process_one_work+0x5b0/0x5b0
>   kthread+0xf1/0x120
>   ? kthread_complete_and_exit+0x20/0x20
>   ret_from_fork+0x1f/0x30
>   </TASK>
> 
> So just use the cgroup_attach_{lock,unlock}() helper to fix it.
> 
> Fixes: 4f7e7236435c ("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock")
> Reported-by: Zhao Gongyi <zhaogongyi-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Signed-off-by: Qi Zheng <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Applied to cgroupp/for-6.4-fixes w/ Fixes tag updated to 05c7b7a92cc8 (the
commit that 4f7e7236435c fixes) and stable tag added.

Thanks.

-- 
tejun
