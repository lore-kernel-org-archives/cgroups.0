From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] memcg, oom: provide more precise dump info while
 memcg oom happening
Date: Wed, 7 Nov 2012 10:02:09 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1211070956540.27451@chino.kir.corp.google.com>
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com> <1352277696-21724-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=pCjKb/aoPJ5w3G3CwH4lYvXWUIkGaO2CxgNxbFPN4MY=;
        b=mjMRnYhfpkidkpIK4e2plnPujBQ1gTsrwJ4o9+k52KeRjS/B3Hy49JOcvPWUipMcm5
         igr9w6AEXvH1Ju9ceKw83CmLXEqbF+YBQzlHMidBakL26U9pSlkGz+erbzlf/3WwRiad
         wQ3acL/ncB8GWOf1v+PlOVLXi/iUXw2WxVkVB4ha11EuFKW6jBoyZ+9Ah6H/Aj0CTAG0
         AD0DJ91Ab4aiXBoNj4EOdz0Gkpm/yrIljb6iACuPndAJvTAVSXXGEs/8YGnmmbJ0+vxM
         Fuczzd3FGZcPGggrCTkKBnEFkGCAFGtVBhdKwjnUP/2LJe2YL/Ryk8NsaYXrwIC96zTz
         PttA==
In-Reply-To: <1352277696-21724-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

On Wed, 7 Nov 2012, Sha Zhengju wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0eab7d5..2df5e72 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -118,6 +118,14 @@ static const char * const mem_cgroup_events_names[] = {
>  	"pgmajfault",
>  };
>  
> +static const char * const mem_cgroup_lru_names[] = {
> +	"inactive_anon",
> +	"active_anon",
> +	"inactive_file",
> +	"active_file",
> +	"unevictable",
> +};
> +
>  /*
>   * Per memcg event counter is incremented at every pagein/pageout. With THP,
>   * it will be incremated by the number of pages. This counter is used for
> @@ -1501,8 +1509,59 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
>  	spin_unlock_irqrestore(&memcg->move_lock, *flags);
>  }
>  
> +#define K(x) ((x) << (PAGE_SHIFT-10))
> +static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
> +{
> +	struct mem_cgroup *mi;
> +	unsigned int i;
> +
> +	if (!memcg->use_hierarchy && memcg != root_mem_cgroup) {
> +		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> +			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
> +				continue;
> +			printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],

This printk isn't continuing any previous printk, so using KERN_CONT here 
will require a short header to be printed first ("Memcg: "?) with 
KERN_INFO before the iterations.

> +				K(mem_cgroup_read_stat(memcg, i)));
> +		}
> +
> +		for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
> +			printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
> +				mem_cgroup_read_events(memcg, i));
> +
> +		for (i = 0; i < NR_LRU_LISTS; i++)
> +			printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
> +				K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
> +	} else {
> +

Spurious newline.

Eek, is there really no way to avoid this if-conditional and just use 
for_each_mem_cgroup_tree() for everything and use

	mem_cgroup_iter_break(memcg, iter);
	break;

for !memcg->use_hierarchy?

> +		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> +			long long val = 0;
> +
> +			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
> +				continue;
> +			for_each_mem_cgroup_tree(mi, memcg)
> +				val += mem_cgroup_read_stat(mi, i);
> +			printk(KERN_CONT "%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
> +		}
> +
> +		for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
> +			unsigned long long val = 0;
> +
> +			for_each_mem_cgroup_tree(mi, memcg)
> +				val += mem_cgroup_read_events(mi, i);
> +			printk(KERN_CONT "%s:%llu ",
> +				mem_cgroup_events_names[i], val);
> +		}
> +
> +		for (i = 0; i < NR_LRU_LISTS; i++) {
> +			unsigned long long val = 0;
> +
> +			for_each_mem_cgroup_tree(mi, memcg)
> +				val += mem_cgroup_nr_lru_pages(mi, BIT(i));
> +			printk(KERN_CONT "%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
> +		}
> +	}
> +	printk(KERN_CONT "\n");
> +}
>  /**
> - * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
>   * @memcg: The memory cgroup that went over limit
>   * @p: Task that is going to be killed
>   *
> @@ -1569,6 +1628,8 @@ done:
>  		res_counter_read_u64(&memcg->kmem, RES_USAGE) >> 10,
>  		res_counter_read_u64(&memcg->kmem, RES_LIMIT) >> 10,
>  		res_counter_read_u64(&memcg->kmem, RES_FAILCNT));
> +
> +	mem_cgroup_print_oom_stat(memcg);

I think this should be folded into mem_cgroup_print_oom_info(), I don't 
see a need for a new function.

>  }
>  
>  /*
> @@ -5195,14 +5256,6 @@ static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>  }
>  #endif /* CONFIG_NUMA */
>  
> -static const char * const mem_cgroup_lru_names[] = {
> -	"inactive_anon",
> -	"active_anon",
> -	"inactive_file",
> -	"active_file",
> -	"unevictable",
> -};
> -
>  static inline void mem_cgroup_lru_names_not_uptodate(void)
>  {
>  	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 7e9e911..4b8a6dd 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -421,8 +421,10 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
>  	cpuset_print_task_mems_allowed(current);
>  	task_unlock(current);
>  	dump_stack();
> -	mem_cgroup_print_oom_info(memcg, p);
> -	show_mem(SHOW_MEM_FILTER_NODES);
> +	if (memcg)
> +		mem_cgroup_print_oom_info(memcg, p);

mem_cgroup_print_oom_info() already returns immediately for !memcg, so I'm 
not sure why this change is made.

> +	else
> +		show_mem(SHOW_MEM_FILTER_NODES);

Well that's disappointing if memcg == root_mem_cgroup, we'd probably like 
to know the global memory state to determine what the problem is.

>  	if (sysctl_oom_dump_tasks)
>  		dump_tasks(memcg, nodemask);
>  }

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
