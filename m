From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC Patch V1 09/30] mm, memcg: Use cpu_to_mem()/numa_mem_id()
 to support memoryless node
Date: Fri, 18 Jul 2014 09:36:14 +0200
Message-ID: <20140718073614.GC21453@dhcp22.suse.cz>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <1405064267-11678-10-git-send-email-jiang.liu@linux.intel.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MOK+rF8T3WZWRmSd8LGxOnzO3tsipTiYFiJpBX166y4=;
        b=zGlaj9vno9NiLvebciBBAXV5KtWl3Rku7SXhSimODJi+5XwMAjVpOpLgrV/2/yKJz0
         6XBvTaRcvzzUwR8wpHiYqFmLh+iXtlyF09bJXMN0W4uBjsMEfqqsIUbcxxECW3uZy21r
         xLnj73pxuifiyu75+mjhCs5JDNe+9QOoWq89iOxFCMSJ23+p+2nIzKz3c7pDoD527AYW
         b+ENkYownJiaH8KVk49LdMEE9jKwlHXwMZs4jR9klwZBuY4Xa21V5pQYzjTy7W032Sjf
         jHMja84qEBjrh6aOa98XQsb8XVWFCo+OBUEa1cS+wMyL3qoVE8dcpAmdjUOlz1Cp9V0a
         2zWQ==
Content-Disposition: inline
In-Reply-To: <1405064267-11678-10-git-send-email-jiang.liu@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri 11-07-14 15:37:26, Jiang Liu wrote:
> When CONFIG_HAVE_MEMORYLESS_NODES is enabled, cpu_to_node()/numa_node_id()
> may return a node without memory, and later cause system failure/panic
> when calling kmalloc_node() and friends with returned node id.
> So use cpu_to_mem()/numa_mem_id() instead to get the nearest node with
> memory for the/current cpu.
> 
> If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
> is the same as cpu_to_node()/numa_node_id().

The change makes difference only for really tiny memcgs. If we really
have all pages on unevictable list or anon with no swap allowed and that
is the reason why no node is set in scan_nodes mask then reclaiming
memoryless node or any arbitrary close one doesn't make any difference.
The current memcg might not have any memory on that node at all.

So the change doesn't make any practical difference and the changelog is
misleading.

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  mm/memcontrol.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a2c7bcb0e6eb..d6c4b7255ca9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1933,7 +1933,7 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
>  	 * we use curret node.
>  	 */
>  	if (unlikely(node == MAX_NUMNODES))
> -		node = numa_node_id();
> +		node = numa_mem_id();
>  
>  	memcg->last_scanned_node = node;
>  	return node;
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
