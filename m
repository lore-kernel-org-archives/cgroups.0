From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH 10/10] slab: use memcg_kmem_cache_wq for slab destruction
 operations
Date: Sun, 29 Jan 2017 19:04:17 +0300
Message-ID: <20170129160416.GA1795@esperanza>
References: <20170117235411.9408-1-tj@kernel.org>
 <20170117235411.9408-11-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=IuVp4Lj06LEEpwKsq8E2ivZbWEhtyxGnndLW0TVDhT8=;
	b=tF84qeTa06R+1U07WDt5z4zmXuDaJ6Fe+rGK5ZLcE73t37VdwhAJlTL7kFLXi4BzjDRR/HQC92+zM6qaRJc2qc8ctLEMDsCPti075CNZN5e3MZ6UVr1jUctFmwjlXivsFtFebZVqaFYrfRvl/biMHbJ3g+jw4ghGX3UEaR6D6EM=;
Content-Disposition: inline
In-Reply-To: <20170117235411.9408-11-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Tue, Jan 17, 2017 at 03:54:11PM -0800, Tejun Heo wrote:
> If there's contention on slab_mutex, queueing the per-cache
> destruction work item on the system_wq can unnecessarily create and
> tie up a lot of kworkers.
> 
> Rename memcg_kmem_cache_create_wq to memcg_kmem_cache_wq and make it
> global and use that workqueue for the destruction work items too.
> While at it, convert the workqueue from an unbound workqueue to a
> per-cpu one with concurrency limited to 1.  It's generally preferable
> to use per-cpu workqueues and concurrency limit of 1 is safe enough.
> 
> This is suggested by Joonsoo Kim.
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
