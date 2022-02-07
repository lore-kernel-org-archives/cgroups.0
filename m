From: Zhang Qiao <zhangqiao22@huawei.com>
Subject: Re: [PATCH] cgroup/cpuset: Fix a race between cpuset_attach() and cpu
 hotplug
Date: Mon, 7 Feb 2022 14:17:30 +0800
Message-ID: <0761d941-8fbb-d06b-3d0b-8330c8b54499@huawei.com>
References: <20220121101210.84926-1-zhangqiao22@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20220121101210.84926-1-zhangqiao22@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, matthltc@us.ibm.com, bblum@google.com, menage@google.com, akpm@linux-foundation.org, longman@redhat.com, mkoutny@suse.com, zhaogongyi@huawei.com

Gentle ping on this patch.

在 2022/1/21 18:12, Zhang Qiao 写道:
> As previously discussed(https://lkml.org/lkml/2022/1/20/51),
> cpuset_attach() is affected with similar cpu hotplug race,
> as follow scenario:
> 
>      cpuset_attach()				cpu hotplug
>     ---------------------------            ----------------------
>     down_write(cpuset_rwsem)
>     guarantee_online_cpus() // (load cpus_attach)
> 					sched_cpu_deactivate
> 					  set_cpu_active()
> 					  // will change cpu_active_mask
>     set_cpus_allowed_ptr(cpus_attach)
>       __set_cpus_allowed_ptr_locked()
>        // (if the intersection of cpus_attach and
>          cpu_active_mask is empty, will return -EINVAL)
>     up_write(cpuset_rwsem)
> 
> To avoid races such as described above, protect cpuset_attach() call
> with cpu_hotplug_lock.
> 
> Fixes: be367d099270 ("cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time")
> Reported-by: Zhao Gongyi <zhaogongyi@huawei.com>
> Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
> ---
>  kernel/cgroup/cpuset.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index dc653ab26e50..0af5725cc1df 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2252,6 +2252,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>  	cgroup_taskset_first(tset, &css);
>  	cs = css_cs(css);
> 
> +	cpus_read_lock();
>  	percpu_down_write(&cpuset_rwsem);
> 
>  	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
> @@ -2305,6 +2306,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>  		wake_up(&cpuset_attach_wq);
> 
>  	percpu_up_write(&cpuset_rwsem);
> +	cpus_read_unlock();
>  }
> 
>  /* The various types of files and directories in a cpuset file system */
> --
> 2.18.0
> 
> .
> 
