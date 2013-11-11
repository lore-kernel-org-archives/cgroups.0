From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 11 Nov 2013 16:39:43 +0100
Message-ID: <20131111153943.GA22384@dhcp22.suse.cz>
References: <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131031192732.2dbb14b3@gandalf.local.home>
 <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131108001437.GC1092@cmpxchg.org>
 <CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 08-11-13 11:20:53, Markus Blank-Burian wrote:
> Thanks for the patch Johannes!
> 
> I tried tried it immediately, but it still hangs. But this time the
> worker threads have a slightly different call stack. Most of them are
> now waiting in css_killed_work_fn:
> 
>   [ffff880c31a33e18] mutex_lock at ffffffff813c1bb4
>   [ffff880c31a33e30] css_killed_work_fn at ffffffff81080eba
>   [ffff880c31a33e50] process_one_work at ffffffff8103f7db
>   [ffff880c31a33e90] worker_thread at ffffffff8103fc7d
>   [ffff880c31a33eb0] worker_thread at ffffffff8103fb39
>   [ffff880c31a33ec8] kthread at ffffffff8104479c
>   [ffff880c31a33f28] kthread at ffffffff81044714
>   [ffff880c31a33f50] ret_from_fork at ffffffff813c503c
>   [ffff880c31a33f80] kthread at ffffffff81044714
> 
> The other few workers hang at the beginning of proc_cgroupstats_show
> and one in cgroup_rmdir:
> 
>   [ffff8800b7825e40] mutex_lock at ffffffff813c1bb4
>   [ffff8800b7825e58] proc_cgroupstats_show at ffffffff8107f5f0
>   [ffff8800b7825e78] seq_read at ffffffff81107953
>   [ffff8800b7825ee0] proc_reg_read at ffffffff81135f73
>   [ffff8800b7825f18] vfs_read at ffffffff810ed3ea
>   [ffff8800b7825f48] sys_read at ffffffff810edad6
>   [ffff8800b7825f80] tracesys at ffffffff813c52db
> 
>   [ffff880c308e1e40] mutex_lock at ffffffff813c1bb4
>   [ffff880c308e1e58] cgroup_rmdir at ffffffff81081d25
>   [ffff880c308e1e78] vfs_rmdir at ffffffff810f8bed
>   [ffff880c308e1ea0] do_rmdir at ffffffff810f8d02
>   [ffff880c308e1f18] user_exit at ffffffff8100aed1
>   [ffff880c308e1f28] syscall_trace_enter at ffffffff8100c356
>   [ffff880c308e1f70] sys_rmdir at ffffffff810f9a95
>   [ffff880c308e1f80] tracesys at ffffffff813c52db

These three are blocked on cgroup_mutex which is held by
css_killed_work_fn below. So if we are really looping there then the
whole cgroup core is blocked.

> The looping thread is still this one:
> 
>   [ffff880c30049d50] mem_cgroup_reparent_charges at ffffffff810e637b
>   [ffff880c30049de0] mem_cgroup_css_offline at ffffffff810e679d
>   [ffff880c30049e10] offline_css at ffffffff8107f02f
>   [ffff880c30049e30] css_killed_work_fn at ffffffff81080ec2
>   [ffff880c30049e50] process_one_work at ffffffff8103f7db
>   [ffff880c30049e90] worker_thread at ffffffff8103fc7d
>   [ffff880c30049eb0] worker_thread at ffffffff8103fb39
>   [ffff880c30049ec8] kthread at ffffffff8104479c
>   [ffff880c30049f28] kthread at ffffffff81044714
>   [ffff880c30049f50] ret_from_fork at ffffffff813c503c
>   [ffff880c30049f80] kthread at ffffffff81044714

Out of curiosity, do you have memcg swap accounting enabled? Or do you
use kmem accounting? How does your cgroup tree look like?

Sorry if this has been asked before but I do not see the thread from the
beginning.

-- 
Michal Hocko
SUSE Labs
