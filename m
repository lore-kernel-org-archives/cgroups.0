From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] mm/page_alloc: detect allocation forbidden by cpuset
 and bail out early
Date: Wed, 15 Sep 2021 13:30:27 +0200
Message-ID: <YUHZU4OHaJy3WtRk@dhcp22.suse.cz>
References: <1631590828-25565-1-git-send-email-feng.tang@intel.com>
 <3bd87d8a-d09e-ac7-1d1d-25ad1b9d5ed9@google.com>
 <20210915053247.GG56674@shbuild999.sh.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631705431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UOkCjvFoaNxGNbGFWeeVQVHJtZCjHhgLPxx+uerfl10=;
        b=HNke4/c6CnQ8nnlErjOvekgpXVSQXjWl4Ol2+/tLgrRlknDlrVnGAlJb48fXnI99PKyxch
        OYd1ItE4KjwfkP1Zku3mE76kBPFNJ8txDsFMjiMkJFJOsTZYn4j5Fetseg8i3S8mO1/f1k
        /jZcCmJ85qh1RlBqZrqrlIGfiLDUXFU=
Content-Disposition: inline
In-Reply-To: <20210915053247.GG56674-H4oSubS0T0ZnxsEdoo2cZdh3ngVCH38I@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 15-09-21 13:32:47, Feng Tang wrote:
> On Tue, Sep 14, 2021 at 05:30:03PM -0700, David Rientjes wrote:
[...]
> > I'm wondering about a single node nodemask, for example, where all 
> > ZONE_NORMAL memory is hot-removed.

While this is theoretically possible it is highly unlikely to happen.
Non movable memory just takes one kernel allocation to prevent any
hotremove operation to finish. I have to say I was not aware of the
hotplug callback. It all seems rather suspicious. I will have a look.

Anyway something worth having covered "just in case". Thanks for
pointing it out.
 
> Thanks for the reminding! Yes, memory hot remove can change the
> cpuset's effective nodemask, we may need to add similar check inside
> cpuset_hotplug_update_tasks() which is called by cpuset_hotplug_workfn(), 
> something like below?
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 7fa633e..d5f6776 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3186,6 +3186,14 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>  	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
>  	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
>  
> +	if (mems_updated && !cpusets_insane_config() &&
> +		movable_only_nodes(new_mems)) {
> +		static_branch_enable(&cpusets_insane_config_key);
> +		pr_info("Unsupported (movable nodes only) cpuset configuration detected (nmask=%*pbl) after memory hotplug."
> +			"Cpuset allocations might fail even with a lot of memory available.\n",
> +			nodemask_pr_args(new_mems);
> +	}

Please create a helper rather than two copies of the same. Thanks!
> +
>  	if (is_in_v2_mode())
>  		hotplug_update_tasks(cs, &new_cpus, &new_mems,
>  				     cpus_updated, mems_updated);
> 
> Thanks,
> Feng

-- 
Michal Hocko
SUSE Labs
