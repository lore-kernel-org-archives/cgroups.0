From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 11/16] memcg: destroy memcg caches
Date: Fri, 21 Sep 2012 13:22:20 -0700
Message-ID: <20120921202220.GO7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-12-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2TiDVvqJfMw/mWRABwvuele+cPK12ifGZAmDm45XI20=;
        b=AeEAgWJ/1GdxwALHh7DsK3SXWmFmeio4nzTdDY6Z6ZumSwendn5w11k2MlEKwOGMXX
         y9x9waWDjlahx/7CsRvRF8j1IV7+7sIUTMATNF2XWrcPq26p37Of1VXV9p3zNOX/SpHs
         gQbyeXfV/eUerBKigB5URwGQY5CYzEd8AwiUP85KMgX7OUKWov8qtaHum7pc+7KHg2op
         TQ7RRLGSJUC5FL7VW6pN3KtQYBktCW6NXtKaMFD3x+Q98mNdl9q0IVcI+rKaifHwLmSv
         X3ZeKlM5q9uDqYkdQE4dqL2auGTSbNI+s6vMQgNW88OHt7Qv+mw0TJvGiEmNUVd2+q0Z
         957w==
Content-Disposition: inline
In-Reply-To: <1347977530-29755-12-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

Hello, Glauber.

On Tue, Sep 18, 2012 at 06:12:05PM +0400, Glauber Costa wrote:
> +static LIST_HEAD(destroyed_caches);
> +
> +static void kmem_cache_destroy_work_func(struct work_struct *w)
> +{
> +	struct kmem_cache *cachep;
> +	struct mem_cgroup_cache_params *p, *tmp;
> +	unsigned long flags;
> +	LIST_HEAD(del_unlocked);
> +
> +	spin_lock_irqsave(&cache_queue_lock, flags);
> +	list_for_each_entry_safe(p, tmp, &destroyed_caches, destroyed_list) {
> +		cachep = container_of(p, struct kmem_cache, memcg_params);
> +		list_move(&cachep->memcg_params.destroyed_list, &del_unlocked);
> +	}
> +	spin_unlock_irqrestore(&cache_queue_lock, flags);
> +
> +	list_for_each_entry_safe(p, tmp, &del_unlocked, destroyed_list) {
> +		cachep = container_of(p, struct kmem_cache, memcg_params);
> +		list_del(&cachep->memcg_params.destroyed_list);
> +		if (!atomic_read(&cachep->memcg_params.nr_pages)) {
> +			mem_cgroup_put(cachep->memcg_params.memcg);
> +			kmem_cache_destroy(cachep);
> +		}
> +	}
> +}
> +static DECLARE_WORK(kmem_cache_destroy_work, kmem_cache_destroy_work_func);

Again, please don't build your own worklist.  Just embed a work item
into mem_cgroup_cache_params and manipulate them.  No need to
duplicate what workqueue already implements.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
