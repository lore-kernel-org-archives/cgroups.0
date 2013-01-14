From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: synchronize_rcu in cgroup_attach_task and cgroup_attach_proc
Date: Mon, 14 Jan 2013 12:07:17 +0800
Message-ID: <50F38475.6030703@huawei.com>
References: <CAMbhsRQo3mjSMWTtUzqaHbeZqVYafzUjoweWa9Oz3QNRM46PVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMbhsRQo3mjSMWTtUzqaHbeZqVYafzUjoweWa9Oz3QNRM46PVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/1/12 7:48, Colin Cross wrote:
> Quick background:  Android uses cgroups heavily to manage thread
> priorities, putting threads in a background group with reduced
> cpu.shares when they are not visible to the user, and in a foreground
> group when they are.  Some RPCs from foreground threads to background
> threads will temporarily move the background thread into the
> foreground group for the duration of the RPC.  This results in many
> calls to cgroup_attach_task.
> 
> The call to synchronize_rcu() in cgroup_attach_task and
> cgroup_attach_proc can take up to 100ms, and averages 50ms on Nexus 10
> (ARM Exynos5250 SoC) when the cpus are all idle, and similar times
> have been measured on multiple other ARM SMP SoCs.
> 
> I worked with Paul around v3.0 to try to remove the synchronize_rcu
> calls (see https://android.googlesource.com/kernel/common/+/befae2f2c9137d6af5c8b38670f00441019032bb),
> but nobody seemed to have a clear understanding of the full extent of
> what the synchronize_rcu was protecting.  Since then the relevant
> code, especially cgroup_rmdir, has been heavily rewritten, so
> hopefully someone understands it better now.
> 
> The only rcu-protected variable updated in cgroup_attach_task is
> tsk->cgroups.  Freeing the old tsk->cgroups is already rcu-protected
> by kfree_rcu in __put_css_set.  The only thing that happens before
> cgroup_attach_task returns out to userspace is threadgroup_unlock and
> cgroup_unlock.  Is anything relying on cgroup_mutex to be held for an
> RCU grace period?  If not, it seems like the synchronize_rcu isn't
> protecting anything and is just wasting time.
> 

Let's remove these two synchronize_rcu()s without hesitation. If some
subtleties are broken, we'll fix them, and thus make the code saner.

Patch will be sent out soon.
