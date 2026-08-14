Received: from mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E01433D4E2
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 01:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671021; cv=none; b=QUlF/rnpTVgasWvy5dWDUfoJ7cKwITzmJTz3w7AblV0m77oCLcJdWaW8Lkx96eyD0UsHOJM38kpMQeU3G+mCCgb5GxaWgUcAUfZAiAP5RqSxjBZTWcy9lriDY/Zv8f+eSwojxslQC2y/tMJWAuXjK+Qyy6wtA2JXhIFVOgpZsCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671021; c=relaxed/simple;
	bh=mJVpl+4xZO80M/OyNFMbUx08bRvBm8AGaGXAAVqZKA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tWMQ7QQikUBpf3jCgOyxvc4S+7nn8L5c1kv7uwu6xNRRARwNnUgvsA3UTd0Q8IOlVM2PYHiWy1C6I83f17UNQm/synwytZW1gkM71YuegJAD5sXIpy9KjpketQxbkW/UWQ7BEt3q+uW8DTKW8EFXTDCIFIWa2cOxMt0soxvEHw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DY1hXoZ6; arc=none smtp.client-ip=95.215.58.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DY1hXoZ6"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mJVpl+4xZO80M/OyNFMbUx08bRvBm8AGaGXAAVqZKA8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786670996; v=1; x=1787275796;
 b=DY1hXoZ6vTmcsBXsYod4ZqC5V+KXAxrFf57kesxFOQRMAENF5GuaCE468aJspN4VQLLlo+Ap
 Jr55opKuLFMIdV0AsWfgBLpWHaQjZ8ZecWNZs2GpwEy5+/20NvtaFm7xValiZLcPgy6Y/+9RJuV
 GtsLoq8sF0YTHVmmZx+SwOzg=
X-Envelope-To: cgroups@vger.kernel.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id b69033f2e9e602e1;
	Fri, 14 Aug 2026 01:29:56 +0000
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	David Finkel <davidf@vimeo.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 2/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Fri, 14 Aug 2026 09:29:24 +0800
Message-Id: <20260814012924.2388613-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260814012924.2388613-1-ridong.chen@linux.dev>
References: <20260814012924.2388613-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Closes: https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
Assisted-by: Claude:claude-opus-4-8
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dd8756870ff..5e5edc988119 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4748,7 +4748,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 			  loff_t off, struct page_counter *pc,
 			  struct list_head *watchers)
 {
-	unsigned long usage;
+	unsigned long usage, old_watermark;
 	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
@@ -4756,11 +4756,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
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

