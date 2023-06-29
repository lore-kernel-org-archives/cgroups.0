From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] cpuset: Allow setscheduler regardless of manipulated
 task
Date: Thu, 29 Jun 2023 08:11:33 -0400
Message-ID: <15c607d9-c1fa-ca11-d675-8f2b3a6fd15b@redhat.com>
References: <20230629091146.28801-1-mkoutny@suse.com>
 <20230629091146.28801-2-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688040700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iUMXrX97pfVEXgUti557n3bGMAKPy8ETXJCsvtuqbtI=;
        b=Cjmq1SOGJJuoaldEXYcOisxPFuhLY3diXOlUw1Xfw0ZZVYIiuWU/K7TGFzoWgJEeqgxWCt
        QZaeFb/DeBeXzWU5s7gtSaWEka4354nVp1lG8mXRiWM6rqx4lzGW49xsaDbRl3gvMDYXGR
        RYDa9+dZY53f1hwqK3U2fh8FDxidD+o=
Content-Language: en-US
In-Reply-To: <20230629091146.28801-2-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


On 6/29/23 05:11, Michal Koutný wrote:
> When we migrate a task between two cgroups, one of the checks is a
> verification whether we can modify task's scheduler settings
> (cap_task_setscheduler()).
>
> An implicit migration occurs also when enabling a controller on the
> unified hierarchy (think of parent to child migration). The
> aforementioned check may be problematic if the caller of the migration
> (enabling a controller) has no permissions over migrated tasks.
> For instance, a user's cgroup that ends up running a process of a
> different user. Although cgroup permissions are configured favorably,
> the enablement fails due to the foreign process [1].
>
> Change the behavior by relaxing the permissions check on the unified
> hierarchy (or in v2 mode). This is in accordance with unified hierarchy
> attachment behavior when permissions of the source to target cgroups are
> decisive whereas the migrated task is opaque (as opposed to more
> restrictive check in __cgroup1_procs_write()).

The is_in_v2_mode() check is for supporting the v2 mode in cgroup v1. 
However, there is no controller enabling in v1. So I think you should 
just use cgroup_subsys_on_dfl(cpuset_cgrp_subsys) as the v2 check if 
your focus is just to prevent problem when enabling cpuset controller.


>
> [1] https://github.com/systemd/systemd/issues/18293#issuecomment-831205649
>
> Signed-off-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index e4ca2dd2b764..3b5f87a9a150 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2495,6 +2495,13 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   		ret = task_can_attach(task, cs->effective_cpus);
>   		if (ret)
>   			goto out_unlock;
> +
> +		/*
> +		 * Skip rights over task check in v2, migration permission derives
> +		 * from hierarchy ownership in cgroup_procs_write_permission()).
> +		 */
> +		if (is_in_v2_mode())
> +			continue;
>   		ret = security_task_setscheduler(task);
>   		if (ret)
>   			goto out_unlock;

This change will likely conflict with the latest cpuset change on 
tracking # of dl tasks in a cpuset. You will have to, at least, move the 
dl task check before the security_task_setscheduler() check.

Another fact about cpuset controller enabling is that both cpus_allowed 
and mems_allowed are empty at that point. You may also add these checks 
as a preconditions for disabling the security_task_setscheduler check.

Cheers,
Longman

