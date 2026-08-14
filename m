Received: from mta0.migadu.com (out-168.mta0.migadu.com [91.218.175.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D550332143D
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 01:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671000; cv=none; b=sC5IT/Xf1Iw8LMeGvZkhlt/IDuKATZ+LkhV683pONKRJZIAKxHcl8x8zbEMABzwTwV/nIU/H8LsPSvkb1tqz6YOvYsi4E/0WsjNm6HPVzs5oO4mh5oZJvMLUBlKTKgG9Qfmx+L8AeltezeT6qgIEm7DDNvl+NY4AeG9FJQ+zrXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671000; c=relaxed/simple;
	bh=YRIK/awmx71exiVOjlgX7attdFmpDuckcomywEMtZlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XKvFEQqtvbt/JX7hrvHI3J/JsQz14TFRn0mGt+rTgh4v4RduD3M1a5FSvh7XXnf61Yhjt99/DsH7Z4JflDAPcyEQaZ/lwXqrgxu4QyKk2tDGtD0rj9nX05GUMTdaapHgNBLeNEQ9SOm55ihtyu7oQuT0Bg0UpARL8MRMNms5duI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=umpg/rpQ; arc=none smtp.client-ip=91.218.175.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="umpg/rpQ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YRIK/awmx71exiVOjlgX7attdFmpDuckcomywEMtZlw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786670988; v=1; x=1787275788;
 b=umpg/rpQ0RnezST5AyWEhNrlGcp9Ihpe2PksMoQcWQDlXU4R8wBA/WB1e+ajFOSZkEjI3oPW
 7Iww2O7O1qIoVY0nTOABHu0X/YM44axR0fC36fO1MBpC7acU3Zg1tf04P8K2+vl/bpDcI6fm+AI
 Sx8Mh1hddQEV5PGthp5Dx/oo=
X-Envelope-To: cgroups@vger.kernel.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id bbd37d40f1c9974b;
	Fri, 14 Aug 2026 01:29:48 +0000
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
Subject: [PATCH v3 1/2] memcg: acquire peaks_lock when reading memory.peak
Date: Fri, 14 Aug 2026 09:29:23 +0800
Message-Id: <20260814012924.2388613-2-ridong.chen@linux.dev>
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
 mm/memcontrol.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..6dd8756870ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4713,8 +4713,13 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
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
@@ -5858,8 +5863,13 @@ static u64 swap_current_read(struct cgroup_subsys_state *css,
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

