From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH 06/10] slab: implement slab_root_caches list
Date: Fri, 27 Jan 2017 21:06:56 +0300
Message-ID: <20170127180656.GC4332@esperanza>
References: <20170117235411.9408-1-tj@kernel.org>
 <20170117235411.9408-7-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=03CbqwjJAUzysCiREO0x2uujSUb2xohJBc5RYqHokOU=;
	b=T0Fnnqr4r8UAJRPX3+huZjCDHW4HQ4K/+duBbETj7jeP33S7Mquwlsd6amK5mJiLWtN+4+MzZn35YfM2wkVyejfP3V7s7s3tpkfC0/A2DlBH7NZuDihCVGfVg1YNzCx4WMck++jOro+0x+CMRN016uOL0RCtmke+zSAKZqaB0Zo=;
Content-Disposition: inline
In-Reply-To: <20170117235411.9408-7-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Tue, Jan 17, 2017 at 03:54:07PM -0800, Tejun Heo wrote:
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
> This patch adds a new list slab_root_caches which lists only the root
> caches.  When memcg is not enabled, it becomes just an alias of
> slab_caches.  memcg specific list operations are collected into
> memcg_[un]link_cache().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Jay Vana <jsvana@fb.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Vladimir Davydov <vdavydov@tarantool.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
