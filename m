From: Oliver Upton <oliver.upton-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v5 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
Date: Tue, 28 Jun 2022 18:53:55 +0000
Message-ID: <YrtOQxEi8fijGwSQ@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656442441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=htPFhHOsa3d7/VGnFqnbz5VFkkx8xDdtzMvjjntEVQQ=;
        b=d6djTxUwEkHGAYEqJ+FSn4G/FZeJSZoQaoOZxxQhJaqcI2qvYIgXT+trdlZ0GWC661TwyO
        1oiSHS8oHUyMAMhElHKJhcjJFylgZXvccpHWWmhbSO2Tv35HgJpLHoM6RfUaZ/baIXg/yK
        KB8JzslXVDM8K4q77AikRR+g7gpG87A=
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-5-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org

Hi Yosry,

On Mon, Jun 06, 2022 at 10:20:58PM +0000, Yosry Ahmed wrote:
> Count the pages used by KVM in arm64 for stage2 mmu in secondary pagetable
> stats.

You could probably benefit from being a bit more verbose in the commit
message here as well, per Sean's feedback.

> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/arm64/kvm/mmu.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f5651a05b6a85..80bc92601fd96 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -92,9 +92,13 @@ static bool kvm_is_device_pfn(unsigned long pfn)
>  static void *stage2_memcache_zalloc_page(void *arg)
>  {
>  	struct kvm_mmu_memory_cache *mc = arg;
> +	void *virt;
>  
>  	/* Allocated with __GFP_ZERO, so no need to zero */
> -	return kvm_mmu_memory_cache_alloc(mc);
> +	virt = kvm_mmu_memory_cache_alloc(mc);
> +	if (virt)
> +		kvm_account_pgtable_pages(virt, 1);
> +	return virt;
>  }
>  
>  static void *kvm_host_zalloc_pages_exact(size_t size)
> @@ -102,6 +106,21 @@ static void *kvm_host_zalloc_pages_exact(size_t size)
>  	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>  }
>  
> +static void *kvm_s2_zalloc_pages_exact(size_t size)
> +{
> +	void *virt = kvm_host_zalloc_pages_exact(size);
> +
> +	if (virt)
> +		kvm_account_pgtable_pages(virt, (size >> PAGE_SHIFT));
> +	return virt;
> +}
> +
> +static void kvm_s2_free_pages_exact(void *virt, size_t size)
> +{
> +	kvm_account_pgtable_pages(virt, -(size >> PAGE_SHIFT));
> +	free_pages_exact(virt, size);
> +}
> +
>  static void kvm_host_get_page(void *addr)
>  {
>  	get_page(virt_to_page(addr));
> @@ -112,6 +131,15 @@ static void kvm_host_put_page(void *addr)
>  	put_page(virt_to_page(addr));
>  }
>  
> +static void kvm_s2_put_page(void *addr)
> +{
> +	struct page *p = virt_to_page(addr);
> +	/* Dropping last refcount, the page will be freed */
> +	if (page_count(p) == 1)
> +		kvm_account_pgtable_pages(addr, -1);
> +	put_page(p);

Probably more of a note to myself with the parallel fault series, but
this is a race waiting to happen. This only works because stage 2 pages
are dropped behind the write lock.

Besides the commit message nit:

Reviewed-by: Oliver Upton <oliver.upton-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
