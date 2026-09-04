Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E34A447813
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 09:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515199; cv=none; b=DK0ATor6yFCKLc2NRNkHE+R8TUHx5M00Xoo2fe9tbHDpf/CZBbJoabDNn6IOcRD+u9EyRbfZnWhfLH9Q15+dpSKLteDeADzHKStFVSt6+bmdqDPDhBZIxj6NnwkjEJhWEnXJZyuHmySltugssZeKBiGckVxG558j5UBgSbGlAYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515199; c=relaxed/simple;
	bh=/egS0JLq3DdP+ELRV2+UfNnFQyripc/bTgQpMQb2RyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDrTvdQDaUGevJVXbFFsTc+GtVscoPU6CqaFtRB+ivBCUDYJwMXhexDRCgGy4AtyUdjWEeQCvZMRVnWLtub0llE98P+e8j46tTbos7BepfcdQH7vjIdPud5FpjfuVKTjusS7hGdwQPm5JWyDf7+CngfUdlRaM/Y6WajFksR/IkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qW3oOuJB; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qW3oOuJB"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/egS0JLq3DdP+ELRV2+UfNnFQyripc/bTgQpMQb2RyA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788515195; v=1; x=1789119995;
 b=qW3oOuJBe29Tupcqm9ATJ9aRgS3psFQXuPso1euycC7858JUW3MBvmxVRvaPD+zzUfcrM3rb
 00VakCJQPwc+h8kR+79Z/WbkPVEFCi1Epwmau5Nz+ojPkq6GlC//NVhlb3sFC2nLYH79tCgIsA2
 H6mQkg8uB6wDBdNuWqEMvqSk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8f911b791d4dc657;
	Fri, 04 Sep 2026 09:46:34 +0000
X-Mizu-Trace-ID: 8f911b791d4dc657
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
Subject: [PATCH v3 3/3] mm: memcg: skip the RCU lock when the memcg is not dying
Date: Fri,  4 Sep 2026 17:45:56 +0800
Message-ID: <0db657472c5278b2e2b87fbca7590b47ca520303.1788514750.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788514750.git.zhuhui@kylinos.cn>
References: <cover.1788514750.git.zhuhui@kylinos.cn>
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
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

