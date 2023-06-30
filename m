From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 1/3] cpuset: Allow setscheduler regardless of
 manipulated task
Date: Fri, 30 Jun 2023 15:19:37 -0400
Message-ID: <34ca9855-b38e-74e8-8c82-e0dc3fc5b485@redhat.com>
References: <20230630183908.32148-1-mkoutny@suse.com>
 <20230630183908.32148-2-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688152782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gQeupD5Hvtw3+gqmqjD4kEWekm8is74wkIjoamnYm2Y=;
        b=SiR0LrdCAz2yxvL7jsYHT2kU3wVwtf+N0xSBv1x880MghnZXv4qLMuUGwzKvUSgDTQLeyE
        gk7/K+DdAk/iaEu86LB4UxAOgZMgxj+U+RiH4EjQALuXcrkC2EUeGB8Lr5lEexwf7oatLD
        sMAiJqjX5UBZqz7Pl2cF1Gh/sbqH0vw=
Content-Language: en-US
In-Reply-To: <20230630183908.32148-2-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>


On 6/30/23 14:39, Michal Koutný wrote:
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
>
> [1] https://github.com/systemd/systemd/issues/18293#issuecomment-831205649
>
> Signed-off-by: Michal Koutný <mkoutny@suse.com>
> ---
>   kernel/cgroup/cpuset.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 58e6f18f01c1..41d3ed14b0f4 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2505,9 +2505,16 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>   		ret = task_can_attach(task);
>   		if (ret)
>   			goto out_unlock;
> -		ret = security_task_setscheduler(task);
> -		if (ret)
> -			goto out_unlock;
> +
> +		/*
> +		 * Skip rights over task check in v2, migration permission derives
> +		 * from hierarchy ownership in cgroup_procs_write_permission()).
> +		 */
> +		if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys)) {
> +			ret = security_task_setscheduler(task);
> +			if (ret)
> +				goto out_unlock;
> +		}

I am somewhat hesitant to skip the security_task_setscheduler() check 
for all cgroup v2 task migrations. The check is controlled by SElinux 
which is a different subsystem. I believe the scheduler property here 
refer's to the task cpu affinity and node mask. If you look at 
cpuset_attach(), we have actually skipped the task iteration process to 
change them if cpu affinity and node mask aren't changed at all.

I don't want to introduce a possible security vulnerability because of 
this relaxation. I would suggest you skip it under the same condition of 
no change to cpu affinity and node mask for cgroup v2.

Thanks,
Longman

