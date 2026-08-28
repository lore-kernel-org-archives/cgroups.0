Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0294638C433
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909112; cv=none; b=aKFT8i8iUl/6jsI4yB+mCULQ2+MbOk8p0KPll9ZQMjUvrvZOX/rvNeBBSL9oZdHmUeb1sQCzi+lsR8Yhu5nsYTBG8W0xR4cNuxokIUU9LbAlV/OlE9d76WFzzJnqSy6F3HUi/flCoDzl7+jjC/w/xUR5waUZL260Ak6JSDVCepo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909112; c=relaxed/simple;
	bh=dBqn/fwXS6Yqu7+OeooRTuVzLOlPePdPqVBD4zdNuTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=txxXBUHqdhmqGA8kd6xFb/ol9U54L348rBlYr4l2RSs8KeSl3Hm5N4TvwAxK0VujWaoasA5rR5Vs+6WlbkxPGQ3Im0ohWJB4nR1snfC0kGQXEqnunafNAaeoFaySc1fzjtR+odAl+DXOmEJD3ngG2f25bY1DDJ0TTQ/yHJRnPKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S9ChDKaL; arc=none smtp.client-ip=91.218.175.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S9ChDKaL"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dBqn/fwXS6Yqu7+OeooRTuVzLOlPePdPqVBD4zdNuTA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787909107; v=1; x=1788513907;
 b=S9ChDKaLDw1RrTJFJfcqJNeTpafUMPONVvbaQW8JqDshbUn0LnQJnL6RgjNKr8Q28oSO42RH
 oIOmhPqXy1J60mbKDF+3BJIHk3ZR/AigbVTa+TlmkrewN5JVFuvc41K+K6B8C4FsVfdpUIlwNN/
 noG+AmmaXTB9yQ7GDxneWt6s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 770e0ca2d72166ed;
	Fri, 28 Aug 2026 09:25:07 +0000
X-Mizu-Trace-ID: 770e0ca2d72166ed
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
Subject: [PATCH 1/2] mm/page_counter: avoid integer overflow in effective_protection()
Date: Fri, 28 Aug 2026 17:24:31 +0800
Message-Id: <20260828092432.1257917-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260828092432.1257917-1-ridong.chen@linux.dev>
References: <20260828092432.1257917-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

effective_protection() distributes a parent's protection among its
children with two proportional calculations:

	protected * parent_effective / siblings_protected

and, for recursive protection:

	(parent_effective - siblings_protected) * (usage - protected)
		/ (parent_usage - siblings_protected)

All operands are page counts in unsigned long, and the multiplication is
done at unsigned long width before the division. On systems with >= 16TB
RAM the product can exceed 2^64 and wrap, yielding a bogus effective
protection value and silently breaking memory.min/low enforcement. This
was reported by the sashiko review tool [1].

Use mul_u64_u64_div_u64() for both expressions, which performs the
multiply in a 128-bit intermediate before dividing. The divisors are
non-zero on the paths that reach them: siblings_protected >
parent_effective in the first case and parent_usage > siblings_protected
in the second.

[1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1

Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/page_counter.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..311153b0e002 100644
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
@@ -399,9 +401,9 @@ static unsigned long effective_protection(unsigned long usage,
 	    usage > protected) {
 		unsigned long unclaimed;
 
-		unclaimed = parent_effective - siblings_protected;
-		unclaimed *= usage - protected;
-		unclaimed /= parent_usage - siblings_protected;
+		unclaimed = mul_u64_u64_div_u64(parent_effective - siblings_protected,
+						usage - protected,
+						parent_usage - siblings_protected);
 
 		ep += unclaimed;
 	}
-- 
2.34.1

