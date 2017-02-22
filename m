From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm/cgroup: delay soft limit data allocation
Date: Wed, 22 Feb 2017 18:11:33 +0100
Message-ID: <20170222171132.GB26472@dhcp22.suse.cz>
References: <1487779091-31381-1-git-send-email-ldufour@linux.vnet.ibm.com>
 <1487779091-31381-3-git-send-email-ldufour@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1487779091-31381-3-git-send-email-ldufour@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed 22-02-17 16:58:11, Laurent Dufour wrote:
[...]
>  static struct mem_cgroup_tree_per_node *
>  soft_limit_tree_node(int nid)
>  {
> @@ -465,6 +497,8 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
>  	struct mem_cgroup_tree_per_node *mctz;
>  
>  	mctz = soft_limit_tree_from_page(page);
> +	if (!mctz)
> +		return;
>  	/*
>  	 * Necessary to update all ancestors when hierarchy is used.
>  	 * because their event counter is not touched.
> @@ -502,7 +536,8 @@ static void mem_cgroup_remove_from_trees(struct mem_cgroup *memcg)
>  	for_each_node(nid) {
>  		mz = mem_cgroup_nodeinfo(memcg, nid);
>  		mctz = soft_limit_tree_node(nid);
> -		mem_cgroup_remove_exceeded(mz, mctz);
> +		if (mctz)
> +			mem_cgroup_remove_exceeded(mz, mctz);
>  	}
>  }
>  

this belongs to the previous patch, right?
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
