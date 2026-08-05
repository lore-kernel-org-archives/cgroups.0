Received: from out-169.mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8609A4F5E0
	for <cgroups@vger.kernel.org>; Wed,  5 Aug 2026 02:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785897961; cv=none; b=e3/p1bnFvp2ozFoyT4w/7XOsydcWX3oMz1v4MuPjt9eSehAaBkvaiN1brSCEEUgmiEFrXubHpey3onDTORMkyhQ8s67Hk+mEn1wT9HFEctJHto3WfnDXhej4utORhgaE1vCpBalWl39bTRoS6zACrRT6n6XCemZamuxaWquaHak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785897961; c=relaxed/simple;
	bh=JqRCjed6pktQSlqIFhtbMMb/Y+4ibo1iI+5PU0c5gsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZCF68g9qXqVuKhyidwIjaHwpWZu+PsCnnU7AgnnIuMfNijwL9hLEKFgoqaCrm1CQL4LZ1t3DEoAKn7SHzo+RwEYUjDy5dtOpdtmVZ+Biblvg9AZ2T4F3/vgaMK+Fmys1bbuRoNKox+4Jikx0mvaov0VtKHJn8NF4sXrkKBPDvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ntaXuvkZ; arc=none smtp.client-ip=95.215.58.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ntaXuvkZ"
Date: Wed, 5 Aug 2026 10:45:46 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785897957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vszTdmI/6U9C77/hLmYs62w3OXYnIeDOydJXj5JIneM=;
	b=ntaXuvkZoNlKM7NwMSgL7XGFJ8lc16GoJBjWuE+5FV0pq9PB5m5eCsuqk0r8uRmGWyIHuN
	V24qb7qV6/L5ub7x8y5DILgU3JC6iejwVaIQCZbFarJTSTnSZAYfEnFumS7CdLWlsE7y69
	gaoiU/swPiYPmhGjVicJ+w2nJJfJBIY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
Message-ID: <anKj2u9jT0WwNO8N@MiWiFi-R3L-srv>
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 08/04/26 at 11:08am, Lorenzo Stoakes (ARM) wrote:
> There are a number of internal headers local to mm/ which reference
> functions and data types without including the relevant headers.
> 
> mm/vma.h is a special case that intentionally does not include additional
> headers, but the others are not.
> 
> This breaks tooling like clangd (which is where I noticed this), though the
> build is OK due to the C files including the headers happening to include
> required dependencies.
> 
> It's better to be explicit about dependencies anyway, so add the missing
> includes and fix clangd as a bonus.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/cma.h           | 1 +
>  mm/hugetlb_cma.h   | 2 ++
>  mm/memcontrol-v1.h | 1 +
>  mm/pgalloc-track.h | 3 +++
>  mm/shuffle.h       | 2 ++
>  mm/swap.h          | 1 +
>  mm/vmalloc.h       | 2 ++
>  7 files changed, 12 insertions(+)

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/cma.h b/mm/cma.h
> index c70180c36559..ab6d39898ea5 100644
> --- a/mm/cma.h
> +++ b/mm/cma.h
> @@ -2,6 +2,7 @@
>  #ifndef __MM_CMA_H__
>  #define __MM_CMA_H__
>  
> +#include <linux/cma.h>
>  #include <linux/debugfs.h>
>  #include <linux/kobject.h>
>  
> diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
> index 3aa483573d17..730b2b4965b6 100644
> --- a/mm/hugetlb_cma.h
> +++ b/mm/hugetlb_cma.h
> @@ -2,6 +2,8 @@
>  #ifndef _LINUX_HUGETLB_CMA_H
>  #define _LINUX_HUGETLB_CMA_H
>  
> +#include <linux/hugetlb.h>
> +
>  #ifdef CONFIG_CMA
>  void hugetlb_cma_free_frozen_folio(struct folio *folio);
>  struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 0f703f239c80..1e394269c613 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -4,6 +4,7 @@
>  #define __MM_MEMCONTROL_V1_H
>  
>  #include <linux/cgroup-defs.h>
> +#include <linux/memcontrol.h>
>  
>  /* Cgroup v1 and v2 common declarations */
>  
> diff --git a/mm/pgalloc-track.h b/mm/pgalloc-track.h
> index e9e879de8649..1a6de1358a21 100644
> --- a/mm/pgalloc-track.h
> +++ b/mm/pgalloc-track.h
> @@ -2,6 +2,9 @@
>  #ifndef _LINUX_PGALLOC_TRACK_H
>  #define _LINUX_PGALLOC_TRACK_H
>  
> +#include <linux/mm.h>
> +#include <linux/pgtable.h>
> +
>  #if defined(CONFIG_MMU)
>  static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
>  				     unsigned long address,
> diff --git a/mm/shuffle.h b/mm/shuffle.h
> index 61bbcddeeee6..11bec7521ab8 100644
> --- a/mm/shuffle.h
> +++ b/mm/shuffle.h
> @@ -2,7 +2,9 @@
>  // Copyright(c) 2018 Intel Corporation. All rights reserved.
>  #ifndef _MM_SHUFFLE_H
>  #define _MM_SHUFFLE_H
> +
>  #include <linux/jump_label.h>
> +#include <linux/mmzone.h>
>  
>  #define SHUFFLE_ORDER MAX_PAGE_ORDER
>  
> diff --git a/mm/swap.h b/mm/swap.h
> index d077e5893a42..ec580c713204 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -5,6 +5,7 @@
>  #include <linux/atomic.h> /* for atomic_long_t */
>  #include <linux/mm.h> /* for PAGE_SHIFT */
>  #include <linux/memcontrol.h> /* for mem_cgroup_swappiness() */
> +#include <linux/swap.h> /* for MAX_SWAPFILES_SHIFT, struct swap_info_struct */
>  
>  struct mempolicy;
>  struct swap_iocb;
> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> index dcfe30eaa80c..8866ddcff668 100644
> --- a/mm/vmalloc.h
> +++ b/mm/vmalloc.h
> @@ -5,6 +5,8 @@
>  #ifndef __MM_VMALLOC_H
>  #define __MM_VMALLOC_H
>  
> +#include <linux/vmalloc.h>
> +
>  #ifdef CONFIG_MMU
>  void __init vmalloc_init(void);
>  int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> 
> ---
> base-commit: e47602c51d20a93fa1711ed896dc9480de4374d9
> change-id: 20260804-fix-some-local-headers-0ebc15f34c72
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
