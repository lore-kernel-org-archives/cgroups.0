Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864DF37A498;
	Thu, 30 Jul 2026 02:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785379989; cv=none; b=XAVrWOl3idvekHc4AYM26SKzIqvtM6nfkIBc4ipCeNMgUnyAOnceWCTMfJzDplgW+p1GiKHLsXYpffTP4ElV/pgBhxVD0RsaAbJwxMCDss2vDpAz1+/kSRPYi4bxJznJNnF4qiYqXAqetE5xZutt0Z7nyHidWrvL3Z1YLqdv5oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785379989; c=relaxed/simple;
	bh=t9LVtDM4B5f605B0mzcnlceBYrXqGuUemb2TwG4H8jA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqGfW7jsjTWzCQmSsYeUfbfbsOA3L1Sot61e7BYRPEEFUqSoxILdLPc+fck+eRYkkFrOAHi/CeTGiLhGFpA7xXuKMX5l35UGXSvTIwvz8hD2ctobt57Pvd1Bh35X7C2nLFqrQ4CrvulYy9k5js+s35aO96kp/zkms6O/erwTPLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NpA4In9j; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NpA4In9j"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785379983; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pjx9IpZ8ImTKeEqYEWqNw8reCWkkI4bG3P98loavW/8=;
	b=NpA4In9jqZOTjbiVYo0zyzWoNU9W86zSz2lItZwBnxv3mcvCWY8D3uiZllYEyx+TKELIez04NlK1J3By5mfSY0bI3BpvIRUhDZKlAd5yfbl7VSi7FHsOqs7GXMzDTfECYrYBLtU7KvNrnslVNXpY5uh7JtjoeYLDway59ggzCRA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=29;SR=0;TI=SMTPD_---0X83cfc2_1785379979;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X83cfc2_1785379979 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Jul 2026 10:53:01 +0800
Message-ID: <f0bde6a0-d4be-48b3-abe2-28127a82a139@linux.alibaba.com>
Date: Thu, 30 Jul 2026 10:52:59 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/4] mm/shmem: split large folios only on -E2BIG
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org,
 youngjun.park@lge.com, hughd@google.com, chrisl@kernel.org,
 kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com
References: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
 <20260730021630.2235914-5-xueyuan.chen21@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260730021630.2235914-5-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/30/26 10:16 AM, Xueyuan Chen wrote:
> shmem_writeout() currently splits a large folio on every
> folio_alloc_swap() failure. With the refined return-value contract, only
> -E2BIG indicates that splitting might allow smaller folios to be swapped
> out.
> 
> Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
> redirty and reactivate the folio as before.
> 
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 6641823bed16..6f959191ef70 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1609,6 +1609,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>   	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>   	pgoff_t index;
>   	int nr_pages;
> +	int ret;

Nit: can be in one line:

int nr_pages, ret;

>   	bool split = false;
>   
>   	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
> @@ -1689,7 +1690,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>   		folio_mark_uptodate(folio);
>   	}
>   
> -	if (!folio_alloc_swap(folio)) {
> +	ret = folio_alloc_swap(folio);
> +	if (!ret) {
>   		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
>   		int error;
>   
> @@ -1742,7 +1744,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>   		swap_cache_del_folio(folio);
>   		goto redirty;
>   	}
> -	if (nr_pages > 1)
> +	if (nr_pages > 1 && ret == -E2BIG)
>   		goto try_split;
>   redirty:
>   	folio_mark_dirty(folio);

