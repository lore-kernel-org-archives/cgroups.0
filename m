From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Wed, 23 Nov 2022 07:05:05 -1000
Message-ID: <Y35Swdpq+rJe+Tu3@slm.duckdns.org>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EztbpzZ3Kt/PihSs3M5nNP63NaXEehzBdLCvtUKvG5E=;
        b=RKa7MkTVo23uF7O9o9uVprUaLAkBBOnLupy8+9eq20WsELWHC3gn7EWXE5QZZKHWgE
         W5gpisnVSt2PfdQ7o92wW2ZgQOV2rO1+3Vp37Ti4G1tz2xNLFT7FdKUezFaDTEydRocP
         6J6urHkFaCS43MXSYtQP6FWwUqNcuGr90JoGwco/EBCVJCXNfQi0jRRzoEeIzgbNgwQ+
         fiL7/oB351BuHm4WO7aOCpXQ88TnjwPch218oKonZo8m81RUIAsKhRr4oThK/j4x/Pfd
         v+z6sXCqjjMEyf55xjUOAgWso7nGWdw00Lk/NqavHQsNO6YNwSU5UbZKd6YcuEoisdD1
         vX7w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221123082157.71326-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 08:21:57AM +0000, haifeng.xu wrote:
> When change the 'cpuset.mems' under some cgroup, system will hung
> for a long time. From the dmesg, many processes or theads are
> stuck in fork/exit. The reason is show as follows.
> 
> thread A:
> cpuset_write_resmask /* takes cpuset_rwsem */
>   ...
>     update_tasks_nodemask
>       mpol_rebind_mm /* waits mmap_lock */
> 
> thread B:
> worker_thread
>   ...
>     cpuset_migrate_mm_workfn
>       do_migrate_pages /* takes mmap_lock */
> 
> thread C:
> cgroup_procs_write /* takes cgroup_mutex and cgroup_threadgroup_rwsem */
>   ...
>     cpuset_can_attach
>       percpu_down_write /* waits cpuset_rwsem */
> 
> Once update the nodemasks of cpuset, thread A wakes up thread B to
> migrate mm. But when thread A iterates through all tasks, including
> child threads and group leader, it has to wait the mmap_lock which
> has been take by thread B. Unfortunately, thread C wants to migrate
> tasks into cgroup at this moment, it must wait thread A to release
> cpuset_rwsem. If thread B spends much time to migrate mm, the
> fork/exit which acquire cgroup_threadgroup_rwsem also need to
> wait for a long time.
> 
> There is no need to migrate the mm of child threads which is
> shared with group leader. 

This is only a problem in cgroup1 and cgroup1 doesn't require the threads of
a given task to be in the same cgroup. I don't think you can optimize it
this way.

Thanks.

-- 
tejun
