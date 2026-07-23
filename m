Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE0D21773D
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 03:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784777101; cv=none; b=i9eFr+tBsVdl/HP7kU6txWT+kmCnurDDtQ3u2vRcicJ0+bcjfNpq2AvW9GmBuPhfKyb4o3td7OVKIxB/9w9S9pp6pBHJ0iips0IDK+eiNFg8wjF7lSnqEnfg1R7FFDEcnSx8YlMELZTcEtIT3I1P8RPYqZhvq4lisf7OIeHXVvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784777101; c=relaxed/simple;
	bh=SV1+mRyfJNQrxgCoD9E7OJ/F93YLJizs0Bgq3MRrG7A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jZAgcU8xLgz+9qEBWBSKBuKFnLIc0/Cysdj/4TXwTa/ushL6eMjaLE+ErLCN5TMkcO/0xOW09g7CwgtohZhvp4mQVdqDNV71jPNiCqP1I/niVt1NACJDEtkhmpqyEG1M72apresGmZEc51jElwkxVqah+g2bPgpMmNk3EBx20jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GvZkGeK1; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GvZkGeK1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784777096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rZhMI+Xfi/MnQ7cYAB16qZh1E4VoFljWZHADbHhtJCg=;
	b=GvZkGeK1NssUvw2Hd/UC0LKe7Tvt5EcyWhdqxxdxGdvIgpyYh6L0pSkLMfJCwftRKMSonH
	MU5GoMUoBdq8aM5+8y4Qd00TVsA+kJfR1J2nUU4fz4UlmRg1JciiUh3yK8mkSM2LD9AFjr
	9uRHyDYFLi70knt4TRJdhsg6QG71WoY=
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
Subject: [PATCH -v4 0/2] mm: vmscan: fix node reclaim ignoring swappiness parameter
Date: Thu, 23 Jul 2026 11:24:32 +0800
Message-Id: <20260723032434.2016749-1-ridong.chen@linux.dev>
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

v3 -> v4:
 - READ_ONCE() was missed when reading memcg->swappiness, add it back.

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

