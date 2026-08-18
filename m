Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2433ACA40;
	Tue, 18 Aug 2026 02:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787020497; cv=none; b=nMzPUOzyQ6MGFxVaKqfAkCOrJWR1jDTiWrVti1+cIvYGRDTnkOKlbDj+z/BcT11SuXB9RhhIRMoxefghrh+7uuCL9xmN7f2mMHwMjUkannu/fWZ2YpAQc0Z+fToQQXZZZVNNd25fy8iLGw18XY1Vz60cbqvI5gKCohfRA4RlhdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787020497; c=relaxed/simple;
	bh=92uJx17oQwt8gUraMF0LQUVa8Koxh+Eq2UAYSFy8T8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oZSc1qAbnYPZypxQg0i396QdkFBBNEqW3jhW1t/pFKTRcbc9Dkjb8CSvz02v/HMLW+PbNl+Wh0DezO/PPf2B11OY6U96mV7zxEQ/taXWe3IxQN809HuguTBclibnHDiHShrX/AznMIx0TlUo3HTnex39wG+QWJSJJ2hvozKGWwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5dc877189aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:40fbb603-83d4-40e4-93d7-8c15ea63e4fb,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.19,REQID:40fbb603-83d4-40e4-93d7-8c15ea63e4fb,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:2ac71e1d8fe337a34aa18802dbdd9618,BulkI
	D:260818103445VLMWCMQC,BulkQuantity:0,SF:10|66|78|81|82|102|123|127|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5dc877189aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 906498104; Tue, 18 Aug 2026 10:34:41 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [RFC PATCH 6/8] mm/memcontrol: add memory.tier control file
Date: Tue, 18 Aug 2026 10:31:19 +0800
Message-Id: <20260818023121.100613-7-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qiqi Liu <liuqiqi@kylinos.cn>

Introduce the memory.tier control file to expose per-tier usage and limits.
Counters are pre-allocated during css_alloc or memory hotplug:

  tierN.current=<bytes> (read-only)
  tierN.high=<bytes|max> (default: max)
  tierN.max=<bytes|max>  (default: max)

Writes are parsed via page_counter_memparse():
  - high: Sets page_counter_set_high() and reclaims down to the new limit,
    scoped to the tier's nodes, mirroring memory_high_write().
  - max: Sets the limit via xchg() and reclaims or OOMs down to the new
    limit, mirroring memory_max_write().

Since counters are pre-allocated for all online tiers, updates require
no memory allocation and return -ENOENT for unknown tiers.

Example:
  # cat memory.tier
  tier4.current=1048576
  tier4.high=max
  tier4.max=536870912
  # echo "tier4.high=268435456" > memory.tier

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/memcontrol.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3aa55c287248..a6c6057f0e4f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4822,6 +4822,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct memcg_tier_counter *tc;
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
@@ -4835,6 +4836,13 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tc, &memcg->tier_counters, list) {
+		page_counter_set_max(&tc->counter, PAGE_COUNTER_MAX);
+		page_counter_set_high(&tc->counter, PAGE_COUNTER_MAX);
+	}
+	rcu_read_unlock();
 }
 
 struct aggregate_control {
@@ -5331,6 +5339,96 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static int memory_tier_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	struct memcg_tier_counter *tc;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tc, &memcg->tier_counters, list) {
+		seq_printf(m, "tier%d.current=%llu\n", tc->tier_id,
+			(u64)page_counter_read(&tc->counter) * PAGE_SIZE);
+		seq_printf(m, "tier%d.high=", tc->tier_id);
+		seq_puts_memcg_tunable(m, READ_ONCE(tc->counter.high));
+		seq_printf(m, "tier%d.max=", tc->tier_id);
+		seq_puts_memcg_tunable(m, READ_ONCE(tc->counter.max));
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
+static ssize_t memory_tier_write(struct kernfs_open_file *of,
+	char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	struct memcg_tier_counter *tc;
+	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
+	bool drained = false;
+	nodemask_t nodes, *nmp = NULL;
+	unsigned long val;
+	char knob[8], *p;
+	int tier_id, err;
+
+	buf = strstrip(buf);
+	if (sscanf(buf, "tier%d.%7[^=]", &tier_id, knob) != 2)
+		return -EINVAL;
+	if (strcmp(knob, "high") && strcmp(knob, "max"))
+		return -EINVAL;
+	p = strchr(buf, '=');
+	if (!p)
+		return -EINVAL;
+	err = page_counter_memparse(p + 1, "max", &val);
+	if (err)
+		return err;
+
+	rcu_read_lock();
+	tc = memcg_tier_counter_find(memcg, tier_id);
+	rcu_read_unlock();
+	if (!tc)
+		return -ENOENT;
+
+	if (!tier_id_to_nodemask(tier_id, &nodes) && !nodes_empty(nodes))
+		nmp = &nodes;
+
+	if (!strcmp(knob, "high"))
+		page_counter_set_high(&tc->counter, val);
+	else
+		xchg(&tc->counter.max, val);
+
+	if (of->file->f_flags & O_NONBLOCK)
+		return nbytes;
+
+	for (;;) {
+		unsigned long nr_pages = page_counter_read(&tc->counter);
+
+		if (nr_pages <= val)
+			break;
+		if (signal_pending(current))
+			break;
+		if (!drained) {
+			drain_all_tier_stock(memcg);
+			drained = true;
+			continue;
+		}
+		if (reclaim_tier(memcg, nr_pages - val, GFP_KERNEL, nmp))
+			continue;
+		if (nr_retries) {
+			nr_retries--;
+			continue;
+		}
+		if (!strcmp(knob, "max")) {
+			memcg_memory_event(memcg, MEMCG_OOM);
+			if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
+				break;
+			cond_resched();
+		} else {
+			break;
+		}
+	}
+
+	return nbytes;
+}
+
 /*
  * Note: don't forget to update the 'samples/cgroup/memcg_event_listener'
  * if any new events become available.
@@ -5500,6 +5598,12 @@ static struct cftype memory_files[] = {
 		.seq_show = memory_max_show,
 		.write = memory_max_write,
 	},
+	{
+		.name = "tier",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_tier_show,
+		.write = memory_tier_write,
+	},
 	{
 		.name = "events",
 		.flags = CFTYPE_NOT_ON_ROOT,
-- 
2.43.0

