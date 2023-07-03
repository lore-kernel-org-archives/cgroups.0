From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] cpuset: Allow setscheduler regardless of
 manipulated task
Date: Mon, 3 Jul 2023 14:00:13 -0400
Message-ID: <f54ae464-6684-5640-4b1e-90af0cb769cd@redhat.com>
References: <20230703172741.25392-1-mkoutny@suse.com>
 <20230703172741.25392-2-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688407215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VjXD9hgua/WyFNkzAf/5dqsBFSxFdg110zmVMs5EXro=;
        b=HzCMh324nktszn4H8HB/7Be3jbomVWGJWvQNNC8QAYhTJ/AkoBEZvjvvxu22/6qbfzqzFF
        m8wUQKgP/mDs6OpSaEHS792R19AmHy8YIWYvC/2JIi07ApYYLkDOIjLeXMZ9TM3KGxT7oq
        fC9bvQrCzZm1qfDR6YwhpfcJ8tLz2Jw=
Content-Language: en-US
In-Reply-To: <20230703172741.25392-2-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 7/3/23 13:27, Michal Koutný wrote:
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
> hierarchy when no effective change would happen.
> This is in accordance with unified hierarchy attachment behavior when
> permissions of the source to target cgroups are decisive whereas the
> migrated task is opaque (as opposed to more restrictive check in
> __cgroup1_procs_write()).
>
> Notice that foreign task's affinity may still be modified if the user
> can modify destination cgroup's cpuset attributes
> (update_tasks_cpumask() does no permissions check). The permissions
> check could thus be skipped on v2 even when affinity changes. Stay
> conservative in this patch though.
>
> [1] https://github.com/systemd/systemd/issues/18293#issuecomment-831205649
>
> Signed-off-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 19 ++++++++++++++++---
>   1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 58e6f18f01c1..0a9b860844ca 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2487,6 +2487,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   	struct cgroup_subsys_state *css;
>   	struct cpuset *cs, *oldcs;
>   	struct task_struct *task;
> +	bool cpus_updated, mems_updated;
>   	int ret;
>   
>   	/* used later by cpuset_attach() */
> @@ -2501,13 +2502,25 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   	if (ret)
>   		goto out_unlock;
>   
> +	cpus_updated = !cpumask_equal(cs->effective_cpus, oldcs->effective_cpus);
> +	mems_updated = !nodes_equal(cs->effective_mems, oldcs->effective_mems);
> +
>   	cgroup_taskset_for_each(task, css, tset) {
>   		ret = task_can_attach(task);
>   		if (ret)
>   			goto out_unlock;
> -		ret = security_task_setscheduler(task);
> -		if (ret)
> -			goto out_unlock;
> +
> +		/*
> +		 * Skip rights over task check in v2 when nothing changes,
> +		 * migration permission derives from hierarchy ownership in
> +		 * cgroup_procs_write_permission()).
> +		 */
> +		if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
> +		    (cpus_updated || mems_updated)) {
> +			ret = security_task_setscheduler(task);
> +			if (ret)
> +				goto out_unlock;
> +		}
>   
>   		if (dl_task(task)) {
>   			cs->nr_migrate_dl_tasks++;
Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Longman

