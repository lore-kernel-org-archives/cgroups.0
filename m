From: "Huang, Shaoqin" <shaoqin.huang@intel.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Mon, 13 Jun 2022 11:18:14 +0800
Message-ID: <bdfea446-623c-d423-673f-496b3725ec2c@intel.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-2-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655090317; x=1686626317;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vc2NDR4Vbc0GZDQNzB67W1qeI0BuVtdQtSGTUmSxqfw=;
  b=F8Dx3iBfucBbhNPavTBSdlzhEzUSLGfMLjFBh9yDczSUphtvnMAvN6NU
   Y2MRq+8eVI5/TwFvXqxThG1f0eqynfAPoerRkRdin+XJkTRW1dRjHQVxz
   ECFnP5iQ72H0AGdtIKxhTfUwS65t6MVVxtQIgD0sK4oIwaRMWtlA/xLE4
   lBUKYdsij7jtgO3oMm1/lIZkLC/5HHZBa+PFbY2nNK/RNdHeWASg3FMO9
   Qh8vLJ1vt39+Nh41d5NrPFiZPCAFs2zdWsKD67dSnuFEL0SRf8NeBK5ns
   4WRxORcHL9r2LzC66Dvq5GzU9uqrxPlgHBJi/lEfbrjvlErwQZwFbW8hS
   w==;
Content-Language: en-US
In-Reply-To: <20220606222058.86688-2-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-mm@kvack.org



On 6/7/2022 6:20 AM, Yosry Ahmed wrote:
> Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> KVM mmu. This provides more insights on the kernel memory used
> by a workload.
> 
> This stat will be used by subsequent patches to count KVM mmu
> memory usage.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>   Documentation/admin-guide/cgroup-v2.rst | 5 +++++
>   Documentation/filesystems/proc.rst      | 4 ++++
>   drivers/base/node.c                     | 2 ++
>   fs/proc/meminfo.c                       | 2 ++
>   include/linux/mmzone.h                  | 1 +
>   mm/memcontrol.c                         | 1 +
>   mm/page_alloc.c                         | 6 +++++-
>   mm/vmstat.c                             | 1 +
>   8 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 69d7a6983f781..307a284b99189 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1312,6 +1312,11 @@ PAGE_SIZE multiple when read back.
>   	  pagetables
>                   Amount of memory allocated for page tables.
>   
> +	  sec_pagetables
> +		Amount of memory allocated for secondary page tables,
> +		this currently includes KVM mmu allocations on x86
> +		and arm64.
> +
>   	  percpu (npn)
>   		Amount of memory used for storing per-cpu kernel
>   		data structures.
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 061744c436d99..894d6317f3bdc 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -973,6 +973,7 @@ You may not have all of these fields.
>       SReclaimable:   159856 kB
>       SUnreclaim:     124508 kB
>       PageTables:      24448 kB
> +    SecPageTables:	 0 kB
>       NFS_Unstable:        0 kB
>       Bounce:              0 kB
>       WritebackTmp:        0 kB
> @@ -1067,6 +1068,9 @@ SUnreclaim
>   PageTables
>                 amount of memory dedicated to the lowest level of page
>                 tables.
> +SecPageTables
> +	      amount of memory dedicated to secondary page tables, this
> +	      currently includes KVM mmu allocations on x86 and arm64.

Just a notice. This patch in the latest 5.19.0-rc2+ have a conflict in 
Documentation/filesystems/proc.rst file. But that's not a problem.

>   NFS_Unstable
>                 Always zero. Previous counted pages which had been written to
>                 the server, but has not been committed to stable storage.
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index ec8bb24a5a227..9fe716832546f 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -433,6 +433,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>   			     "Node %d ShadowCallStack:%8lu kB\n"
>   #endif
>   			     "Node %d PageTables:     %8lu kB\n"
> +			     "Node %d SecPageTables:  %8lu kB\n"
>   			     "Node %d NFS_Unstable:   %8lu kB\n"
>   			     "Node %d Bounce:         %8lu kB\n"
>   			     "Node %d WritebackTmp:   %8lu kB\n"
> @@ -459,6 +460,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>   			     nid, node_page_state(pgdat, NR_KERNEL_SCS_KB),
>   #endif
>   			     nid, K(node_page_state(pgdat, NR_PAGETABLE)),
> +			     nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
>   			     nid, 0UL,
>   			     nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
>   			     nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index 6fa761c9cc78e..fad29024eb2e0 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -108,6 +108,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>   #endif
>   	show_val_kb(m, "PageTables:     ",
>   		    global_node_page_state(NR_PAGETABLE));
> +	show_val_kb(m, "SecPageTables:	",
> +		    global_node_page_state(NR_SECONDARY_PAGETABLE));
>   
>   	show_val_kb(m, "NFS_Unstable:   ", 0);
>   	show_val_kb(m, "Bounce:         ",
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 46ffab808f037..81d109e6c623a 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -219,6 +219,7 @@ enum node_stat_item {
>   	NR_KERNEL_SCS_KB,	/* measured in KiB */
>   #endif
>   	NR_PAGETABLE,		/* used for pagetables */
> +	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
>   #ifdef CONFIG_SWAP
>   	NR_SWAPCACHE,
>   #endif
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 598fece89e2b7..ee1c3d464857c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1398,6 +1398,7 @@ static const struct memory_stat memory_stats[] = {
>   	{ "kernel",			MEMCG_KMEM			},
>   	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
>   	{ "pagetables",			NR_PAGETABLE			},
> +	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
>   	{ "percpu",			MEMCG_PERCPU_B			},
>   	{ "sock",			MEMCG_SOCK			},
>   	{ "vmalloc",			MEMCG_VMALLOC			},
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0e42038382c12..29a7e9cd28c74 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5932,7 +5932,8 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>   		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
>   		" unevictable:%lu dirty:%lu writeback:%lu\n"
>   		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
> -		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
> +		" mapped:%lu shmem:%lu pagetables:%lu\n"
> +		" sec_pagetables:%lu bounce:%lu\n"
>   		" kernel_misc_reclaimable:%lu\n"
>   		" free:%lu free_pcp:%lu free_cma:%lu\n",
>   		global_node_page_state(NR_ACTIVE_ANON),
> @@ -5949,6 +5950,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>   		global_node_page_state(NR_FILE_MAPPED),
>   		global_node_page_state(NR_SHMEM),
>   		global_node_page_state(NR_PAGETABLE),
> +		global_node_page_state(NR_SECONDARY_PAGETABLE),
>   		global_zone_page_state(NR_BOUNCE),
>   		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
>   		global_zone_page_state(NR_FREE_PAGES),
> @@ -5982,6 +5984,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>   			" shadow_call_stack:%lukB"
>   #endif
>   			" pagetables:%lukB"
> +			" sec_pagetables:%lukB"
>   			" all_unreclaimable? %s"
>   			"\n",
>   			pgdat->node_id,
> @@ -6007,6 +6010,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>   			node_page_state(pgdat, NR_KERNEL_SCS_KB),
>   #endif
>   			K(node_page_state(pgdat, NR_PAGETABLE)),
> +			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
>   			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
>   				"yes" : "no");
>   	}
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index b75b1a64b54cb..06eb52fe5be94 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1240,6 +1240,7 @@ const char * const vmstat_text[] = {
>   	"nr_shadow_call_stack",
>   #endif
>   	"nr_page_table_pages",
> +	"nr_sec_page_table_pages",
>   #ifdef CONFIG_SWAP
>   	"nr_swapcached",
>   #endif
