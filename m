Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793835033;
	b=AzVT0I0bVkqD7l4HKuanqG8xeqAT5EnDN1vUs7h2QTDgL79xf4ibD0tQKo+umQ+iPeP3
	 xsNXAhWHSQAZQIA6/KK4QWp/IZuAA2Rg2dMJ14rjdm2rbV9LuIb6LV87vplheKlKYp5H6
	 TcTniQQQliK73l6iyHGSbhLCHhMUkHHtRtfE8+wtDNhDMxYq2/Z7lxyVk3Y4WdyGRpi8l
	 jRHrki35WijK8CHv/swS30zPaZxMUvaervKmXRdRStGN76vQ8T+ML5pT1USI6mdQOz5f3
	 GljRtQVd0+xyjhgiGDS6B4ERNz1X2JobfyO3N4m0vi8mYQyBlNKYF1AmLImj088w6Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835033;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RXyZYe/CTboqHUSipMlaWiZYB5WKA52593Qh8Q69WAI=;
	b=Pz19WRSxLn9uGvgdoNOKuBQxgNFTmgP5h9NXdLgVp9aRIk8OAnj081SjFj5VbKE6Oj+Y
	 v+9ewj0zaCMHCPzGO2UhkNT57V7ZFf/C8b9Dfyx2tQOdHgZ7iksRfRj1TvI6oSdgc1ikl
	 7+2Hv5Wz4QzHr/pj7k9qdm+rStuxX5GITS78KwHMECXr0Fo0jCe1uVMRuZwDoj2gslT+T
	 CCsHFjbaaM5vE++bSWzMDocaegM0c7vWRDZF7oykKbAo/bXaDhicLb5apQQ5jfzpqakda
	 N3rVxYQioA75M+GW215Y0sApSzEM/0Ivyl+38+u4sqWkhkowgdeN2ABmtd0y9BsdKsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HS8B4pqa;
	arc=none smtp.remote-ip=209.85.128.176
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDD0606A32E
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 23:30:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFDD0606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HS8B4pqa
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b31448caccso10745157b3.1
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 15:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835032; x=1794439832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RXyZYe/CTboqHUSipMlaWiZYB5WKA52593Qh8Q69WAI=;
        b=HS8B4pqa554AlFeqlrC0uUxfD8ae0uZvprOtQ67IKBjZlbVK3Z1QJu7VdesAVcphgD
         bk1EEW8kl5HWaJTYKdqN1eXPhdct59jvUlPNjPiWl7vf92mAxxmmUMwaHNO9MSJ0bAwc
         2aZN0qVlxhVqtcuvS/Ri4N0riJqR+P0fuNM8JY34SrL8DHZ/dgdo/TzQPnEYge6Ff3ow
         YrHQ7l1rCsZQsUs8/lZm5ToZcM1MP0CQwqqEtT4Nj7dRd4D8ue2vp8x+CK7OYmJCEqz8
         ruW+egnRjjpHNfnlb5m/nOy11289jLPdEqlOMFyjgC9YfKUwgFaVKPTidFh6hOAaZhwi
         gEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835032; x=1794439832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RXyZYe/CTboqHUSipMlaWiZYB5WKA52593Qh8Q69WAI=;
        b=DTYYZ+cHNXneVJdlO4VIu/j+aLT89UoZ2A22bkNIM+CXF0LbapkZ7MVBUNq9DWZWQr
         t6zZ5tOunHYBSC8B2P4ZzM8bMtYtd0nVAC+v2NEYGAi5ZIDKCj+jjt5oahS6WOkDAjJB
         qmcql7spDylgnMUryUuk03rcVlGyl0X+Rl7uHIqgeImXNPq9VyovJfyZRLPQjP38UkFV
         uoYfjswPIClzDiNXceNOAzGMFh02n39Z8FZ+m9KmolyDEH+byvYTIYJfCkjCHZZb/mGf
         3ffqkfot3cTvWfKv56YxDNSxcGgNOREfzs5al7nG1zA1xuitbKHlhsaoyPbmgXoWwPex
         8UGg==
X-Forwarded-Encrypted: i=1; AKwUvBxQvqPdwxc/ee9qpXnaeZU8H9eA8/5H78sEU+Syeli5b2DXZVmSeMkPpMG0ge5iX3JF3aJHU1hD@vger.kernel.org
X-Gm-Message-State: APuU4Z/OEpjorT8NKpExbqnlJDH+h4vpSMSpdH6y7Ji7MU5vsqbOphWy
	nKG6XcvUpmw2fujKBv3dvow0KWavUY6t4wIcvqLm8vOistuTHTGkDKEP
X-Gm-Gg: AYBFou1eqDM5IwzTndMDYFMYtTg25iajqyS7RpWs/WsikDk1q+FNQRUnq8aU3YDT5sQ
	7AqyiBhCNshwnyDubio41aZwJEB5/oeVh/e9nLoN2xaEYSdgguIkHiVsHDK6p/eXpnSDtYii/Hj
	3i53fgzeyB0KmBI+Y1YbXcXd7duZUljzJcJGWfg+F4kdAr4wXW2fEhyj2V4hMycpbXcgb6GT1fZ
	Zf9+/MYNgtIgHoIBvUfTOu2QOzHF9kbRDxT1eXtiuqa7hnwoL26f4m54tApdlJ7jZ7LY2FWh0J9
	Ldd04h+vPp1Q+KwwFnjJQKA3bgJAnkrnmRQ5G6H6oWMK5PwfDHEDE3L+fUAKBtvBB8TJHR3YsUd
	WtzhLcWTUtxvCg2V/ZNTvx6+xnXn6c2hMG9n3ffX/d0D8JYcA5iBY4exGdHqoZMSRGI8dJJIJq9
	DLPfVl8kTa5OX+mtIAWz4ktrj4UIn4sKVtGh6/dOeW4Idqb0MTG8DJo3HmzG/69c9PSO79KAUcp
	3vX3XC4yKQVDMjo76hkDJWwGev41mWJzcNsi4q1kzTvxQVHkfHnw/aInVZ3EQnJR/bpuxHl3kW0
	gvreIW30AW620u91Nlg4WKVj3DTfIV/95YQNMTFb/XB9CUI9VwfgigGFXdrCR37s0i2e8idBfxD
	Zyiwf+A==
X-Received: by 2002:a05:690c:82:b0:8b0:eb6d:d887 with SMTP id 00721157ae682-8b2b678e12bmr130360207b3.56.1793835031679;
        Wed, 04 Nov 2026 15:30:31 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3098c313esm29215227b3.15.2026.11.04.15.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:31 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 1/7] mm/memcontrol: flatten try_charge_memcg control flow
Date: Wed,  4 Nov 2026 15:30:22 -0800
Message-ID: <20261104233029.3282438-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
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
index ffbcea28a608c..66f38efb800ab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2811,18 +2811,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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

