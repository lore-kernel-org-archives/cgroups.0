Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BD537FF42
	for <cgroups@vger.kernel.org>; Sat, 11 Jul 2026 09:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783761135; cv=none; b=St6tNBE6YqgC9F2Sb29eeqfjFwJQzS6p8ghXdLBTENfg+NRLfM1607Yxc9ZqG5twyNnLmX2gegUGH6op62fWAygRBBmkZVkHUH/sTwRl6FfcxFzKx9v8LqMr9XsM0Otvi/i1j5mWNo8zuM2g1hMY6sw3OGG9I/pTg/Qfhl8DrME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783761135; c=relaxed/simple;
	bh=4UpULPU5AwjYzbo+czoPlYDksnUC87jPPJYqWwfzsVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EjjB/j4lwsT9CMHD3m8F/qPLmvgsvjM655jW7tZSlHo4oD8PAhdT9KWE0floyndGATaDrWJtNYrRBVcBE3aOW4F20XseCMt6Miqb/xmFkHAAp8/FFVsYslV8QOTqW1QIKhQPj5G/a8Q+bcqhyX6xMQpQiBZ6N0+Nj7CyxgluKNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gwX1St9y; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gwX1St9y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783761129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V0U6wuv8Iso5WD0+W0vrvXxkpcyPWjDPaBsrbVb3xvE=;
	b=gwX1St9yWookbKnJlLCfLdPMVyJcTPtp3PL/LemJy8e8plxTihXSlOHVQ4hpbGJKZNwNhA
	90GBmQcxmCfOkixN6YPRgwdIfiRWOdXfIqw5qjPPk1r6MBKih3LJk2SKZV9gMxnh2NGKoA
	s+MM0hUy2/hW2BhTobpo+Yi1eN6sAzw=
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 0/2] mm: fix node reclaim swappiness handling
Date: Sat, 11 Jul 2026 17:11:55 +0800
Message-ID: <20260711091157.306070-1-ridong.chen@linux.dev>
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
but it was silently ignored when CONFIG_MEMCG is disabled. The root cause
is that sc_swappiness() had separate implementations for CONFIG_MEMCG and
!CONFIG_MEMCG, and the latter never checked proactive_swappiness.

Patch 1 moves mem_cgroup_swappiness() from swap.h to memcontrol.h and
makes it handle both CONFIG_MEMCG and !CONFIG_MEMCG cases in a single
inline function. This is a prerequisite for unifying sc_swappiness().

Patch 2 consolidates sc_swappiness() into a single definition that
works regardless of CONFIG_MEMCG, fixing the node reclaim swappiness
bug.

Ridong Chen (2):
  memcg: move mem_cgroup_swappiness to memcontrol.h
  mm: vmscan: fix node reclaim ignoring swappiness parameter

 include/linux/memcontrol.h | 25 +++++++++++++++++++++++--
 include/linux/swap.h       | 19 -------------------
 mm/memcontrol.c            |  3 +--
 mm/vmscan.c                | 17 +++++++----------
 4 files changed, 31 insertions(+), 33 deletions(-)

-- 
2.43.0

