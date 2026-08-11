Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED38402BAA
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 20:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786480356; cv=none; b=HD/rMS8dXpQ2FEpGygofeqmV/BYsEvpjKK0ppRyPeLxaGrZi8H5jNj3OrNaXfUjQY51SXA9t7lzpotS/DC7/VxkQPOmYCVZduCOpQ3pWvDgl9U8Q0gHH+T6RkkwMej0IGBD765B2d/gD4z7SfPdkwDDJRsWLmhlfDdT2AzJCb+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786480356; c=relaxed/simple;
	bh=U9K7f0QJFSHjM3kZX+nRyD7KRwwpOhhPRYAfnJjDSoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKzeLB89hv4jL7DHnodRzmO3O4eOTcsJgG4jX/nPvGGk8HjB1+rshfjbI4NfDai26/YcsaTdVIuItA/iWH7QJ6AHkJ67i9xiIh/CAHdWNgDO2nnQydfIVHModUM7jcS9aN1AmV0cy9U165AytfiI9VTLVo8MGd4D42DrMeFl598=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q4KemcBI; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q4KemcBI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kMaHE95s1N2ro/hCTjeuWjiZbKrQjnsN0zD3VNnyWTQ=;
	b=q4KemcBI3JXk3fWT/q8wUMtoNfqZJlPmQG1Me6eNlskfW+iCFIzGJNVvpEBAagPzCazkqR
	7ouS09BROAyYGe5iZK9V1kMaN3WFVRXDwVzGHJdmOnVN3t8huWXWZkz6iU6N6bskDEjHJb
	rATBlfgk6qxpHPSnQq6bmoh3y+Lo5WQ=
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
Subject: [PATCH 4/9] memcg: remove the soft limit reclaim tracepoints
Date: Tue, 11 Aug 2026 13:31:58 -0700
Message-ID: <20260811203203.3456029-5-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

mm_vmscan_memcg_softlimit_reclaim_begin and
mm_vmscan_memcg_softlimit_reclaim_end were only emitted by
mem_cgroup_shrink_node(), which is gone, so they can never fire again.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/trace/events/vmscan.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index b4bf7b8def1f..8a872990b4be 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -214,13 +214,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_be
 
 	TP_ARGS(gfp_flags, order, memcg)
 );
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
-
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
-
-	TP_ARGS(gfp_flags, order, memcg)
-);
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
@@ -260,13 +253,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
 	TP_ARGS(nr_reclaimed, memcg)
 );
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
-
-	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
-
-	TP_ARGS(nr_reclaimed, memcg)
-);
 #endif /* CONFIG_MEMCG */
 
 TRACE_EVENT(mm_shrink_slab_start,
-- 
2.53.0-Meta

