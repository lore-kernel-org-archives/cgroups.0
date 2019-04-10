From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2] cpuset: restore sanity to
 cpuset_cpus_allowed_fallback()
Date: Wed, 10 Apr 2019 12:11:18 -0400
Message-ID: <50099ef3-ae62-2ed0-1294-2df3475c299d@redhat.com>
References: <20190409204003.6428-1-jsavitz@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190409204003.6428-1-jsavitz@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joel Savitz <jsavitz@redhat.com>, linux-kernel@vger.kernel.org
Cc: Phil Auld <pauld@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

On 04/09/2019 04:40 PM, Joel Savitz wrote:
> If a process is limited by taskset (i.e. cpuset) to only be allowed to
> run on cpu N, and then cpu N is offlined via hotplug, the process will
> be assigned the current value of its cpuset cgroup's effective_cpus field
> in a call to do_set_cpus_allowed() in cpuset_cpus_allowed_fallback().
> This argument's value does not makes sense for this case, because
> task_cs(tsk)->effective_cpus is modified by cpuset_hotplug_workfn()
> to reflect the new value of cpu_active_mask after cpu N is removed from
> the mask. While this may make sense for the cgroup affinity mask, it
> does not make sense on a per-task basis, as a task that was previously
> limited to only be run on cpu N will be limited to every cpu _except_ for
> cpu N after it is offlined/onlined via hotplug.
>
> Pre-patch behavior:
>
> 	$ grep Cpus /proc/$$/status
> 	Cpus_allowed:	ff
> 	Cpus_allowed_list:	0-7
>
> 	$ taskset -p 4 $$
> 	pid 19202's current affinity mask: f
> 	pid 19202's new affinity mask: 4
>
> 	$ grep Cpus /proc/self/status
> 	Cpus_allowed:	04
> 	Cpus_allowed_list:	2
>
> 	# echo off > /sys/devices/system/cpu/cpu2/online
> 	$ grep Cpus /proc/$$/status
> 	Cpus_allowed:	0b
> 	Cpus_allowed_list:	0-1,3
>
> 	# echo on > /sys/devices/system/cpu/cpu2/online
> 	$ grep Cpus /proc/$$/status
> 	Cpus_allowed:	0b
> 	Cpus_allowed_list:	0-1,3
>
> On a patched system, the final grep produces the following
> output instead:
>
> 	$ grep Cpus /proc/$$/status
> 	Cpus_allowed:	ff
> 	Cpus_allowed_list:	0-7
>
> This patch changes the above behavior by instead resetting the mask to
> task_cs(tsk)->cpus_allowed by default, and cpu_possible mask in legacy
> mode.
>
> This fallback mechanism is only triggered if _every_ other valid avenue
> has been traveled, and it is the last resort before calling BUG().
>
> Signed-off-by: Joel Savitz <jsavitz@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 4834c4214e9c..6c9deb2cc687 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3255,10 +3255,23 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
>  	spin_unlock_irqrestore(&callback_lock, flags);
>  }
>  
> +/**
> + * cpuset_cpus_allowed_fallback - final fallback before complete catastrophe.
> + * @tsk: pointer to task_struct with which the scheduler is struggling
> + *
> + * Description: In the case that the scheduler cannot find an allowed cpu in
> + * tsk->cpus_allowed, we fall back to task_cs(tsk)->cpus_allowed. In legacy
> + * mode however, this value is the same as task_cs(tsk)->effective_cpus,
> + * which will not contain a sane cpumask during cases such as cpu hotplugging.
> + * This is the absolute last resort for the scheduler and it is only used if
> + * _every_ other avenue has been traveled.
> + **/
> +
>  void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
>  {
>  	rcu_read_lock();
> -	do_set_cpus_allowed(tsk, task_cs(tsk)->effective_cpus);
> +	do_set_cpus_allowed(tsk, is_in_v2_mode() ?
> +		task_cs(tsk)->cpus_allowed : cpu_possible_mask);
>  	rcu_read_unlock();
>  
>  	/*

Acked-by: Waiman Long <longman@redhat.com>

