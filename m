Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B68E23D283
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 02:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749725; cv=none; b=a4l+hyIC51La/MnDlG4xRBW6CcbJt3JqT/dJAChpG26odkgY3OhSa56oMtxrbyvUyUNnOzLtkdnZqZZ/6M6pJ4JFwPWteb6Ke1BFabTkZPz/BgSOgsIVcYAc/RPqFoueY9K1yAoYPOxoD8s8WxsnH7pBRy8MNS3K5c85vfKu4fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749725; c=relaxed/simple;
	bh=MCtc53OvC78dPVDjleIyZtuN4ZTyv8ZI6/y02lp/l+A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A1KxJPtT3/sYq1vmtGKeGnRhs2W5uFp9DdytgOSJdZZ1n+in5UDq603iva+d6YuYaU1FZmry1xi8Qb6CQwIprHjIhjibSUajWIJErrRNEgrhtviiHPLvVrw9yvepUhcZT69IhuOCEuKK7U3smGkelraeb150Fw1uE4QJirXyqfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uZZiQlT+; arc=none smtp.client-ip=95.215.58.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uZZiQlT+"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MCtc53OvC78dPVDjleIyZtuN4ZTyv8ZI6/y02lp/l+A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788749722; v=1; x=1789354522;
 b=uZZiQlT+PEkOYqWyEgxkbAAO/FhvqxqZ9kFMc8T0hqET5nCFArsI8gB8mnijRKcz3HbQIVPe
 mRRyFUZnI6N3R6IGcjfjOC2Zl0vNyVD3SnjbgGkRLFAugmNJp/6SWbQmR7/49IxIPX9WrqyxxIE
 JFyU4T5qBohGutVP6IV2hx6w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cb267324da5e0b08;
	Mon, 07 Sep 2026 02:55:08 +0000
X-Mizu-Trace-ID: cb267324da5e0b08
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/2] mm/page_counter: avoid integer overflow in effective_protection()
Date: Mon,  7 Sep 2026 10:54:44 +0800
Message-Id: <20260907025445.1836238-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907025445.1836238-1-ridong.chen@linux.dev>
References: <20260907025445.1836238-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

effective_protection() scales a parent's protection by a ratio of page
counts, e.g. for recursive protection:

	(parent_effective - siblings_protected) * (usage - protected)
		/ (parent_usage - siblings_protected)

The multiply is done at unsigned long width before dividing. On systems
with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
protection value and silently breaking memory.min/low enforcement.

Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
usage and parent_usage are not read atomically (a child is charged
before its parent), usage - protected can briefly exceed the divisor,
making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
the ratio stays <= 1.

Reported by the sashiko review tool [1].

[1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1

Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/page_counter.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127a..ea0d1646cff85 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -8,6 +8,7 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
@@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
 	 * otherwise get a smaller chunk than what they claimed.
 	 */
 	if (siblings_protected > parent_effective)
-		return protected * parent_effective / siblings_protected;
+		return mul_u64_u64_div_u64(protected, parent_effective,
+					   siblings_protected);
 
 	/*
 	 * Ok, utilized protection of all children is within what the
@@ -397,13 +399,20 @@ static unsigned long effective_protection(unsigned long usage,
 	if (parent_effective > siblings_protected &&
 	    parent_usage > siblings_protected &&
 	    usage > protected) {
-		unsigned long unclaimed;
+		unsigned long parent_unclaimed, parent_unprotected, unprotected;
 
-		unclaimed = parent_effective - siblings_protected;
-		unclaimed *= usage - protected;
-		unclaimed /= parent_usage - siblings_protected;
+		parent_unclaimed = parent_effective - siblings_protected;
+		parent_unprotected = parent_usage - siblings_protected;
 
-		ep += unclaimed;
+		/*
+		 * The usages aren't read atomically, so a child can transiently
+		 * appear to use more than its parent, making the ratio exceed 1
+		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
+		 */
+		unprotected = min(usage - protected, parent_unprotected);
+
+		ep += mul_u64_u64_div_u64(parent_unclaimed, unprotected,
+					  parent_unprotected);
 	}
 
 	return ep;
-- 
2.34.1

