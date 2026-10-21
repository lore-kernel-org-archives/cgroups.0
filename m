Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792623320;
	b=QMxTuACRFzkxBND1vZ4EQf3/7teoQlN4pGx8XS6l8p6ZNVdlt5rDrTw6vmJPlg2t/AoY
	 Mcb8u8H+AfTOQSoAbTI1tzdYvLWpUG4z4sSjAGhi9CiNUpqxVCgP8oyvp0qMW6aeSM4/g
	 16TGWHDw2CS8EOXlBj5gON5EDZHppuP7mTdBc9lTpeX1rtRrfZO85f9tT7d/8kxbyNpq3
	 GImppb1glotrYqe264KLrWn5zDAYjn7kohqnOXypc/AkOVT3lACa70lU4E+AW732TEUyD
	 y8plmCO/4+xfv+FRe1Qhxhb65zIMhQ4QFsa0BcO+psFIKA4YUWAp9//uXYSUxnVq7Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792623320;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O4E88v6TnIIh+ETRycvbXAskumAVYN69m/ippxnJhTg=;
	b=ZvmUGajePy3zc55tAGGdtdhiduKsnOGE5ZppOxoIvhG8ClnhWCKgl8CzIgyYFAItXLLK
	 CouaHxNZXOK/O2/KhZv56wIq/ynE+dDExmoh3jZrWcMZnCZcZU4Z+1NGuR70gCqslyIcU
	 ftSvLXY0cBFw6kpqiI5BCvBDCFD4wnsX01M8Cl8cXyDeyqyiU+Wy3TjTKYFs5JU2mIRq/
	 PD/mJ3fXOSrpJ5JkHvHpOw6M2RNh6om7w9dTIzl9GOSw0p15WcWa3ofyg4OuMihr3sDW6
	 31WVebmnyMAQfEyTYZCl0xURCDRgNrb1kIPpX6O2vyKtu/4qzbvjl79dwr0r93RCYGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Wuupda1p;
	arc=none smtp.remote-ip=209.85.128.175
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFC6606A322
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 22:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AFC6606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Wuupda1p
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8726acc5eadso12125237b3.0
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 15:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623318; x=1793228118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O4E88v6TnIIh+ETRycvbXAskumAVYN69m/ippxnJhTg=;
        b=Wuupda1pCGwl5/yDZp6M6l/JiuYQeP6eLG6x7f5seUjwFikPGUj7hetNT2VhTUrahi
         mcG9E3/32eVhexoLvkRO2bzcO4XbGGOEQJyHN3lcJ0yOy4bkwqyRw/Z2Fby6z6Ltz2ly
         KFdBN/Zoh7S3Ocg+MPDfn4L12s9hThwr714dZj3s0e1g6GcRHuuAKPbJTNUShlmEng3J
         jyk0hvjpgB14KwvDUXRsv3t8UuYYq+QpgP9spCNjollqVOwhSwSDFiFiuSvdBDRCXO8L
         Y4nzMI0sQk//6mFO/rZg0QB8rbC1TbGhIo0FPPEQlIFRehO3rNUDVHYYAeNDsX9WSaBZ
         61aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623318; x=1793228118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O4E88v6TnIIh+ETRycvbXAskumAVYN69m/ippxnJhTg=;
        b=BxpF2RKyPS8MF0GxjPJoCgDb8noN+Dwt8G5fkADLBpWMTbQnuJc4dNC8RR6dCEhOQa
         64ZPZjEu4W/35aNgPTEuVB6SxW4Q8rt0Cc3sX8r1pI0ZZdxZl6QQqgM71ObboYlXqpXQ
         59SLqV0iAgJ8/FWLVm4T8bP5iRkvzyvanKVsXErNzRv8pRsJ0jiOtAlhhIomljzug+1R
         AYvKlXfe5ncve2LeiU07VRY8x0qpZdBb+mcSXVpnd1uFPl8pZ6fDDxzkOrtAAJyAXUp5
         Z1wmf1EU2KQD9v7oLC58jQsXnNMpsjxLfH515qzGvG8zzo8EOzMyQXT5oIk/JcJeF0ES
         N5Ng==
X-Forwarded-Encrypted: i=1; AKwUvBz1932RYEAN2mRwmvyHPJyoyDqD1m7xT7V4ueoOiiq4l4k+zSVI1a2bAqQwLZtzOuWqpXwTGORz@vger.kernel.org
X-Gm-Message-State: AFq9FYKMwlqpyoZhvlSgUz5YaKkaRDqyqfIK7i17pR+83dKWVXvcveiJ
	qZEgN6MD0mxdOJbiHnga4w/xuecZthFPX0PuFWgZQoz62pihiTX8zZAx
X-Gm-Gg: AYBFou0N9cJG89yrZzRdHVwrOwC7YXwzLBe39VKAgMwS1WY++Y+Buf6KZmoAITRa83d
	Q40RYyXVo75WYBfESfr8t4yZ1gZ6wxgh3Ev/G8RILEPQDRmvwjos+zhwCNXpJSyWxWXeiscllVi
	x7HT4UBfQJlK+Qtf/IsXeSCcLfXhjtxHQuOFqIZj0aBqH4B2GknIHurOQNshpY8VTaQWEAqgJAe
	RgqlXkUCDXkvHn08GhCB+zAekvE0oWxAVXzhwyTDSARQahJrxvAdcAgbb9K9Ke4BHS35rodIib7
	kSM409Yo659ncUTSIvIo9nKZfHR8ePay+To4AAU7GO7Ux3qsBT31Jg2Rijblw3td1geg3T3I7XK
	VFr5PaY6x7DZuJaVX3LIyvKXB8Pdaw3QPLKDmvXp4A3dJoOOJEmyD2XGDpqK73ZSI6OA2xezayD
	uQ65T6gEBmEEUeBz/eOb9rEfUf0ezonnYi8hmnQxScVpCZJVXgOtT5+HgZpmXuOiBoXcSFhwXNW
	KP5qZkDFWtAxf73HL6zf+gdYRbpAR+5f5WpZQV6ZcSZORVDwI1uyCS4ARmBCl7RQCQk9DgIOmk/
	IDbeQfMNdmQ=
X-Received: by 2002:a05:690c:d89:b0:8ae:a0c0:463e with SMTP id 00721157ae682-8b133d7d1a7mr24871677b3.53.1792623318346;
        Wed, 21 Oct 2026 15:55:18 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300735f3sm18293307b3.8.2026.10.21.15.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:18 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
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
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v7 1/5] mm/memcontrol: flatten try_charge_memcg control flow
Date: Wed, 21 Oct 2026 15:55:10 -0700
Message-ID: <20261021225516.1620680-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
References: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
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

Refactor try_charge_memcg by flattening the nested memsw/memory
page_counter operations to separate the logic between the two.

When page_counter_try_charge is made stock-aware, this flattening makes
the control flow easier to follow since each page counter now has its
own success/failure paths.

No functional changes intended.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b6..cdd6aba91e444 100644
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

