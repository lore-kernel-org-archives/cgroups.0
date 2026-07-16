Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C752D8DDF
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 03:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784171885; cv=none; b=eLmYOswnEht0nma1JHLALC7CfoURQ2/9iqQP0cda5O96l//qTyzH68D1Ult6Lf2zcJ337kquh7C21mQFjg9OKUAUvOGCW1fjqebSoe4ToEGZn///FFw/QVHiOmFhjPHWYV6j1639aPZSo9mb8BR4Uk2thZC3BO+51VyuDvPuP0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784171885; c=relaxed/simple;
	bh=jNsYLCXIhhJHFfM7B5l2mf7E/wIuuVKRv6Mj06V5zdY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z/iZ8FY7nRr90wwlbE7FR5L8jsja2t6ODMMlcftVTfSTCdd+JSTfoYvWwyVdpD+TKTFwAd6bnbzdcEAvHqnqDB26oLifXjmubfMpFIleZAvPm1/t/P+6n9NyovCN7EAGaTqumoyqpqJ8NYE4Ke+cXUnxOG6OFmONwxMmpi1P2KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jvzy5ecU; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jvzy5ecU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784171882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C9uTjr+QHcjA0BGg5K3KptTToPaHw9+EB+dy4ID1gXs=;
	b=Jvzy5ecUdLoLt3ejPYRfKtMmP00eTeTy6jyspFaBAGcX6bY0p3xhysVQOfDqq/xGCPnKnM
	8iDmZ7M7OeOU0kiLlSRpH5qz12RLOadT/H+YugzcE+9MsaeClWWHNlz+Tg+aGHHmz+kWJ3
	wyr3bFNnVIIOBYpUGQBmxcm4q4KnScw=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong <chenridong@xiaomi.com>
Subject: [PATCH v2 0/2] mm: fix node reclaim swappiness handling
Date: Thu, 16 Jul 2026 11:17:27 +0800
Message-Id: <20260716031729.1064007-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Ridong <chenridong@xiaomi.com>

The per-node proactive reclaim interface
(/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
but it is silently ignored when CONFIG_MEMCG is disabled. The root cause
is that sc_swappiness() has separate implementations for CONFIG_MEMCG and
!CONFIG_MEMCG, and the latter never checks proactive_swappiness.

Patch 1 moves mem_cgroup_swappiness() and vm_swappiness out of the public
include/linux/swap.h into the mm-private mm/swap.h, and makes the helper
handle both CONFIG_MEMCG and !CONFIG_MEMCG in a single inline function.
This is a prerequisite for unifying sc_swappiness().

Patch 2 consolidates sc_swappiness() into a single definition that works
regardless of CONFIG_MEMCG, fixing the node reclaim swappiness bug.

---

v1 -> v2:
 - Move mem_cgroup_swappiness() and vm_swappiness to mm/swap.h instead of
   include/linux/memcontrol.h. Suggested by Barry Song.
 - Correct fix tag for patch 2.

v1: https://lore.kernel.org/all/20260711091157.306070-1-ridong.chen@linux.dev/

Ridong Chen (2):
  memcg: move mem_cgroup_swappiness and vm_swappiness to mm/swap.h
  mm: vmscan: fix node reclaim ignoring swappiness parameter

 include/linux/memcontrol.h |  4 ++--
 include/linux/swap.h       | 19 -------------------
 mm/memcontrol.c            |  4 ++--
 mm/swap.h                  | 20 ++++++++++++++++++++
 mm/vmscan.c                | 19 +++++++------------
 5 files changed, 31 insertions(+), 35 deletions(-)

-- 
2.34.1

