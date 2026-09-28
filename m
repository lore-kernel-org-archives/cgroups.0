Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5373D9DA6
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 19:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623434; cv=none; b=Jwr+XH3AK/1/xj3bbV865PSis0+LV3f8q3bLN//nW9J/u6vWKpZmagx70bIPAaL6hUx6/fy8EJ0+z0DeLkKiPLz2EYIEK2S28N0FHulP+9N92/o4Mx2cdBu/uh2bQVhD52J8LcWlEQmI1bOhPrHjWThVdGduP1KfVlAXgZWk61w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623434; c=relaxed/simple;
	bh=fkznwRMTW7m+73J/coL8E6TveSuO7AR7NGB3WPh5Mi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itM/+GRc04FHoJtS89fm9ma2jqu6nkPay92h+ElHiZyUeAoj8cFMS+QD7M6pe9m96SqGic0Y1RxQ9FbNx0NjXDtlIzeo/MqKMVPbDA+Ha21z7955GEVBS4t+97C/aZB9pXqUyCMKW53zaP7zk4R8KDbcEtSsSfdOC0xjSaE9rRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KlfNl6ts; arc=none smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KlfNl6ts"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4b37a29bf27so1571172b6e.2
        for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 12:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790623431; x=1791228231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WHveE+gpiQTTbGsR6xfcK57TMqcWcGFoeOvQiQqSmeo=;
        b=KlfNl6ts+goBdzADvIU+bMu7kADT6HQQgC+ll2ANJC3ls4eEiICSzrBiCrf0IU0hG2
         Q/wcJsCO05GZqyxtkszrdvdDh7HgU9mNMK2zzPHo6e7azlYSWBgqCT3nqH8RoIQS2DWg
         ZsM8+3iO7Gg7NfNC5iZ+mGSzWXWRGFGkBsvBAaBx8SXkGZym+gv06TDP3BHltrE1zEz5
         YjvOjGsI1nLJpijvyoMmj4UMRNGPUpq8VnKGFl5l0vJ5Rns3xP1ps1wIUCko85LIU5qb
         RQCEDAW/uIg2nXqWNCFlhkuyWXE5CfanmdQSCEri6791u2llv4dcG4k43MW37oGDdGza
         XXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790623431; x=1791228231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WHveE+gpiQTTbGsR6xfcK57TMqcWcGFoeOvQiQqSmeo=;
        b=AuN3Bh3mZh/XhJwzR5E6RGFJQ5ZeB2xJ3F63zpXRSGdah8y32ol/FzmCrS7/qFfFq5
         fFRVhHybZWZp0lleLYieYlKUw8pxrFFLSKbg+yXvMo2dGlQIOUSR/r0t8dhh6smvmvl5
         S07RfTKXjAH1U7MND6OUfffmwPgjjhJecDfkjDzodM2MKRd66i9DzBJrl8wn2Y7QtB4k
         q1jUj3vX+bSdaf5Tc7woL7DAOJ7Dkz7BwXoSJJa1mqrf8hnUL8yUY69ZUBgopGGGYAc4
         xmSmmV1iRib8iMXv/wLW64W38weamANtHwLxczxbHhNhzCXIlMwlYz3KGZdsq5cjScxx
         qmAg==
X-Forwarded-Encrypted: i=1; AKwUvBy3y4mYjt7mNw8VTnjrmjSaYrMUwsk5Uvhn0gZFelSovvGv35OqWa4yQRIhBlB/fMl8khKyPHKm@vger.kernel.org
X-Gm-Message-State: AFuF++nVIJt0RzpLaL0XE2WRKjLZMSNvP+8epOZLifSZfzKzQT9v+b1s
	pwBCwL0331x12Tj4MylmBNR2rzfQqq/eg/AW0wqbhciL4VG3gkKFcAsU
X-Gm-Gg: AYBFou3bmbmfF33qGxrHnPep0NXxceBMTU5g11vMa+fUjaDqkwh3kE59EESd3xVO4DF
	fLcFt5ZFM1VvG/vrxppV/LBx6NWj9wfD/8V8+d70l8gJCQ0kB7IbWbwUCTbSO5yB32hWhPcuJ7F
	pyV3eq3kHTwfR6e90nFaVdBSkAHjQc0koiNuTat6ZqZuCTemaszwC7l0ovAs8AHW4AvrOcp4RRl
	WX3it55K5s0OzULD7dpMq6JuIth0zPqA93wfT8bewwCiEit3n9FdWihpVD0GM/FpKJuI9QA4Mfu
	VO7orCL+EZwEzO0xKuiFVau07HKGbG91ynj+DAVQ0KSnBkHmgrhsf+CRB4m63K1R/NX7TDB2BYa
	EL+fArRBLphpoEpV5A8371GbmFWsuqpKkvvmBIaXJXhUIK8ndbYrqbr9U8vrIbb0H+Z00TAtEdN
	jT/CkUfBQNI6htNtubfwCxjPADBbC+ab9ewYyH0Ph4m8dtSMdL3lsL4lFsgRFABMRz5RVpv2T/c
	1QZ4wkFArTZnRFEoJpdhseibiJV3g==
X-Received: by 2002:a05:6808:10d6:b0:4d6:9232:b3c0 with SMTP id 5614622812f47-4d72cd363ccmr16423959b6e.55.1790623431516;
        Mon, 28 Sep 2026 12:23:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4b::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ebbc7b7acesm2515978b6e.11.2026.09.28.12.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 12:23:51 -0700 (PDT)
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
Subject: [PATCH v6 RESEND 1/5] mm/memcontrol: flatten try_charge_memcg control flow
Date: Mon, 28 Sep 2026 12:23:44 -0700
Message-ID: <20260928192349.3432886-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
References: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
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
index aad0498a7bd65..edb2da5a326c5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2721,18 +2721,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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

