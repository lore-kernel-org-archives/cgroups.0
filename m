From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix a race between cpuset_attach() and cpu
 hotplug
Date: Fri, 21 Jan 2022 07:43:08 -0500
Message-ID: <a166a39f-aa9f-95af-3f3f-f4e17e7c3305@redhat.com>
References: <20220121101210.84926-1-zhangqiao22@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642768997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4npqjtp4XyHuyXZdSlqBznaQ1OqDTHRAdb5cB+lM/zc=;
        b=PXIn/UNnBJVjU84zryMv1X6arDqVGAVkQ5mkZBKPAj4GJOVqRnPW25ZhurHfLRA8WF0VmP
        +K+fALcOy13dirYaS5VuNWnM7aTuTLiRy0MRRq3vZhBd+4dp/nKW7bHH7JHVjzdmzF+t3y
        fjxxtDh+7JHwx6PhNyU2hXinvnP0tNw=
Content-Language: en-US
In-Reply-To: <20220121101210.84926-1-zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, bblum-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 1/21/22 05:12, Zhang Qiao wrote:
> As previously discussed(https://lkml.org/lkml/2022/1/20/51),
> cpuset_attach() is affected with similar cpu hotplug race,
> as follow scenario:
>
>       cpuset_attach()				cpu hotplug
>      ---------------------------            ----------------------
>      down_write(cpuset_rwsem)
>      guarantee_online_cpus() // (load cpus_attach)
> 					sched_cpu_deactivate
> 					  set_cpu_active()
> 					  // will change cpu_active_mask
>      set_cpus_allowed_ptr(cpus_attach)
>        __set_cpus_allowed_ptr_locked()
>         // (if the intersection of cpus_attach and
>           cpu_active_mask is empty, will return -EINVAL)
>      up_write(cpuset_rwsem)
>
> To avoid races such as described above, protect cpuset_attach() call
> with cpu_hotplug_lock.
>
> Fixes: be367d099270 ("cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time")
> Reported-by: Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index dc653ab26e50..0af5725cc1df 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2252,6 +2252,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>   	cgroup_taskset_first(tset, &css);
>   	cs = css_cs(css);
>
> +	cpus_read_lock();
>   	percpu_down_write(&cpuset_rwsem);
>
>   	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
> @@ -2305,6 +2306,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
>   		wake_up(&cpuset_attach_wq);
>
>   	percpu_up_write(&cpuset_rwsem);
> +	cpus_read_unlock();
>   }
>
>   /* The various types of files and directories in a cpuset file system */
> --
> 2.18.0

The locking sequence looks right.

Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

