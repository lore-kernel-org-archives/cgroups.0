Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181FB43F8B8
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 08:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609620; cv=none; b=Ml0V1x5OsjB839bZNsDEio+O2M7BeJ7F0mvlkygVgGW8Xu4YkZrFu/OWr9E4EOCczuPmPMLgKy0yCUCDYPGHcouzj0GfQxJL/qSHO7MbFu3f8T/reAj8AOxpaFnnfqkCktF8M6irT2IN+Vk/DGIiwWtF8ppY2/HR5rWhUekT+VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609620; c=relaxed/simple;
	bh=I/NzXhcW/eH2722E91KGbJkv5uFuuhAvtBQcMJeWrRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QvA9kmmYaLkXMsmWJAhLWqvUWsn94XuhIH/7jyTlzhH539fOucvPaH8U4LbJbNRayQasSCvWxyHwaehmdiSaUT+Os3eJE5hH47q32UqKuI30JTIq60eqfsVedIvzITmlgQHBEHrp1lkjx1mevicnIayRu6mRy0ETnfPMlaX5/R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bGfw+JNy; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bGfw+JNy"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47fe377a217so1116035f8f.1
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609617; x=1787214417; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jb3x2xS6aF9vNzoM2pzTwYtYyaatYjz82383HVr+7k0=;
        b=bGfw+JNyv0HB6QcZs2OTJsoBuJeiOsW3vA8pufOjE3fPvLCT6Ey5yzTg/E/NszcvrW
         4/Lb30zxzaPQ+EGzeDFjEb4cqhlKni9I/DOZ/U1hL0MxLdiKsviVYOJZ5hdqG9aE5JKq
         D1RbEHBr+hdz9JhfiRSJowIjp37e3OFpjzCy5rTrOVLgQyiE8B80cgMHpKvP4qUhUxne
         C7XEtUfz2h0J9Zw+CJ3wC/VUpKFII3fe2qoiw84ECuXNbussqHWYIFR5hyO7R3i+J43z
         pUrKao0rP0dmWsHZpTfk6IKbqJhB2xYxBseSbx19RmZJPW8OoI2RDh6xp6xmjYkbqyNM
         gCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609617; x=1787214417;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jb3x2xS6aF9vNzoM2pzTwYtYyaatYjz82383HVr+7k0=;
        b=iZY7ldKFvcDpAjbavyfxFjo2ODpIqBDAp0m8whdF7Z5UYkRs7KDK7eHYyZaKdknz9Z
         1WmAEGoLLaDWUSfwgq4/67Jxjb0lSUgUUxtkV/j0TSf3b/Sri/GkuIQgwQo54p4kDD2u
         i23nzLRuMc29Lq2V0hB4kKZLce6U4NGZ2fjCjLf6RwbVSJr78P+X73YLLDTR2JzOMXKS
         UWq2JJJZOw+cS/3Qn5O5byxEy0WECbMZGwnLb4ZAmGp9ENj05sW4hPtUFwe7b+tAhGAy
         8+JfTJpsaBf0Z/UHEH3INRB2dGosiFC8wtLic8lSa2Dq6h8w2QcQFLq1XEZl3x/aMzHw
         x6tQ==
X-Forwarded-Encrypted: i=1; AHgh+RoOgJweZoLd4Xr2TAHazSRsu+jE/wDFeWGsz9bKerPDpDHfQEu9KXiJlqSixvhOse+Ao9CMR/nI@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy7JRxTLDt2/vow5FCvJG7EYPTsmWc6NnKJV8Z4X4d4kwn7/RA
	ieArXPKsNjaZQAGSHGN6hJPz8KGB0+KriQxSWludkxiRt3eZa+q4uQPbHPQ9v7uLfUY=
X-Gm-Gg: AR+sD12wVkBa6jEkSdFgIstLPgwb+lI5A1MC/yu0bicmqR8rEEx0x1Ui8VNHPpsnadG
	3+6mwqGQvrTen3VOM2J35PDegVEMb0zHlCKxyGYt9Kk/g8pne51iQAvtIIB8CdaqDZE5h0orM1V
	lB38dwv2SimOewym+Yqa2IiKsoBQZCkrk53k0uMZFct8xPZvWh2vvxQIiGEjwOT9745BazKIDpr
	dp/EQX0gPxdhpzFRMOQ3WPQi/uCLyAlHcYzhZWIsmhyofmQ1OYh4uwOOOr2u63Wy8yLdJ9vSG69
	YfFloR+jQlrmUkK2Z/x3w7eFdbPJ/WjxMlZ528aEj2weflJGVtrmjNpNkTbrBA8Z5JHIc3JcYG+
	2T4iCuvkQajbcwvmERhs3uiSRrXPbopi831xvZVt14bYxlmQXIXBz2Oas0xTOPt8fdjI232fThs
	xFXSiYIXwH+8eAxFvW/7K1m7+K7Sv20NqttkFeAgH/OmSiG3Fu2178YVduTyUoNv5GC+YQcRc=
X-Received: by 2002:adf:f74d:0:b0:47f:cb30:8616 with SMTP id ffacd0b85a97d-4815a00e362mr140464f8f.27.1786609617172;
        Thu, 13 Aug 2026 01:26:57 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a56133csm4400191f8f.7.2026.08.13.01.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:26:56 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:26:55 +0200
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
Subject: Re: [PATCH 6/9] memcg: remove lru_gen_soft_reclaim()
Message-ID: <an1_z6V5l7CNaCSb@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-7-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-7-shakeel.butt@linux.dev>

On Tue 11-08-26 13:32:00, Shakeel Butt wrote:
> The soft limit rbtree was the only caller. Dropping it leaves
> MEMCG_LRU_HEAD unreachable, since nothing else ever rotates a memcg with
> that op, so remove the op too and update the memcg LRU comment.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

I am not deeply familiar with MGLRU to give my ack but from a quick look
this looks right.

> ---
>  include/linux/mmzone.h | 30 +++++++++++-------------------
>  mm/vmscan.c            | 16 ++--------------
>  2 files changed, 13 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff5416..01fabd0ece0d 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -635,35 +635,32 @@ struct lru_gen_mm_walk {
>   * For each node, memcgs are divided into two generations: the old and the
>   * young. For each generation, memcgs are randomly sharded into multiple bins
>   * to improve scalability. For each bin, the hlist_nulls is virtually divided
> - * into three segments: the head, the tail and the default.
> + * into two segments: the tail and the default.
>   *
>   * An onlining memcg is added to the tail of a random bin in the old generation.
>   * The eviction starts at the head of a random bin in the old generation. The
>   * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GENS) indexes
>   * the old generation, is incremented when all its bins become empty.
>   *
> - * There are four operations:
> - * 1. MEMCG_LRU_HEAD, which moves a memcg to the head of a random bin in its
> - *    current generation (old or young) and updates its "seg" to "head";
> - * 2. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
> + * There are three operations:
> + * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
>   *    current generation (old or young) and updates its "seg" to "tail";
> - * 3. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
> + * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
>   *    generation, updates its "gen" to "old" and resets its "seg" to "default";
> - * 4. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
> + * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
>   *    young generation, updates its "gen" to "young" and resets its "seg" to
>   *    "default".
>   *
>   * The events that trigger the above operations are:
> - * 1. Exceeding the soft limit, which triggers MEMCG_LRU_HEAD;
> - * 2. The first attempt to reclaim a memcg below low, which triggers
> + * 1. The first attempt to reclaim a memcg below low, which triggers
>   *    MEMCG_LRU_TAIL;
> - * 3. The first attempt to reclaim a memcg offlined or below reclaimable size
> + * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
>   *    threshold, which triggers MEMCG_LRU_TAIL;
> - * 4. The second attempt to reclaim a memcg offlined or below reclaimable size
> + * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
>   *    threshold, which triggers MEMCG_LRU_YOUNG;
> - * 5. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
> - * 6. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
> - * 7. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> + * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
> + * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
> + * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
>   *
>   * Notes:
>   * 1. Memcg LRU only applies to global reclaim, and the round-robin incrementing
> @@ -696,7 +693,6 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg);
>  void lru_gen_online_memcg(struct mem_cgroup *memcg);
>  void lru_gen_offline_memcg(struct mem_cgroup *memcg);
>  void lru_gen_release_memcg(struct mem_cgroup *memcg);
> -void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
>  void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
>  bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
>  void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
> @@ -737,10 +733,6 @@ static inline void lru_gen_release_memcg(struct mem_cgroup *memcg)
>  {
>  }
>  
> -static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
> -{
> -}
> -
>  static inline void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
>  {
>  }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 790b50c78a2e..71244cf33d59 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4373,7 +4373,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  /* see the comment on MEMCG_NR_GENS */
>  enum {
>  	MEMCG_LRU_NOP,
> -	MEMCG_LRU_HEAD,
>  	MEMCG_LRU_TAIL,
>  	MEMCG_LRU_OLD,
>  	MEMCG_LRU_YOUNG,
> @@ -4395,9 +4394,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
>  	new = old = lruvec->lrugen.gen;
>  
>  	/* see the comment on MEMCG_NR_GENS */
> -	if (op == MEMCG_LRU_HEAD)
> -		seg = MEMCG_LRU_HEAD;
> -	else if (op == MEMCG_LRU_TAIL)
> +	if (op == MEMCG_LRU_TAIL)
>  		seg = MEMCG_LRU_TAIL;
>  	else if (op == MEMCG_LRU_OLD)
>  		new = get_memcg_gen(pgdat->memcg_lru.seq);
> @@ -4411,7 +4408,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
>  
>  	hlist_nulls_del_rcu(&lruvec->lrugen.list);
>  
> -	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
> +	if (op == MEMCG_LRU_OLD)
>  		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
>  	else
>  		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
> @@ -4489,15 +4486,6 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
> -{
> -	struct lruvec *lruvec = get_lruvec(memcg, nid);
> -
> -	/* see the comment on MEMCG_NR_GENS */
> -	if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_HEAD)
> -		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
> -}
> -
>  bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
>  {
>  	struct lruvec *lruvec = get_lruvec(memcg, nid);
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
