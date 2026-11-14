Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616202;
	b=ZjHmwMdTwxwsHYtV765qaD6S1L20c9QL+5JfDmfE4ghQRvUT6ARiJntLKVFI4/k+C5BI
	 cg2o6GW32eIasmLKY198K4ik075DM1C7mbwJdxIhDYQKFD/WzEKvYNAjBUD7fywk1Hr8P
	 6NBHYqj0OzgKdcHV8RSTwSuYdFe+sdkqK24+JKYZd5ZeCoJpMJ12z0pfPNWts71g8H33+
	 HWJofB3ZP3ZT1ECh+se19Aj2y4+RCzGHPRn/96EH7XNJDum6D5sUQ0G8IfE75GRYa+Q0M
	 AnK+6wQqJ/wI7a7EG2/LPA4GBHn0hFHHRQ4AhYkQNkNIf3hvcUg3/W/sJcAlsdnRQbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616202;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JBroOjocv6eBCvG1grylAnibv/9seMQfy8rDwVLFt1I=;
	b=zTvh5PyiIm8w5LTlWK4GxZI3lVDI4KGfG2z+5/3oaytv4duwPtCBtbulQKLnMyLEJUQ0
	 sthVOiO4IebRw5HvqXwBNVpt6THGyj5Cqif8IvsrDiHnyjIcEDXlRY4rOJdF5cHbjwCwC
	 3QnGQFRrcBnPXyzLMrMiqCDXgQzSgyq++0jfglUvMHPcLehQgKbkjR1tNI3RhJEZR25ij
	 Gr9IqRbDy+Ei2k5Fk2lTQWiFWmFli5aexbw9Nm2EO5Gl4VaH68tV3g3DKDHDc07D8x5VC
	 1Xh5xIaAjRgacBfhuS5tjbxfnwJf1h1UGUbp8hWLG15kC0U58yAV9zb23pl6boBtoNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rVZK2VGn;
	arc=none smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48CF606A335
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 00:30:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E48CF606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rVZK2VGn
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b394e2af9cso12249387b3.1
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 16:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616201; x=1795221001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JBroOjocv6eBCvG1grylAnibv/9seMQfy8rDwVLFt1I=;
        b=rVZK2VGnT/zw1MUlc7AG3Wz0nWcL3jNoQ5BtmFk9lQcAH/OiiL9gJaY/JVzWB5Sbxj
         IlNmJHY52qmmSAOGaQHhLynmGcz7vd6cQELlnR0f07GJZRwxYqtsU83y1Dt6fzeBr+3E
         IWzcZuBEI55sYb3zGGqBQnoaDoqHWNt77Ubu3q4h+TLvTrQj4gIEcH/dYZ8s81S2ebEe
         DSortlPUsqFF9SQiiEuErVgpaaNykJigbbHuupKRTjCQ5E0U8IxTMK8PcCA6sPDPgVvF
         TjPxlE5hM8LaeHIIbmAZgqNTTVWM337SU+q967D5ny4XCAClk2pXa22M4KitklXJgYXA
         cvzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616201; x=1795221001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JBroOjocv6eBCvG1grylAnibv/9seMQfy8rDwVLFt1I=;
        b=lwOIFkUn+7DDwqHsE+phm83chxUBrtj2tA7uZNyOj6yHRADvaWwwnQw59Em2NGGODN
         jVfVda7FDfIoSw/2P35xY1yChc8SSfBq5EwH9MCMdffxxmKvrJn9ErWCz3VoQ6KtUtBu
         1v7D+g+Nlx9vBaA2Z/eSDoX9ffqyK503f/l3E+1w5OTluZGNAwK+9wZYcogtD1s6GXbM
         YbTrnD5UEw2a1QNFg4Hy1suVeA2n/aGsehRpH/CZ4g7doHZ7LEGM1XWZBk97Q3eNiWWe
         vYMeuq61Qe5FTrfde9jxXzpIUoUXGZerAInqqBQmHzs+7XdQKvs6HTH2oX12GIPhe8pV
         5oig==
X-Forwarded-Encrypted: i=1; AL+hErGqhLGqdeE/80x/ufUDZBZlu2FMK/5gUlPWBac3IroF6Tv6/G57E1nViBqq8SO+KcqnIVMe6CRy@vger.kernel.org
X-Gm-Message-State: APuU4Z816We37Ohqw2z9qVS1GL59qDnJksXHLNZymUYbxE+dQCy4uyKH
	SZwTXjiDCV19nvEgXhbFD7kV/9G+uxwWdrD9SE+3RCqNBJHPE97Zy+RK
X-Gm-Gg: AYBFou0njuuJtb/6cbVEt67nmXS3yYPlS7spUA4iVouR4FDp3W5DA9DEsW7ZTkCPnOz
	LCcedML3PMKuTjA1gm7prqLamJjnNugVRZAVEttA5knaGq3IrNLY4ynOKXvdYQG7i6oqg6enujw
	vs9AcOoCXk2krGv3JGDm8q99S0DOWW6fSb9ogBpPLzOv93gITqSqaNWVBhaoanebXTnBsz303Qe
	XIvCpRJNwxzXUXepM9IHNGNZnI+bn8Z5ie/aSoi2+yVLB5z4I3XLx/k7xD1+Ti968Jok6zvCM3A
	rwRY3UDAya2DHAHzKVOgKfoSt8aspONkMjB8tFe+7Ro9Mpn1G70ozRUECiJpKjwd8aJElh000Li
	6G2+5lA2Rm/Nz3G8scm7wziogA82BjxwMNSzrGYdHEEUyvubGOqQUz8NMIKsVT2Jx89N0xn3QvW
	lGciu+EhO77Dw6cL+JZq1EAzamu3erhsnDUORDrSVGMoelGuv2YF7VVkHKhKwBDmrZCJDJzMKlq
	x5sVKw2aAjzzEi8uGGYewNhIHrGnfGH25HI2uUPhwOUjYyJvzQO9EIU5wAEzzOVDrpMxDbQLXpd
	t6Pkjnew6gPKMinhi3lPBGITZo/maqEd9nWRgbonWfptlDM+FBvfs/TB+kW/t6MjVGrSgAMtxXj
	z9Z+R0xNUs/P8oJEhJfS1vhTPkLM=
X-Received: by 2002:a05:690c:e251:10b0:8b3:23f3:134d with SMTP id 00721157ae682-8b4aa2b33a1mr16832317b3.42.1794616200944;
        Fri, 13 Nov 2026 16:30:00 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa96b441sm33820597b3.23.2026.11.13.16.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:30:00 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: yosry@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v3 3/4] mm: workingset: skip the root memcg flush in workingset_test_recent()
Date: Fri, 13 Nov 2026 16:28:21 -0800
Message-ID: <20261114002822.1043378-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.1
In-Reply-To: <20261114002822.1043378-1-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
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

We can skip the rstat flush in workingset_test_recent() when the
eviction memcg is the root memcg. lruvec_page_state() now reads the LRU
sizes of the root memcg from the node counters, which are always up to
date, and workingset_test_recent() only reads the eviction memcg's own
lruvec. This avoids an expensive flush on the refault path, as flushing
the root memcg flushes every memcg in the system.

For reclaim however, we still need to keep the flush (for now) since
global and root reclaim also read the rstat stats of the child memcgs
they scan, which the flush is needed for in order to keep up to date.

On an 80-CPU machine, a root flush took 69us on average with little
cgroup activity and ~0.9ms with 128 memcgs actively allocating (wall
time, including waiting for the rstat lock). Reading a node counter
doesn't add any cost. It took the same amount of time as reading the
rstat counter (~150ns, which includes bpftrace probe overhead).

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..383f951eaad4 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -483,10 +483,13 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * section (for e.g, in cachestat) - these callers need to skip flushing
 	 * stats (via the flush argument).
 	 *
+	 * For the root memcg, the LRU sizes are read directly from the node
+	 * counters (see lruvec_page_state()).
+	 *
 	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
 	 * still needed here?
 	 */
-	if (flush)
+	if (flush && !mem_cgroup_is_root(eviction_memcg))
 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
-- 
2.52.1

