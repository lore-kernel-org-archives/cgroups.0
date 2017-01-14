From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH 6/9] slab: don't put memcg caches on slab_caches list
Date: Sat, 14 Jan 2017 16:39:18 +0300
Message-ID: <20170114133918.GE2668@esperanza>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-7-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=9+0mZBh78TSPKGEz7c6kquOrp1H8UiWHBBd/33bGwyI=;
	b=Em6vTj5IX0nWPzWCr68K5xh6tQhvACSv41Y61XGDRbeHhHG8hT9DeM9vKn0KPcVz48jwJT6kv1At/6tkNvzJdejpXcqQkcGOMtfkZncezgbm/eAfz7W0zaesr1dBq4kbuetQ/MxX+w+VDpYjtwGJC1MVo71xdNr+YW86t7nYf0o=;
Content-Disposition: inline
In-Reply-To: <20170114055449.11044-7-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Sat, Jan 14, 2017 at 12:54:46AM -0500, Tejun Heo wrote:
> With kmem cgroup support enabled, kmem_caches can be created and
> destroyed frequently and a great number of near empty kmem_caches can
> accumulate if there are a lot of transient cgroups and the system is
> not under memory pressure.  When memory reclaim starts under such
> conditions, it can lead to consecutive deactivation and destruction of
> many kmem_caches, easily hundreds of thousands on moderately large
> systems, exposing scalability issues in the current slab management
> code.  This is one of the patches to address the issue.
> 
> slab_caches currently lists all caches including root and memcg ones.
> This is the only data structure which lists the root caches and
> iterating root caches can only be done by walking the list while
> skipping over memcg caches.  As there can be a huge number of memcg
> caches, this can become very expensive.
> 
> This also can make /proc/slabinfo behave very badly.  seq_file
> processes reads in 4k chunks and seeks to the previous Nth position on
> slab_caches list to resume after each chunk.  With a lot of memcg
> cache churns on the list, reading /proc/slabinfo can become very slow
> and its content often ends up with duplicate and/or missing entries.
> 
> As the previous patch made it unnecessary to walk slab_caches to
> iterate memcg-specific caches, there is no reason to keep memcg caches
> on the list.  This patch makes slab_caches include only the root
> caches.  As this makes slab_cache->list unused for memcg caches,
> ->memcg_params.children_node is removed and ->list is used instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Jay Vana <jsvana@fb.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/slab.h |  3 ---
>  mm/slab.h            |  3 +--
>  mm/slab_common.c     | 58 +++++++++++++++++++++++++---------------------------
>  3 files changed, 29 insertions(+), 35 deletions(-)

IIRC the slab_caches list is also used on cpu/mem online/offline, so you
have to patch those places to ensure that memcg caches get updated too.
Other than that the patch looks good to me.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
