Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E4719644B
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 08:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932949; cv=none; b=P4y1kA0AnMBXnWx4uXuOQfvnX2DWXfa0RweMi8wyG2ri0CZTYUh/WasNRB84qoAYPDbqV1Svb8vrYLYOlDp41rWtmuKBYKUGnMe8dt6dPGPJf6vmANqTe3xJ4RrJjKpKLJ1dm5uyQe7NGhBBMF1hIroCJO0BNyIpR+3MT3Bovq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932949; c=relaxed/simple;
	bh=9WcLLEUTfH5DXwDE4U4LjhiDFTxdCugGyLPUB06Q4Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aFsPYFyZt7S27SHoNtgQ/AStLi0lULIRR1gendeb5rxGtcAcffrK+mHArARJ8zVrK6QbdFQomcDqVQb4q2OhJPETGR7Abdua04BGey+co2rAmJ9qPYQ1Xojrh5SebOVrSbyziRNhs5mGKdetm9FPBFayrnIPWhPZ7p21BjUep8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VCPm2n9U; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VCPm2n9U"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783932936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lRQmt4fwY1pc83IFqnyeFa3xOFtn7qun/zE5d+hdHz8=;
	b=VCPm2n9UQKVR4xjj4T1LbYJORcayH6qqLMp+hCPm9RGeN+6D0xu8GSkBowu/PS2guv5m+b
	Xwu9j1vMNww/fxb6P1mSg1LquSQuJ6REZqA0NFDLFyHXJRaLs5Pv6QD0ngboHOKkLPQjIc
	SqKb1sHStxIMiionF5pejh9FjoMr5js=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Stanislav Fort <stanislav.fort@aisle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg-v1: account vmpressure event allocations
Date: Mon, 13 Jul 2026 16:55:20 +0800
Message-ID: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Commit 72797d218b43 ("mm/memcg: v1: account event registrations and drop
world-writable cgroup.event_control") accounted cgroup v1 event
registration allocations with GFP_KERNEL_ACCOUNT, but missed struct
vmpressure_event.

Use GFP_KERNEL_ACCOUNT for this allocation as well.

Fixes: 72797d218b43 ("mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index e8b6e1560278..f8424ec3734b 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1721,7 +1721,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
 		mode = ret;
 	}
 
-	ev = kzalloc_obj(*ev);
+	ev = kzalloc_obj(*ev, GFP_KERNEL_ACCOUNT);
 	if (!ev) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.43.0

