Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.134
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793437282;
	b=OIneq2JwHu6TbPSy4BFO2m8ndvfh4yZAUxyycAtq6X/Om+VZ/xyLMwR0QS9eQfWWzkee
	 Ufq6AMCfZTpQFV9Y1qqbzkSEiQKjmVfwvPx2V/oEQ+XcqLy3pWe9jBvkSdEk1cQivsJjN
	 Os71tSmg3c390e2b9W4S1TxPR5ej2COKIPAVubE/Wq5Lu0woP/zmBwCdupKzT4CeTr7d9
	 k7HQ2jOznopCQ1Le39F4wme9z8w5NY8IgA2Ydv1JapnMjurLLYb+vIuwTHvmfTviYkQOH
	 9De8nmTx2uMaSDiOHpwYZTvc/6XGcNlugMngKelohMKJg2a4jNjzseqj68mgFWpj71w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793437282;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8EAs3QvFvaSFhq2cyIL1T9bjNJc6WlnZgmI91srTaNI=;
	b=ZTmP+TC7IR021RDeMfsuBIWg4YA7F6kTo+03x8TlIcoV5VZ3IEQaqO1f3Uq9Vtzhs3Qb
	 GqPT1Vmlj/CwwTEaOBM3sMhaxAi+q+JgTv6UvGOaDlfPjGgIswwjZbC+M8C/2oeoCNiD7
	 rsXXI5Z6twDCVL0UDYjf6H5lycEnY1pGQITp8WnfPTzry5qn6tTObfAWraj3IRsVdn55E
	 FBI+aOc8co4cnQTT6Vt9Gc1OJiH/M1oeZCxVOrsnhny/xbCs+0CFzMd3fj43Fe65DqQBX
	 KNf8KsNf1eR4L9vkapPcPZsfjSse3Q5ShBt9N2H04pqk7rq3DuFlwqpQSGjrbboc0HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VO9QeCJo;
	arc=none smtp.remote-ip=91.218.175.134
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62294606A31C
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 09:01:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62294606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VO9QeCJo
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LMPLkNm0J12/2POSpRky5OUFx70cELWQjCjS53X+ghs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437279; v=1; x=1794042079;
 b=VO9QeCJo6tA9e7R4mzmG/fTi9CKbqJgpnb57ZmPVL7ZdQcZnKby2sChqxWzTDVT969INNbfq
 eUEc5kIPF1WoSH6RgBugN4FIItl69N/Rnjw+/llWfFjw3LVWCWQzzPTfQwb+R6dENF3sp91PmA4
 CbzB2uvjIlqNz77Jlgaaufcc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d03afa4a643ee410;
	Sat, 31 Oct 2026 09:01:19 +0000
X-Mizu-Trace-ID: d03afa4a643ee410
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
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 2/6] mm/vmscan: move vmscan tracepoints to a local header
Date: Sat, 31 Oct 2026 17:00:37 +0800
Message-ID: <20261031090041.58574-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031090041.58574-1-ridong.chen@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
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

From: Ridong Chen <chenridong@xiaomi.com>

Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
tracepoints can be extended to reference vmscan-internal structures such
as struct scan_control, which is not visible outside mm/.  This mirrors
what several other subsystems already do with their trace headers (e.g.
fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
vmscan.o, the only user that defines CREATE_TRACE_POINTS.

No functional change.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 MAINTAINERS                                        | 2 ++
 mm/Makefile                                        | 1 +
 mm/shrinker.c                                      | 2 +-
 include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
 mm/vmscan.c                                        | 2 +-
 5 files changed, 9 insertions(+), 2 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index aaf2825ac945..2ad01107fa05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17653,6 +17653,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17802,6 +17803,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
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
index 4fb424e721bc..4fbdade6d2f6 100644
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
index 9959ca158ce8..79d2d614afd0 100644
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
2.43.0

