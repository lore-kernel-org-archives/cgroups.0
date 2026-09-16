Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EC849A3AE
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 21:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789592786; cv=none; b=uU2E4SxgCwp76SJydHaW6S//UTCQMVgEvgRjnv5GDjpuE6RMIhV07NOw6UUlXh3W8QuvuTrgpuRX6rQ1RZPN0Zsmr1OrowWRpAjhccQXyKH3DMR7YLI8OVu1hFJj8jTG2FJKvKx26vVSUv5z90sF7WV9ZILQ1EktZNQZM506J2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789592786; c=relaxed/simple;
	bh=IQNpo0voZl44flDTr/7bJrTih9RnNbJtVb25BrCwX4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bi0X36RuLtvdPW8fyOLDvKrtDUD0h4ZVYR9pVaFagcmLSSiq0Ax4KSWnepHOV1IbBg6wlgkehRGn28VrAdaBzUMfwb6XLoiBHJ4wThIrDMzNp6IP52BhjRWyDPkqupNMpPdpVbgW0lxvElcHd/YkNj1ENcv8GDkysiXn2NLNwLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHPK4bAu; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHPK4bAu"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c0776592e3so91982b6e.1
        for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 14:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789592757; x=1790197557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KzgD7tpJ/TV5FYPH6ulvzWsXqYOY3DYINqe8nFmUw9M=;
        b=aHPK4bAurX8scni84dKccg0rLHmPsoLmjjaVuhlPtnrHrP1Rko8oJF3wSb15S0yMcW
         AlAlcHXG3KoTvbmi78oLTlkFhwWeMdc0DxHLc56WPvrdRnb0LbjtAGtKauHFtgjx5zAG
         W8FXOB3CttFaKBpaWmRw4n4gwDQR5Q3qnnzqjqvUZE97gs31dBjswkrvdEaLFmkvZz6m
         LYzfqNui6IUWxlBJUZWPWf9mHTPHYy9Q5mRpdiaHClVSqEP7Go/6A8C2muguFQZbuod+
         +TKahYvAsVSaaYqD+NZ1abceH4BWiMGAnWUSHz7VX0AUMPV8hv+t+CfWPeO7N2jAlF9f
         +dvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789592757; x=1790197557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KzgD7tpJ/TV5FYPH6ulvzWsXqYOY3DYINqe8nFmUw9M=;
        b=rXM3k3MNGt4vRkERVfe6hMwbWJMPblXJK2xYakDzMDH5fORBTUKynzGMJtBwqS/8tL
         1NH399gJ2+z/eEZBj3sV7UBEQ1cq05uwX6w8Mt0LjrTVuziU9FN2JqwPMnSV8OIBN5Kl
         kEnvuL1LW6vsmjO6htRTiCvR7LBusNbzjEOYxTTWj//4W58HWC1M+ZzXUQ6c5TQMi14L
         DTU/jrNtByECSK6H5aamk8Vl3W13WnvhKUYUe30SZVxNhDSLnUQJJHb5Lahy2UcdduXo
         c3S2iHfaIojvVRbESJDpvecTg4Cp1tbg4y+k6/9JAJQ+oHfZqP86hPMD/lfm3p7Ked8s
         ij9Q==
X-Forwarded-Encrypted: i=1; AKwUvBzOdH89SoTj+hmgPJhngZTRS/B+WEVgISi0CvGHSpXcFrXcUoKtSXiRWXtLx9/VFUk3kqxeqhlH@vger.kernel.org
X-Gm-Message-State: AFuF++k1fQPGQ1ZocnL/2IDpSqLEkI/FrerV5lKn1yViwzNPVlYvBUli
	lsqX8+zZoC9Vj89O7x2i74pYDffxUO0zwGn2cRyJZVBjspQC/bvMe+lv
X-Gm-Gg: AYBFou1NZmmGbH9RK+e38tfHfJhtYzPtaXmDehgpsZqHq2yvdPAfaJ7/EhfI+yUrPWD
	FH98Ngdltvz5G+gHw9zlFpX9JakXw/AHkz6ullmvyDGXurzONeXwTY1helcByUZqHANNj3g255I
	MAPxro1cBWk/EZFkNgDWfQJqlkF2jWraM02bgM2pVIq1ERpfZa0FOxBwWQ4/6FVujfr9KqEE6Jv
	OH+OOFzj10dyHImJmOjSBcm3YoPJUIPCSpnY0TwAu8tdYf8rPhh7pamQ3pBQs1kUHhMmgSsk7oH
	XHnMZ8zrtg4/W8iFMgsITJ0xia9jr5hROO3KxwoT6vI5qNJ24j3FxPo7VUFPoJGcjuC4B36MDH/
	XMGhg94T+NznlKPfFurq7CBHhdilRYOf6rWbdt+TOqBFxdA7BKJlUI6bIjv5W7SCHdnIZ83aYNx
	MR2mN+I4bloIbJIVOjZBhs5e63DJ/t/7gUDnY7L+2NZvg7tskfA6kTfJZWlFjRzSnYiRtZfnuwl
	49AMCKRMCtg92ruXN2ZzoQuKyEnKSN7WEX77lVv
X-Received: by 2002:a05:6808:1a0e:b0:4c3:7695:1177 with SMTP id 5614622812f47-4ca497b2b58mr4346226b6e.6.1789592756726;
        Wed, 16 Sep 2026 14:05:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4c::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6d796b64sm891126b6e.15.2026.09.16.14.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:05:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 1/5] mm/memcontrol: flatten try_charge_memcg control flow
Date: Wed, 16 Sep 2026 14:05:47 -0700
Message-ID: <20260916210552.891730-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
References: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588e..48c475909e6bb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2707,18 +2707,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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

