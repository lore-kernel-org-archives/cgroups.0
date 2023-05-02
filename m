From: Petr =?UTF-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Subject: Re: [PATCH 19/40] change alloc_pages name in dma_map_ops to avoid
 name conflicts
Date: Tue, 2 May 2023 17:50:52 +0200
Message-ID: <20230502175052.43814202@meshulam.tesarici.cz>
References: <20230501165450.15352-1-surenb@google.com>
        <20230501165450.15352-20-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1683042654; bh=hI16GBufNUpeUYJO29ecGF2T3JkuXMUYlbwpXV7Ce1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hpCWoQk88LVg7fXQ3b+AVQsGAsNQ2r+jjHVNUux6ck4Irf+Zj3OBmb0DG1d5v80F0
         H420pD744+RdF+aqEdiS68mSamSjXCAac39xdL3B+FvtX/WoIjl1A+4HDlAkK0N9kT
         mgK+Oxs8dDzSdANM3/+MPo85nVNVR2H1c67YErvgyCXqxtW7tSUu+bkad7zPR3QpxA
         n0bhf3NB/o5NPE3CdKxABZz7x+zVnT0Mi1h5m9uwvaWhdePztbtaxp26PRxzfnSb8i
         5xS2IiqM6Gct4RDJVy63qv2EAMd/B7f/45wGQwNmpSiRlxOgkkTyofl87KFSXWR0xt
         u7HQUTKsfNbvg==
In-Reply-To: <20230501165450.15352-20-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.

On Mon,  1 May 2023 09:54:29 -0700
Suren Baghdasaryan <surenb@google.com> wrote:

> After redefining alloc_pages, all uses of that name are being replaced.
> Change the conflicting names to prevent preprocessor from replacing them
> when it's not intended.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  arch/x86/kernel/amd_gart_64.c | 2 +-
>  drivers/iommu/dma-iommu.c     | 2 +-
>  drivers/xen/grant-dma-ops.c   | 2 +-
>  drivers/xen/swiotlb-xen.c     | 2 +-
>  include/linux/dma-map-ops.h   | 2 +-
>  kernel/dma/mapping.c          | 4 ++--
>  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
> index 56a917df410d..842a0ec5eaa9 100644
> --- a/arch/x86/kernel/amd_gart_64.c
> +++ b/arch/x86/kernel/amd_gart_64.c
> @@ -676,7 +676,7 @@ static const struct dma_map_ops gart_dma_ops = {
>  	.get_sgtable			= dma_common_get_sgtable,
>  	.dma_supported			= dma_direct_supported,
>  	.get_required_mask		= dma_direct_get_required_mask,
> -	.alloc_pages			= dma_direct_alloc_pages,
> +	.alloc_pages_op			= dma_direct_alloc_pages,
>  	.free_pages			= dma_direct_free_pages,
>  };
>  
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 7a9f0b0bddbd..76a9d5ca4eee 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1556,7 +1556,7 @@ static const struct dma_map_ops iommu_dma_ops = {
>  	.flags			= DMA_F_PCI_P2PDMA_SUPPORTED,
>  	.alloc			= iommu_dma_alloc,
>  	.free			= iommu_dma_free,
> -	.alloc_pages		= dma_common_alloc_pages,
> +	.alloc_pages_op		= dma_common_alloc_pages,
>  	.free_pages		= dma_common_free_pages,
>  	.alloc_noncontiguous	= iommu_dma_alloc_noncontiguous,
>  	.free_noncontiguous	= iommu_dma_free_noncontiguous,
> diff --git a/drivers/xen/grant-dma-ops.c b/drivers/xen/grant-dma-ops.c
> index 9784a77fa3c9..6c7d984f164d 100644
> --- a/drivers/xen/grant-dma-ops.c
> +++ b/drivers/xen/grant-dma-ops.c
> @@ -282,7 +282,7 @@ static int xen_grant_dma_supported(struct device *dev, u64 mask)
>  static const struct dma_map_ops xen_grant_dma_ops = {
>  	.alloc = xen_grant_dma_alloc,
>  	.free = xen_grant_dma_free,
> -	.alloc_pages = xen_grant_dma_alloc_pages,
> +	.alloc_pages_op = xen_grant_dma_alloc_pages,
>  	.free_pages = xen_grant_dma_free_pages,
>  	.mmap = dma_common_mmap,
>  	.get_sgtable = dma_common_get_sgtable,
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 67aa74d20162..5ab2616153f0 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -403,6 +403,6 @@ const struct dma_map_ops xen_swiotlb_dma_ops = {
>  	.dma_supported = xen_swiotlb_dma_supported,
>  	.mmap = dma_common_mmap,
>  	.get_sgtable = dma_common_get_sgtable,
> -	.alloc_pages = dma_common_alloc_pages,
> +	.alloc_pages_op = dma_common_alloc_pages,
>  	.free_pages = dma_common_free_pages,
>  };
> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
> index 31f114f486c4..d741940dcb3b 100644
> --- a/include/linux/dma-map-ops.h
> +++ b/include/linux/dma-map-ops.h
> @@ -27,7 +27,7 @@ struct dma_map_ops {
>  			unsigned long attrs);
>  	void (*free)(struct device *dev, size_t size, void *vaddr,
>  			dma_addr_t dma_handle, unsigned long attrs);
> -	struct page *(*alloc_pages)(struct device *dev, size_t size,
> +	struct page *(*alloc_pages_op)(struct device *dev, size_t size,
>  			dma_addr_t *dma_handle, enum dma_data_direction dir,
>  			gfp_t gfp);
>  	void (*free_pages)(struct device *dev, size_t size, struct page *vaddr,
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index 9a4db5cce600..fc42930af14b 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -570,9 +570,9 @@ static struct page *__dma_alloc_pages(struct device *dev, size_t size,
>  	size = PAGE_ALIGN(size);
>  	if (dma_alloc_direct(dev, ops))
>  		return dma_direct_alloc_pages(dev, size, dma_handle, dir, gfp);
> -	if (!ops->alloc_pages)
> +	if (!ops->alloc_pages_op)
>  		return NULL;
> -	return ops->alloc_pages(dev, size, dma_handle, dir, gfp);
> +	return ops->alloc_pages_op(dev, size, dma_handle, dir, gfp);
>  }
>  
>  struct page *dma_alloc_pages(struct device *dev, size_t size,

I'm not impressed. This patch increases churn for code which does not
(directly) benefit from the change, and that for limitations in your
tooling?

Why not just rename the conflicting uses in your local tree, but then
remove the rename from the final patch series?

Just my two cents,
Petr T
