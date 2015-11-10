From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH v2 4/6] slab: add SLAB_ACCOUNT flag
Date: Tue, 10 Nov 2015 21:54:01 +0300
Message-ID: <20151110185401.GW31308@esperanza>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <1ce23e932ea53f47a3376de90b21a9db8293bd6c.1447172835.git.vdavydov@virtuozzo.com>
 <20151110183808.GB13740@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20151110183808.GB13740@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 10, 2015 at 01:38:08PM -0500, Tejun Heo wrote:
> On Tue, Nov 10, 2015 at 09:34:05PM +0300, Vladimir Davydov wrote:
> > Currently, if we want to account all objects of a particular kmem cache,
> > we have to pass __GFP_ACCOUNT to each kmem_cache_alloc call, which is
> > inconvenient. This patch introduces SLAB_ACCOUNT flag which if passed to
> > kmem_cache_create will force accounting for every allocation from this
> > cache even if __GFP_ACCOUNT is not passed.
> > 
> > This patch does not make any of the existing caches use this flag - it
> > will be done later in the series.
> > 
> > Note, a cache with SLAB_ACCOUNT cannot be merged with a cache w/o
> > SLAB_ACCOUNT, i.e. using this flag will probably reduce the number of
> > merged slabs even if kmem accounting is not used (only compiled in).
> 
> Am I correct in thinking that we should eventually be able to removed
> __GFP_ACCOUNT and that only caches explicitly marked with SLAB_ACCOUNT
> would need to be handled by kmemcg?

Don't think so, because sometimes we want to account kmalloc.

Thanks,
Vladimir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
