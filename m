Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F24E440A15
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 08:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609553; cv=none; b=OUsX6lP5rJX1VkA4q+OH5DZoR97w9nQqvg117uSjzDlwnPnPJfcIMXaPXlo3bVn7OPJxfpE3Jx3oksNWpm1FGB2F/Am0pAsTU2VZsyZaUOo6zhum+XE4N5fT59tgFm+H/y4Gi0h6EKtglPzpOmqZ18jb/jn9ZWUjCJl2ohJuZrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609553; c=relaxed/simple;
	bh=OwzypSxa4ec84yvJkHCWgLJyCWPrtCIPvMO9pIGEo10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gmScm6InZBfHKMV3nfILY0dCR3iP2UbKMeqkjRLUzSvPbgs+ETxrlfKkqJcXiZPff1oHOAMTTXufWE6XJVpNPfAi6XpFPib9ehZC01a3MheCd++GiKiyXecYUDVGheJfuOWfJVpZXXvf4CBf0sB0k6LnK6aQ2RzIiTVPJl04L2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I4+sIEHB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I4+sIEHB"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4954a32cf1eso1818105e9.3
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609548; x=1787214348; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d7EWP/UZyzHoakqvLZkpxTo9WbVTelGn+MRpEEiULPo=;
        b=I4+sIEHB59sx6uQhtuCzCoDlDHOrB3JUi6XpBqoNl8K5+c79KHNe8rG4zpgm9TR3YS
         Js9NsluJB1fdXFIaTSzGNQ2jtOhFZtRDDv/uruo499XCUIgKJ5rfH97XXtckZveJiw5r
         U4oqZ8lCZ1fxcbTK57AhlgcDc5TuqgxarxpEZtJNFLMI/uAE2tpt1TZtluOq/c+tfkG3
         sJG++bBMhMU92SUlTPxCaSaryaBnV1psMBtJaWX5FQ2ykG9VmQ6tw9jXUI+mnFtYD1a0
         cgJv0doH3uCFJFp3x2X6PXfcuMrn/CVIrxkIX2tt/jONOKGyhkRfaJ/TKHZ4t6RRnMeQ
         Sq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609548; x=1787214348;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d7EWP/UZyzHoakqvLZkpxTo9WbVTelGn+MRpEEiULPo=;
        b=Nil33LWdRkud95Tw7CSGFen4K7ZzQ/LXIYZWJadEGHRQ+Q9C0k5mz1CHQ0kwmhMGC6
         XGZae1M830uPyEbFaKkud211qqB6lXYww/xMghPJ7I0aq01ds6iDR7TaYzH1J2evWZe1
         dQpC7vkkt+hqG/LbGqzMbDHpuxjU3ZLJX0UC442T7ZrT8kFjHipGXnWqgtlP9JWH73ei
         w7hEQnPBchoRZ1dhbroUbbm03dD7RReRBo/klqFBdAydF8zlMmlgtO2BSWlyNcIl4+8N
         kD8CE6DBdTS9TN+N0FjuXtfZstK7yqStVvGUZsF0NgjZuYZAGigWk1qEASkK/06JnTgX
         XEtQ==
X-Forwarded-Encrypted: i=1; AHgh+RqBNXjnVHHpkkuoI0GyxRJtlH/r3nyLePqhD56NpO3Hi7Vx4NTtdaw+hVzEAhaL7cj/4HfknvVS@vger.kernel.org
X-Gm-Message-State: AOJu0YwEbg8iBfPINrpqqXAbQejfVZ8v1Jrq1ET1WF63LZmTSuScVfiU
	RqIBnxGBYNU+FnQdN+F6zDklBwf83Hjofdi9kL3VFgcQ/Ou0bDEAobFcHcMkTlYVxUg=
X-Gm-Gg: AR+sD13a/aIk0M8FsMfuKW9G1GSoT0bu2tfcYrIuvfplzXL2cR+cV+fntuNrj9IQ/GS
	XrqnNCPxB6cJw4zsxD9mARrt+nDD8oRNLV8bpMQs2lhKKtp8lxLaWkDPTf1fYDsusizUqloGJ4T
	GZhH4SYBql4fcQccnAFaG/OVnR4s4mUFJRIC+JE3fILRetk0tc9h004XaCJxyBUBFu9H9d3D8i+
	vzSFSKNHureJLqMRdJZXT17HGbq31p0xEeVP5xzCamEL7LBS8ry/c2WNenfPBHUC731hFWlRKEf
	CN5yX+7BfO/TpWO0yNeZzb3chUgbkFnSqyPuKD8xNBUMURp7S25UnGAnx+ISHU+yneCFKpIOggr
	1sVQcC1bT/Vp9jwus/QTFf75r/peYRU7o+k7AMnDSXbp3XeCPGbgvADbNaSgQAJHd47za7BXScG
	+6aCWmrln8hVpACJ8AIr7DjO08vUC4QFhmQaBSYh4bbiQhDVUrSDrUzbd/+9h4vWBTRMobl3E=
X-Received: by 2002:a05:600c:e489:20b0:499:8467:3f2d with SMTP id 5b1f17b1804b1-49984673f49mr6182385e9.19.1786609548419;
        Thu, 13 Aug 2026 01:25:48 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499820f5d26sm32668385e9.1.2026.08.13.01.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:25:48 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:25:47 +0200
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
Subject: Re: [PATCH 5/9] memcg: remove the soft limit rbtree
Message-ID: <an1_i8BeRtUA01xs@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-6-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-6-shakeel.butt@linux.dev>

On Tue 11-08-26 13:31:59, Shakeel Butt wrote:
> With soft limit reclaim gone, the per-node rbtree of cgroups in excess
> has no readers left. Remove the tree, the helpers maintaining it, and
> the subsys_initcall that existed only to allocate it. memcg1_check_events()
> no longer needs to feed it, which also drops the last caller of
> lru_gen_soft_reclaim().
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol-v1.c | 176 +--------------------------------------------
>  mm/memcontrol-v1.h |   2 -
>  mm/memcontrol.c    |   1 -
>  3 files changed, 2 insertions(+), 177 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index b38b8d0f7f51..475f998b7643 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -17,23 +17,6 @@
>  #include "swap_table.h"
>  #include "memcontrol-v1.h"
>  
> -/*
> - * Cgroups above their limits are maintained in a RB-Tree, independent of
> - * their hierarchy representation
> - */
> -
> -struct mem_cgroup_tree_per_node {
> -	struct rb_root rb_root;
> -	struct rb_node *rb_rightmost;
> -	spinlock_t lock;
> -};
> -
> -struct mem_cgroup_tree {
> -	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
> -};
> -
> -static struct mem_cgroup_tree soft_limit_tree __read_mostly;
> -
>  /* for OOM */
>  struct mem_cgroup_eventfd_list {
>  	struct list_head list;
> @@ -99,133 +82,6 @@ static struct lockdep_map memcg_oom_lock_dep_map = {
>  
>  DEFINE_SPINLOCK(memcg_oom_lock);
>  
> -static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
> -					 struct mem_cgroup_tree_per_node *mctz,
> -					 unsigned long new_usage_in_excess)
> -{
> -	struct rb_node **p = &mctz->rb_root.rb_node;
> -	struct rb_node *parent = NULL;
> -	struct mem_cgroup_per_node *mz_node;
> -	bool rightmost = true;
> -
> -	if (mz->on_tree)
> -		return;
> -
> -	mz->usage_in_excess = new_usage_in_excess;
> -	if (!mz->usage_in_excess)
> -		return;
> -	while (*p) {
> -		parent = *p;
> -		mz_node = rb_entry(parent, struct mem_cgroup_per_node,
> -					tree_node);
> -		if (mz->usage_in_excess < mz_node->usage_in_excess) {
> -			p = &(*p)->rb_left;
> -			rightmost = false;
> -		} else {
> -			p = &(*p)->rb_right;
> -		}
> -	}
> -
> -	if (rightmost)
> -		mctz->rb_rightmost = &mz->tree_node;
> -
> -	rb_link_node(&mz->tree_node, parent, p);
> -	rb_insert_color(&mz->tree_node, &mctz->rb_root);
> -	mz->on_tree = true;
> -}
> -
> -static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
> -					 struct mem_cgroup_tree_per_node *mctz)
> -{
> -	if (!mz->on_tree)
> -		return;
> -
> -	if (&mz->tree_node == mctz->rb_rightmost)
> -		mctz->rb_rightmost = rb_prev(&mz->tree_node);
> -
> -	rb_erase(&mz->tree_node, &mctz->rb_root);
> -	mz->on_tree = false;
> -}
> -
> -static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
> -				       struct mem_cgroup_tree_per_node *mctz)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&mctz->lock, flags);
> -	__mem_cgroup_remove_exceeded(mz, mctz);
> -	spin_unlock_irqrestore(&mctz->lock, flags);
> -}
> -
> -static unsigned long soft_limit_excess(struct mem_cgroup *memcg)
> -{
> -	unsigned long nr_pages = page_counter_read(&memcg->memory);
> -	unsigned long soft_limit = READ_ONCE(memcg->soft_limit);
> -	unsigned long excess = 0;
> -
> -	if (nr_pages > soft_limit)
> -		excess = nr_pages - soft_limit;
> -
> -	return excess;
> -}
> -
> -static void memcg1_update_tree(struct mem_cgroup *memcg, int nid)
> -{
> -	unsigned long excess;
> -	struct mem_cgroup_per_node *mz;
> -	struct mem_cgroup_tree_per_node *mctz;
> -
> -	if (lru_gen_enabled()) {
> -		if (soft_limit_excess(memcg))
> -			lru_gen_soft_reclaim(memcg, nid);
> -		return;
> -	}
> -
> -	mctz = soft_limit_tree.rb_tree_per_node[nid];
> -	if (!mctz)
> -		return;
> -	/*
> -	 * Necessary to update all ancestors when hierarchy is used.
> -	 * because their event counter is not touched.
> -	 */
> -	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
> -		mz = memcg->nodeinfo[nid];
> -		excess = soft_limit_excess(memcg);
> -		/*
> -		 * We have to update the tree if mz is on RB-tree or
> -		 * mem is over its softlimit.
> -		 */
> -		if (excess || mz->on_tree) {
> -			unsigned long flags;
> -
> -			spin_lock_irqsave(&mctz->lock, flags);
> -			/* if on-tree, remove it */
> -			if (mz->on_tree)
> -				__mem_cgroup_remove_exceeded(mz, mctz);
> -			/*
> -			 * Insert again. mz->usage_in_excess will be updated.
> -			 * If excess is 0, no tree ops.
> -			 */
> -			__mem_cgroup_insert_exceeded(mz, mctz, excess);
> -			spin_unlock_irqrestore(&mctz->lock, flags);
> -		}
> -	}
> -}
> -
> -void memcg1_remove_from_trees(struct mem_cgroup *memcg)
> -{
> -	struct mem_cgroup_tree_per_node *mctz;
> -	struct mem_cgroup_per_node *mz;
> -	int nid;
> -
> -	for_each_node(nid) {
> -		mz = memcg->nodeinfo[nid];
> -		mctz = soft_limit_tree.rb_tree_per_node[nid];
> -		if (mctz)
> -			mem_cgroup_remove_exceeded(mz, mctz);
> -	}
> -}
> -
>  static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
>  				struct cftype *cft)
>  {
> @@ -336,7 +192,7 @@ static void mem_cgroup_threshold(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -/* Cgroup1: threshold notifications & softlimit tree updates */
> +/* Cgroup1: threshold notifications */
>  
>  /*
>   * Per memcg event counter is incremented at every pagein/pageout. With THP,
> @@ -405,17 +261,8 @@ static void memcg1_check_events(struct mem_cgroup *memcg, int nid)
>  	if (IS_ENABLED(CONFIG_PREEMPT_RT))
>  		return;
>  
> -	/* threshold event is triggered in finer grain than soft limit */
> -	if (unlikely(memcg1_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit;
> -
> -		do_softlimit = memcg1_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_SOFTLIMIT);
> +	if (unlikely(memcg1_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH)))
>  		mem_cgroup_threshold(memcg);
> -		if (unlikely(do_softlimit))
> -			memcg1_update_tree(memcg, nid);
> -	}
>  }
>  
>  void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
> @@ -2391,22 +2238,3 @@ void memcg1_free_events(struct mem_cgroup *memcg)
>  {
>  	free_percpu(memcg->events_percpu);
>  }
> -
> -static int __init memcg1_init(void)
> -{
> -	int node;
> -
> -	for_each_node(node) {
> -		struct mem_cgroup_tree_per_node *rtpn;
> -
> -		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> -
> -		rtpn->rb_root = RB_ROOT;
> -		rtpn->rb_rightmost = NULL;
> -		spin_lock_init(&rtpn->lock);
> -		soft_limit_tree.rb_tree_per_node[node] = rtpn;
> -	}
> -
> -	return 0;
> -}
> -subsys_initcall(memcg1_init);
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 1e394269c613..fd611e66859a 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -41,7 +41,6 @@ bool memcg1_alloc_events(struct mem_cgroup *memcg);
>  void memcg1_free_events(struct mem_cgroup *memcg);
>  
>  void memcg1_memcg_init(struct mem_cgroup *memcg);
> -void memcg1_remove_from_trees(struct mem_cgroup *memcg);
>  
>  static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
>  {
> @@ -98,7 +97,6 @@ static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true;
>  static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
>  
>  static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
> -static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
>  static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
>  static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1d3339520809..b68f1f16ae54 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4394,7 +4394,6 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  
>  	vmpressure_cleanup(&memcg->vmpressure);
>  	cancel_work_sync(&memcg->high_work);
> -	memcg1_remove_from_trees(memcg);
>  	free_shrinker_info(memcg);
>  	mem_cgroup_free(memcg);
>  }
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
