Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002BC3AB298
	for <cgroups@vger.kernel.org>; Fri, 26 Jun 2026 08:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782461609; cv=none; b=s1wk04vATEFYEB7jJB80LUIVu5sm+qe7VXKVLvfB4rLPN0CzIYVyNsR5Qd2bhlaPois4W/TLn1lp7mlVG1Uk3pErpfL/Q2jnytFz3HvLFL9TRWTBNW81XPEwaEuk9AHhqJjyC6bfoA79Wv4OFe+tF+dKLNZQ+xg1dpqpXzfYiY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782461609; c=relaxed/simple;
	bh=0Qz6/p2PFTP0Q0Wh2hhUCHMGF39ogQaEpibpiXhbe4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FIK8Iygl5d8Efx6JlE1Vpu4IcW4ju5XWpuGA3sm5vlIXMnzVsskpbITuVf9TgM68xJ+PrjzvR8kFRK3IRjd7kTcZ9W05o3BhYi/VKWIDEpRtALWbkfeiTbnudNteTFWxCrL7aM9D9IPRzb2NMS+2fe9HvWjFtn8PVj4GByfTp/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kaawmade; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kaawmade"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782461605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hVXcUv9YI3BwSeys0voxuca3R/WAQc1fgr2LF5ndO3g=;
	b=kaawmade3x1ug1rVE5qqbPvBZWAIBodU6Fjm8n8NxVmwo9ovpQ4lG4uXRUAV6z141Ye0nj
	NDtMxXO4Nj51000giv8+GJddZdxUdehXIwDB5/dAgEKN7j2dBvjRWx+3zIjCd9IHtNvxiF
	uIbvte+HGDm7T5da44HkHtn+WH7e0VU=
From: hongfu.li@linux.dev
To: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	natalie.vock@gmx.de
Cc: cgroups@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Hongfu Li <hongfu.li@linux.dev>
Subject: [PATCH] cgroup/dmem: Use size_t for try_charge() and uncharge() size
Date: Fri, 26 Jun 2026 16:12:31 +0800
Message-ID: <20260626081231.47464-1-hongfu.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hongfu Li <hongfu.li@linux.dev>

The charge APIs currently accept the allocation size as u64, but every
caller passes a size_t value derived from drm_gem_object::size.
Using u64 is unnecessary and, on 32-bit architectures, may lead to
truncation when the value is later cast to unsigned long for internal
page_counter functions.

Change the public function signatures to take size_t instead of u64.
Inside the implementation, pass the size directly to
page_counter_try_charge() and page_counter_uncharge(), which already
expect unsigned long.

Signed-off-by: Hongfu Li <hongfu.li@linux.dev>
---
 include/linux/cgroup_dmem.h | 8 ++++----
 kernel/cgroup/dmem.c        | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
index dd4869f1d736..ed7440eb9c28 100644
--- a/include/linux/cgroup_dmem.h
+++ b/include/linux/cgroup_dmem.h
@@ -17,10 +17,10 @@ struct dmem_cgroup_region;
 #if IS_ENABLED(CONFIG_CGROUP_DMEM)
 struct dmem_cgroup_region *dmem_cgroup_register_region(u64 size, const char *name_fmt, ...) __printf(2,3);
 void dmem_cgroup_unregister_region(struct dmem_cgroup_region *region);
-int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
+int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, size_t size,
 			   struct dmem_cgroup_pool_state **ret_pool,
 			   struct dmem_cgroup_pool_state **ret_limit_pool);
-void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64 size);
+void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, size_t size);
 bool dmem_cgroup_state_evict_valuable(struct dmem_cgroup_pool_state *limit_pool,
 				      struct dmem_cgroup_pool_state *test_pool,
 				      bool ignore_low, bool *ret_hit_low);
@@ -36,7 +36,7 @@ dmem_cgroup_register_region(u64 size, const char *name_fmt, ...)
 static inline void dmem_cgroup_unregister_region(struct dmem_cgroup_region *region)
 { }
 
-static inline int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
+static inline int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, size_t size,
 					 struct dmem_cgroup_pool_state **ret_pool,
 					 struct dmem_cgroup_pool_state **ret_limit_pool)
 {
@@ -48,7 +48,7 @@ static inline int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64
 	return 0;
 }
 
-static inline void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64 size)
+static inline void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, size_t size)
 { }
 
 static inline
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4753a67d0f0f..38108536d2d6 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -619,7 +619,7 @@ get_cg_pool_unlocked(struct dmemcg_state *cg, struct dmem_cgroup_region *region)
  * Must be called with the returned pool as argument,
  * and same @index and @size.
  */
-void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64 size)
+void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, size_t size)
 {
 	if (!pool)
 		return;
@@ -649,7 +649,7 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_uncharge);
  *
  * Return: 0 on success, -EAGAIN on hitting a limit, or a negative errno on failure.
  */
-int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
+int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, size_t size,
 			  struct dmem_cgroup_pool_state **ret_pool,
 			  struct dmem_cgroup_pool_state **ret_limit_pool)
 {
-- 
2.54.0

