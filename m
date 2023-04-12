From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup,freezer: hold cpu_hotplug_lock before
 freezer_mutex
Date: Wed, 12 Apr 2023 07:31:19 -1000
Message-ID: <ZDbq563-czAiFFQb@slm.duckdns.org>
References: <00000000000009483d05ec7a6b93@google.com>
 <695b8d1c-6b7a-91b1-6941-c459cab038b0@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681320681; x=1683912681;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVE3G2vtoNe3tigwWwJhpxVf0V7qF7ZUFUl9foF/vUg=;
        b=U08PSEwkK+i+EG82Qzu3ybPuJ6WSf1SmNz8kb81QHhHmXbi/seRIaE6A2nHNN9s3H9
         GiVOJCz/B2TLEtghEPIjuk2DGe4OZDEE088ZWuDOYtHca776MnKKCEr8NmbeBnIorhXT
         Z5i4Wwus+Kuri7B66levj6GTyRQCL06SMbi2vJva4WO0/zlp6bYRKSknCuu722aUpUB5
         dRg4hJiNI1v9u6eFocJvBsZH2HpKHxOvlQy3JxGHrvpT919rSvAO1MedCyQj14kcRh7k
         g0BIybZWbqcEKlZ4XgxiBx66Rl0Ujg7XLStvI4+S8Af38DkkP9bFixy5cconkBIIit2N
         AA5g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <695b8d1c-6b7a-91b1-6941-c459cab038b0-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+c39682e86c9d84152f93-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>

On Wed, Apr 05, 2023 at 10:15:32PM +0900, Tetsuo Handa wrote:
> syzbot is reporting circular locking dependency between cpu_hotplug_lock
> and freezer_mutex, for commit f5d39b020809 ("freezer,sched: Rewrite core
> freezer logic") replaced atomic_inc() in freezer_apply_state() with
> static_branch_inc() which holds cpu_hotplug_lock.
> 
> cpu_hotplug_lock => cgroup_threadgroup_rwsem => freezer_mutex
> 
>   cgroup_file_write() {
>     cgroup_procs_write() {
>       __cgroup_procs_write() {
>         cgroup_procs_write_start() {
>           cgroup_attach_lock() {
>             cpus_read_lock() {
>               percpu_down_read(&cpu_hotplug_lock);
>             }
>             percpu_down_write(&cgroup_threadgroup_rwsem);
>           }
>         }
>         cgroup_attach_task() {
>           cgroup_migrate() {
>             cgroup_migrate_execute() {
>               freezer_attach() {
>                 mutex_lock(&freezer_mutex);
>                 (...snipped...)
>               }
>             }
>           }
>         }
>         (...snipped...)
>       }
>     }
>   }
> 
> freezer_mutex => cpu_hotplug_lock
> 
>   cgroup_file_write() {
>     freezer_write() {
>       freezer_change_state() {
>         mutex_lock(&freezer_mutex);
>         freezer_apply_state() {
>           static_branch_inc(&freezer_active) {
>             static_key_slow_inc() {
>               cpus_read_lock();
>               static_key_slow_inc_cpuslocked();
>               cpus_read_unlock();
>             }
>           }
>         }
>         mutex_unlock(&freezer_mutex);
>       }
>     }
>   }
> 
> Swap locking order by moving cpus_read_lock() in freezer_apply_state()
> to before mutex_lock(&freezer_mutex) in freezer_change_state().
> 
> Reported-by: syzbot <syzbot+c39682e86c9d84152f93-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
> Link: https://syzkaller.appspot.com/bug?extid=c39682e86c9d84152f93
> Suggested-by: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>
> Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>

Applied to cgroup/for-6.3-fixes.

Thanks.

-- 
tejun
