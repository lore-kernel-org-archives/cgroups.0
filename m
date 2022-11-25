From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup/cpuset: Clean up cpuset_task_status_allowed
Date: Fri, 25 Nov 2022 17:51:53 -0500
Message-ID: <991abacd-ba35-f06c-6f25-793d3e45926e@redhat.com>
References: <20221125075133.12718-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669416720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SzvRXW76btfy/JOc5ym9c3+SoFVqAx5jbHxLD+PWPus=;
        b=DijFfRYkbAcuv5UG1A6At11DydSB+c8m6bDlvAueqMFMZpMS51LJrqrfls6Ht7bfL2f3Lm
        wEiV+bSOJuUpSSCclS+wCwljk+BA7EVicOdc6wTwIwKl2b9TryYu2y7scCvzfgrkOclQ98
        u7PMfT1Jr5kqUkpz4YOyQm1c0Zz+g9k=
Content-Language: en-US
In-Reply-To: <20221125075133.12718-1-haifeng.xu@shopee.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "haifeng.xu" <haifeng.xu@shopee.com>
Cc: lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/25/22 02:51, haifeng.xu wrote:
> cpuset_task_status_allowed just shows mems_allowed status, so
> rename it to task_mems_allowed. Moreover, it's only used in
> proc_pid_status, so move it to fs/proc/array.c. There is no
> intentional function change.
>
> Signed-off-by: haifeng.xu <haifeng.xu@shopee.com>
> ---
>   fs/proc/array.c        | 13 +++++++++++--
>   include/linux/cpuset.h |  7 -------
>   kernel/cgroup/cpuset.c |  9 ---------
>   3 files changed, 11 insertions(+), 18 deletions(-)
>
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 49283b8103c7..e6cdef8387e6 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -80,7 +80,6 @@
>   #include <linux/file.h>
>   #include <linux/fdtable.h>
>   #include <linux/times.h>
> -#include <linux/cpuset.h>
>   #include <linux/rcupdate.h>
>   #include <linux/delayacct.h>
>   #include <linux/seq_file.h>
> @@ -413,6 +412,16 @@ static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
>   		   cpumask_pr_args(&task->cpus_mask));
>   }
>   
> +static void task_mems_allowed(struct seq_file *m, struct task_struct *task)
> +{
> +#ifdef CONFIG_CPUSETS
> +	seq_printf(m, "Mems_allowed:\t%*pb\n",
> +		   nodemask_pr_args(&task->mems_allowed));
> +	seq_printf(m, "Mems_allowed_list:\t%*pbl\n",
> +		   nodemask_pr_args(&task->mems_allowed));
> +#endif
> +}
> +
>   static inline void task_core_dumping(struct seq_file *m, struct task_struct *task)
>   {
>   	seq_put_decimal_ull(m, "CoreDumping:\t", !!task->signal->core_state);
> @@ -449,7 +458,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>   	task_cap(m, task);
>   	task_seccomp(m, task);
>   	task_cpus_allowed(m, task);
> -	cpuset_task_status_allowed(m, task);
> +	task_mems_allowed(m, task);
>   	task_context_switch_counts(m, task);
>   	return 0;
>   }
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index d58e0476ee8e..30b91116dd2f 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -112,8 +112,6 @@ extern int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
>   extern int cpuset_memory_pressure_enabled;
>   extern void __cpuset_memory_pressure_bump(void);
>   
> -extern void cpuset_task_status_allowed(struct seq_file *m,
> -					struct task_struct *task);
>   extern int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
>   			    struct pid *pid, struct task_struct *tsk);
>   
> @@ -246,11 +244,6 @@ static inline int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
>   
>   static inline void cpuset_memory_pressure_bump(void) {}
>   
> -static inline void cpuset_task_status_allowed(struct seq_file *m,
> -						struct task_struct *task)
> -{
> -}
> -
>   static inline int cpuset_mem_spread_node(void)
>   {
>   	return 0;
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 589827ccda8b..5798d4231662 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4045,12 +4045,3 @@ int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
>   	return retval;
>   }
>   #endif /* CONFIG_PROC_PID_CPUSET */
> -
> -/* Display task mems_allowed in /proc/<pid>/status file. */
> -void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
> -{
> -	seq_printf(m, "Mems_allowed:\t%*pb\n",
> -		   nodemask_pr_args(&task->mems_allowed));
> -	seq_printf(m, "Mems_allowed_list:\t%*pbl\n",
> -		   nodemask_pr_args(&task->mems_allowed));
> -}

It is just a minor cleanup. I think that is OK.

Acked-by: Waiman Long <longman@redhat.com>

