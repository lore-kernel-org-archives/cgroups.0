Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793797736;
	b=NfPn6d4Z/WvDdK09bQUBU/6mzOKGTinWppNt+Ri1dToNsBlebalOnceY8DXXeXnrJee0
	 zCA37mfgLb2/XTySnS396ZzSXJ4J4prddHpDT6l5kJJjnkwuG6zob5xlN3UWbxVQzO7xl
	 we0SYZ/Dv5AOAbB1k0/99TtEbnrezHNkrvzEDpAzn7QwFIeOy+7oNsOKq7I10+5V9ofmz
	 X7WQzI6V42cUNRNcKwhew3myY/JyyE1WsoZIm2oakZBM0/5ON6uIgQs4HCi3jRlog3oQ5
	 +tWcmAK5bqQ+fqu0Wz+lFj+T0M4vcx/28R3y5I9wfczG05DHJhQTVhM115NfxvSlF6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793797736;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Km4Cv0O0nuE0+Y+BE7m08mP9J2XXD5bcoWZppFqnwaU=;
	b=F53PtHF97vx5+e/dVF1fPUK7lLmojGmu8qn/QbuC4i+36Lt1wewGW/qLmnJJXQXhnW0D
	 WV02KikCNWzkgtzqeiz28ezkTioEd1zqz0rqhv7W12yO/4ihU6uShvSxj6N78UOL8D9e2
	 9dTphhW+AnwkaEfILyAnmVSfuVSSzoUKyY3LLsrPshGonq6ARPfZcxRJ/dknCYqCppJFQ
	 i30a19vQmtI2PpsFW+mVUHXQd2ulq4MXjeGH0LbraWYnA7lqVfxjTZMroKXDpA6PWrD2B
	 hPcLrgUP2RqmHcnwsdZrEnVqbhtk1ALX/o/v9yfMBSA75ttjjvi4FIq1gwMOa3k5Zbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=coHRrqJ5;
	arc=none smtp.remote-ip=91.218.175.133
Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DACF606A329
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 13:08:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DACF606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=coHRrqJ5
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jyyu3ZdXnJNcUGMDlH0RvUqU3YiWZYptJtZdAQQmKqQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797732; v=1; x=1794402532;
 b=coHRrqJ5FeVPLaMeCy3cHUAwJS5EOlqMiGUb5qf0LjOAVY9qtA/qtyfzDG+SPiSctla8760I
 sNVTorqDFIe6qhN9j3QkzoqDYOO+/gca9qdmqFCamDcDotddFY4lBRUINMwG4zPas5wzQf/T7IF
 OIGrhoeu9HFnjyGfsoNnCl10=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 25592fce0d3f543f;
	Wed, 04 Nov 2026 13:08:52 +0000
X-Mizu-Trace-ID: 25592fce0d3f543f
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v7 1/7] mm/memcontrol: drop unused vmscan tracepoint include
Date: Wed,  4 Nov 2026 21:08:11 +0800
Message-Id: <20261104130817.849089-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104130817.849089-1-ridong.chen@linux.dev>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
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
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ffbcea28a608..1ebc9330aeae 100644
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
2.34.1

