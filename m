Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5E24B4032
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 11:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790596027; cv=none; b=Hk4u/RnBP8HfbyizR1g1FpgMsBcv760KG7JrDykN6d5lMxoGBwCkqVbFgdQN+gmQ9V+t01zYCMRrB2x7Sg1OYmYfmqLQFcxBFnmexk/tZhztfvsVQmZRk1i7clTcR5n2MjHTRqHZooi9Rv2BWhROpMdcNbmesoQIgxO/GFkU5UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790596027; c=relaxed/simple;
	bh=tBnHeT9n3h9R80j6UKN1h8POd16BKYoh4+WiZYGwAFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WC6PJdgs2aZaFQRzCrtErZ8kapbks7hWefrXffAwsMTXNtaEleJTE1YY99/a6GYV15h42JBCKt7K3eykMvp4iYrosL52dwg2kh1xWPjunDZmTyuROzkdVoMmEOyP91lU3cVnyKxdv9tYzgXP1Q/5EJ3SQLhRty5bey3Yrnllz+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bBOOvOA/; arc=none smtp.client-ip=91.218.175.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bBOOvOA/"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tBnHeT9n3h9R80j6UKN1h8POd16BKYoh4+WiZYGwAFw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596023; v=1; x=1791200823;
 b=bBOOvOA/IKxbFuxTxyt0UBslh0/lUFF/+VXJiuNGb8cyZvzmr5+3mFeD7jBVpOAuK2SM0LE4
 uyyYVmJ7LC3vCrVWfpSRlUfboSPbrQuLH64smldybAUZKA8OIDWklbYCTFaqaF2BtakejxzkPIa
 qGFPmrF/r4jRyZ7vzST2j1IQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b48613931d2c734c;
	Mon, 28 Sep 2026 11:47:02 +0000
X-Mizu-Trace-ID: b48613931d2c734c
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
Subject: [PATCH RFC v2 1/7] mm/memcontrol: drop unused vmscan tracepoint include
Date: Mon, 28 Sep 2026 19:46:18 +0800
Message-Id: <20260928114625.3609130-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

memcontrol.c includes <trace/events/vmscan.h> but does not use any of
the tracepoints or macros it defines: all tracepoints invoked here come
from memcg.h and writeback.h.  Removing the include still compiles
cleanly.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..95c2322d4a6f 100644
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

