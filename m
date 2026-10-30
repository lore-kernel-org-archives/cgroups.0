Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393685;
	b=INgkEn8poAIWCLy6nsoq8GnMLwhyEVh86kjIWTXX1rKck6xniy4vgU6ZPnFs41uVooHt
	 RTiQ7u4PbEkixGXSRNIJ1JvSCXDV1btlKJUyYmMEXgFLmy3IQyY0k0zbsvYmcuqJ+f5Tz
	 fyeNJe8apVnuDQsSLz+onoAhhgHKbTZhT/MKDXwzZzjyXnqMKbW77KPntqDPrbP8Ccqma
	 BjbRcdTfjfTyqZO3owgH74OErsdb48huIyTezG2SdQqc7guEL9C/IbtMyDv4LnTYmMjeY
	 iAC/w+DfoArsif+qKeEln13GLGq5CEWhU51A4B+QVD9HDCOciQk86V85fIqZGpzVqLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393685;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WvB6ePpKWWKwFI9dveLQEwy+mNq3q4b5hvoyCK6cGIg=;
	b=ues6tGUWJ8o6DljnDtIgbsEXkY3oYusVobFPXIkNXocvCK1od3/+AHm74HmhnaIetMfl
	 BumD3qitF9pbb6pDTZqMWcsoN4C0As8jGAlDybvTGerL8+KhWLqkMcAggmESVREnNuf5x
	 iIyH+rshxnwsIizmQx5e7eLuW+3VZ1MAS/d6tpgqMQLvf8jkp0FrUPemaz1GRiun/KdDM
	 EVWCHwKF8C6lx1Nz2r4d63sDG3nJP8A0BRI+bpzr5UG+pmGW/wrbpw3iO1BZ0UXT6YSuX
	 sQkjM+UJt6JswVuRWnF9fcT3RrV4VUEz0yuB5a3GW8S7wu+Vkzw9Zy7dsxqbSrTRuyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p6NdYS5x;
	arc=none smtp.remote-ip=91.218.175.72
Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E734606A323
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 20:54:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E734606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p6NdYS5x
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PEe7LP+ea1c/6uQpUdYkMtQm9r7KkVekkLLCHeCHzrQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393682; v=1; x=1793998482;
 b=p6NdYS5xu4Ofo3c7yLwGkEcBjz1wod2WxK6ICnQ+wq225o/TkjQYwGwM4h2TjCD6+B/KSu0f
 yWOLwKsoxbx81L8sko6x36MgAhTQ6w1AYPZrZRamW56w9KZfUiGrpM0H7Or/y0iGYj0eQji7C5u
 aoaw6OL7ZJWIs/pgs8LN/ZHk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9e68337c290a835a;
	Fri, 30 Oct 2026 20:54:42 +0000
X-Mizu-Trace-ID: 9e68337c290a835a
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 3/5] memcg: use high_work for kernel threads
Date: Fri, 30 Oct 2026 13:54:14 -0700
Message-ID: <20261030205418.341214-4-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030205418.341214-1-shakeel.butt@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
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

Kernel threads never return to userspace, so deferred memory.high
reclaim does not run. Reclaim and throttling during a charge can also
delay work they do for other tasks.

Treat kernel threads like interrupts. Queue high_work for the first
cgroup over memory.high and skip reclaim and throttling in the charging
thread.

User workers created by create_io_thread() and vhost_task_create() keep
their current behavior. Vhost kernel threads use the new path, even when
they borrow the owner's mm.

The worker requests a fixed batch of pages each time. A fast allocator
can keep usage well above memory.high. Kernel threads also skip
memory.swap.high throttling and its high-event reporting. The memory.max
and memory.swap.max checks stay the same.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index af95a4574a0f..42bdaaacafb7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2708,6 +2708,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
 
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
@@ -2726,8 +2727,12 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
 
-		/* Don't bother a random interrupted task */
-		if (!in_task()) {
+		/*
+		 * Don't make an unrelated interrupted task handle this charge.
+		 * Kernel threads may be working for other tasks, so let a worker
+		 * reclaim instead.
+		 */
+		if (use_worker) {
 			if (mem_high) {
 				if (allow_spinning)
 					schedule_work(&memcg->high_work);
@@ -2754,6 +2759,10 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	/* Interrupts and kernel threads stop here. */
+	if (use_worker)
+		return;
+
 	/*
 	 * Reclaim is set up above to be called from the userland
 	 * return path. But also attempt synchronous reclaim to avoid
-- 
2.53.0-Meta

