From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH 4/9] slab: reorganize memcg_cache_params
Date: Sat, 14 Jan 2017 16:30:00 +0300
Message-ID: <20170114133000.GC2668@esperanza>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-5-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=GZNMsFoYSXJLCsm9gF5Nx01VSiNO22awAL5LKfB2VsY=;
	b=r3sObd2nLHafV7/cWUidtoT6mj+gP4EYUCl7Vs6H7iUr7PbfdhX5zd48qzEnf5fmdUlMyoGcNO1fI5rVQ39VsCR14vmjwCNe/4gHJqkbAgjfN3xBH9oegqAUVhBVnxOMGcCb7mmz8+0eTFgumwmjGZ2RenSGiifLM4PKZVZvVso=;
Content-Disposition: inline
In-Reply-To: <20170114055449.11044-5-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Sat, Jan 14, 2017 at 12:54:44AM -0500, Tejun Heo wrote:
> We're gonna change how memcg caches are iterated.  In preparation,
> clean up and reorganize memcg_cache_params.
> 
> * The shared ->list is replaced by ->children in root and
>   ->children_node in children.
> 
> * ->is_root_cache is removed.  Instead ->root_cache is moved out of
>   the child union and now used by both root and children.  NULL
>   indicates root cache.  Non-NULL a memcg one.
> 
> This patch doesn't cause any observable behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
