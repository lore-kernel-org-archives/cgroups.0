Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794275631;
	b=OgJc7xgrNQYQjZbP1b38YhEGWjxxHTV6PQMrx9HMjAL6yTiNb7SCA4BgHj1qr6egyYfh
	 xL9G/wsiNSJt4ekRrzCkQYogIh3Ym/ags6etma1XqrcWbPrLn9epwSWEiK0GZalt+ENMG
	 qQMBS0CflIvAA0w4wATwVh/mAUMQge0Pufb6F2F+fqjMQD7PyIznRCTbUxDbFbBLNHq1s
	 KdqhEEdOww6SG1Sgz23LMGuVrAepPiDH2Z9aSxNPfS6yg9AndjJ9rxI7jEMEn1Ly21S1I
	 rW5psuDQPL3VDTMRHbBhIFnIqxwziSWs4RUYfiaskOpUldnMejkM/9mVaoAoqoaHTkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794275631;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1b9Gm52IiM/h9OrZZh1jFEopd/R8VOMTojmLWfiROik=;
	b=YVOxGIrOa9a5roHsfdJ2z1gqMZ+Gf95Jli76ZFmRvh8sn8KG7Sz5oY2TmE6/mt7lZRe5
	 QOJwN0XVvLqqpAxTTZ0Z51usL/z+fYYqRYCpru/YDnX68PjK7CEPA9+aKwBr4/YSKNWf6
	 1y1gxAa2k/9HXQOyJ5fw79peEyD2KRVx3k1Ss2hQLTBttMnB+58VsFa5F88/7rKSVNIQR
	 h1JyGXoMcDxcSgSkqt4Dzq66FfsFS1J1hxUbyrPM3kfpPa+ihUzVa1n+aUi36btxHrH/3
	 uwyZZgI4eWyWk5DfrJo4nR25BtZeDw029rNZgHnPq7DBvKhVVA07kY3Ply5vAzjrkMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZraHMuko;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F24606A321
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 01:53:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96F24606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZraHMuko
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ed3d8877e6so8741265ad.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 17:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275630; x=1794880430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1b9Gm52IiM/h9OrZZh1jFEopd/R8VOMTojmLWfiROik=;
        b=ZraHMukoYuWbeDf06dc2H7240y1pgD9viLx6SKbJgnThT+n6A621A8T2FaSix6a+lB
         mhgluOut7A/XahfJzxGskHJb5dgtn/9a8WuKvdcYQDM6hqCcVyL6cA2gsAte02kHHk+o
         BRRFjNrLB9oDdXnM9ew2ZIW0+I0oJaO9iBgtjFe+ceE79vjkX1Jbnz9kMxhll6Fu4Q5Z
         9miAa1zK4dG5ifeDDjAbWlN2zfYEEgUi+WaahpDpctKA/3VawbEilJo2yvN+dGxiykpH
         M+iDf+5lkE464Yjj6MrcvzRNglj49s5mB5pA9lQXh/rwvEiPYrx/33otZbmlQ1DzMI6y
         HTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275630; x=1794880430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1b9Gm52IiM/h9OrZZh1jFEopd/R8VOMTojmLWfiROik=;
        b=sglHa4pMrMpMQ/j5uOjvl8gl0Bo7T6mb+O0GWCxg0I7fNesKMKQ6qQZNtX46arMVxZ
         0fOPPlsVRoOKfXridyPiwMtExvIm9lUtSdUYTNtVOJ12l8WU2VdGBVmD26Aaj3kryvTe
         Oz2IGbibSxwNG2coo+ZJU6ucgSIX/j3ddI4F+GpyJ4onJ5ppCvd1G8BHTzVU42YN0Zzb
         7tZ1Y5AFjHKvPJtxRXTb95v2qfFPu9Wn9OdmUVafgtT3QSkxVJxM7CFNtzi8OegLcL9H
         C6xCsAYwXHEyjH3+pSXlfUdGKekSrGP/pEfI7/l5xoFef5OUQrI6iJL2Z0R3p/AFBP3e
         bYvw==
X-Forwarded-Encrypted: i=1; AL+hErFbxqS36gVTmzHE1i5aIFJw1/adD5xBv08lqAHDVrcODpo5ZfkHsRDpkJievq8NgsHCr85IAfp/@vger.kernel.org
X-Gm-Message-State: APuU4Z9+mA1zEUwLpOf/oOELRiFNqvKutptP9YAynAstxkpHiZLKCqD9
	9z00YDv+jhmnXWmL4Fs9ByyVRMPRugg/CbcVRzGa9TodaiCxjQdVRpnu
X-Gm-Gg: AYBFou2xbq+7LG2YZ2BngtkHu1+zFY1v/kTx4NOc4kWPrNeE5xdFoBuyHNunDgwhRbz
	MCu0c+5lEThU6L5f7KEHJ8B0ZlFPl36Bez/GCQuhBM63Ws3y1PB1cn4EX1HWbEEaaO+l20Xiutm
	CDpfftYNRF7KHa9wcFXuof3NV7J/J4/tJOTqv/pqGWp800yxzfJiGQ7iPLaHg/ZtqMBKnZplGVi
	H8r+7W0xic6RYrr+yk+9tBab8Zd5hlyr+McA7Rhx8afahU+bZJ1+8VXH/HTStya4+Vll9Okr5wL
	b6gV2pBn7FcZb2U2+I0DnaW6dI6w72hSIenHkE6+6vODMIqcyhQnkvzWabgW2jv4r9Lv6OFsSUb
	XCR1pL2dvYHhMCpzyBI6Id1d3OJjloLE617ELcfCpDcItyC1TkQUD2Xn0H16YasIbY2IykbX1aP
	hkybbkYLAE0WCe1VczDAKGuFRub+P4pQeSlPhgt4ovx+eP9HiYVhvE4mKD/j8IeCIVO+mzGtLNE
	YJgkn0cc1LKDLfu+Fya2IbbUXtv6B5owtlOyPhmwG0dPr+uxR/nq6o+8vyKBStZDpIZ+QT9OGS+
	dvJ+ZkHI1njEXQqM4Evmc7YSLmITBwMHFcwXh6s4ZY7nCsxsZ3J67hd8NQ+BNAshKHJB10k61cV
	R79OYy2M9yjt9087bfumJ6gQzbg==
X-Received: by 2002:a17:903:120b:b0:2e9:660a:7944 with SMTP id d9443c01a7336-2edb92c846bmr9971635ad.58.1794275629806;
        Mon, 09 Nov 2026 17:53:49 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6a3e61bsm3307325ad.11.2026.11.09.17.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:49 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 0/4] mm: read root memcg stats from global counters instead of flushing
Date: Mon,  9 Nov 2026 17:53:17 -0800
Message-ID: <20261110015321.611093-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reclaim, refault detection, the zswap shrinker, and DAMON quota goals all
flush the memcg rstat stats before reading them. When the target is the
root memcg (eg global reclaim), that flushes every cgroup in the system,
which is expensive. Most of these flushes are ratelimited today, but the
stats they read can be stale for seconds.

For the root memcg, the call sites can read global counters directly
instead of going through rstat. Global counters are always up to date
and don't need flushing. For stats that only track memory charged to a
memcg (eg LRU sizes, workingset, rotation, and reclaim writeback
counts), the root memcg's hierarchical value equals the node counter.

Patch 1 is a zswap fix for the shrinker's count for the root memcg and
can be applied independently of the rest. It doesn't have the stable
tag, since the zswap shrinker is opt-in and the fix can change writeback
behavior. With a workload running in the root cgroup, the shrinker wrote
back 0 pages before the fix and drained the whole pool after it.

Patch 2 makes lruvec_page_state() and lruvec_page_state_monotonic() read
the node counters for the root memcg by default, except for the stats
whose node counters also count memory that isn't charged to a memcg.

Patch 3 skips the flush in workingset_test_recent() when the eviction
memcg is the root memcg. Reclaim keeps its flush for now, since global
and root reclaim also read the stats of the child memcgs they scan.

Patch 4 skips the root flush for DAMON's node_memcg_used_bp and
node_memcg_free_bp quota goals, whose flush is not ratelimited.

Of the excluded stats, kernel stack, secondary page tables and
WORKINGSET_NODERECLAIM only differ from the node counters because
accounted kernel memory allocated by tasks in the root cgroup isn't
charged to the root memcg. If the root memcg's stats should include that
memory, then those could read the node counters as well. This is left
for a separate subsequent patchset though since that changes what the
root memcg reports and needs more upstream consensus.

Three root flushes remain. Reclaim also reads the stats of the child
memcgs it scans, and count_shadow_nodes() and filemap_cachestat() need
the root memcg's own (local) stats or the stats of arbitrary memcgs,
which means global counters can't be used as a substitute there. This
will be addressed in a subsequent patchset, as well as getting rid of
ratelimiting for most call sites.

On an 80-CPU machine running proactive reclaim on the root cgroup, a
root flush took 69us on average with little cgroup activity and ~0.9ms
with 128 memcgs repeatedly allocating and freeing memory (wall time,
including waiting for the rstat lock). Reading a node counter doesn't
add any cost: it took the same amount of time as reading the rstat
counter (~150ns, which includes bpftrace probe overhead).

For more context on the background of this series, please see the
discussion about memcg stats flushing in [1].

Changes since v1 [2]:
- Read the node counters for the root memcg by default in
  lruvec_page_state()/lruvec_page_state_monotonic(), with explicit
  exclusions, instead of adding lruvec_lru_page_state() helpers that
  callers opt in to (Yosry). As a result, the root memcg's memory.numa_stat
  now also reports the node counters for the non-excluded stats
- Split the workingset_test_recent() flush skip out into its own patch
  (patch 3)
- The DAMON patch (now patch 4) only skips the flush, as
  lruvec_page_state() reads the node counters for the root memcg
- Rebased onto current mm-new

[1] https://lore.kernel.org/linux-fsdevel/CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20261102225030.2743129-1-joannelkoong@gmail.com/

Joanne Koong (4):
  mm: zswap: fix shrinker count for the root memcg
  mm: memcg: read root lruvec stats from the node counters
  mm: workingset: skip the root memcg flush in workingset_test_recent()
  mm/damon/core: use node counters instead of flushing the root memcg

 mm/damon/core.c |  7 ++++++-
 mm/memcontrol.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++---
 mm/workingset.c |  5 ++++-
 mm/zswap.c      |  7 +++++--
 4 files changed, 64 insertions(+), 7 deletions(-)


base-commit: b95f8bb86713c860ce8536d22a988b949b884d5f
-- 
2.52.0

