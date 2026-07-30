Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54673FF1B5
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 11:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785412465; cv=none; b=hEdjabdoFIBXVLkTKsDGhVJ5nlsRVitfPABaDcc80L6vQ8TVIbZ3jhNpET1zw0YjOCDco1+JiZChK6vR708g0PIO7g7EINfRiEw9iahm8u/jWUClx+CA6JW8wLvFmI/zPdm9YZQOigCecXZUfc8C0gKCv2MWOIoUVbU7eC4NnpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785412465; c=relaxed/simple;
	bh=h+sMLeZfRIlfDEbmZmcgzOyTDkuRoPMynSmmJE5AoBw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bFkg0G+wg9b36z94KrYcvHyaaq/XjPnGsy0uQBSPU8JVNsnBYAUvec99f3jENS8qmM9Uv8MfV2W64UT1S3LY1gJgfZ0DG5iCMq7e06pJY8xSBLv4d5ezNG1eTcufKD2XZoXO0LzKrZp5mGDCXM1Uc7FBmc56WcpqFPcSsu6mxTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ltZxcP7t; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ltZxcP7t"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785412460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ti2bSmazGTeJeWuqEsKxELAbB2h/8DFLycOObfhZA2c=;
	b=ltZxcP7t3+OjBynxx5eUHF4NPsMADw77gEwHiFN27N1wa/6uj5b0KtDS09qnl70esX3g/P
	OfpcZ1n9roz4V4PhzDlvoAlEoque5p/Xel7rhYs3tlBwdc+xDsCo56T6y4Y0NrQbh5VrYA
	p0n+Zb1zGpsF+8rNSKmuYp3ZeaJq6fU=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Finkel <davidf@vimeo.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Thu, 30 Jul 2026 19:53:14 +0800
Message-Id: <20260730115314.1069089-1-ridong.chen@linux.dev>
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
index 60145aadfc5e..881e7c459c64 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4692,7 +4692,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 			  loff_t off, struct page_counter *pc,
 			  struct list_head *watchers)
 {
-	unsigned long usage;
+	unsigned long usage, old_watermark;
 	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
@@ -4700,11 +4700,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 	spin_lock(&memcg->peaks_lock);
 
 	usage = page_counter_read(pc);
+	old_watermark = READ_ONCE(pc->local_watermark);
 	WRITE_ONCE(pc->local_watermark, usage);
 
 	list_for_each_entry(peer_ctx, watchers, list)
-		if (usage > peer_ctx->value)
-			WRITE_ONCE(peer_ctx->value, usage);
+		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
+			WRITE_ONCE(peer_ctx->value, old_watermark);
 
 	/* initial write, register watcher */
 	if (ofp->value == OFP_PEAK_UNSET)
-- 
2.34.1

