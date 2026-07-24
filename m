Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E26618DB1A;
	Fri, 24 Jul 2026 00:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784853261; cv=none; b=UrstLPuSLiDkFLiE1Ch6ve39nbS7/oCG8mJn0HRYKg2dPfDodL9KNxkKdUkUGYICl6UHTBHp8Q7FOeQUQ9w94taBTvLwcPLpu3OWPD6v6hVqc/mxRphTLmevV09OE9qPVg/yzC3JT32t7Nad7JGbDA+lGpsnt4QW0nfeW39ertA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784853261; c=relaxed/simple;
	bh=Us/biEOAa6we3J+jY5W04D2N+aXeXQ/gHeOB9O2ec4k=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=aOLJDNgptNS0ZQx6FZJifbH2ZvPJUojuD6N2XMVKiN2s3mcA0+Gk714PtJ2KssOOIdUaMN9TkDx18we50k4rd06+EeVKUfGMsPq3Tk2Ar0eaJ8/FI9F9g+i6EJclQlwTZY5fDrdDN5Qf30zlD7GxtWOZUo4J1affKNoimpukC5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2N475bEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2N475bEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275F41F000E9;
	Fri, 24 Jul 2026 00:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784853259;
	bh=uFiuk9YnSrQ9gDttwKCFevREVVtLKrpsxcv5mAjS/Pk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2N475bEUQDEIU440uwwra2wBt6wKRKr1mV5I3Z1Jnouas8x7jlTrSOLtKBGplsCzy
	 dIpAe0zkYkdC3f3qPzGrprzpie8of66ajK00ElzN2YdHOIIO0GGvbQsNES6qIw5pr1
	 Krhmdws8yXY79Cyscu1ngMxt5hicdceFEECwGq4o=
Date: Thu, 23 Jul 2026 17:34:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Song Hu <husong@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 0/2] mm: vmscan: fix node reclaim ignoring
 swappiness parameter
Message-Id: <20260723173418.010e38f655f83850d92c2c8e@linux-foundation.org>
In-Reply-To: <20260723032434.2016749-1-ridong.chen@linux.dev>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 11:24:32 +0800 Ridong <ridong.chen@linux.dev> wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The per-node proactive reclaim interface
> (/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
> but it is silently ignored when CONFIG_MEMCG is disabled. The root cause
> is that sc_swappiness() has separate implementations for CONFIG_MEMCG and
> !CONFIG_MEMCG, and the latter never checks proactive_swappiness.
> 
> Patch 1 moves mem_cgroup_swappiness() and vm_swappiness out of the public
> include/linux/swap.h into the mm-private mm/swap.h, and makes the helper
> handle both CONFIG_MEMCG and !CONFIG_MEMCG in a single inline function.
> This is a prerequisite for unifying sc_swappiness().
> 
> Patch 2 consolidates sc_swappiness() into a single definition that works
> regardless of CONFIG_MEMCG, fixing the node reclaim swappiness bug.

Thanks, I updated mm.git to this version.

> v3 -> v4:
>  - READ_ONCE() was missed when reading memcg->swappiness, add it back.
> 
> v2 -> v3:
>  - Simplify mem_cgroup_swappiness as suggested by Johannes.  
>  - Rebase on the next-20260722

Here's how v3 plus v4 altered mm.git:


 mm/swap.h |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/mm/swap.h~b
+++ a/mm/swap.h
@@ -105,18 +105,11 @@ extern int vm_swappiness;
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_V1
-	/* Cgroup2 doesn't have per-cgroup swappiness */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return READ_ONCE(vm_swappiness);
-
-	/* root ? */
-	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return READ_ONCE(vm_swappiness);
-
-	return READ_ONCE(memcg->swappiness);
-#else
-	return READ_ONCE(vm_swappiness);
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
+	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
+		return READ_ONCE(memcg->swappiness);
 #endif
+	return READ_ONCE(vm_swappiness);
 }
 
 #ifdef CONFIG_SWAP
_

