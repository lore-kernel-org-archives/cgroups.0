Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B349E45D19E
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 09:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093294; cv=none; b=C19Fr//SXzYLPdrmHC/YPpVA5oBZ8wN0KSQzTfeegz4azHO0zHUotnOPLIxv2XH8JaRJIFJp79XLlV20t6QVP5ktGi2YAEFElKaL3F2Fi+TppofiqfNRFD/WJhBzMMstqU6WlQ9ZfEb6W1EGebQgcNedzMGT+V7OGVIHhz5kqh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093294; c=relaxed/simple;
	bh=RX8z9I7OnvV2npprIz+JGsArP2imG52U22R46ndOGIs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wd/uiv6VPM9jIMaRfXLfiVdSGDD5wA+C8LHO+IU163wqsTgZXtNldicPGiYpLAcIfX99H/EUHpOQd1qWmyjFR5aypwH+8DpDOnj+K2IsDbB1wgaGnZV6RAWO8Vw6Idv9M0C6i7Ady4fO550rAzSXc3fJcSV0l0jG5CJvqolC0WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pO2RGrX0; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pO2RGrX0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786093290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1NsqwCylIQfggUS/ZnqvTGsvf2SS7Ne6C41Isj65uBs=;
	b=pO2RGrX0w7v5HhK+rJrWAW+Dx1crB29AW4wfl5lJuRzAwJYJlA0kcUK6n9xu3fL0BYM7FW
	6ek77di8TrigMxcEobIEXgXiLuF9HObGxVQh3o/13a8nPOAsz3YMpIajZL/ss8NnuV+EgB
	OEhNrrjonR05/Y6EVQL5Kzz1ALEwjAo=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	cui.tao@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 2/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Fri,  7 Aug 2026 17:00:00 +0800
Message-Id: <20260807090000.1532495-3-ridong.chen@linux.dev>
In-Reply-To: <20260807090000.1532495-1-ridong.chen@linux.dev>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Ridong Chen <chenridong@xiaomi.com>

Writing to memory.peak resets the peak for that fd only. Each fd is a
watcher and reads back max(its own value, the shared local_watermark).

peak_write() resets by lowering local_watermark to the current usage.
To keep the other watchers' peaks it then walks the watcher list, but it
stores the current usage into them instead of the old watermark. So once
usage has dropped from a peak, a reset on one fd wrongly drags every
other fd's peak down too, even fds that never reset.

Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
collapses to 1060 KB although B never reset. With this patch B keeps
reading 410624 KB.

Fix: save the old watermark before lowering it and use that to floor the
other watchers, so a reset only affects the fd that issued it.

Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2da55b778ae3..28577beeb3d0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4746,7 +4746,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 			  loff_t off, struct page_counter *pc,
 			  struct list_head *watchers)
 {
-	unsigned long usage;
+	unsigned long usage, peer_watermark;
 	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
@@ -4754,11 +4754,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 	spin_lock(&memcg->peaks_lock);
 
 	usage = page_counter_read(pc);
+	peer_watermark = max(usage, READ_ONCE(pc->local_watermark));
 	WRITE_ONCE(pc->local_watermark, usage);
 
 	list_for_each_entry(peer_ctx, watchers, list)
-		if (usage > peer_ctx->value)
-			WRITE_ONCE(peer_ctx->value, usage);
+		if (peer_ctx != ofp && peer_watermark > peer_ctx->value)
+			WRITE_ONCE(peer_ctx->value, peer_watermark);
 
 	/* initial write, register watcher */
 	if (ofp->value == OFP_PEAK_UNSET)
-- 
2.34.1

