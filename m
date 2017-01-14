From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH 5/9] slab: link memcg kmem_caches on their associated
 memory cgroup
Date: Sat, 14 Jan 2017 16:33:56 +0300
Message-ID: <20170114133356.GD2668@esperanza>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-6-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=dzEyH9UBxXuaF1C88Dll+4ESqh/Qki3hdaqIsJZOsHA=;
	b=PVST++LxLfO6apkUBr2nbyDdloAEA5XLpUMnwkXIxClmolpfCMoffCAD5fmAmFBjov6X6j03T31m8620kTYfuWYvUO+K4XH7kKBsa64QRRhIZOcEtmHXGfkpUU6v5Gm1mvSmMdoI8gl6mECXliB+gKVMnIapQexII9mK1H0quFQ=;
Content-Disposition: inline
In-Reply-To: <20170114055449.11044-6-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Sat, Jan 14, 2017 at 12:54:45AM -0500, Tejun Heo wrote:
> With kmem cgroup support enabled, kmem_caches can be created and
> destroyed frequently and a great number of near empty kmem_caches can
> accumulate if there are a lot of transient cgroups and the system is
> not under memory pressure.  When memory reclaim starts under such
> conditions, it can lead to consecutive deactivation and destruction of
> many kmem_caches, easily hundreds of thousands on moderately large
> systems, exposing scalability issues in the current slab management
> code.  This is one of the patches to address the issue.
> 
> While a memcg kmem_cache is listed on its root cache's ->children
> list, there is no direct way to iterate all kmem_caches which are
> assocaited with a memory cgroup.  The only way to iterate them is
> walking all caches while filtering out caches which don't match, which
> would be most of them.
> 
> This makes memcg destruction operations O(N^2) where N is the total
> number of slab caches which can be huge.  This combined with the
> synchronous RCU operations can tie up a CPU and affect the whole
> machine for many hours when memory reclaim triggers offlining and
> destruction of the stale memcgs.
> 
> This patch adds mem_cgroup->kmem_caches list which goes through
> memcg_cache_params->kmem_caches_node of all kmem_caches which are
> associated with the memcg.  All memcg specific iterations, including
> stat file access, are updated to use the new list instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Jay Vana <jsvana@fb.com>
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
