From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] mm: memcontrol: basic memory statistics in cgroup2
 memory controller
Date: Wed, 13 Jan 2016 14:49:30 -0800
Message-ID: <20160113144930.b20ed63f1c6a28730f66eccd@linux-foundation.org>
References: <1452722469-24704-1-git-send-email-hannes@cmpxchg.org>
	<1452722469-24704-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1452722469-24704-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, 13 Jan 2016 17:01:08 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Provide a cgroup2 memory.stat that provides statistics on LRU memory
> and fault event counters. More consumers and breakdowns will follow.
> 
> ...
>
> @@ -5095,6 +5107,46 @@ static int memory_events_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> +static int memory_stat_show(struct seq_file *m, void *v)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
> +	int i;
> +
> +	/* Memory consumer totals */
> +
> +	seq_printf(m, "anon %lu\n",
> +		   tree_stat(memcg, MEM_CGROUP_STAT_RSS) * PAGE_SIZE);

Is there any reason why this won't overflow a longword on 32-bit?

> +	seq_printf(m, "file %lu\n",
> +		   tree_stat(memcg, MEM_CGROUP_STAT_CACHE) * PAGE_SIZE);
> +
> +	/* Per-consumer breakdowns */
> +
> +	for (i = 0; i < NR_LRU_LISTS; i++) {
> +		struct mem_cgroup *mi;
> +		unsigned long val = 0;
> +
> +		for_each_mem_cgroup_tree(mi, memcg)
> +			val += mem_cgroup_nr_lru_pages(mi, BIT(i)) * PAGE_SIZE;
> +		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i], val);
> +	}
> +
> +	seq_printf(m, "file_mapped %lu\n",
> +		   tree_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED) * PAGE_SIZE);
> +	seq_printf(m, "file_dirty %lu\n",
> +		   tree_stat(memcg, MEM_CGROUP_STAT_DIRTY) * PAGE_SIZE);
> +	seq_printf(m, "file_writeback %lu\n",
> +		   tree_stat(memcg, MEM_CGROUP_STAT_WRITEBACK) * PAGE_SIZE);
> +
> +	/* Memory management events */
> +
> +	seq_printf(m, "pgfault %lu\n",
> +		   tree_events(memcg, MEM_CGROUP_EVENTS_PGFAULT));
> +	seq_printf(m, "pgmajfault %lu\n",
> +		   tree_events(memcg, MEM_CGROUP_EVENTS_PGMAJFAULT));
> +
> +	return 0;
> +}

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
