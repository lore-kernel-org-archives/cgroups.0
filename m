Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F2532A3C9;
	Sat,  5 Sep 2026 23:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651264; cv=none; b=ac3fvwMgCIjv5f4F0nMwRE82oEMOjSR9eKGGGcl9+6UtlbWycZSk4IoPKbjOsI4R/OCzZdROf02r0aJjpfoPUVJ8+tR4ZcKA9woX0DgUcGr0xzb3GfZlJDx56v/pVrVKBgFmmc0rH+pgq6a2ASEGveSt4ZRABajLxOyoi/SJKGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651264; c=relaxed/simple;
	bh=w078YN4c5Z92lEaGqYaRONFw28+c8b2lFM6cr4WcaHs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ebylfjzSG35fVFUItvfOGFkk5QoKsmj28bnO6QDJ+iI8XFqFBauGYweIMGF6BrlDr2Bbt9GpByNmGHtd3ElyQB0RzjUqHT4iPRwH+JsJgqbBjZ3kF/tzpAvgRaVMVbT3ggGwYVroMmxvAZfmkzQvupgSONR8sg4pRsSAUi6TxWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ArrtLe6P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ArrtLe6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA931F00A3A;
	Sat,  5 Sep 2026 23:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651263;
	bh=ywBvGvF1QAkmenEsO5AtSwGMCsTkLfBx4RbvcxuGfcg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ArrtLe6PpOaxcyg+4/KCEC++MSxo/sRI29yTDnnZQC5E1x8aR+0TsMCmhJ8Z4IZ32
	 7meO5w1II8TkhRg64OHpcxWwjweR73aFQo4567+x6ngsAgUfgUxkgTGw2dviGxf306
	 RGc2c5vEsCAYB7sb+Ty2Lr7GE5ZA4xlIl+RMaFHs=
Date: Sat, 5 Sep 2026 16:34:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Usama Arif <usama.arif@linux.dev>, Meta kernel
 team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] memcg: group struct fields by access pattern
Message-Id: <20260905163422.4da655f452c4015cda0d4e3b@linux-foundation.org>
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  4 Sep 2026 20:05:16 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Every so often we get a memcg performance regression caused by nothing
> more than a field moving. Someone adds a field, removes one, or puts a
> few behind a config option. The layout shifts, fields with different
> access patterns land on the same cache line, and a bot reports a
> regression.
> 
> ...
>
> This series makes the layout a contract the compiler checks, the same
> way struct net_device does it. Fields are sorted into named cache line
> groups by access pattern, and memcg_struct_check() verifies at build
> time that every field sits in its group. A field added in the wrong
> place now breaks the build instead of quietly costing a few percent.

Sounds smart.

Significant repair work was needed for the struct mem_cgroup_per_node
and struct mem_cgroup alterations, due to the below pending changes.  I
think I got it all, please check.

--- linux-7.3-rc1/include/linux/memcontrol.h	2026-08-30 04:44:06.000000000 -0700
+++ 25/include/linux/memcontrol.h	2026-09-05 16:31:03.119571612 -0700
@@ -95,25 +95,12 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 
-#ifdef CONFIG_MEMCG_V1
-	/*
-	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
-	 * and update often fields to avoid false sharing. If v1 stuff is
-	 * not present, an explicit padding is needed.
-	 */
-
-	struct rb_node		tree_node;	/* RB tree node */
-	unsigned long		usage_in_excess;/* Set to the value by which */
-						/* the soft limit is exceeded*/
-	bool			on_tree;
-#else
 	CACHELINE_PADDING(_pad1_);
-#endif
 
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	long			lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -293,8 +280,6 @@ struct mem_cgroup {
 
 	struct memcg1_events_percpu __percpu *events_percpu;
 
-	unsigned long soft_limit;
-
 	/* protected by memcg_oom_lock */
 	bool oom_lock;
 	int under_oom;


