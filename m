Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B698844238F
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134066; cv=none; b=eijz6PjOC+Z5kr3b1iGrDekN63o9u+HaE/nmeYq/uSZ15woiSKWzUGwGCJdNzDrxHfFC7jGP8aSfsBWus8cgVQcfaWn0pXB2lh+KdLe97BMhiO8y2NDreZu9rd+YkZGR8dIPc9eb5gOBm+UmVxCINqL1xil5unK7J9Cm4uyNoz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134066; c=relaxed/simple;
	bh=lwHpAgFN6fA3DPa6IS11A3vLJx+TAT5kwwP52j6vCDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVpJAw1vYluGdvvfXmJ1q9ccCnTaltvtYD8hDdGPmkSRvTi0Wq0/VTVomuyX7MxdIQ7mKcO1J4HgFydYAT/xOr9SyyDN7bq33tBSeWqwe4/nFIYVezqHes+4iRj0F/QiEAtfqzhmcH5D8FwIbluXYxO3ZK6wW+aiT/17OpUPkfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mw1qNUEP; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mw1qNUEP"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb64085c45so2957238a34.2
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134063; x=1786738863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uIJ1lfVFAjreFSGxK42rkml7ixTeVT5CBMzYSJnOvv4=;
        b=mw1qNUEPm7EcjyCBraD6oiaQghMYIqN8PN3ximGJj5onVdu5N8b4U6GGane6XRAIvh
         TuMWBmmQXV7AJrNViqHUl4mbhV2WGsWHwF2AOC7Q+Duon+cVVf+Jr2I1IfYqTH3B4QL4
         PG2HrO8c9IwE/Wf4L06at7kdGbyfsuE8sfryS1OG1rq90gQL+AK1j8uu7PFh9tA1qYKi
         oeuBzYS6AmhOd8ulRCfU7+9c2zmYadCvIngHfjHZSsCBkJlfV8YStvgS5SqIWnWKD3Mo
         Ci7eXCFisZzJRZKeHUBlxwh/ttWU91wIINJ9MvunZfZ9a/PIO1QOGFWjj1o9OFOIUeZ+
         CHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134063; x=1786738863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uIJ1lfVFAjreFSGxK42rkml7ixTeVT5CBMzYSJnOvv4=;
        b=He9fmc0cqfoERbAIrRgRuURmu9jWgCbieXl2fHkiocmqHWoK+VI/R1Kbt5ByGnsHSu
         /OX0m3d9J72isek45q+/sv1QbP4uR76v8LkHT+SIrlnk57GE6id3YgLoww6FBs8kFLcF
         FHeKbXTmZ8WV8vITOMFUhlQv7jOd/iWMr+tYZNP2+goIx1ZxUD31/EpJ0p/3frbWG+Bn
         bTKVPrX2HWD58xY4RJdNwE07+Cq6OMpvcUXrOQMoOjn0Z65Tw78O5+0mf9kME5EjPxhs
         kdvm9wMG73Bz9s5wbiRcDe4ddwIH9gCB6lva6CoMmQuFzUOt5by7chu/x1np9RXtMuca
         MM/A==
X-Forwarded-Encrypted: i=1; AHgh+Rp1ToS3BqATJIiSxR6f/Wf28NnFnMaSU6u7MVplQWN34DzKTlmGs85kPuWVBOmMY7+MfkCpUSeJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzaADu9BTWGIoHozRoD579Lj5jn/b15v5uKciJj7dmHvH9XyeAY
	u1hu2phg1BRcp0Fr7/wFb8aWpj9ZXvMkVR91wS7mp7jDVu+WEMRn3VQy
X-Gm-Gg: AR+sD13TAUn+tQ0c8niZ1Vp6TGSFNbT1VdXeTGYryxYAei0F5rvWsNE3fsMZBZNFpSL
	Nezi3lhgBJZtxzk2BV1dfn+oQsitRag0DJJ5j9i+CbsWqdLw9X0mYXZEWOdHJH5w/VPJWfecLHk
	46Jx9rGMhKHFwtaue5HA4E1mEdI9iyU6QxGttZRPiV2Dc2XphUZNDKlKORqLPF+rrtTL4qXaH0l
	bbC0JWNkjneWl6Ta+Gfx/Kb7e/j8mV4IyouRSF8rOyGpEt4NaQ1JjLjLx9SkOCWfwRyCh8vz5hv
	G1CBrgkqBNe7eFsfrWhdWkB3zbkdV09mQh4UUFLxexBXOPNeMHfoXbHYZ7JzM/r+TRrsktgwDtd
	P3x36o0sfn+Pg4aQ381uoEWCCbbchHkWagD1BXVikzMZSIjcLiw2iY79Buf9vhHQ/bC32wAJiCT
	yeasbklD8BKhxIgVGccT5E/8Hxu+tOlqv7HcRgzPnzQ0T9Currfc9T62X930x43pF2k2dpOzrop
	aaMgIrM9a8Teoe1J9o=
X-Received: by 2002:a05:6820:8118:b0:6ae:55f6:2cdb with SMTP id 006d021491bc7-6b041ee0996mr1744079eaf.1.1786134063536;
        Fri, 07 Aug 2026 13:21:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1a76701sm2665817fac.5.2026.08.07.13.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:03 -0700 (PDT)
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
Subject: [RFC PATCH v3 02/14] mm/memcontrol: Refactor page_counter charging in try_charge_memcg
Date: Fri,  7 Aug 2026 13:20:45 -0700
Message-ID: <20260807202059.2620949-3-joshua.hahnjy@gmail.com>
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

In preparation for adding charging and uncharging of a new page_counter
toptier to try_charge_memcg, refactor the code so that it is easier to
distinguish between the memcg v1/v2 cases.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cefe33b5fd285..ec28512de6a23 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2668,18 +2668,22 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.0-Meta

