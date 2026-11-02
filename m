Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793659866;
	b=s+VIhhPHoRPzS4u7eu11Du+0kDCBcoafu8PeHQP4gdzOqT+tKcjRzxqb/Wxn/zVO0SZE
	 ic+Fy5c90gkctLB07qsWY1vsw0IMc/HBf/p9G4mDm1ufrx+mxj9skycoU0IQcKwDI/vyV
	 PGnAEfIIm52NfbaHam7WBOFJKODPGXMxTcH+1cuBi9cxp8kD3wtE99+0/BeGE0rSHtGeg
	 UldYDfdutkJLrsfWQPT/HkjDTeBV6zz8FRN8dBZkbg0YXZWPfHDWIFmrh0weDakO9PM5z
	 VtrqKnOzo/h7VIm8dd0OsKrFPd4W2aSskES49vObCSmF66IcMDh77Mc6wnA11GZDySA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659866;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YsIHlK7moF+Sg9EM5XQG5yakBii09xJE59b2g1kveUQ=;
	b=0ckYDQ0HoXFwGg1570HQN7RuDgscx5lGSMS4SCVb/SbrZ21UNY1UwqsleX4ZwhP/AUjR
	 DVFCPK/lUP34tNjqVJ7fnHkNZGD1PZfgrUeYIZVDxZFhWm9AVjYCraTGOcXUKfJIWZlc/
	 +yAsmMF9w+deeMxhR7GRTGEovqaW7LLb4AiwXmTdROYGF1/r4R2TLFE3vyCFRfhYavfZw
	 jEQiaSAnOVT2Zc05XpdTJGQdXy/bizSc2ALXX71JCnTca8NkBXCQot3WmyzaicnqxTcXn
	 X8sFwQl4ZeozN7DxM0beL+q9qrQgHa9zvX3WFy6/D1HNlduUUjoaC/05vMpox4oJccA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0gtWqlqN;
	arc=none smtp.remote-ip=74.125.224.41
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC79606A329
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 22:51:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FC79606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0gtWqlqN
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6798af41644so2405480d50.2
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 14:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793659865; x=1794264665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YsIHlK7moF+Sg9EM5XQG5yakBii09xJE59b2g1kveUQ=;
        b=0gtWqlqNdh2hiNOsAQbcqqPGarO9IufeTmqtlKlUChQ0E3vkhfa9z1k0vzNUWXaEPq
         W+lXNETUM8kMeLwCKanMnBFPO6iq8GphRD5dCzjJlP6BOkk1o5elSSuY4BIwu0ojTV1r
         cIAL38HjsC3mRbMUYeUc65duE4i5M14L1gSyhR0srq4+eZWZVZby9hgD/JjiaUKUw5H7
         kzW+fD1ZpwfGvmHTfG37f2kvho2uhliQTT7OLpzjbfSyMVCU37EzAGjUiZ4UOZ7i4CNx
         y6qSz3zulNxF708YNGQw77psoK6vjI+hZZ3vDz3P24ZVUJ4drGRmKoE3v6R46+U6tIsj
         CONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793659865; x=1794264665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YsIHlK7moF+Sg9EM5XQG5yakBii09xJE59b2g1kveUQ=;
        b=MlTCpcDZkAyYyVS6D9QQz2SSdkDq210U5tkSimkHoEVoAyOC7a1luvGJ5bl8D/TH21
         jtm+D3BAA3fVdT/i7JtMC/Tcg+rtL7DB/w60/qY3WJ89UAAQFyydLBfaSvLXvhQmf22a
         a9V2yP7ILLB1LGH1uQCvidPybzl3Ezr64rURZ/0453LUzL/ferOcL/f5crLUy7Y+iDg7
         EJU/MTT+0MSYe1Kw3geIC87ogNTv1vhsUpMVIjCYLGkKy0rIxJNG15aswiG4Z3ZV53QC
         3KyvernkkWXA0NHOE68JKYvLXxIVzYvrIamg8ueybFHXKTTCpWT14a7geQYc9AkpGg8B
         urwA==
X-Forwarded-Encrypted: i=1; AKwUvBwXUB1Z3Yd+6NkxmaYTUHW5ANWCA5Es/QZZN+gkRZjR66HLca32wwWoQTA4ZgW3EQzIeFKSoOau@vger.kernel.org
X-Gm-Message-State: APuU4Z97b/ouYB7tDG8rri2GsM5cb7qki26BQJm4lepqTpywCgAxlPi/
	x35oO1ZpW6S9QfLZzAyKinxErhQ8Ejq10EkVxwcKdGku2Rlfro+t6rjx
X-Gm-Gg: AYBFou13+AVOL7PSuyPgVfMrituLojtIhW/cMw+0Nz/w3HvIlFRMMZC5gX3V/CT910X
	YvkoR+COxAWJiRSKUFgewvPeBgfIYHD7+42gx5l8LsSpWPsKjSWtziBGSetCKckD97m/kRfukvK
	t3mf229K8xYB7W65MtfWyJLqb2XPiHLCN9P6whL0HXZtnAL/YxKd7Z32UxL8eMVG5/tZQNTGKOM
	cTSNghxWCLobc3EndHHMZE852QftSBRKR3egHVPWsNJTsEINEsgLTHNOPufZhXuj+RpkLpFquS8
	rBE7ENK56vQXc9feya3j4Yje99rTbTYfWl61BKvkbBcDTAobA/u0Atcil8JXL5PEG2p5qYcp8CW
	VMH9VNq8eTC+AvLZ/XzCE1CYLx4n/bk205PgrnSttRx7OnZZslIomnUUrQPJ1CP2OK5PyFMw7vj
	2GcRd1Zr8jnI7/rRi7S8lQsSOj3zskPgUEGVJFvvTYc089jJ2X08CBrllwHJf3K3yTEKtsoZQ9W
	/CeMTX/n9VL5tyzImFBdiYO6JKJ6nLMD+PbRMuZHBVN9pKrZecIH/CEyCR+tE7Vw5fa/M4hm/eG
	AJo4QX4yJFO4jRjHoAJMrG+E/Ud8pR8qmog34uCfQ73jqi6NeKnudNzIs/b3cu3+2UZRVx7TBF9
	COZaLeL4Bce4hXnJmjBHTkE9P4JE=
X-Received: by 2002:a05:690e:14ca:b0:679:c4e9:b645 with SMTP id 956f58d0204a3-67ba4c90a9emr8088319d50.4.1793659865073;
        Mon, 02 Nov 2026 14:51:05 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67baf2b138bsm5940925d50.9.2026.11.02.14.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:51:04 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v1 3/3] mm/damon/core: use node counters instead of flushing the root memcg
Date: Mon,  2 Nov 2026 14:50:30 -0800
Message-ID: <20261102225030.2743129-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102225030.2743129-1-joannelkoong@gmail.com>
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
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

damos_get_node_memcg_used_bp() flushes the memcg stats before reading
the LRU sizes of the goal's memcg on the goal's node. For the root
memcg, that flushes every cgroup in the system. The flush is not
ratelimited, which means it happens every time the goal is evaluated.

For the root memcg, the node counters hold the same LRU sizes as the
memcg rstat stats, and they are always up to date. Use
lruvec_lru_page_state(), which reads the node counters for the root
memcg, and skip the flush for the root memcg.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/damon/core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index bcb6395d9f66..61d92e572c53 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3049,12 +3049,17 @@ static unsigned long damos_get_node_memcg_used_bp(
 			return 10000;
 	}
 
-	mem_cgroup_flush_stats(memcg);
+	/*
+	 * The root memcg's LRU sizes are read directly from the node counters
+	 * (see lruvec_lru_page_state()).
+	 */
+	if (!mem_cgroup_is_root(memcg))
+		mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
-	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
-	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_ANON);
-	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
-	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
+	used_pages = lruvec_lru_page_state(lruvec, NR_ACTIVE_ANON);
+	used_pages += lruvec_lru_page_state(lruvec, NR_INACTIVE_ANON);
+	used_pages += lruvec_lru_page_state(lruvec, NR_ACTIVE_FILE);
+	used_pages += lruvec_lru_page_state(lruvec, NR_INACTIVE_FILE);
 
 	mem_cgroup_put(memcg);
 
-- 
2.52.0

