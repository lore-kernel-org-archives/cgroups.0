Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2CE440A0B
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 08:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609501; cv=none; b=AEmc5b43in3PHOBX3Ny1P7wZ7YnpbuO2TmBTIwazDDlU5KnACMBqb+PI2wrZ/JjFlYDZ5kVUKRFKXROyuKgB27ltsluw8p9K/qfg3OuWLGZPqStuPQls32uhyQCj0G5+vIaU49Gul9sU106xn366btps1XbNYgekqkE+YTXIxHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609501; c=relaxed/simple;
	bh=37vAtmNfOujMcH3MWHXINElpCL9eyAWFyk+kSktAwy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jdck3Lg8DBzeMdHaLip5XhoscgWLMZ6aMkcshuzTz7ISpB5IjUtZuScKykvm9l/tVpcxtP94Vju51W4aTLoinEdVZUCMCxLWU9hxL9C203bSqwAlaW5ws0SzGn8BeRWCpVKEFyBaI4TpnoBPjTPoEHKzvtEqOp1RnIe+q8WzTI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PdLYFM79; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PdLYFM79"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f96c5b722so946200f8f.0
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609498; x=1787214298; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=olz8czTGt9Myorg9Ej6EStVuWMdLaEwvC+90rEKHcaE=;
        b=PdLYFM79/GqP4V+lmM7tuqa5xML/i1dgIteWYIrQyDZWDAyD/YvHcgiQVqFs5WaqFd
         ZKObpOBZr7tLh/TS25TGZtph7owr4sZ7mmeZP53gLxYyQOt9dRmNVaiU4NmTAkM2V8te
         pnljgPlekMBi+I1LF31ggnn/7syz/Up5BeWv88LX5NQgu3ibo2FgvFNEAf+U6mlWKPpj
         GqSIUca/iSDdR54dYXZGDhxjEraAy78ZXsRo5Q4zPxhtV4ZVFFMU6PP3qXSxak6+qXOn
         gB1oABxCyu1Pfy4fjnWt+UMmpquIREeQ41laccdb0AYTXX7vMoZHaSXgE/Sq/8AHgm5o
         +/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609498; x=1787214298;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=olz8czTGt9Myorg9Ej6EStVuWMdLaEwvC+90rEKHcaE=;
        b=Aw5N835L9Ile4Gvxs6i5FwEVxcH7Dks9v6mQZO+BBp1GVXAzrfuij5ymeCDqlmIQJX
         v12ohbdFlYxT1KuU8iqBbNcAy0P81IqOOC/hG2hON5qfWk7P5CxTcbLW6VGvjLHplAnL
         L8Xd5ASCkLIwGIn4GUIslhIuXnOzVdJAFZddLQ1Y9ZkfmFWzfD7D1O+o9HxXDhe81zeh
         eq0TglZY+QgAjhYwG7SWLAs8QXGBroG9SyYOZ5ZbEYR8KJK2Fh6Jf09a5JgQ8okczHMa
         siYGxIxvngnaog+qsCo4x2QKBxKH+0qErpJ4Se2qF6GqYMDZO/XrctHGQ+ENTzfyTmrp
         VFIg==
X-Forwarded-Encrypted: i=1; AHgh+RqrZT5MFUw1lHSqu/Q3xifm+bKHd79JXy9fMAxctj6uO6pebjsKqub+r+XIcQGr8c7L01ynxLD9@vger.kernel.org
X-Gm-Message-State: AOJu0YwniiLXeVgeeMan9HAS+7UCfgwPPgk/nvqYsQEjuKsLENYXyvJN
	uuPAxn7a+8jwrpGdgPhIfyxWZdhQxdAyvC8w/E1Sm34PDgQEbdupcoEuzYMwX4ppOjo=
X-Gm-Gg: AR+sD10AFLe9JlSY9dcZfgfAKM3npbqw2j7RCADHKVXCOoM0SdG6OHR+THANooKXWeT
	8de04fGTDuAoehhGKwgmfxTTQr7IGQ4oOFx8AEhOPqJjA7bnzxNWZk4CKN6++BT0RPJTevz5K3h
	0p0T9j0blXu6Okdvr5MwNjJbPoBPbg65J7QGm2LuMPkibo4rHYDO2SMH7KhlJaxYUa8sVCqjxB+
	/3kBOnqOF520X2SWDBlR1QiiAHs5y79kThFKjBWK49RNyTxewL6coJbWLW4cBqbl4C72q8shKhf
	2TbnT2kANSYkN4hU+w7RYKpLjDTf4LPt1Xxmwf9+IBTVWgE/S7hjnFnHrZunSMaChDlZgWCqFCB
	o77JUXT1atJlLUew8tf7wX5W0iHg2DceMoLqk2zDnQRHmewMz1CDNB/3qmfGTaGSyOiFlLC40ES
	tXGHU+TaWrjcM9jZ7Xo1VcJibDGx0XObOj4FzWJkNh0iZx+mBEq6XRt1CrZLbgmF/k0PJlqjz0Z
	4cjUuMc2w==
X-Received: by 2002:a5d:45c8:0:b0:481:4dcd:aefa with SMTP id ffacd0b85a97d-48159ca6290mr4320423f8f.6.1786609498024;
        Thu, 13 Aug 2026 01:24:58 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5af19fsm4502301f8f.24.2026.08.13.01.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:24:57 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:24:56 +0200
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
Subject: Re: [PATCH 3/9] memcg: remove mem_cgroup_shrink_node()
Message-ID: <an1_WBpFCiYL2Flr@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-4-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-4-shakeel.butt@linux.dev>

On Tue 11-08-26 13:31:57, Shakeel Butt wrote:
> Its only caller was soft limit reclaim, which is gone.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/internal.h |  4 ----
>  mm/vmscan.c   | 41 -----------------------------------------
>  2 files changed, 45 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 678ce8d03515..b2315bdb7350 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -85,10 +85,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   gfp_t gfp_mask,
>  					   unsigned int reclaim_options,
>  					   int *swappiness);
> -unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
> -				     gfp_t gfp_mask, bool noswap,
> -				     pg_data_t *pgdat,
> -				     unsigned long *nr_scanned);
>  
>  #ifdef CONFIG_NUMA
>  extern int sysctl_min_unmapped_ratio;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 032b14793d91..790b50c78a2e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6795,47 +6795,6 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  
>  #ifdef CONFIG_MEMCG
>  
> -/* Only used by soft limit reclaim. Do not reuse for anything else. */
> -unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
> -						gfp_t gfp_mask, bool noswap,
> -						pg_data_t *pgdat,
> -						unsigned long *nr_scanned)
> -{
> -	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	struct scan_control sc = {
> -		.nr_to_reclaim = SWAP_CLUSTER_MAX,
> -		.target_mem_cgroup = memcg,
> -		.may_writepage = 1,
> -		.may_unmap = 1,
> -		.reclaim_idx = MAX_NR_ZONES - 1,
> -		.may_swap = !noswap,
> -	};
> -
> -	WARN_ON_ONCE(!current->reclaim_state);
> -
> -	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
> -			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
> -
> -	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.gfp_mask,
> -						      sc.order,
> -						      memcg);
> -
> -	/*
> -	 * NOTE: Although we can get the priority field, using it
> -	 * here is not a good idea, since it limits the pages we can scan.
> -	 * if we don't reclaim here, the shrink_node from balance_pgdat
> -	 * will pick up pages from other mem cgroup's as well. We hack
> -	 * the priority and make it zero.
> -	 */
> -	shrink_lruvec(lruvec, &sc);
> -
> -	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, memcg);
> -
> -	*nr_scanned = sc.nr_scanned;
> -
> -	return sc.nr_reclaimed;
> -}
> -
>  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   unsigned long nr_pages,
>  					   gfp_t gfp_mask,
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
