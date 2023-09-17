From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup/cpuset: Rebuild sched domains if isolated
 partition changed
Date: Sun, 17 Sep 2023 12:51:43 -0400
Message-ID: <5e513c72-7198-a55e-6e2b-a811d5529284@redhat.com>
References: <20230915154505.363754-1-pierre.gondois@arm.com>
 <20230915154505.363754-2-pierre.gondois@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694969508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rgW2MUYlHHfdCZ+QdWezRlOQ9jHuf7PY43yzWv+wfSM=;
        b=IjU9t6MWj6lTsBF26yp59OqLh75sOW83MeuNLLdgC3tqWjhtB5KaKqbxVH1famW+lto3Px
        lsOoGYfBLh28K7z6vKxDWcyzTz73AUhxO2I/xuwB8LyCrRs4WTacf+B9hiwdhgwbe4NB6C
        7YMtVzuQKwzk63z52DSk3Q2r+l+LNz4=
Content-Language: en-US
In-Reply-To: <20230915154505.363754-2-pierre.gondois-5wv7dgnIgG8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Pierre Gondois <pierre.gondois-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/15/23 11:45, Pierre Gondois wrote:
> When an isolated parition is created, the sched domains (sds) are
> rebuilt and the sds of the isolated CPUs are detached. This only
> happens at the creation of the isolated parition. Updating
> the cpuset of the partition doesn't rebuild the sds:
>
> To reproduce:
>    # ls /sys/kernel/debug/sched/domains/cpu0/
>    domain0
>    # ls /sys/kernel/debug/sched/domains/cpu1/
>    domain0
>    #
>    # mkdir cgroup
>    # mount -t cgroup2 none cgroup/
>    # mkdir cgroup/A1/
>    # echo "+cpuset" > cgroup/cgroup.subtree_control
>    # echo 0-3 > cgroup/A1/cpuset.cpus
>    # echo isolated > cgroup/A1/cpuset.cpus.partition
>    #
>    # ls /sys/kernel/debug/sched/domains/cpu0/
>    # ls /sys/kernel/debug/sched/domains/cpu1/
>    #
>    # echo 0 > cgroup/A1/cpuset.cpus
>    # ls /sys/kernel/debug/sched/domains/cpu0/
>    # ls /sys/kernel/debug/sched/domains/cpu1/
>    #
>
> Here CPU1 should have a sched domain re-attached.
>
> Signed-off-by: Pierre Gondois <pierre.gondois-5wv7dgnIgG8@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 58e6f18f01c1..e3eb27ff9b68 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1680,11 +1680,15 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>   		 * empty cpuset is changed, we need to rebuild sched domains.
>   		 * On default hierarchy, the cpuset needs to be a partition
>   		 * root as well.
> +		 * Also rebuild sched domains if the cpuset of an isolated
> +		 * partition changed.
>   		 */
> -		if (!cpumask_empty(cp->cpus_allowed) &&
> -		    is_sched_load_balance(cp) &&
> -		   (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
> -		    is_partition_valid(cp)))
> +		if ((!cpumask_empty(cp->cpus_allowed) &&
> +		     is_sched_load_balance(cp) &&
> +		     (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
> +		      is_partition_valid(cp))) ||
> +		    (cp->partition_root_state == PRS_ISOLATED ||
> +		     cp->partition_root_state == PRS_INVALID_ISOLATED))
>   			need_rebuild_sched_domains = true;
>   
>   		rcu_read_lock();

Thanks for spotting the problem and sending out a patch to fix it. 
However, it should be done in the update_cpumask(). The sched_domain 
rebuild in update_cpumasks_hier() is supposed to be used for impacted 
descendant cpusets lower down in the hierarchy.

Anyway, I believe this problem should have been fixed in commit 
a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & 
CS_SCHED_LOAD_BALANCE handling") recently merged into the v6.6 kernel. 
Would you mind testing the latest upstream kernel to see if this problem 
is gone or not?

Thanks,
Longman

