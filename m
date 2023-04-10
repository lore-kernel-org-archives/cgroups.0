From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] mm: oom: introduce cpuset oom
Date: Mon, 10 Apr 2023 12:26:15 -0400
Message-ID: <0978e4c6-0af5-be68-dc8d-3b55d00ec2cd@redhat.com>
References: <20230410025056.22103-1-ligang.bdlg@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681143980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3K4izxTpeZeRb9RjlSqD5EHbDYTo8MP2lTjHdQRyzJo=;
        b=fLLlypiAdOEgziS4D6QbKHWq9QVtwwtMs0lc8xokDafzBlKAuzs/tGPBvkgMsDeIaM8PDc
        QPfR20p0nyvYQSXPgevZrgDl0midUD7Jn9r9EDImOUXdL8nUlIbTdHaToPp+z+J1hrHeWU
        pic1Z0Bm75+iQyg0WT0pSmTW0p4ggx8=
Content-Language: en-US
In-Reply-To: <20230410025056.22103-1-ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 4/9/23 22:50, Gang Li wrote:
> Cpusets constrain the CPU and Memory placement of tasks.
> `CONSTRAINT_CPUSET` type in oom  has existed for a long time, but
> has never been utilized.
>
> When a process in cpuset which constrain memory placement triggers
> oom, it may kill a completely irrelevant process on other numa nodes,
> which will not release any memory for this cpuset.
>
> We can easily achieve node aware oom by using `CONSTRAINT_CPUSET` and
> selecting victim from all cpusets with the same mems_allowed as the
> current cpuset.
>
> Example:
>
> Create two processes named mem_on_node0 and mem_on_node1 constrained
> by cpusets respectively. These two processes alloc memory on their
> own node. Now node0 has run out of memory, OOM will be invokled by
> mem_on_node0.
>
> Before this patch:
>
> Since `CONSTRAINT_CPUSET` do nothing, the victim will be selected from
> the entire system. Therefore, the OOM is highly likely to kill
> mem_on_node1, which will not free any memory for mem_on_node0. This
> is a useless kill.
>
> ```
> [ 2786.519080] mem_on_node0 invoked oom-killer
> [ 2786.885738] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
> [ 2787.181724] [  13432]     0 13432   787016   786745  6344704        0             0 mem_on_node1
> [ 2787.189115] [  13457]     0 13457   787002   785504  6340608        0             0 mem_on_node0
> [ 2787.216534] oom-kill:constraint=CONSTRAINT_CPUSET,nodemask=(null),cpuset=test,mems_allowed=0
> [ 2787.229991] Out of memory: Killed process 13432 (mem_on_node1)
> ```
>
> After this patch:
>
> The victim will be selected only in all cpusets that have the same
> mems_allowed as the cpuset that invoked oom. This will prevent
> useless kill and protect innocent victims.
>
> ```
> [  395.922444] mem_on_node0 invoked oom-killer
> [  396.239777] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
> [  396.246128] [   2614]     0  2614  1311294  1144192  9224192        0             0 mem_on_node0
> [  396.252655] oom-kill:constraint=CONSTRAINT_CPUSET,nodemask=(null),cpuset=test,mems_allowed=0
> [  396.264068] Out of memory: Killed process 2614 (mem_on_node0)
> ```
>
> Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Cc: <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
> Cc: <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Signed-off-by: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Thanks for the update.
> ---
> Changes in v3:
> - Provide more details about the use case, testing, implementation.
> - Document the userspace visible change in Documentation.
> - Rename cpuset_cgroup_scan_tasks() to cpuset_scan_tasks() and add
>    a doctext comment about its purpose and how it should be used.
> - Take cpuset_rwsem to ensure that cpusets are stable.
>
> Changes in v2:
> - https://lore.kernel.org/all/20230404115509.14299-1-ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> - Select victim from all cpusets with the same mems_allowed as the current cpuset.
>    (David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>)
>
> v1:
> - https://lore.kernel.org/all/20220921064710.89663-1-ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> - Introduce cpuset oom.
> ---
>   .../admin-guide/cgroup-v1/cpusets.rst         | 14 +++++-
>   include/linux/cpuset.h                        |  6 +++
>   kernel/cgroup/cpuset.c                        | 44 +++++++++++++++++++
>   mm/oom_kill.c                                 |  4 ++
>   4 files changed, 66 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
> index 5d844ed4df69..d686cd47e91d 100644
> --- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
> +++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
> @@ -25,7 +25,8 @@ Written by Simon.Derr-6ktuUTfB/bM@public.gmane.org
>        1.6 What is memory spread ?
>        1.7 What is sched_load_balance ?
>        1.8 What is sched_relax_domain_level ?
> -     1.9 How do I use cpusets ?
> +     1.9 What is cpuset oom ?
> +     1.10 How do I use cpusets ?
>      2. Usage Examples and Syntax
>        2.1 Basic Usage
>        2.2 Adding/removing cpus
> @@ -607,8 +608,17 @@ If your situation is:
>    - The latency is required even it sacrifices cache hit rate etc.
>      then increasing 'sched_relax_domain_level' would benefit you.
>   
> +1.9 What is cpuset oom ?
> +--------------------------
> +If there is no available memory to allocate on the nodes specified by
> +cpuset.mems, then an OOM (Out-Of-Memory) will be invoked.
> +
> +Since the victim selection is a heuristic algorithm, we cannot select
> +the "perfect" victim. Therefore, currently, the victim will be selected
> +from all the cpusets that have the same mems_allowed as the cpuset
> +which invoked OOM.
Nit: That feature is not specific to cgroup v1, as it applies to v2 as 
well. Maybe you can be more specific about that.
>   
> -1.9 How do I use cpusets ?
> +1.10 How do I use cpusets ?
>   --------------------------
>   
>   In order to minimize the impact of cpusets on critical kernel
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 980b76a1237e..75465bf58f74 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -171,6 +171,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
>   	task_unlock(current);
>   }
>   
> +int cpuset_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg);
> +
>   #else /* !CONFIG_CPUSETS */
>   
>   static inline bool cpusets_enabled(void) { return false; }
> @@ -287,6 +289,10 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
>   	return false;
>   }
>   
> +static inline int cpuset_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg)
> +{
> +	return 0;
> +}
>   #endif /* !CONFIG_CPUSETS */
>   
>   #endif /* _LINUX_CPUSET_H */
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index bc4dcfd7bee5..4c51225568aa 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4013,6 +4013,50 @@ void cpuset_print_current_mems_allowed(void)
>   	rcu_read_unlock();
>   }
>   
> +/**
> + * cpuset_scan_tasks - specify the oom scan range
> + * @fn: callback function to select oom victim
> + * @arg: argument for callback function, usually a pointer to struct oom_control
> + *
> + * Description: This function is used to specify the oom scan range. Return 0 if
> + * no task is selected, otherwise return 1. The selected task will be stored in
> + * arg->chosen. Thins function can only be called in select_bad_process()
> + * while oc->onstraint == CONSTRAINT_CPUSET.

Nit: That is not strictly correct as dump_tasks() will call this as well.

Cheers,
Longman

