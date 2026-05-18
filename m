Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC703E3165;
	Mon, 18 May 2026 08:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779092924; cv=none; b=tylqz3qocNmtdtJHIenTGMwZJhdE/GBd+376U0G6002oy97W042MCRgnLu85T2m7X31uuzybbQOEI30+RFZXGDfaoPKgjQYdh7Kxa01wTCv1vRZjBVktk4ckHHwRiItc3T0MQxJT4acDzubWqTfa2VhE/+GMb7HLgrSskPrGu9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779092924; c=relaxed/simple;
	bh=U3zygpRxtwore9LdOObLhUz83qM/Y7vE/trH8fFzkvM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GV8B6j2y6xLtBqMAYWAMJVADEOwZ9vpwdmyCDMz6Up2ov7jpwBxn6Eg25axcmMQoJnye9auU5D5+0+7vkGBeF9lk95pocx8qOIBAq+Vhlmt9Z4xdrfM5s315+ReJdo/6d8/b/Rn/95e9p0IuNA/6V3trISlACpQLUoA/Cnnt6LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 014CB3E97F;
	Mon, 18 May 2026 08:28:31 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH] mm: memcontrol: propagate NMI slab stats to memcg vmstats
Date: Mon, 18 May 2026 10:28:19 +0200
Message-ID: <20260518082830.599102-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTFxJEobSYWwhmTf2yZh3BcfZZ+gpAvsqMM7mQkREdaLd07SR+OFCteFixqSYGMWLGWiJ1KRxQdYDM244Q63WvZIySt//nzf5rM9NUh89hsnVwavQIBIeZ54gWu589OuRCP6KBhL6Jt3Wn/z00f9wsMHAnKjoRsii/78ip/eJ8f5ZLz60LkRdNrQljgBvqQWUoi76vHWPY3sVwzfYhvJiwbCrOzYlOdgRMrulLyGGS6IehY/zkYz5xLC7cE1yuH6HM/xpxnytLlA4IuEgKozD9+Ts3TERPNN0E21IswUVF2rGvNZW97180rGVLWfUMDtmL5IBGI9KRxzVXENdykdMgDolIHRM0SuSnouYvxjHPjtVHDXI2B+aNvz8FPBn6M5Y1oWXEDq91YX6CLE0WOHm0pQTUtAE2rBFXX/skXhZTnDx4CBC3TsKxw8EEaob2v+PBxn1DNqfxY1n4rzT/wfJ8FV+rSpogGjDGwxx98IzoUVfjciBSQ8TliJF08cRhf5h+0F4pggwF8PZoM1lxH+1RktKBduaBkSJ1w3EEHaXB/c///1HhICrvz0priN9vRoad9MzMfn8TnYSgQkVcm/DOBuq2Xu/a0ZI3VtaBB8umsZdLCTJ7xK8uOp9tkah4x0cfa9td832mKfx2yWF2MHRFPdyQ/+B8v0p3IrakZRqyccVQ
X-GND-State: clean
X-GND-Score: -100

flush_nmi_stats() drains per-node NMI slab atomics into the per-node
lruvec_stats, but does not propagate them to the memcg-level vmstats.

For non NMI case, account_slab_nmi_safe() calls mod_memcg_lruvec_state()
which updates both per-node lruvec_stats and memcg-level vmstats, so
flush_nmi_stats() needs to flush to per-node lruvec_stats as well as
memcg-level vmstats.

So fix this by flushing to the memcg-level vmstats for NMI too.

Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
Cc: stable@vger.kernel.org
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f..953a3c0556a5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4343,6 +4343,9 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 			lstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			memcg->vmstats->state[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 		if (atomic_read(&pn->slab_unreclaimable)) {
 			int slab = atomic_xchg(&pn->slab_unreclaimable, 0);
@@ -4351,6 +4354,9 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 			lstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			memcg->vmstats->state[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 	}
 }
-- 
2.54.0

