Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E233A38F223
	for <cgroups@vger.kernel.org>; Thu,  5 Feb 2026 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770282212; cv=none; b=pacZZri++CIksWXkfjWW3F4zV08s6wju+VKtYRJo0I8GgRl/10OQCPwPtE+5/QcASFIR+hSMtFvSdpUIzL20WxSnobUwI5zcBFoNPU1fTAVHz+0pGsEyiknhJEqXkp2uw2wlSPP7L2iCSD8vTAFxLWMuvM34nvQSUV6aFiY3JOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770282212; c=relaxed/simple;
	bh=5HYhcnLDSGLF0Qa5k5rbzP/ii3CIRLogODz/+dFoTXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3UVLm6bWzB169Epwoy8oQMLSm7wDw4lNNkv6gkCeBvu+RVf0+0qVXuwD+87ROUgCW2FRtz7KdB0iBrFgiLDsNRMVqK2tx68uvm4KAjLD0vtMwYs4LdYJIHAmZKBoj07hkgsUxkhlf9if/V3OLDrWWwjcuB6nu6O2xWrO8Y2rpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XBGsBzEd; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XBGsBzEd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6/MGG1ZszDY15CWQQf1XHvW0YBRAfzPGexebmplBHBQ=;
	b=XBGsBzEd0UfEMySGvkKeEgj5gLXMK/+CJicc1EAfkZTyTD26W3lWjmlmr0JiCkfHf5Kjfb
	Ge9XSgIpxU5afrmc7eYxSNHA2l52P7U97Mxx5x+MOokU8LRX/hkbEQ086mpUzPqlCL8KFu
	HZrNiX90GF4i1ljcO3ZdjZ3skawPJvA=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 17/31] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
Date: Thu,  5 Feb 2026 17:01:36 +0800
Message-ID: <c6672bc05f6876ead7f2f1cb5c5cfd7ba918a72b.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Qi Zheng <zhengqi.arch@bytedance.com>

In the near future, a folio will no longer pin its corresponding memory
cgroup. To ensure safety, it will only be appropriate to hold the rcu read
lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in folio_split_queue_lock{_irqsave}().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 mm/huge_memory.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 580376323124c..3f6675240f9dc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1154,13 +1154,29 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
 
 static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 {
-	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	/*
+	 * The memcg destruction path is acquiring the split queue lock for
+	 * reparenting. Once you have it locked, it's safe to drop the rcu lock.
+	 */
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static struct deferred_split *
 folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
 {
-	return split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static inline void split_queue_unlock(struct deferred_split *queue)
-- 
2.20.1

