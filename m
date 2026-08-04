Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F06A3DB62E;
	Tue,  4 Aug 2026 10:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785840260; cv=none; b=Ks80GV57xU1rhuYQEqS/7oVOujpAgt/4n8VWJ7O+kOTpdG3jWimMTv2uhZG6bIBKTnjiSb0/VUQD34nK9d1IDf22hpVqDmrqGw0ClDA+CFm2syHKXLXwVDKsjP1cdUKnsRdy/keXGspfawcmwKhPuBWb53PuXfDVJx2QroQ3o54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785840260; c=relaxed/simple;
	bh=FprXuEddmuTf2fiBDT67GnKyCRDF0HwbaH5HEGfhrHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aSw1cc9EyF0dOPEcXQj2y1eN5ZqBHVRW8Lqr8o2QrG8KleMofHMa4vsfbeehjT6xxC/nVTODCJaBmrLmOjUPNLPaP3nUcHlXw1AyI7iLbjWHQCkff3QAn9OSDNgOEV23FW23Y/pRzLFibwXv2y6VM/XCUdrq41GwRmkzkKMnwwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhHPpu9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhHPpu9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAD51F000E9;
	Tue,  4 Aug 2026 10:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785840259;
	bh=/7Lz/16O972X7b9BDwdCXlNzOwjhX4m2W3eDdGDb7Hk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HhHPpu9NG+FdugEnSxR6v7kzwQ2jexS+NP2GUkauEGwqB/SKplPFoIsssGpjQ5bTO
	 vzNSugEwn0zZ8dqutVxIyPmJ4h0gu5h73A61CkPVEEhmDbyOWTOiuoanJfrWQUE3zY
	 kN6yFxnf8202Yus49ktIeU3vg6i8cN/EgE1vfc9iAPpB6htmmTba71hU+M9dHugr7G
	 7TR6MZQRBTzJlRqR5pWCSvi7IkvC/CcSFW0dSYTw3JJq5NLGcGAkrMx4eSh7zVae1s
	 HrvPWORpetnFw3joFpL/fRp/rTFuXN0DZ4l2Ywn2m+tU9bKVYt20v0Xg7HXTKbm5DF
	 EwiQGNUZd6Flw==
Message-ID: <24e4c4cf-c9d6-4148-a6a2-cd9c14ca9a3c@kernel.org>
Date: Tue, 4 Aug 2026 12:44:11 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/4/26 12:08, Lorenzo Stoakes (ARM) wrote:
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

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/cma.h           | 1 +
>  mm/hugetlb_cma.h   | 2 ++
>  mm/memcontrol-v1.h | 1 +
>  mm/pgalloc-track.h | 3 +++
>  mm/shuffle.h       | 2 ++
>  mm/swap.h          | 1 +
>  mm/vmalloc.h       | 2 ++
>  7 files changed, 12 insertions(+)
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

