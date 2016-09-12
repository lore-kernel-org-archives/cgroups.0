From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: handle race between CPU hotplug and
 cpuset_hotplug_work
Date: Mon, 12 Sep 2016 10:48:31 +0800
Message-ID: <57D6177F.8000904@huawei.com>
References: <1473381684-9537-1-git-send-email-joonwoop@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473381684-9537-1-git-send-email-joonwoop-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonwoo Park <joonwoop-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Cc: Tejun

On 2016/9/9 8:41, Joonwoo Park wrote:
> Discrepancy between cpu_online_mask and cpuset's effective CPU masks on
> cpuset hierarchy is inevitable since cpuset defers updating of
> effective CPU masks with workqueue while nothing prevents system from
> doing CPU hotplug.  For that reason guarantee_online_cpus() walks up
> the cpuset hierarchy until it finds intersection under the assumption
> that top cpuset's effective CPU mask intersects with cpu_online_mask
> even under such race.
> 
> However a sequence of CPU hotplugs can open a time window which is none
> of effective CPUs in the top cpuset intersects with cpu_online_mask.
> 
> For example when there are 4 possible CPUs 0-3 where only CPU0 is online:
> 
>   ========================  ===========================
>    cpu_online_mask           top_cpuset.effective_cpus
>   ========================  ===========================
>    echo 1 > cpu2/online.
>    CPU hotplug notifier woke up hotplug work but not yet scheduled.
>       [0,2]                     [0]
> 
>    echo 0 > cpu0/online.
>    The workqueue is still runnable.
>       [2]                       [0]
>   ========================  ===========================
> 
>   Now there is no intersection between cpu_online_mask and
>   top_cpuset.effective_cpus.  Thus invoking sys_sched_setaffinity() at
>   this moment can cause following:
> 
>    Unable to handle kernel NULL pointer dereference at virtual address 000000d0
>    ------------[ cut here ]------------
>    Kernel BUG at ffffffc0001389b0 [verbose debug info unavailable]
>    Internal error: Oops - BUG: 96000005 [#1] PREEMPT SMP
>    Modules linked in:
>    CPU: 2 PID: 1420 Comm: taskset Tainted: G        W       4.4.8+ #98
>    task: ffffffc06a5c4880 ti: ffffffc06e124000 task.ti: ffffffc06e124000
>    PC is at guarantee_online_cpus+0x2c/0x58
>    LR is at cpuset_cpus_allowed+0x4c/0x6c
>    <snip>
>    Process taskset (pid: 1420, stack limit = 0xffffffc06e124020)
>    Call trace:
>    [<ffffffc0001389b0>] guarantee_online_cpus+0x2c/0x58
>    [<ffffffc00013b208>] cpuset_cpus_allowed+0x4c/0x6c
>    [<ffffffc0000d61f0>] sched_setaffinity+0xc0/0x1ac
>    [<ffffffc0000d6374>] SyS_sched_setaffinity+0x98/0xac
>    [<ffffffc000085cb0>] el0_svc_naked+0x24/0x28
> 
> The top cpuset's effective_cpus are guaranteed to be identical to online
> CPUs eventually.  Hence fall back to online CPU mask when there is no
> intersection between top cpuset's effective_cpus and online CPU mask.
> 
> Signed-off-by: Joonwoo Park <joonwoop-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for fixing this!

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.17+

> ---
>  kernel/cpuset.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index c7fd277..b5d2b73 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -325,8 +325,7 @@ static struct file_system_type cpuset_fs_type = {
>  /*
>   * Return in pmask the portion of a cpusets's cpus_allowed that
>   * are online.  If none are online, walk up the cpuset hierarchy
> - * until we find one that does have some online cpus.  The top
> - * cpuset always has some cpus online.
> + * until we find one that does have some online cpus.
>   *
>   * One way or another, we guarantee to return some non-empty subset
>   * of cpu_online_mask.
> @@ -335,8 +334,20 @@ static struct file_system_type cpuset_fs_type = {
>   */
>  static void guarantee_online_cpus(struct cpuset *cs, struct cpumask *pmask)
>  {
> -	while (!cpumask_intersects(cs->effective_cpus, cpu_online_mask))
> +	while (!cpumask_intersects(cs->effective_cpus, cpu_online_mask)) {
>  		cs = parent_cs(cs);
> +		if (unlikely(!cs)) {
> +			/*
> +			 * The top cpuset doesn't have any online cpu in
> +			 * consequence of race between cpuset_hotplug_work
> +			 * and cpu hotplug notifier.  But we know the top
> +			 * cpuset's effective_cpus is on its way to be same
> +			 * with online cpus mask.
> +			 */
> +			cpumask_copy(pmask, cpu_online_mask);
> +			return;
> +		}
> +	}
>  	cpumask_and(pmask, cs->effective_cpus, cpu_online_mask);
>  }
>  
> 
