From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Date: Mon, 22 Sep 2014 10:15:50 +0800
Message-ID: <541F8656.2030409@huawei.com>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp> <541D16EA.70407@huawei.com> <20140920172819.GD3681@htj.dyndns.org> <201409211415.GJG26578.MFQOHtSFVJLOOF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201409211415.GJG26578.MFQOHtSFVJLOOF-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fernando_b1-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

>> On Sat, Sep 20, 2014 at 01:55:54PM +0800, Zefan Li wrote:
>>>> Then, what made current->flags to unexpectedly preserve PF_USED_MATH flag?
>>>> The user is running cgrulesengd process in order to utilize cpuset cgroup.
>>>> Thus, cpuset_update_task_spread_flag() is called when cgrulesengd process
>>>> writes someone's pid to /cgroup/cpuset/$group/tasks interface.
>>>>
>>>> cpuset_update_task_spread_flag() is updating other thread's
>>>> "struct task_struct"->flags without exclusion control or atomic
>>>> operations!
>>>>
>>>> ---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------
>>>> 300:/*
>>>> 301: * update task's spread flag if cpuset's page/slab spread flag is set
>>>> 302: *
>>>> 303: * Called with callback_mutex/cgroup_mutex held
>>>> 304: */
>>>> 305:static void cpuset_update_task_spread_flag(struct cpuset *cs,
>>>> 306:                                    struct task_struct *tsk)
>>>> 307:{
>>>> 308:    if (is_spread_page(cs))
>>>> 309:            tsk->flags |= PF_SPREAD_PAGE;
>>>> 310:    else
>>>> 311:            tsk->flags &= ~PF_SPREAD_PAGE;
>>>> 312:    if (is_spread_slab(cs))
>>>> 313:            tsk->flags |= PF_SPREAD_SLAB;
>>>> 314:    else
>>>> 315:            tsk->flags &= ~PF_SPREAD_SLAB;
>>>> 316:}
>>>
>>> We should make the updating of this flag atomic.
>>
>> Ugh, why do we even implement that in cpuset.  This should be handled
>> by MPOL_INTERLEAVE.  It feels like people have been using cpuset as
>> the dumpsite that people used w/o thinking much.  Going forward, let's
>> please confine cpuset to collective cpu and memory affinity
>> configuration.  It really shouldn't be implementing novel features for
>> scheduler or mm.
>>
>> Anyways, yeah, the patch looks correct to me.  Can you please send a
>> version w/ proper description and sob?
>>
> 
> This race condition exists since commit 950592f7b991 ("cpusets: update
> tasks' page/slab spread flags in time") (i.e. Linux 2.6.31 and later)
> but "struct task_struct"->atomic_flags was added in Linux 3.17.
> 
> If use of ->atomic_flags for cpuset is acceptable, how should we fix
> older kernels? Backport ->atomic_flags?
> 

Yeah, we'll just add tsk->atomic_flags to struct task_struct when
backporting this patch for stable trees.
