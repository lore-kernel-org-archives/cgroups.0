From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/3] mm: vmalloc: introduce array allocation functions
Date: Tue, 8 Mar 2022 14:47:42 +0100
Message-ID: <Yidefp4G/Hk2Twfy@dhcp22.suse.cz>
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-2-pbonzini@redhat.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646747263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M2cDsI5mV1M6x3gdOfjF4IWbEcsh+bq/qA5q8DqCU9o=;
        b=fTGzL+Af7eT3+Xr2+FC85hjMRC7ZhDBLssNwdwoiK64evmjG9XM7sBl9QI3NDATNY9gLDI
        Gr1BC0VcIHrXCMfGQkZp0Lq42uC7UwXPlGOy4fKSn4Xp33+fxJlnpie01Q2PCsnw8PCsZY
        RwF7ozOFU3c9piwYZTC92OpOEbwNtHg=
Content-Disposition: inline
In-Reply-To: <20220308105918.615575-2-pbonzini@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, stable@vger.kernel.org

On Tue 08-03-22 05:59:16, Paolo Bonzini wrote:
> Linux has dozens of occurrences of vmalloc(array_size()) and
> vzalloc(array_size()).  Allow to simplify the code by providing
> vmalloc_array and vcalloc, as well as the underscored variants that let
> the caller specify the GFP flags.
> 
> Cc: stable@vger.kernel.org
> Cc: linux-mm@kvack.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Seems useful
Acked-by: Michal Hocko <mhocko@suse.com>

Is there any reason you haven't used __alloc_size(1, 2) annotation?

Thanks!
> ---
>  include/linux/vmalloc.h |  5 +++++
>  mm/util.c               | 50 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 880227b9f044..d1bbd4fd50c5 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -159,6 +159,11 @@ void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
>  		int node, const void *caller) __alloc_size(1);
>  void *vmalloc_no_huge(unsigned long size) __alloc_size(1);
>  
> +extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
> +extern void *vmalloc_array(size_t n, size_t size) __alloc_size(1, 2);
> +extern void *__vcalloc(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
> +extern void *vcalloc(size_t n, size_t size) __alloc_size(1, 2);
> +
>  extern void vfree(const void *addr);
>  extern void vfree_atomic(const void *addr);
>  
> diff --git a/mm/util.c b/mm/util.c
> index 7e43369064c8..94475abe54a0 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -647,6 +647,56 @@ void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
>  }
>  EXPORT_SYMBOL(kvrealloc);
>  
> +/**
> + * __vmalloc_array - allocate memory for a virtually contiguous array.
> + * @n: number of elements.
> + * @size: element size.
> + * @flags: the type of memory to allocate (see kmalloc).
> + */
> +void *__vmalloc_array(size_t n, size_t size, gfp_t flags)
> +{
> +	size_t bytes;
> +
> +	if (unlikely(check_mul_overflow(n, size, &bytes)))
> +		return NULL;
> +	return __vmalloc(bytes, flags);
> +}
> +EXPORT_SYMBOL(__vmalloc_array);
> +
> +/**
> + * vmalloc_array - allocate memory for a virtually contiguous array.
> + * @n: number of elements.
> + * @size: element size.
> + */
> +void *vmalloc_array(size_t n, size_t size)
> +{
> +	return __vmalloc_array(n, size, GFP_KERNEL);
> +}
> +EXPORT_SYMBOL(vmalloc_array);
> +
> +/**
> + * __vcalloc - allocate and zero memory for a virtually contiguous array.
> + * @n: number of elements.
> + * @size: element size.
> + * @flags: the type of memory to allocate (see kmalloc).
> + */
> +void *__vcalloc(size_t n, size_t size, gfp_t flags)
> +{
> +	return __vmalloc_array(n, size, flags | __GFP_ZERO);
> +}
> +EXPORT_SYMBOL(__vcalloc);
> +
> +/**
> + * vcalloc - allocate and zero memory for a virtually contiguous array.
> + * @n: number of elements.
> + * @size: element size.
> + */
> +void *vcalloc(size_t n, size_t size)
> +{
> +	return __vmalloc_array(n, size, GFP_KERNEL | __GFP_ZERO);
> +}
> +EXPORT_SYMBOL(vcalloc);
> +
>  /* Neutral page->mapping pointer to address_space or anon_vma or other */
>  void *page_rmapping(struct page *page)
>  {
> -- 
> 2.31.1

-- 
Michal Hocko
SUSE Labs
