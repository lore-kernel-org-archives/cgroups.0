Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC7023A9BD
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 04:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064176; cv=none; b=ZgSWk7F9RL/gtrOksQqosm0zI+13j4izGfpjKWPvrLcIWXyrrHmCzTfF+oCD00ZbbAsS1rAx6SS2aU14ZuxsX9RFVCjfijxwL+w+iGPRfsB0sRr+OYl1srtASLEYy3pJ0lFNBmSDl+QP+0ucu2+gHsE31CWAsly2yU64QVQX7SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064176; c=relaxed/simple;
	bh=9IpPFSzcLdM/8SH0aciFnU7h9JSdrOn6A0jBLTwIgtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwTOu4bh/nPSWJ3wyJzFPvFrqqxZbIrHEdmU8wzLDMt5ZPMQFjosrDnIcuuMmiaziURsOkOQ8pI7Fhf0uECxkBB6n6544wsXXK84Q9NO5feBa4n1DSeDq5qlonZuOw76cBN91qCzQzFxwZCJnwg9n7C+0R3XAYOXTNbuuROsa9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YQxk98Sj; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQxk98Sj"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d319b84213so3379085ad.1
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 21:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064174; x=1788668974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
        b=YQxk98SjDJPDMnJlW4hOvuSBRj6k7+uyilsE4BVW92xcQAHTJqNvZ0dex2smaX3v/i
         Xia9beFQ5crg8Myd2W8qxZViVYSKhkxXkXEOhhsb1n2KlBVHYZ3V489oHXO3cb6bdVvP
         zXd2GpWvu/KSAWSPW0A6dN/MhUIAfmYVKF5+lWWmrqr6nY1FNR7eJFenTIDls800Vjb6
         3WaedjA3iM2v8WA3zoV7Xo2Onf6jqH4wY9qFGoa0ogvppIPkC8bI962Ru5VClykiG92y
         1A8RLvy9bk9fBiaDfT3kIR88WisOonG/Pb/aj3JHJRYgGi30bJX4TmQLKgWXg8zZrBDk
         P2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064174; x=1788668974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
        b=njrF6nQcYy7WRJ2EYrRYpYKi+P/syBmcmUHtzg/Mmu8XOzMKd5P4eX+KKO5ybumJcv
         ous3n6gofE6ecBRtqn0+hU691Rdqg8hXO7wSUu3pJyokMP8tIo8dFM2L4olis6wk35ww
         B8WWmlrN/wtIFwmmEipBo0veqlSie2/OHC0dxMuJmudnt8yrApSPTjymM50mhqGJpCim
         1meuOmZoysaeryiD2zlpajZUBrU6im/oZPjUeMTqg+9ioXLB41Js5pnANoTPtVyP96pH
         +8o4FlnfvM23HnaMSnnRpXpCrO8Lw9Lu1sf75AW9bvQZ+WwTrggCalQcfikLy/WCiJVL
         n2gw==
X-Forwarded-Encrypted: i=1; AKwUvByzsd9C8vtMcBUk//sB6S0CHhMc26rVMgM7ac0+qoSBI9b2ACaxkGuVLLqQjnKoyY+ts9e2RXHt@vger.kernel.org
X-Gm-Message-State: AFuF++kgh0CoZWclF6sMBRdAm83M4DU9W/fOiVZdtxuDCNx4LUARIu9Y
	yf3q++0/i0QDJkxv+lZr6nuT+XT9ft3K2aaDukXvi+M1go5IhD5NNfoq
X-Gm-Gg: AYBFou2ZcfbZFXD7VOGaIW0Qr09ufGs3EVfnkjc/vIS1h03+O2oMMVeW5+aGqeJFFRg
	uekNXOGAEP1mXTK1QHf6XAOuulE9Ohfe/wr6r3Q2RQ+ydfEgKnOqZ4ULPZreWw+tV4MyO4dA4CF
	53L/58dlxEZiN1xWefDP/lb8bxNiJzm/f4vzKy64eJ9jc/iWig3v3v+ryK2iGhS9TJVqhL69C18
	QL6AIVC0ClNJkCWD9oCcy4vudNgeV/UbyL9gJKY7m+Xr3L5AvHekx8UFqgTC29eXI9ABUPieyyJ
	yo5qELfjFGxMc86cnduQtru1oAUHXAzMHkxDBtlanHJ1xWAIMwSoOoCKJCNE7MEnTUZJOMFxquP
	/jaJPIR4ZBmFCd0lansueTHTbI4Uoo+Nx7m+fRa77ggaFXRZGGY3ou8/dalzd1qex+19lfs8DU4
	ZKY0plt8YrEindggzrFGYrJJ+JnvfCNNgCc2n+c11JpsE4bdIa2qhRDJIy3rHF3dpxvasyKk7LQ
	mmif59oyuVMryjHXxAVC7L7zmovkHHci5lB4ywBWyqTrAvKAioq
X-Received: by 2002:a17:903:1112:b0:2d6:3c1a:85ef with SMTP id d9443c01a7336-2d74e08b96emr156523785ad.4.1788064173835;
        Sat, 29 Aug 2026 21:29:33 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:33 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	xueyuan.chen21@gmail.com
Subject: [PATCH v7 1/4] mm: add page_counter_margin()
Date: Sun, 30 Aug 2026 12:29:17 +0800
Message-ID: <20260830042920.2280454-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Weiner <hannes@cmpxchg.org>

mem_cgroup_get_nr_swap_pages() open-codes the remaining capacity across
the memcg swap counter hierarchy.

Add page_counter_margin() to return the minimum usable space from a page
counter to the root, and use it in mem_cgroup_get_nr_swap_pages(). This
is a pure refactoring with no intended behavior change.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/page_counter.h |  1 +
 mm/memcontrol.c              |  9 +++------
 mm/page_counter.c            | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc87..07b7cb12249c 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -68,6 +68,7 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 	return atomic_long_read(&counter->usage);
 }
 
+long page_counter_margin(struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..109c08be91cf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5670,12 +5670,9 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (mem_cgroup_disabled() || do_memsw_account())
-		return nr_swap_pages;
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
-		nr_swap_pages = min_t(long, nr_swap_pages,
-				      READ_ONCE(memcg->swap.max) -
-				      page_counter_read(&memcg->swap));
+	if (!mem_cgroup_disabled() && !do_memsw_account())
+		nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
+
 	return nr_swap_pages;
 }
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..450543f4b318 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -46,6 +46,26 @@ static void propagate_protected_usage(struct page_counter *c,
 	}
 }
 
+/**
+ * page_counter_margin - remaining usable space within hierarchical limits
+ * @counter: counter
+ *
+ * Return: The minimum value of max minus usage across @counter and all of
+ * its ancestors. The value may be negative during a concurrent charge.
+ */
+long page_counter_margin(struct page_counter *counter)
+{
+	long margin = PAGE_COUNTER_MAX;
+
+	do {
+		long m = READ_ONCE(counter->max) - page_counter_read(counter);
+
+		margin = min(margin, m);
+	} while ((counter = counter->parent));
+
+	return margin;
+}
+
 /**
  * page_counter_cancel - take pages out of the local counter
  * @counter: counter

base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3

