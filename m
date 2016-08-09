From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RFC][PATCH] cgroup_threadgroup_rwsem - affects scalability and
 OOM
Date: Tue, 9 Aug 2016 23:57:03 +1000
Message-ID: <20160809135703.GA11823@350D>
References: <4717ef90-ca86-4a34-c63a-94b8b4bfaaec@gmail.com>
 <57A99BCB.6070905@huawei.com>
Reply-To: bsingharora@gmail.com
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D1HEFcVskDkHt7YGuNz0uW43PYL+FatSWyyJXzhA964=;
        b=X/Q9m7iT2fy3WzoEsHthrn1h/gguEKfWvw5V2QLMC4CWOPzVZT/LW/dAsUewvBN6k6
         YhzQ50KfbJWKF09nO2TelelrfUVWZGk2h+qFeKe7tIYYCrjQTdvW3GnXHQy+Tbnma3Cm
         /Luy+6TdbfT4zEGZSXyHozBizrVFn7Ii9PTuk+KBq1g/frKlthR61M1Rbs/5+7Ew9hhD
         BZhVtdMcg1E73VcCtz0G9OnbSLkGt1fCZCey5a7krml8cCo5ZyinaFFv7gnCIRSYaLGA
         eaB07ZuuLTMUckobS1WV6hsChbLfyt2dsGh7hAxxY2FBEk/q0KesUVaT+TwVK/4Vmm4e
         Phug==
Content-Disposition: inline
In-Reply-To: <57A99BCB.6070905@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

On Tue, Aug 09, 2016 at 05:00:59PM +0800, Zefan Li wrote:
> > This almost stalls the system, this patch moves the threadgroup_change_begin
> > from before cgroup_fork() to just before cgroup_canfork(). Ideally we shouldn't
> > have to worry about threadgroup changes till the task is actually added to
> > the threadgroup. This avoids having to call reclaim with cgroup_threadgroup_rwsem
> > held.
> > 
> > There are other theoretical issues with this semaphore
> > 
> > systemd can do
> > 
> > 1. cgroup_mutex (cgroup_kn_lock_live)
> > 2. cgroup_threadgroup_rwsem (W) (__cgroup_procs_write)
> > 
> > and other threads can go
> > 
> > 1. cgroup_threadgroup_rwsem (R) (copy_process)
> > 2. mem_cgroup_iter (as a part of reclaim) (cgroup_mutex -- rcu lock or cgroup_mutex)
> > 
> > However, I've not examined them in too much detail or looked at lockdep
> > wait chains for those paths.
> > 
> > I am sure there is a good reason for placing cgroup_threadgroup_rwsem
> > where it is today and I might be missing something. I am also surprised
> > no-one else has run into it so far.
> > 
> > Comments?
> > 
> 
> We used to use cgroup_threadgroup_rwsem for syncronization between threads
> in the same threadgroup, but now it has evolved to ensure atomic operations
> across multi processes.
> 

Yes and it seems incorrect

> For example, I'm trying to fix a race. See https://lkml.org/lkml/2016/8/8/900
> 
> And the fix kind of relies on the fact that cgroup_post_fork() is placed
> inside the read section of cgroup_threadgroup_rwsem, so that cpuset_fork()
> won't race with cgroup migration.
>

My patch retains that behaviour, before ss->fork() is called we hold
the cgroup_threadgroup_rwsem, in fact it is held prior to ss->can_fork()


Balbir 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
