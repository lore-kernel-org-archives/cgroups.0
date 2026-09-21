Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0C5492502
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 11:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789991214; cv=none; b=gijZtUs4fbvanxXpCtAa58H0+77GIXa7sAEwaJHsaZxQhadUalXyhIuOzphVGtxluGfr6ePsXDenF8tf2eiHwF81+OHGr8CwZ+vXrR9LDRGNaFHulNwIyuU3Ex/2Opy38BcBFhrd0pb9+o7hpkfsvuKni6y/BE2CKtLw6cHP7s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789991214; c=relaxed/simple;
	bh=MtpBUFbzYu1oiksXdT+2b1TI1k9PS5Y6zJeNKYblZfY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lYDVi6ejKIiIm86eZ6kbHBg6fNVcSAX3lpl+xYjVmqSHzRwepcDlDtzxRA75LH9aoavuV66cEpKqbGBZfsPErsujD5e2zh9BERdrQwwh/EAPpZLYiLvW9exwwTC+RkthMnfnBOi/KDsYyx5UH5amD9gGtRpl4mhc9rQuTNcQ9s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CgvFSGfc; arc=none smtp.client-ip=91.218.175.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CgvFSGfc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MtpBUFbzYu1oiksXdT+2b1TI1k9PS5Y6zJeNKYblZfY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789991206; v=1; x=1790596006;
 b=CgvFSGfc0f5mkgkhlKI3hvsEzJAbnIiw+COZbsZQYEmR1ZlbwrsbLB/EC7g/1KwaQzZzeudY
 YsWajDQ5z5xzq/2GEajOC0IQUYKIfd8F6bmOr3882exYnOjWWh9QKfhjZ21vao/wBYYhH89xT42
 B5osjB2vIMC/fBOyOZh+LL6Q=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a9ffc5cf04c1e7d3;
	Mon, 21 Sep 2026 11:46:46 +0000
X-Mizu-Trace-ID: a9ffc5cf04c1e7d3
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC 2/4] mm/vmscan: move vmscan tracepoints to a local header
Date: Mon, 21 Sep 2026 19:46:04 +0800
Message-Id: <20260921114606.3871820-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921114606.3871820-1-ridong.chen@linux.dev>
References: <20260921114606.3871820-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
tracepoints can be extended to reference vmscan-internal structures such
as struct scan_control, which is not visible outside mm/.  This mirrors
what several other subsystems already do with their trace headers (e.g.
fs/ext2, kernel/trace/trace_benchmark).

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS                                        | 2 ++
 mm/shrinker.c                                      | 2 +-
 include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
 mm/vmscan.c                                        | 2 +-
 4 files changed, 8 insertions(+), 2 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index e26b963d4001..c1dbb35273c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17227,6 +17227,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17374,6 +17375,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7ec2a9704f6f..3c3e87c4b61c 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -3,7 +3,7 @@
 #include <linux/rwsem.h>
 #include <linux/shrinker.h>
 #include <linux/rculist.h>
-#include <trace/events/vmscan.h>
+#include "trace_vmscan.h"
 
 #include "internal.h"
 
diff --git a/include/trace/events/vmscan.h b/mm/trace_vmscan.h
similarity index 99%
rename from include/trace/events/vmscan.h
rename to mm/trace_vmscan.h
index 8a872990b4be..c5d824fef554 100644
--- a/include/trace/events/vmscan.h
+++ b/mm/trace_vmscan.h
@@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
+#undef TRACE_INCLUDE_FILE
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../mm
+#define TRACE_INCLUDE_FILE trace_vmscan
 #include <trace/define_trace.h>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 91295070ca33..0eb7fa8e1d43 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -71,7 +71,7 @@
 #include "swap.h"
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/vmscan.h>
+#include "trace_vmscan.h"
 
 struct scan_control {
 	/* How many pages shrink_list() should reclaim */
-- 
2.34.1

