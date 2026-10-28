Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793184225;
	b=G/qf/opRdOEjocdJJqxD2031qK4YjkUoygVfBpA4IIsLY58PU/iYirHlV+QPYIvRDRFW
	 Ewm+UiPgSCIrny3l8Hxlx/uWSL/H5wZf5AU4RVNGpGf86018cGFGFkw1I5dHHIS++gLHl
	 buQb+C3Xmc0zCJeJnGuX+rL1bvqkfb9hSIXiBLhQT4EvD9nKT+61QbztpuHMQjXA3frC4
	 TlGAZQMUDb1Rp8mbBhqnzI/p5HXmVpK/mlz6pe71kiHUwMhU5acBMLVmkpSYHIsWr2LLc
	 BHE8YOTCxYwafUMXgkG88usOnFrBHhjq/BFPUpo7TksDATK2JDtOjCTsrpwDnZP1lHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793184225;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=9PEXPx1f1v6I2CjAMNLRcdHwCcztH0pJkRVk37TqP40=;
	b=wszob4H9UlARchEpRSgwlKbwgjgoqp6OX3I6ckjDkU2Q4ILP53jFsZHdch80ukvvS++5
	 EHr5w7PWa7ng4pEcWx/F0yqXBkdQ28TXfVcdLMZfe9l8z+MEJ/UlzhagRHXXfW0g7B+/u
	 +PMtBDdvRmVZrT2CC5qXTMNGFpolHMUNoUZgzwaex8MQ2mPIZH0JOIG1keRXpBV3yusdO
	 KC/YzAABGFF4Qsu2DwQ/TD0fRXUQq042UGj2JfMoyGto5pS3+Cme5P6qCvEshlO/Lf39T
	 3r17P/7gbaJ38p8saP9bAXXVAI8A8u2F8xUJt/MQS2hp/elZr20R2mnYUjh3/PepKtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tgz+LzV+;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3D1606A323
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 10:43:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E3D1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tgz+LzV+
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e5378b281aso3938965ad.2
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 03:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793184225; x=1793789025; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9PEXPx1f1v6I2CjAMNLRcdHwCcztH0pJkRVk37TqP40=;
        b=tgz+LzV+dwEKJDmG74Pr1aGCyv4LebV50v6CwuWqxRNOW1XFP43YJgPlVeyyQEpAbL
         tIIYI7wazhn0HNcl0IUX4DJq9T6YHUoFt6RRDHwg53aoTtO0IJ1FYfEJhU/PNP86qd0R
         WYW49tX9/ZiemyGoOxBVfnXeYMlgVxABNxm+Kk3mvVAacSLf00/NyUglTB6/XGZuXYzN
         aFfS0AHdEtecypjIRHhZXOhJ6S2IXn/YPNmnjKWriJyGuQetBs2f6QRt2VqMC1EPCq2d
         i1YKLh8ssu/KZV+bsxOysgUfq0eiOMkfNCn7AuCzPtEdA4blRTX00rwMC1PuZubvmtQw
         Cy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793184225; x=1793789025;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9PEXPx1f1v6I2CjAMNLRcdHwCcztH0pJkRVk37TqP40=;
        b=DCdIq26lvSI+6zM7M+iTGaJTT+HvkxQeNbOvBNfnfCT4vaVupa7dIMP/gh+qUJxbkG
         oq0Vh1uqin839FZcjWwDZZRuEzjEotqvltQLbr3GBJocduPbgtNWSIV5l9eNSjASmWOy
         VTC3BUMqWKBJYBtuva1+kD13hH5rD8LDooaRP8bpAlL320FOuY1+2gGOUeJUU27532P6
         dcQwcYACbIH5e9Whgt1fDEQTDirV0wTrIEMnqw8vOlPIthCULdjaJZG2iiGCIBkl80O7
         nFeIk/I6KHVxKKHjB4ecz9QOZ1gmnxQRN2zqkipD0NE+TuhfbH8TN0meJgQQAk4yff7Q
         JA3A==
X-Forwarded-Encrypted: i=1; AKwUvBxqs5RlSkO28DF28mpBmbgWvvbDrwodQbgcj2yoces3JbeqkggJx35nrJqCgZ4hsEQJRKWFNKfn@vger.kernel.org
X-Gm-Message-State: AFq9FYIaj/CzZOK72dA0CP6fs8pX5WgmvfIOTwkRJQIApSMtYreYQE3B
	gR1E++ocSwsXKj5Ejgtb1SRzeFEy7E7iXHJwfSkcKqEeObznDnRKRhJl
X-Gm-Gg: AYBFou3fbvK7QtBWnfqgOymfC4HK/AhHbm+yhtv8mEa2+iTK2N+hUjnSEoiY6iTzoQ+
	v1CuPNfEaocmhQpY6HT3ZcX6S13N5Duavohh8Dk4uF7Jx9cN0REgdTs6uReXMcvygAT7qypHP7d
	BEHNIV9HZ9Lv9oCmrM8gfQc4VFKcMxSDC6Gb3QMdF8j26RdYGNe6MutUgVLhr/b2gh5L0WjUxkO
	cA8S7LP8SdbEby/oiY6Ka9AnJool1fklw/gIBSnNTE/NmWh6Txu5GJ3BeRFRhju1pg6MMX2vP17
	Tfx+4NbqfMdwU3p1veop2L54m4066cRxzf6KpYHDA7cdaW33gGDsI+hAYkSTVk4RaE5/AOXbnDb
	DLkaSauyX1O3CIeKRvYixMAwEMRPsT89xf58cfLFR8NZd2l0RWEVK0EFhJZHNsQ5n1l9mcDnWvt
	yO6pkssOnJIB0ZZV1tBWEV36afaUrTjzw4tO16yE6BJUCkk5I1a08qFfcx2npKbFxyXQsDuAFFQ
	A2eaKpXBPno6UfTkDtNOf+G724aa6rz6c75U9qsZ/TxqSag2vMmEfDF8PSX8MSt8j9hpJysmrvS
	tRlD7TuGsee1ZAhTWz26F3EK0OGsnpVzMkUeKZqUy7EoQE8mvrQK/b23qxYnWFq3rYEtMpFH
X-Received: by 2002:a17:902:ec8f:b0:2dd:c100:4b76 with SMTP id d9443c01a7336-2eb003e9b1bmr20590075ad.45.1793184224783;
        Wed, 28 Oct 2026 03:43:44 -0700 (PDT)
Received: from KASONG-MC4 ([114.246.239.200])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6c34c27sm19889165ad.50.2026.10.28.03.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 03:43:44 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:43:34 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old
 generation
Message-ID: <auHMXBwnwuRwHLmo@KASONG-MC4>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-3-tjmercier@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-3-tjmercier@google.com>

On Tue, Oct 27, 2026 at 06:06:06PM +0800, T.J. Mercier wrote:
> lru_gen_offline_memcg() moves an offlining memcg to the head of the old
> generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
> visits it first and evicts the folios it left behind.
> 
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios"), those folios are reparented to the
> parent before lru_gen_offline_memcg() runs, and nothing can be added
> back to the offlined memcg's lruvec afterwards. Putting an empty
> offlined memcg at the head of the old generation no longer serves any
> purpose and only delays reclaim from the memcgs that still have memory
> due to additional shrink_many() iteration.
> 
> Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
> like any other memcg below the reclaimable size threshold until
> lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has no
> other user, so remove the op and update the memcg LRU comment as well.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---
>  Documentation/mm/multigen_lru.rst |  4 +---
>  include/linux/mmzone.h            | 14 +++-----------
>  mm/memcontrol.c                   |  1 -
>  mm/vmscan.c                       | 20 +-------------------
>  4 files changed, 5 insertions(+), 34 deletions(-)
> 

...

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 636152d8c94d..45a2c1021f4f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  enum {
>  	MEMCG_LRU_NOP,
>  	MEMCG_LRU_TAIL,
> -	MEMCG_LRU_OLD,
>  	MEMCG_LRU_YOUNG,
>  };

I think there could be other usage of this LRU_OLD macro, but indeed
offline is the only user currently, removing it is cleaner.

And everything looks good to me, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>
