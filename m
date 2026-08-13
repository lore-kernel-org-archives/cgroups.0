Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655524432FF
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 08:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609738; cv=none; b=nApBxV78phdS/QrHi3bYlqs6YyiP8OmOOuQyu1L6o1VrL85Vsh69MiGZtOOa3LOuOF4+GUEOrR1kj25+zGJyvFrvefQ9+1d2cj5Su2wg6U1gL14gOcwBdolTdakKfnOo8flUKcoS4vMtcSIDVBpS6blABlty63R+ve/2f/AwoF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609738; c=relaxed/simple;
	bh=7ZCNTD94xl9jP494SBag3uoCW93UwE54WHGmIq9YfNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuDyXTCgvBtKksrX2G1qPWqvBk1p9XjZTp7bpOTFFeaIPOLnAbAxyAi+KgdzAPuQqo0Ny6D42IdJiWFbob4AEbnmp6kMWFgOrx9hG5H0L0b4HJlfL9OgyQrFprgpkWKBJd5AW8tT0H5Jn8CHHxdk75R4I2iaGiwelvCoMz2o6xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CVg4DdLO; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CVg4DdLO"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-496b7622a83so2709555e9.2
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609734; x=1787214534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fgiJKTttCwuzu5gzwlJpsUc5acP5ulEuNQCsjjnCulg=;
        b=CVg4DdLO4cBmiUspqIQmN+DoZoyynFsZf2Th8+tFzBCx69ILzoLfth28AOHL6TS7J2
         5Myqd45LF/H1SUBcsFe8DeXK9g1cyuiZrcRwJQtUz9NP04ir5163mxLSr+ppDti1YCBM
         zxLMQvisEsxhaunCBnLdUF6XLpGRJpk0D+Lc+wv+DX9YCLh5WOe/7bf/RzQFJHUz36SI
         LtwjU9WMa0jJYVN9si5r2R9u8V05ZzPqh6O9DUIXFB5OuWmU0aOq1DoZ2C1emJpGvZXo
         2m4fZ5crVwxyVZ2n2kEByaDxEHGXqyvBOca8igrFAsiM7j8BvQddzbB6w7Ewx9uPAZ5G
         biBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609734; x=1787214534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fgiJKTttCwuzu5gzwlJpsUc5acP5ulEuNQCsjjnCulg=;
        b=D7Th8K78P4pdZGGsYXWD/OPSVnRhvV9m3yykXXk3E1ib7vDoouZoWYxYXUMFfWUIRW
         PVourvjonQ9eRoHQf7dZjAxYb14JDUYuSeiXLZOMNRMehG1sDMmkhIjULo8cwlnXJnX7
         aqwAjp1IZ8aWnhb7HGO+GLArWQko/B3WYzFcfpXMVU/ffThmvhHS9iY/cd60ldZRI40E
         sRYBMETaO1q/q7rxF2fM0abHtlrMyY4S484whIKKPxrxKIhIFFVEXo+44I7jS5sELA4j
         EkZvQ7MlL/D+Te1LhIWpKbySERNZ1pXE3EwF4o9RYE7kbBzrjPalCqVjO3Cvgqpwn/MR
         DQ6A==
X-Forwarded-Encrypted: i=1; AHgh+RqUFwWJS3OckeXYMgMoQq4mN3OvYO+7W9RutGfCihpDt0pNiAETogEz0s8N3B23O+HL1y6ZJDbs@vger.kernel.org
X-Gm-Message-State: AOJu0YyCTJ0bHZyWe5k3NrirTNQDaPJfydBkBzpOwj5GFLtwaZhA/0AS
	dlFORwY0BdVTKGksG+ieAcZrbrhKUytqtUTkKEunxS4IwN5j7KZ16nkWx2WVaTf0DXA=
X-Gm-Gg: AR+sD12yzhdHjqJtL+3i37Q0EK46BLWSPJreVPs7Re63tpKb3TVEuWXy6yQlDRKry/A
	6VCjmErxbPAbK813ZDbMPaSCAOuxuAE9s8G9GlwPSbNrbLRBFzTegIXakdRRU5pVxgove/OeLK4
	yrrlSos9mtlKcQ8GTYnIYr1dHtQR22g1TiTUJ6wWzQF4xh2/0kCQNY5JHHdMlTghb56KWi13u8n
	3ALhw1WOghAW++Qwr3D+89o1JWTtD1tLCCP4UahNV9/V5YMwg9NJ+qtrrJN8qwo8Fz1N5zsXGEc
	UvLG3ihAZLb5ItmzQM8CLvOMrmctZOXvq0/GhAlJVQ3/BcybqaS2uMSludRax//pyKke6gADGsD
	Ye9haHIliHVwaxe/B+DJeW8zBEillsmAspA1mrO+9FPk27R6Cxdv4htKRDLGDOnHxYH4JGPQb0h
	lgY2cYv/GKrWFXE4ALKoE1qqBLavisWE9i6BWf8ortYTdfgp9/15VZjWFeZCdcunGEoW8qGQw=
X-Received: by 2002:a05:600c:3143:b0:499:795a:c5fc with SMTP id 5b1f17b1804b1-499821c5aeemr42857285e9.7.1786609734405;
        Thu, 13 Aug 2026 01:28:54 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5af191sm4559176f8f.19.2026.08.13.01.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:28:53 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:28:52 +0200
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
Subject: Re: [PATCH 9/9] memcg: simplify v1 event ratelimiting
Message-ID: <an2ARNynd2QQU6eJ@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-10-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-10-shakeel.butt@linux.dev>

On Tue 11-08-26 13:32:03, Shakeel Butt wrote:
> Thresholds are the only periodic v1 event left, so the target enum, the
> per-cpu target array and the switch in memcg1_event_ratelimit() all
> collapse to a single counter.
> 
> memcg1_check_events() no longer needs a node id either, which lets
> memcg1_uncharge_batch() drop its nid argument and struct
> uncharge_gather drop the field feeding it.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol-v1.c | 43 +++++++++++--------------------------------
>  mm/memcontrol-v1.h |  4 ++--
>  mm/memcontrol.c    |  4 +---
>  3 files changed, 14 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 475f998b7643..bf2c7d53b01b 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -200,15 +200,9 @@ static void mem_cgroup_threshold(struct mem_cgroup *memcg)
>   * to trigger some periodic events. This is straightforward and better
>   * than using jiffies etc. to handle periodic memcg event.
>   */
> -enum mem_cgroup_events_target {
> -	MEM_CGROUP_TARGET_THRESH,
> -	MEM_CGROUP_TARGET_SOFTLIMIT,
> -	MEM_CGROUP_NTARGETS,
> -};
> -
>  struct memcg1_events_percpu {
>  	unsigned long nr_page_events;
> -	unsigned long targets[MEM_CGROUP_NTARGETS];
> +	unsigned long threshold_target;
>  };
>  
>  static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
> @@ -225,43 +219,28 @@ static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
>  }
>  
>  #define THRESHOLDS_EVENTS_TARGET 128
> -#define SOFTLIMIT_EVENTS_TARGET 1024
>  
> -static bool memcg1_event_ratelimit(struct mem_cgroup *memcg,
> -				enum mem_cgroup_events_target target)
> +static bool memcg1_event_ratelimit(struct mem_cgroup *memcg)
>  {
>  	unsigned long val, next;
>  
>  	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
> -	next = __this_cpu_read(memcg->events_percpu->targets[target]);
> +	next = __this_cpu_read(memcg->events_percpu->threshold_target);
>  	/* from time_after() in jiffies.h */
>  	if ((long)(next - val) < 0) {
> -		switch (target) {
> -		case MEM_CGROUP_TARGET_THRESH:
> -			next = val + THRESHOLDS_EVENTS_TARGET;
> -			break;
> -		case MEM_CGROUP_TARGET_SOFTLIMIT:
> -			next = val + SOFTLIMIT_EVENTS_TARGET;
> -			break;
> -		default:
> -			break;
> -		}
> -		__this_cpu_write(memcg->events_percpu->targets[target], next);
> +		__this_cpu_write(memcg->events_percpu->threshold_target,
> +				 val + THRESHOLDS_EVENTS_TARGET);
>  		return true;
>  	}
>  	return false;
>  }
>  
> -/*
> - * Check events in order.
> - *
> - */
> -static void memcg1_check_events(struct mem_cgroup *memcg, int nid)
> +static void memcg1_check_events(struct mem_cgroup *memcg)
>  {
>  	if (IS_ENABLED(CONFIG_PREEMPT_RT))
>  		return;
>  
> -	if (unlikely(memcg1_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH)))
> +	if (unlikely(memcg1_event_ratelimit(memcg)))
>  		mem_cgroup_threshold(memcg);
>  }
>  
> @@ -271,7 +250,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
>  
>  	local_irq_save(flags);
>  	memcg1_charge_statistics(memcg, folio_nr_pages(folio));
> -	memcg1_check_events(memcg, folio_nid(folio));
> +	memcg1_check_events(memcg);
>  	local_irq_restore(flags);
>  }
>  
> @@ -344,7 +323,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
>  	VM_WARN_ON_IRQS_ENABLED();
>  	memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
>  	preempt_enable_nested();
> -	memcg1_check_events(memcg, folio_nid(folio));
> +	memcg1_check_events(memcg);
>  
>  	rcu_read_unlock();
>  	obj_cgroup_put(objcg);
> @@ -398,14 +377,14 @@ void memcg1_swapin(struct folio *folio)
>  #endif
>  
>  void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
> -			   unsigned long nr_memory, int nid)
> +			   unsigned long nr_memory)
>  {
>  	unsigned long flags;
>  
>  	local_irq_save(flags);
>  	count_memcg_events(memcg, PGPGOUT, pgpgout);
>  	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_memory);
> -	memcg1_check_events(memcg, nid);
> +	memcg1_check_events(memcg);
>  	local_irq_restore(flags);
>  }
>  
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index f48d0e22e615..b9a21f0fd2c3 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -59,7 +59,7 @@ void memcg1_oom_recover(struct mem_cgroup *memcg);
>  
>  void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
>  void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
> -			   unsigned long nr_memory, int nid);
> +			   unsigned long nr_memory);
>  
>  void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
>  void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
> @@ -107,7 +107,7 @@ static inline void memcg1_commit_charge(struct folio *folio,
>  
>  static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
>  					 unsigned long pgpgout,
> -					 unsigned long nr_memory, int nid) {}
> +					 unsigned long nr_memory) {}
>  
>  static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ba3ef821553d..44ef376d657b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5293,7 +5293,6 @@ struct uncharge_gather {
>  	unsigned long nr_memory;
>  	unsigned long pgpgout;
>  	unsigned long nr_kmem;
> -	int nid;
>  };
>  
>  static inline void uncharge_gather_clear(struct uncharge_gather *ug)
> @@ -5316,7 +5315,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
>  		memcg1_oom_recover(memcg);
>  	}
>  
> -	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory, ug->nid);
> +	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory);
>  	rcu_read_unlock();
>  
>  	/* drop reference from uncharge_folio */
> @@ -5345,7 +5344,6 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
>  			uncharge_gather_clear(ug);
>  		}
>  		ug->objcg = objcg;
> -		ug->nid = folio_nid(folio);
>  
>  		/* pairs with obj_cgroup_put in uncharge_batch */
>  		obj_cgroup_get(objcg);
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
