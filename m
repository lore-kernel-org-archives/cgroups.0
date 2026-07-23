Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21E9347521
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 02:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784775574; cv=none; b=HloUXs5a4XSo8rKRKmneYEY2IZLw6jlC+SN/JevgZanxiaOPBf/1bUVVOfkLM0+KErhbr/Gt6yWgckGEPB92R4g1tOfW6auBzWUGqbz2OgcsxmWZDvTprRK2KyDCGlHsPR/F3kSu9tD/Pl26VtletCoqFdTsgNb0vU+VDyl2VOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784775574; c=relaxed/simple;
	bh=ZIglIw1XuGPV0FB+8lncHWoPzzxwkqMpBGwV16CW4WA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FybQzyGxUx8r/WEkeWD4XvIsq2MHWly9hf6W5/dtDhc88pAbl/tXUs2C7ig3FukT9l3vbjzefEYMn3qMVv8pDS1xszMoM15cz0ZHaXlZIB7JmUf38I5PeP407EcDLI5e2YOFwQmzyPvHNgWImpuTIHt0UTCj+O914dT/vivfQ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IvT+tuwv; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IvT+tuwv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784775560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lxnP6SUwergpNTfnZVhMNth7W47feWOp/n3K9KDqgX0=;
	b=IvT+tuwvJNHdUbyD7+s3z1Z3+78G2kQUozmyyg3XdVZuRdm5rEjCKXQvTBYChs6T2lhGPV
	vV15mlwODOefNbdR27GrCSMo9gfaX32qzMfzomG8HuHRbLgVyg1W5aFY2vsIz8ab+WOkzM
	KZX4PToNn2LIZnvBxSNMoT+WGBQspKk=
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
	Song Hu <husong@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH -v3 0/2] mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Thu, 23 Jul 2026 10:58:56 +0800
Message-Id: <20260723025858.1956584-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Ridong Chen <chenridong@xiaomi.com>

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

v2 -> v3:
 - Simplify mem_cgroup_swappiness as suggested by Johannes.  
 - Rebase on the next-20260722

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
 mm/swap.h                  | 13 +++++++++++++
 mm/vmscan.c                | 19 +++++++------------
 5 files changed, 24 insertions(+), 35 deletions(-)

-- 
2.34.1

