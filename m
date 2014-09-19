From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Date: Sat, 20 Sep 2014 00:21:03 +0200
Message-ID: <20140919222103.GH2832@worktop.localdomain>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201409192053.IHJ35462.JLOMOSOFFVtQFH-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fernando_b1-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, Sep 19, 2014 at 08:53:33PM +0900, Tetsuo Handa wrote:
> cpuset_update_task_spread_flag() is updating other thread's
> "struct task_struct"->flags without exclusion control or atomic
> operations!
> 
> ---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------
> 300:/*
> 301: * update task's spread flag if cpuset's page/slab spread flag is set
> 302: *
> 303: * Called with callback_mutex/cgroup_mutex held
> 304: */
> 305:static void cpuset_update_task_spread_flag(struct cpuset *cs,
> 306:                                    struct task_struct *tsk)
> 307:{
> 308:    if (is_spread_page(cs))
> 309:            tsk->flags |= PF_SPREAD_PAGE;
> 310:    else
> 311:            tsk->flags &= ~PF_SPREAD_PAGE;
> 312:    if (is_spread_slab(cs))
> 313:            tsk->flags |= PF_SPREAD_SLAB;
> 314:    else
> 315:            tsk->flags &= ~PF_SPREAD_SLAB;
> 316:}

So that is indeed clearly buggy and should not be done. One should only
every change current->flags.

Most sites do indeed do that, with exceptions:

 fork.c: some assignments are done before the new task is visible - safe
 __kthread_bind: requires that the task is sleeping - safe
 workqueue/worker: same as __kthread_bind, the task is asleep - safe
 workqueue/rescue: is current - safe

Which does indeed leave this cpuset exception which is clearly and
obviously broken.

The 'simple' solution would be to force 'suspend/freeze' the task while
poking at its ->flags.

