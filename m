From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 06/16] memcg: infrastructure to match an allocation
 to the right cache
Date: Fri, 21 Sep 2012 13:52:36 -0700
Message-ID: <20120921205236.GT7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-7-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=tH2AXnDiHY1pOF2U5hgTWZvgvGdfETm8JA9ZfmGrljw=;
        b=oatbQ3cqnrZPOkGzqZRcULekeuKEs3tTkwQhnTTlLbfC0S0QyQPzuglVYm0SzZrvzJ
         hq0zIWPzGVeHYEG5NwHVDWUxWEBzXSsa3G8FKpD+YfQBcXg8/gIMagiYjRVii5QV5MwH
         azb+i0vuiqaa4gmAcTvOIpAOoj4SqbmrYhZqBB5oXnszSxZN+9DiYAPWIuDVRY8WaFje
         /EYvCLCQIQPyjFjnwENVWp1QiaS0249o1ak1jUbk29DJkU+fS+AaETH5ujCCNyi1IEbX
         J0zQ7G2/rBdTLBpE+yggZ2CIuWrrtZk84KP+tkLkMW60BQHPZF5rHeo47yItUEzIxTMJ
         X+FA==
Content-Disposition: inline
In-Reply-To: <1347977530-29755-7-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

Missed some stuff.

On Tue, Sep 18, 2012 at 06:12:00PM +0400, Glauber Costa wrote:
> +static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
> +						  struct kmem_cache *cachep)
> +{
...
> +	memcg->slabs[idx] = new_cachep;
...
> +struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
> +					  gfp_t gfp)
> +{
...
> +	return memcg->slabs[idx];

I think you need memory barriers for the above pair.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
