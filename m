Received: from out-186.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476A437B41E
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093289; cv=none; b=irF5rhHyWSWkX/byKAZlhLoqGDIh08yF1U7Gq9XG8Yu2nbs7X6Mb/LTSiDmtlCPgnhRnKew1gZ9e+yggn2Ai4QE0iSCa+EdIGaJLZ+gzfojbbB8/o5CfqjS4am6/HrcoFYmoRL+6mMRbxKwLCsYkqEYauIWjUjgtu8O39KhEWGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093289; c=relaxed/simple;
	bh=XKGAvX4djssbQ2ukdaAM8mQE5S74yHPFPdp45LKcSrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HZIkbD1HW3kLwSO+bXrt6Fvp7qXd8ZVH/LrFKT5Y0uxBNovYypQu25TZRP0suHe0Uc7fMHCP7b4ojbJevtZfLTfmEkhRp3GBAgSKWxPT9bJvm2OuvKENJEk1wPKdhgJ59TqtPXnRP+1nfs3xKt2nvSWGd/1Jp0WS0lQJ81bLbmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W4paKvFA; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W4paKvFA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786093285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iG7BQOUNjluMUKJPYfIHD5r/Uah0YPlbWHQVgLWehtU=;
	b=W4paKvFA++v1+lPM1ytHVfF0PZgUR7OB0TF6XKLapSuMujihGcrfh1cnW4DDbj0JgZF4hM
	uzcLPRGnqw+YY1zkx6ns8pfJsv7N2hXW4gK6iqyVohSLE+pv95PdLIOdAdnstM5ayQxb/b
	I+VmA6gxITBSkq9zeH/4MNwnK4FYdSw=
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
Subject: [PATCH v2 1/2] memcg: acquire peaks_lock when reading memory.peak
Date: Fri,  7 Aug 2026 16:59:59 +0800
Message-Id: <20260807090000.1532495-2-ridong.chen@linux.dev>
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
---
 mm/memcontrol.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dd6b1c298345..2da55b778ae3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4711,8 +4711,13 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
 static int memory_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
+	int ret;
 
-	return peak_show(sf, v, &memcg->memory);
+	spin_lock(&memcg->peaks_lock);
+	ret = peak_show(sf, v, &memcg->memory);
+	spin_unlock(&memcg->peaks_lock);
+
+	return ret;
 }
 
 static int peak_open(struct kernfs_open_file *of)
@@ -5790,8 +5795,13 @@ static u64 swap_current_read(struct cgroup_subsys_state *css,
 static int swap_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
+	int ret;
 
-	return peak_show(sf, v, &memcg->swap);
+	spin_lock(&memcg->peaks_lock);
+	ret = peak_show(sf, v, &memcg->swap);
+	spin_unlock(&memcg->peaks_lock);
+
+	return ret;
 }
 
 static ssize_t swap_peak_write(struct kernfs_open_file *of, char *buf,
-- 
2.34.1

