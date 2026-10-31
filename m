Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.125
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793437270;
	b=5FuWBpfxtGwLipYhgG9DyoApOaIsH/k8SkEn47q2woN+096TFYM3G0LjN8ei0ppH9m3o
	 kfgb7kdNrO1OhJOu+Y3+vx2rHxZc3qIbQ3ECu+AvawV8czpSKitR1TCvht6QtvYKRubln
	 LbGR7cBrVEbKmmQuUtm+6417/Ap4c2o2HaIhW/Fh9oqeRJVzqUAGw48d3nzPuQQd9wxNO
	 oEg2FBiVp2lfcpiL9YwGqAw/4FG81aeSGapM74CQJobaiAKEr/fheXdjzkHVpK++P2GIB
	 97N+oMA07ykzVWFeLI2ZcZCsgQjcPBJ+wIsGeUp+Hl4znrdzgMzEGYofiSTWVCppXdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793437270;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2ncgEC9IMszXot5VibjqpArUmCGpn+ctDoSwbL7FfHA=;
	b=gDmMNwVMUuzG6JJ+cjEApxdK725cXKO598n75AQtAWV34/HzYV/HccZ6h1o0RpC8E6dv
	 okJXi4fg8ztzwfk3Hy+mfyaq608J9kl/0Lcm1fUaW/XSux/M+39XWamX/PoPag/21jPnJ
	 QI3iFaedxvBuw9NyT1enuYT5aHjsKwTYFP00KMCfveZ5fDO/5MDpNAfUwZYBzsEBLOYx2
	 9wa/41nI5RFL11JN2x8HKNUIt8gLyAjH2nwsyDO2Ebxym4DOg9lsAY8/iQNEm1Huvsypn
	 Nor2QLuwSAwDO/37k+hKjQs3HQ2xM2X/o84vAOjnOZc2sb0OCnkXPs7nmfyrlcQPioA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ikWGtFFr;
	arc=none smtp.remote-ip=91.218.175.125
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E198D606A323
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 09:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E198D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ikWGtFFr
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LhFhTvoRvl7pKSSWDkFqwayWFuSIT7ln2mRB/yDhXK0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437266; v=1; x=1794042066;
 b=ikWGtFFrvYwxh65llgEgf+rVkllVvrnYHhAHT5ljaIjsc57mJZzNVjLFk7t3y8fCSvNv1wRu
 SiPMPRugi7WCpWmYdhj6H+KCS/68ZtB/I8Mdk9BBW2FOCH/iHR9R5j23iwhKsxRRv7VpaHYsPga
 gy9XSSvqcciOvogN9RxjohOQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e5cbd8b44e2e7798;
	Sat, 31 Oct 2026 09:01:06 +0000
X-Mizu-Trace-ID: e5cbd8b44e2e7798
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
Subject: [PATCH v5 1/6] mm/memcontrol: drop unused vmscan tracepoint include
Date: Sat, 31 Oct 2026 17:00:36 +0800
Message-ID: <20261031090041.58574-2-ridong.chen@linux.dev>
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

memcontrol.c includes <trace/events/vmscan.h> but does not use any of
the tracepoints or macros it defines: all tracepoints invoked here come
from memcg.h and writeback.h.

Drop it ahead of moving the vmscan trace header under mm/, after which
<trace/events/vmscan.h> will no longer exist.

No functional change.

Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..8a35f5b635e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -77,8 +77,6 @@
 #include <trace/events/memcg.h>
 #undef CREATE_TRACE_POINTS
 
-#include <trace/events/vmscan.h>
-
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
-- 
2.43.0

