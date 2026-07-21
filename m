Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425283E49CF
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 16:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784650396; cv=none; b=hj7oav049lXlUHhBnMfZXE9Cg/HYDSn19G7LDC9vh9/BscIhaX+OBstA76OrdNfK1wDb13ANGJUqVUS20z8INMf/gJsCuXSmcfsK27YnPXkqHD704b20wrznbNojUuIvmO4IhQxwlj479XkQC1EhGIfj/fCzmonVqVe/pdfk3To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784650396; c=relaxed/simple;
	bh=CGrfDhCfR8ss2UfSi1waFxauVhaxJybP/DBRGZK15CA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+qtGWdDFEbQ0EKphQJQJzxNNp5gwGHtOFm5+oMlaPPhT3S/Sn3l2HFMffj85myz2xShktUIeOFj6ecvpL72t1lxYc5rAmaR6TqwmUtacWovAVix1LZJX1Z+o6HflWN0dEpQQiAry6cCnkZXudigX0aQNiQsfA1dEAgBRCtWyUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
	by 156.147.23.52 with ESMTP; 22 Jul 2026 01:13:10 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.121 with ESMTP; 22 Jul 2026 01:13:09 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 22 Jul 2026 01:13:09 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	baohua@kernel.org, zhaonanzhe@xiaomi.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, baolin.wang@linux.alibaba.com, hughd@google.com
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <al+alXxG/8XRCM3y@yjaykim-PowerEdge-T330>
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
 <20260717122514.51514-3-xueyuan.chen21@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717122514.51514-3-xueyuan.chen21@gmail.com>

On Fri, Jul 17, 2026 at 08:25:12PM +0800, Xueyuan Chen wrote:
...
>  	local_lock(&percpu_swap_cluster.lock);
>  	if (!swap_alloc_fast(folio))
> @@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
>  	}
>  	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
> -	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
> +	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
> +						&nr_swap_pages))) {
>  		swap_cache_del_folio(folio);

IMHO,
If we get here the allocation succeeded and only the charge failed, so
we already know global swap space exists.
(And also swap_cache_del_folio right above even puts the slots back, 
so nr_swap_pages goes up again)

Could we just take the margin and decide -E2BIG or -ENOMEM from that?

Youngjun
