Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CF4386C17
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 20:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786480333; cv=none; b=JRDPEtRpy8f9I3E5X9iT7FB+BQG1XlgUXvOt0BhjY/z4TyIy1VZIeRySBj0iD2z0jZYxMdzkdRLufwjzlnrwzOmK9YnJdnJs0+0p70Jdu1NZbmUEhlktaY274Li90C21YTjIXFUwwaFObeLlnz700SIMuuOY/CB3A+jIu6452vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786480333; c=relaxed/simple;
	bh=LiMjHu8S5y84qZpPrr85lyxtwL80BP01tgz6LXv7I/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=scmRGFFHqLPF6XlAZkyodWPNCXPVKO8YP+66M22Vg9SMXO2SdBoTCg3z/QsipW5NvgpGWaoN0ZaOxPxIId6Zuh3GtcPJ/NtDdhNu1Jaq6+9x3AXnz5A+g8ghzCsgScLDxC8J/AqUG88l0WBP5rNTmDjWdC1TQl8KlK23RDvfcV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hJdyV2V/; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hJdyV2V/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FWnFGqElf/csDRiK6I4mDw+7j8seyhKcgH4/RRRu6wE=;
	b=hJdyV2V/fCVmAUZkkxcgdZ1M6VBcojoHPorKmJhnTGyg572foFi7egfRFEgklvDIFq/r5k
	HX0CSnj+WRNAdrxajrE5wArWkQZQxJA0rof40HMXtJjju9POr9BYE9Afk2W2TXqz8PdwV/
	C4ZXoEzUeHvjZg/XRvK2HN5LqhvNaLE=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Date: Tue, 11 Aug 2026 13:31:54 -0700
Message-ID: <20260811203203.3456029-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
reclaim is the only thing that runs shrink_lruvec() from kswapd with a
target memcg set, and thus the only way kswapd can reach
lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
reclaim. Do not reuse for anything else." comment and a priority hack,
and it simply never got taught about MGLRU.

Rather than teach it, let's delete it. The v1 soft limit was deprecated
in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
soft limit"). Nobody has reported depending on it in the ~21 months
since, and v2 has covered the same ground for a long time with
memory.low and memory.min.

Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]

Shakeel Butt (9):
  memcg: make the v1 soft limit knob inert
  memcg: remove v1 soft limit reclaim
  memcg: remove mem_cgroup_shrink_node()
  memcg: remove the soft limit reclaim tracepoints
  memcg: remove the soft limit rbtree
  memcg: remove lru_gen_soft_reclaim()
  memcg: remove the per-node soft limit tree fields
  memcg: remove mem_cgroup->soft_limit
  memcg: simplify v1 event ratelimiting

 .../admin-guide/cgroup-v1/memory.rst          |  49 +-
 include/linux/memcontrol.h                    |  27 --
 include/linux/mmzone.h                        |  30 +-
 include/trace/events/vmscan.h                 |  14 -
 mm/internal.h                                 |   4 -
 mm/memcontrol-v1.c                            | 435 ++----------------
 mm/memcontrol-v1.h                            |  12 +-
 mm/memcontrol.c                               |   7 +-
 mm/vmscan.c                                   |  96 +---
 9 files changed, 66 insertions(+), 608 deletions(-)

-- 
2.53.0-Meta

