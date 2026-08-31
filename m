Received: from mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCBA3E073E
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 09:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788169609; cv=none; b=N2kzc30I2j/lNMvYvpunsGtkBlQuHj2KVQMN6q/XUujIwoRZKPo8QZkcJ1Seoirc0HMwqchFPEGZiNSggpepD6RVlwAlS7BHgBz7BGzB+SXVA4B3Itu4BsNDjycUCu5NJDmobFxbACf+1VdXdGpFoiT1yrnDSR2FfLzWnjnKPNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788169609; c=relaxed/simple;
	bh=6jhXtJO17DBB7qI18ikslI33Zv8zYlXSXdj+9tIORRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2wh5mSNpLfj9pWsUHYvzC0LJEpfXCcHlKHN/uJkhFm5E54nd+bZLloebDyHVpnzbqEehIrecMZ0iyp7bze5ap4zSVgbVNqv9vWQ5+4H5YoZ5keN6gKuosAaI/FXC6A/OYSLm+5P3f49Rwt6WNtwtRqLxpopuPDxkHpgW2TmLAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R9okeS85; arc=none smtp.client-ip=95.215.58.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R9okeS85"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6jhXtJO17DBB7qI18ikslI33Zv8zYlXSXdj+9tIORRU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788169606; v=1; x=1788774406;
 b=R9okeS85NqmAhuuAI7UUSUA+gI3T5d+ERJZYJiOBuYL1RLp2wbwHaDrtH9fIzOcPPCJEwwUC
 Bq3X5qSfk2XzEJTjavH521qet+xaV7O9xvZirr1R7J/vof1BjLxK1T2bH8n5vD3/qhR/d7n1/jm
 6ogAeuxtWZVh6jibxEKal1WQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8bffe5621f7da27d;
	Mon, 31 Aug 2026 09:46:45 +0000
X-Mizu-Trace-ID: 8bffe5621f7da27d
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2 3/3] mm: memcg: skip the RCU lock when the memcg is not dying
Date: Mon, 31 Aug 2026 17:46:11 +0800
Message-ID: <3fc10f32131097bb57efaec72d049d635b227cf1.1788169145.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788169145.git.zhuhui@kylinos.cn>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hui Zhu <zhuhui@kylinos.cn>

get_non_dying_memcg_start() takes rcu_read_lock() on every stat update, but
the lock only protects the upward walk to a non-dying ancestor, which
happens solely while a memcg is being offlined.  The dying check itself
reads the CSS_DYING flag of a memcg the caller already holds a reference
to, so it is safe without the lock.

Check memcg_is_dying() first and return immediately when the memcg is
alive, taking the RCU lock only on the rare dying path.  On an anon
fault/charge churn workload in a memcg this recovers the ~0.6% overhead
added by the previous patch (4368077 vs 4343159 pages/s before, back to
~4377000 pages/s after).

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b3d1ac3fe0aa..f454d02746e9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -813,6 +813,17 @@ static long memcg_state_val_in_pages(int idx, long val)
 static inline struct mem_cgroup *
 get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
+	/*
+	 * Fast path: the caller holds a reference to @memcg, so reading
+	 * its CSS_DYING flag without the RCU lock is safe.  The RCU lock
+	 * is only needed to walk up to a non-dying ancestor, which
+	 * happens only while a memcg is actually being offlined.
+	 */
+	if (!memcg_is_dying(memcg)) {
+		*rcu_locked = false;
+		return memcg;
+	}
+
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -824,6 +835,9 @@ get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
+	if (!rcu_locked)
+		return;
+
 	rcu_read_unlock();
 }
 
-- 
2.53.0

