Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F7D25B098
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 03:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792382002; cv=none; b=JXwq8zxl1/KgQKW5vdnqaBqi/8yO4D0AeElfMpwoaZEC8c0w+DHPFWl5HIlJdiDD4yYPnOz9MR4ajgFkI8PIZ9E9tOgEDPzEq5ArBhGI2dz1+RGl5bUDuO/Vg2sdTUWJUsSiDyBo5D2P36gI79/1sZLjRE6fcMX45NI5ejh8BIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792382002; c=relaxed/simple;
	bh=e8l9i2dqh+WprW025KXQLD9b8ygmrBV8jxkpiu2Ku/4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=quQzsZV5E1u9KfWTrRueEV9xbqpG3bQUetTLwUlKVv9/ff0UTVekg1YnX4JGfHEaWLStFzibdokoaaX3JFl4S/rj22HyEUdJPDS6dGUUhFOgF8HBt91BaCyfstWLCJ6aQKYBgMNglCjah6L7BhnxE9Lta7mEPgSJXvoUbI3oC+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OG2ez1ld; arc=none smtp.client-ip=91.218.175.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OG2ez1ld"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=e8l9i2dqh+WprW025KXQLD9b8ygmrBV8jxkpiu2Ku/4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792381998; v=1; x=1792986798;
 b=OG2ez1ldewROnPxlfncxt8/TOHN9tEzKiN7uD3cx2faiyR8TLC5/jEhreOpzuw92GiQuOznl
 jLdtv+j9PO2ziA+EVI8I50NDIfHtDToBcH8lHP8WChiLQ6+Ygz2gMqm2kQcHitCBP2FY5KHKoqK
 szZl+ggBaDC5GXyMAIbdR+bE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c32a42bc20d1c051;
	Mon, 19 Oct 2026 03:53:18 +0000
X-Mizu-Trace-ID: c32a42bc20d1c051
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 2/9] mm/vmscan: move vmscan tracepoints to a local header
Date: Mon, 19 Oct 2026 11:52:45 +0800
Message-Id: <20261019035252.2357900-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019034426.2354049-1-ridong.chen@linux.dev>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
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
fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
vmscan.o, the only user that defines CREATE_TRACE_POINTS.

No functional change.

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS                                        | 2 ++
 mm/Makefile                                        | 1 +
 mm/shrinker.c                                      | 2 +-
 include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
 mm/vmscan.c                                        | 2 +-
 5 files changed, 9 insertions(+), 2 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f1f35a017a6..c41af07e870e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17231,6 +17231,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17380,6 +17381,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
diff --git a/mm/Makefile b/mm/Makefile
index 2a3ec53d62ee..277b97f7f8d7 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -32,6 +32,7 @@ KCOV_INSTRUMENT_vmstat.o := n
 KCOV_INSTRUMENT_failslab.o := n
 
 CFLAGS_init-mm.o += -Wno-override-init
+CFLAGS_vmscan.o += -I$(src)
 
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
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
index 8a872990b4be..ad90f0e9bf2e 100644
--- a/include/trace/events/vmscan.h
+++ b/mm/trace_vmscan.h
@@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
+#undef TRACE_INCLUDE_FILE
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_vmscan
 #include <trace/define_trace.h>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e82ba737c028..a3538484f8da 100644
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

