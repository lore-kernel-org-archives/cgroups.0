Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793835040;
	b=kjfpj1+DgjsGykteI3d1X+0HBE3wlnnoyEHraQBAWhmu1sI7TiyUUrOzvrHPMTpMvooU
	 E8DY2mMqmTDQml3PNI/freNZf7Ay9L/oGOmWLW7PO76VzK6q93IbEpD/pM+i4KWWDOjMz
	 dxuzivBd8lJ7tMdqO+KiI8oaw8q2iK65/cu16W1zQgJRyz6oMtAyy5vWr0+9fYiPxW7jW
	 cG9iBHbCeip4jbWDvXfPYWnuBkInpgF5VGns0lxZLz4iPDhFfYFA0BChsO83sZVgH7pAv
	 RpuufY5idkYU2PwM23AD1cNvvy54DPcwF0OPC/ySKqS5Gau9ALc78Z09PSS/hwBKB9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835040;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ggbUr+h/DO3QjP9CyAwIHdrs2V3aX4kc9gb+lFsYkgc=;
	b=34HfiNAtbt9ngJy6ivxG0H2pY29z75gUw038d+8QKNyOGN1tR44w+C9poKAmzh+vWFhH
	 xNAALJ/3zh45pHXJa7cyb/Mx3jjuNjgfm9aHEuNPVLmjJqdj8YJ2uc0NxbQ+22gUCcI9/
	 VWy3jq9BEjYJeoBSEHcLqVuiNlp+w/mw4f7m6pC23Ou/LZE5QPID+m3zA2gaWu89khz1Z
	 t+48kziZo9ajyjYYYIhkUyrVClJDpk0cgXOthDHG16WOk7UC759OPJaefO9sS248XWH0I
	 xyMdC3NcW+LrNmHCU732RNS+BtJXO2WbwHVDwkyulEMIODWDQqkwu7BHDDvgpwByyMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MJlCjwzy;
	arc=none smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC6D606EEA5
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 23:30:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BC6D606EEA5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MJlCjwzy
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b0ca1ebc8bso18296367b3.2
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 15:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835039; x=1794439839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ggbUr+h/DO3QjP9CyAwIHdrs2V3aX4kc9gb+lFsYkgc=;
        b=MJlCjwzyqnTdLTUTsS3vhlj1KADBHww2829z8Kr7sFOSGbF7LrBSSkBk3sNYv7ORjH
         5BOgYnWzG6zYJQFu5tH4whLZRO5pV20ibm++CEKb4Mt0VnCY0NgjLa+t5KXp1ugQdCR3
         1xx8JtRHtwS9dQ9mTMHvL9+JS4tQuoS5yIo+Pvu/9MXaTRhmMzYPKsBVfEDBzhNaYXsy
         KQ/sCKQcavAk+mAGye4rmOtIUBieRXOMucKgr7MKPB/nhtid+MBiLFtRN0WaICM3D6eL
         ZWd9Pazgh+e6xZuTgPMSxu/9TK6a4zolRcWXo8nAAND/YcWvCNMOHjC5aHsINmrfN/Yd
         Kwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835039; x=1794439839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ggbUr+h/DO3QjP9CyAwIHdrs2V3aX4kc9gb+lFsYkgc=;
        b=EbY00zzpi4RcjBg2+M0c2lIzCi9N+2uS5HgLccdzkNP21d+Wr+08fapsdbEt35cgBc
         hDQzZrB46tkEaEvwMx9cNX9Mz/sS36SBVHtHWm4BgCCOKyXdxfamlXqJRHELhaGqa/Wy
         uRFQT5ObWm9EQY3WwFmhRg7RRij4li7a3VcIsWt/STMUAdoAUXu9kT0R9Gc1eaR/JYVb
         FojdH9ejjEGNaS4q1iasqmVOFuihJR0K0eImXX57NlkyOrW/EbYNeaB17wjCdzZ4DMzY
         UKTv4KtzUYTkNTDRbd8tD15mBH+RH2eVOiPhqZhNErJxnxEPCtQDpFUWrte8m4Gt92p7
         dTFg==
X-Forwarded-Encrypted: i=1; AKwUvBzrqqOy9m1oBwcZVM+4mAshYBClNfse1INIJAICOPfcMTaJauw++OMRQFEEWU5YxIPuu9lZiLUh@vger.kernel.org
X-Gm-Message-State: APuU4Z/ZkCZYeAK6wm3zZscKJCqh+qEgBc9NPmAoVEVJWbZSFtTHRvp0
	F088+jwo7oC68e8E2CWSooWkZgLilUKtsBjCgFbXdxGs9q4Irhv2dQUj
X-Gm-Gg: AYBFou0cQSMGcIMhrhaWC5GuI8tTo3LCvBvSSrg+siog/q1Vx4jpE3A/nL/1pzim2R2
	QlHRSs3MxhAJqUsmDD3dnsoOI9RcfhlGduT2qwy66ARvkzb6mpW0nacDdA+a2ufm4j8/z0xMwV/
	mZ5p6ScIbxyLZ6b88s1EgH+iYY5iENZ7TtXVG+3RTcqcy2p4hoLQj7WgyMsWM2K/1fA6uUIq4KG
	m2MMgC8wbUMP52VlTdAlfDZBhyXOpRluklqGWRNez+LNf7xUi6W1RcsJz3wFIemg9T0s5vMV4XH
	fXmO8KReTD4T70N/Qy8lJ8fw+6YVk4WgDqh+S0As++8rcbCDCh/a2oOf8mRyEscphD57XmaDBI4
	ffKwShhs6eh62oXR7FIonb7Ba5lfgFEdbRHyG2b89ZuTHudKKqoIu9vjZ12jl/6dZ9Yz7ZeaalQ
	L94pRxFIjyFrLpmLojNpobSp20K4hbwsMFepchaCS/ZUTCA92Hb5AlXqRQEsUIlvtMGVCK/8XyU
	nKzazwywI7hXuJ2BxoLjnmBduQZbG97RZQV5CBOy5OPY5FdbpWs6J+E9ev1zO+0/IJUaadyjDn9
	MBvii2o4J1hMghYXdJbcMx1UTg1+iMZy0jtHe1J+UWvT82ztuZxlAdZTJX0=
X-Received: by 2002:a05:690c:660e:b0:8b0:ad5b:d487 with SMTP id 00721157ae682-8b2b6594f19mr132717817b3.2.1793835039309;
        Wed, 04 Nov 2026 15:30:39 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b309bd35c7sm29091047b3.44.2026.11.04.15.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:38 -0800 (PST)
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
Subject: [PATCH v8 7/7] mm/memcontrol: restrict memory stock to leaf cgroups on v2
Date: Wed,  4 Nov 2026 15:30:28 -0800
Message-ID: <20261104233029.3282438-8-joshua.hahnjy@gmail.com>
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

In the old memcg_stock world, non-leaf cgroups in cgroup v2 were never
directly charged (except for reparented objcgs), since processes can
only live in leaf cgroups. This meant that stocking was exclusive to
leaf cgroups.

In the new page_counter_stock world, stock belongs to each page_counter.
To get parity with vanilla stock, prevent stock from accumulating in
page_counters once they have children. This makes sure that stock does
not get stranded in the hierarchy, unable to be used by processes that
actually charge. When a parent becomes a leaf again, re-enable stock.

Prevent stock from accumulating in non-leaf page_counters in three ways:
1. Clear the parent's memory stock pointer to make sure the stock cannot
   get refilled in the future.
2. Schedule drains for non-isolated CPUs that stock the new parent.
3. CPUs that are not drained due to either isolation or racing with a
   refill are cleaned up lazily. The next local stock miss on that CPU
   scans for any stock that has been disabled, and will drain its stock.
   Note that this happens under the local stock lock, but this is rare.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c   | 28 ++++++++++++++++++++++++++++
 mm/page_counter.c |  8 +++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aac987ebaab6f..a7549fd06d93e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2185,6 +2185,22 @@ static void schedule_stock_drain(struct page_counter_stock_pcp __percpu *stock,
 		clear_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags);
 }
 
+static void mem_cgroup_disable_stock(struct mem_cgroup *memcg)
+{
+	struct page_counter_stock_pcp __percpu *stock;
+	int cpu, curcpu;
+
+	stock = xchg(&memcg->memory.stock, NULL);
+	if (!stock)
+		return;
+
+	migrate_disable();
+	curcpu = smp_processor_id();
+	for_each_online_cpu(cpu)
+		schedule_stock_drain(stock, &memcg->css, cpu, curcpu);
+	migrate_enable();
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -4308,6 +4324,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 */
 	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg->private_id_objcg, GFP_KERNEL);
 
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && css->parent)
+		mem_cgroup_disable_stock(parent_mem_cgroup(memcg));
+
 	return 0;
 free_objcg:
 	for_each_node(nid) {
@@ -4360,6 +4379,15 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	drain_all_stock(memcg);
 
 	mem_cgroup_private_id_kill(memcg);
+
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+
+		if (parent && !css_is_dying(&parent->css) &&
+		    atomic_read(&parent->css.online_cnt) == 2 &&
+		    !mem_cgroup_is_root(parent))
+			WRITE_ONCE(parent->memory.stock, &memory_stock);
+	}
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
diff --git a/mm/page_counter.c b/mm/page_counter.c
index e1feb2bd1e225..7a3b7cea0ff94 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -158,6 +158,7 @@ static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
  * Consume the cached charge if enough nr_pages are present, otherwise return
  * failure. Also return failure for charge requests larger than
  * PAGE_COUNTER_STOCK_BATCH or if the local lock is already taken.
+ * Drain disabled cached counters while looking up the requested counter.
  */
 static bool page_counter_consume_stock(struct page_counter *counter,
 				       unsigned long nr_pages)
@@ -176,12 +177,17 @@ static bool page_counter_consume_stock(struct page_counter *counter,
 	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
 		struct page_counter *cached = pcp_stock->cached[i];
 
+		/* Drain any stock that is disabled but hasn't drained yet */
+		if (cached && !READ_ONCE(cached->stock)) {
+			page_counter_drain_stock(pcp_stock, i);
+			continue;
+		}
 		if (counter != cached)
 			continue;
 
 		stock_pages = pcp_stock->nr_pages[i];
 		if (unlikely(stock_pages < nr_pages))
-			break;
+			continue;
 
 		stock_pages -= nr_pages;
 		WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
-- 
2.53.0-Meta

