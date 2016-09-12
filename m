From: Joonwoo Park <joonwoop-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cpuset: handle race between CPU hotplug and
 cpuset_hotplug_work
Date: Sun, 11 Sep 2016 21:05:47 -0700
Message-ID: <20160912040547.k3qtivdcet6p4mel@codeaurora.org>
References: <1473381684-9537-1-git-send-email-joonwoop@codeaurora.org>
 <57D6177F.8000904@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57D6177F.8000904-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, Sep 12, 2016 at 10:48:31AM +0800, Zefan Li wrote:
> Cc: Tejun
> 
> On 2016/9/9 8:41, Joonwoo Park wrote:
> > Discrepancy between cpu_online_mask and cpuset's effective CPU masks on
> > cpuset hierarchy is inevitable since cpuset defers updating of
> > effective CPU masks with workqueue while nothing prevents system from
> > doing CPU hotplug.  For that reason guarantee_online_cpus() walks up
> > the cpuset hierarchy until it finds intersection under the assumption
> > that top cpuset's effective CPU mask intersects with cpu_online_mask
> > even under such race.
> > 
> > However a sequence of CPU hotplugs can open a time window which is none
> > of effective CPUs in the top cpuset intersects with cpu_online_mask.
> > 
> > For example when there are 4 possible CPUs 0-3 where only CPU0 is online:
> > 
> >   ========================  ===========================
> >    cpu_online_mask           top_cpuset.effective_cpus
> >   ========================  ===========================
> >    echo 1 > cpu2/online.
> >    CPU hotplug notifier woke up hotplug work but not yet scheduled.
> >       [0,2]                     [0]
> > 
> >    echo 0 > cpu0/online.
> >    The workqueue is still runnable.
> >       [2]                       [0]
> >   ========================  ===========================
> > 
> >   Now there is no intersection between cpu_online_mask and
> >   top_cpuset.effective_cpus.  Thus invoking sys_sched_setaffinity() at
> >   this moment can cause following:
> > 
> >    Unable to handle kernel NULL pointer dereference at virtual address 000000d0
> >    ------------[ cut here ]------------
> >    Kernel BUG at ffffffc0001389b0 [verbose debug info unavailable]
> >    Internal error: Oops - BUG: 96000005 [#1] PREEMPT SMP
> >    Modules linked in:
> >    CPU: 2 PID: 1420 Comm: taskset Tainted: G        W       4.4.8+ #98
> >    task: ffffffc06a5c4880 ti: ffffffc06e124000 task.ti: ffffffc06e124000
> >    PC is at guarantee_online_cpus+0x2c/0x58
> >    LR is at cpuset_cpus_allowed+0x4c/0x6c
> >    <snip>
> >    Process taskset (pid: 1420, stack limit = 0xffffffc06e124020)
> >    Call trace:
> >    [<ffffffc0001389b0>] guarantee_online_cpus+0x2c/0x58
> >    [<ffffffc00013b208>] cpuset_cpus_allowed+0x4c/0x6c
> >    [<ffffffc0000d61f0>] sched_setaffinity+0xc0/0x1ac
> >    [<ffffffc0000d6374>] SyS_sched_setaffinity+0x98/0xac
> >    [<ffffffc000085cb0>] el0_svc_naked+0x24/0x28
> > 
> > The top cpuset's effective_cpus are guaranteed to be identical to online
> > CPUs eventually.  Hence fall back to online CPU mask when there is no
> > intersection between top cpuset's effective_cpus and online CPU mask.
> > 
> > Signed-off-by: Joonwoo Park <joonwoop-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> > Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> Thanks for fixing this!
> 
> Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.17+
> 

Thanks for reviewing.

Shortly I will send v2 which has few grammar error fixes in the
changelog.
No code change has made.

Joonwoo
