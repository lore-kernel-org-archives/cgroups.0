Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F347F45348A
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134082; cv=none; b=ubyEqYME6FCKmJfn6ldGx4s//aOjyvsNSnp0+fGOezi4SjUUql/tRn/vbt2QI1g+WwjKfNDvEhyBxBGy0L1W6iMKD6Var/mTFT0RYhI0ZftKs0eOE5ZQ9Y75D6yqspXqXPzvpRnJHe8oLwUQCwpDNrMJz1d5yY730IILzPGGcMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134082; c=relaxed/simple;
	bh=ZV2VwtllGfxcjLjy+Ic7pvWCqB5qypDbPzE1Afw8BhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWF7vbQbgfqyqQTH5M1CPB1wazazHWX4H7ANDmWHEQulvPJcv33E9YnNEPut1rFIxhAAvj7cVaLkJ1MJ7Gg3/RDAfxCuQPG/xrCUXxMJ1Ma2YdayPlL35BwvQRp+ZdhnUoUrJqr/cF6D/q8iZukCD0fN/aTeCBUmzUwR9+bwVDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4uwRzY3; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4uwRzY3"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4472500e25fso1467220fac.1
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134079; x=1786738879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8XkMxJlHKp/V+Gx87DIQUe3nc4ANw9n5bBTpUGWIjt4=;
        b=k4uwRzY39CqdgQlzoByv3mAnaL/d0rpYEV4EHO/JzzWMkbwakeJqvOJi3PWdtqyVDA
         RY47niC6f07RohHD8DYWIW//ImootfUXQwEUoClV2sUurLWQDzi9yuDdR4BecBaXPR5l
         2kg6Vgj1ufN9Y9aC9KZ33YPMys/WQVVzkcBod+IqPGQF6EK8/jI5jwj6UVXDL8YKZUny
         nduMSV7S64naM+iwfq9dKSL31+/2730FM1UnhFkxyMbbK/LzyI201ZJ+/chiflop/RqS
         WTTIICeD/BZTCXoq4rHLAbLNsR92DRVCFG4o107jjjIdQJdWvs2PJNnghcHXGrhCBWWr
         BpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134079; x=1786738879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8XkMxJlHKp/V+Gx87DIQUe3nc4ANw9n5bBTpUGWIjt4=;
        b=fXlXl4pqz2V0tm+XkPCdSVrGt0u3UNIz3zJ0eXG8kyEhGG2n6i4Rv4ALCY5uKLA3ct
         3F5isbhMyvaYa8acVqYSMgpBJj7Ly+35gvgFOvPfxRLkKcjMRWiUg4g0os/FActHcNnA
         MTrbXLtW3UTExal3dJZNyIzBaBWtAcG/6ezCWu2OsBb+7wkO/v2vaBTT1TDdIbU/Za1l
         Zm+8ql9lMaWRoVROEZB6CgaVokNGnh4RfvlajTR4NUwpEqEoFdWqptvpOVIy2EUUQmiB
         xGL9o3GYVJMmiw92wUycpyO/yQem8NhJLLDLGxXUGlAg30K7bdAxEaoSCZ9GGCtzqAeQ
         EXZA==
X-Forwarded-Encrypted: i=1; AHgh+RobkjSSl4Rq+KPLDQkV9+TYnsXrvYfd04D2uRELLc0OFNzy6yy2SKkw5eu+jaZDamIlzjGprBv0@vger.kernel.org
X-Gm-Message-State: AOJu0YxcqgF6HStZVnsWlcjjCtJ0VEU7EFf8KR5bK85h/DqvndLFYIMK
	UmX4dngzEWisVCLw3KtmAjBl22pgskB8ROoekfS6DauUM2FAQc9zUtYg
X-Gm-Gg: AR+sD12Ee8/EPcShAxCVodhjf9s9dmyj/+aHysSjKjKo8TcisTPSi2euVL4/WcTEe/c
	/c0HDpKizRRp4lsZ45bLlEmt6SV557X94u2YY0EvfunNQF3CqMy7vfuRG9zEDLhETAJtWmzh8p8
	T0xbkRHRQHYHDxVlAvmtTI9850s7I7L+lsAjzZXnMVF84PxjhIAb13QPomdSS+xXjN8dZKEmxVZ
	0hjiLKIwHyYfeJvYhhqn9FFGj2cNVjzPXIKVrEtFvGHzy5VpUzQXMk7b1mTpDncNqArcLKUFz2+
	RIulliRCDxCC0G9WYcI40iSvjjT0mPuwFuWmnSmXkTYmi6g/mwXU1sMgBy0AfgPcvyuetCghK6w
	5GtW8E9XIuQx8qSNfJ1dPQ8zkMX/I8SnhWabPoYPEmjlJMUTXj4jBPL8fZmjmg29pSPTwxeXmmb
	X9CBA6PLdP/RS1GDntsF1517p3CXvakxmx3a2PijrxPXRCTj0THcYh0uaiEN3C6vDg0kk0q3DfN
	XreBuxs/ZFjw2WyJQ==
X-Received: by 2002:a05:6871:b0f:b0:456:9b53:c6b5 with SMTP id 586e51a60fabf-4599ef8fbcfmr13854626fac.13.1786134078812;
        Fri, 07 Aug 2026 13:21:18 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1ece1fbsm2770188fac.17.2026.08.07.13.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:17 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 12/14] mm/memcontrol: Kick async reclaim on migration and folio replacement
Date: Fri,  7 Aug 2026 13:20:55 -0700
Message-ID: <20260807202059.2620949-13-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Memcg tier charges are now transferred during folio migrations, but
this still leaves forced charges and unenforced paths like folio
replacement, hugetlb migration, and memory hotplug.

Forced charges can and should not be enforced by synchronous reclaim,
but if soft limits are set, we can kick async reclaimers to try and
bring the usage below the high memcg tier limit.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1161934e81380..4dce7c6fefd98 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5663,6 +5663,16 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 		uncharge_batch(&ug);
 }
 
+static void tier_kick_high(struct mem_cgroup *memcg, int slot)
+{
+	struct page_counter *tier_counter;
+
+	tier_counter = mem_cgroup_tier_counter(memcg, slot);
+	if (tier_counter && page_counter_read(tier_counter) >
+			    READ_ONCE(tier_counter->high))
+		schedule_work(&memcg->high_work);
+}
+
 /**
  * mem_cgroup_replace_folio - Charge a folio's replacement.
  * @old: Currently circulating folio.
@@ -5705,6 +5715,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 			int slot = nid_tier_slot(folio_nid(new));
 
 			mem_cgroup_charge_tier(memcg, slot, nr_pages);
+			tier_kick_high(memcg, slot);
 		}
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
@@ -5798,6 +5809,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 		if (old_slot != new_slot) {
 			mem_cgroup_uncharge_tier(memcg, old_slot, nr_pages);
 			mem_cgroup_charge_tier(memcg, new_slot, nr_pages);
+			tier_kick_high(memcg, new_slot);
 		}
 		rcu_read_unlock();
 	}
-- 
2.53.0-Meta

