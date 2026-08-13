Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463D943CE47
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 08:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609683; cv=none; b=J/BCeHIx7siLkmVM4lJOPQ0V8mdZIFT3g8uYCuhv9REs+/+vzrLIqX3KeKWz4hKusP7s3u3dO+/QF8p3c7NnLvfS9uXxaKpYoCxh4+2AmgPBAl1dhgIFiljgVP0fZg9XoIMo0bDqJl7FdJW7bNTFVQ8c7/zxGUjk7jLkaSco24I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609683; c=relaxed/simple;
	bh=XAnEB2S2aRh9VwzrURyEwMPU3MLz8BaEUlI3ygEYEsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PY5cFj+G0rXtQcuA+GdKB/oWVWzTr1vHll75H6JzZyLAsrSwUTfy27jzUljxB6l069lCGdaTZYkTTBy7xLVnTotRmk+hiPCk8xUs/zgtY6lq9zlMw7ZvZOa7sEANZ2u98v9cBRhW1Jcisc/PHnHeBwkWwlpN0ghG7MwptoI5CQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IrAY5u6Y; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IrAY5u6Y"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47fe89fb333so1028315f8f.3
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609680; x=1787214480; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xCzIN0PcYx5XXua8zBFfrYvgdot2po1J62TlNHtY8vs=;
        b=IrAY5u6YZ4lXXlzweo1qsKbTsm983M6fJVNbde7v6BfpfZJ/VxJo3gsIfVIiJezyPH
         4+3OPS/ves9b38N40u18GcIJSHDw4VKLAbRDIuz6EyQ6Y5U50KOlB9rcGHJhLF8CQa84
         df9z9YeXTKuSvjLeE9oTbDBcA2rAODFHmlZDwmsec+J/VyL1GUAk8ntIeoSrNlyVjfnL
         bAvHj7UiVx4qyRUzLtmQEkiTQ26wh9M5fuVf4Cid57XAn8ObFCnEnhfckmtCaUid3MmE
         G+Vr0yiCEbiODpOY619pyqq4D71sUIT6E/yd8157V1RqhM3BZDsED0/TQCRGMrgusgTs
         vSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609680; x=1787214480;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xCzIN0PcYx5XXua8zBFfrYvgdot2po1J62TlNHtY8vs=;
        b=Iwi6f4EbQFhYgkmZzvvHwlWxXHLzVXU3DwScmcMedet7p3YKJD0Fhmb3wyNj0pNOZt
         ACHkCvVzvnDYCyqPiL3FxgJqgcEJ5mVvSkrrTTy/4duaxn3tsVxh2nR6APgfDVxiYxKl
         OTghPkURxfrdj4brem2RiivaKv9/vj1MTlgXa6CCUldwEBHfFQebhv3+9aIZPILWlDGg
         3I+OgS2qEhPwF4MgiI16hmtzUaR1uAsfUtvDO5dc9E3tw60qpxpRJJ7z3LLV1JsVQNJU
         wF0/7pYTQFiu25uaWEyJZNKKX4ZgE0gHuchwL1FSlXG1L2TX8aJSM1lDWdtVzdMtsGvv
         H02Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqzs1/tEkVOGrQnT7Srpl8i309mAP0cRwRLmLg0A+oVZCEGg13LaWjhsLSzkt2euDGJE1zbvUKw@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2+IN84Q7kKsdwJzRhcIdZb5LVEtGo0qcLACGIqOXQuyWlMAFd
	Nqg/InrOI6T9RPYOV82hgdj2I/hYu3Po2or4G/aG9q4kPZRuiI8hz+ZJM5L4ob+D9g8=
X-Gm-Gg: AR+sD12uF7rODxxMigYsq3ou47o2R3sLhOLv3NdipVAcj5Zdk3VHSkLCGq1beRMwjZZ
	2pDDsbpkm0JOz8PjACNQj0/EcgRrljzLMcQ5PGlqCAVbuUb4acvv7vhhi3nUJ/wCHNbznZHAmFu
	Q+tVD0f+aIS2gbguQJKv0i2nAiTbr/xLQXhUTxxRtbidd4AbARcNJzUH6K1CSb/fpv2pKsKJfWh
	fCeAkgNcf9++IXqcjO5OqoDrEcgFIF1fOSEJPlm8NEpbq8nlHj0nkAJT8jHPHQFaI9ktFAp9WOK
	jdMioSD92Ok1M6qnnf40vTO4b9cKfY7NyTAZ1U9lLHNbiFq5tP0GbeQ44f0P7I/ypSHaNtmhW4Y
	+dZbKICfMY+K+08rIZd/rs4deGhL3r4uX4o33vORo0bHtYAVqU23NhnuWT99S1NieFljDPSv942
	6y46Hl20fbrGtLrYtG78veKGj7vzz4fUAf15gzOntlk9oCT4xm5n6ewEtqduKd3o5Edx/lY/A=
X-Received: by 2002:a05:6000:4919:b0:47f:b51d:f0ec with SMTP id ffacd0b85a97d-48159eea06cmr5670939f8f.15.1786609680354;
        Thu, 13 Aug 2026 01:28:00 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5b6c2dsm4071055f8f.26.2026.08.13.01.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:27:59 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:27:59 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] memcg: remove mem_cgroup->soft_limit
Message-ID: <an2ADz06jCDm65Kd@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-9-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-9-shakeel.butt@linux.dev>

On Tue 11-08-26 13:32:02, Shakeel Butt wrote:
> Nothing reads it anymore, so the field and the helper that reset it on
> css alloc and css reset can go.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h | 2 --
>  mm/memcontrol-v1.h         | 6 ------
>  mm/memcontrol.c            | 2 --
>  3 files changed, 10 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ce24e04967d8..526da1d869ed 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -275,8 +275,6 @@ struct mem_cgroup {
>  
>  	struct memcg1_events_percpu __percpu *events_percpu;
>  
> -	unsigned long soft_limit;
> -
>  	/* protected by memcg_oom_lock */
>  	bool oom_lock;
>  	int under_oom;
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index fd611e66859a..f48d0e22e615 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -42,11 +42,6 @@ void memcg1_free_events(struct mem_cgroup *memcg);
>  
>  void memcg1_memcg_init(struct mem_cgroup *memcg);
>  
> -static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
> -{
> -	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
> -}
> -
>  struct cgroup_taskset;
>  void memcg1_css_offline(struct mem_cgroup *memcg);
>  
> @@ -97,7 +92,6 @@ static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true;
>  static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
>  
>  static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
> -static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
>  static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
>  
>  static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b68f1f16ae54..ba3ef821553d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4222,7 +4222,6 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  		return ERR_CAST(memcg);
>  
>  	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> -	memcg1_soft_limit_reset(memcg);
>  #ifdef CONFIG_ZSWAP
>  	memcg->zswap_max = PAGE_COUNTER_MAX;
>  	WRITE_ONCE(memcg->zswap_writeback, true);
> @@ -4429,7 +4428,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>  	page_counter_set_min(&memcg->memory, 0);
>  	page_counter_set_low(&memcg->memory, 0);
>  	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> -	memcg1_soft_limit_reset(memcg);
>  	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
>  	memcg_wb_domain_size_changed(memcg);
>  }
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
