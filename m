Received: from mta1.migadu.com (out-155.mta1.migadu.com [95.215.58.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798673A3834
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 03:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786678235; cv=none; b=QWtscRfab78dyTJLe2zuzov1bgL3VqBbyuXyOtVIpAKCG54Vc9mLYZlWfsWfzr3p94CsYDwYqm72HbsqYJ5HQJ3i9ZdJWnGI2dsfiWnql4kYB2IjRYShY3LA7sLCj0Dh9Cu+yIzlHlRT7tq2YUb2GmAqrJLKv5Ju5eiwnv0UZUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786678235; c=relaxed/simple;
	bh=M3M6KYCU8WrjOH8M0FSq9Y5uJuL5tl6xBP8M1lGPC2M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eByNm74yqZ+wH4K0H929mU922EAXi1zdydGR9nzItQy6bxk1tux3h3DDnzMvBrLNFewBAn2NPv1CEoBDz03/9NOeTrYcUWo/j21c4hEM/tftXZL5U9bqQ970ydQg77qFRpc1rpOV9T5Y8G16+4LO55ZkyLpI1HWRAtWlL46cwVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V943aBKj; arc=none smtp.client-ip=95.215.58.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V943aBKj"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=M3M6KYCU8WrjOH8M0FSq9Y5uJuL5tl6xBP8M1lGPC2M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786678230; v=1; x=1787283030;
 b=V943aBKjkdKDyNGKceNY3ZfcfJ9m50izyAcyqCSA66icCX383muzykY0F6PuuM98+s8Qs3Kc
 ywJy1S/iodyIS/o5Dcdm4WmfCy/B919sNZoqOHuztg25wnK/ksEV5Cnw7GCs8vJxP20/6PWqLNe
 ys8jE5+qBhxtwLDyrXrFpfAM=
X-Envelope-To: cgroups@vger.kernel.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id bff796e104338a1c;
	Fri, 14 Aug 2026 03:30:30 +0000
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Finkel <davidf@vimeo.com>,
	Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 1/2] memcg: acquire peaks_lock when reading memory.peak
Date: Fri, 14 Aug 2026 11:30:04 +0800
Message-Id: <20260814033005.2481920-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260814033005.2481920-1-ridong.chen@linux.dev>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

Sashiko reported that a reader can transiently observe a lower peak
within a race window [1]. peak_show() returns
max(local_watermark, ofp->value), but peak_write() updates those two
under peaks_lock while the reader takes no lock. The interleaving is:

  writer (reset on fd A)                 reader (fd B)
  ----------------------                 -------------
  usage = page_counter_read(pc)
  WRITE_ONCE(local_watermark, usage)
  // watermark lowered to usage
                                         lw  = READ_ONCE(local_watermark)
                                         // sees the lowered usage
                                         val = READ_ONCE(ofp->value)
                                         // B's value not updated yet
                                         return max(lw, val)
                                         // both low -> low peak
  WRITE_ONCE(peer_ctx->value, usage)
  // B updated, but too late

Fix it by acquiring peaks_lock when reading the peak, so the reader sees
a consistent snapshot of local_watermark and the per-fd values. The same
race applies to memory.swap.peak, which shares peaks_lock and the
peak_write() path, so take the lock there as well.

[1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..ceb43b855122 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4714,6 +4714,7 @@ static int memory_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->memory);
 }
 
@@ -5859,6 +5860,7 @@ static int swap_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->swap);
 }
 
-- 
2.34.1

