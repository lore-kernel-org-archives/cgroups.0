Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785177;
	b=ZQ3b6k+X6Xvm8nW/NAqrR0t1nweCXs7tX/VigMAzIXSYj9MuordbadmMWZavaKuK84zZ
	 MlFheh4rbCp54ZdU3/EtTBzmCBhfyOpnskWPAVK5XZFke5JTZtTa8XlkTPwJbU0Z0lb1Q
	 zD5Q912bcpIGeubWwLjj1G9hriG2BhLdiq3jEM2DwDw6ezJ2NBL4mjT+vvjl4TtywtyVL
	 rcopQr9gtLmfvM/rhOiEW2bFANff3cCmFnZkhDrijys6p6hfItI5zSEHYYkT+qlEIXX3F
	 BRM8+3Guw2X8WyH1yarPss0Q1HcaELVkyDqi3XSIxmefvPEZqLrkZZ8mYH2eDjodNpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785177;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GKas3peospknksB0vSRc5IU2FW9D1srUiUjTUhHUOGk=;
	b=BeIMnzBiqjFuMh6wQqBpJ9DbLpC28EtZeuxv3+mXwDoN7YJeqqE94sdsq2HVE6LJ0ngw
	 imyE6Kiag0ibzklS5TYjplx1QtiUvfRJcnrF0jiyWW58A52be3oiYvmsvFzKm68mlrKot
	 KVMduES4tvVHxGCGKWmovBOFiWp7N0T4p9220Y6F5JCOcCycJG9C4PyJDtrJL/cBCEUq/
	 1rmwK2c27woWh0PW+hfqwT3FoGsMQLuaY0/Zweeuo0jBxVBzlXlz8VKE9rAb//ZLTIFvN
	 1Y6025jJlzUY0rxU5cgst1/6UXhwkD/1XQw7ONC04fEoDQzCxJmCVNBxhjNj+AvWn+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142D3606A328;
	Wed,  4 Nov 2026 09:39:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 142D3606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a086d4fad83311f19a56ed5b684f684d-20261104
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:eb28db4d-434b-490d-8aba-b9882b379760,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:eb28db4d-434b-490d-8aba-b9882b379760,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:c3887dee93015b2c45488bae4be79267,BulkI
	D:261104173930I66NRZ8C,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a086d4fad83311f19a56ed5b684f684d-20261104
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1667460396; Wed, 04 Nov 2026 17:39:27 +0800
From: Song Hu <husong@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	tj@kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm: memcontrol: serialize concurrent memory.min/low writes
Date: Wed,  4 Nov 2026 17:39:20 +0800
Message-ID: <20261104093920.2279191-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
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

page_counter_set_min() and page_counter_set_low() require callers to
serialize updates to the same counter.

The v2 write path does not provide that guarantee: kernfs serializes
only writes through the same struct file, while each echo opens the
file independently, and cgroup_file_write() invokes the handler
directly, so concurrent updates run in parallel.

The store and the subsequent propagation replay are not atomic, and
propagate_protected_usage() recomputes protection accounting from the
current page_counter limits instead of a value captured when the
write started.  Two concurrent updates can therefore interleave such
that the replay associated with an older limit overwrites accounting
computed from the newer one: writer A stores 100, writer B stores 200
and replays, then A's replay runs last and leaves min_usage and the
ancestors' children_min_usage computed from the stale 100 while
counter->min is 200.  The wrong accounting
persists until the next charge or uncharge re-runs the propagation;
an idle group with resident pages never self-heals, and reclaim
meanwhile distributes sibling protection by the wrong numbers.  No
corruption beyond mispriced protection.

Serialize the write handlers with a shared mutex, the same shape the
v1 controller already uses for its limit writes (memcg_max_mutex in
memcontrol-v1.c).  The offline and reset paths, which clear the
limits under cgroup_mutex, take the same mutex, so every memcg
writer of page_counter_set_min()/set_low() ends up serialized.  The
mutex is only ever taken as a leaf in process context, so there is
no ordering hazard.  memory.high and memory.max need no lock:
neither propagates protection, and their setters are already atomic
(a plain store and an xchg respectively).

Fixes: bf8d5d52ffe8 ("memcg: introduce memory.min")
Fixes: 230671533d64 ("mm: memory.low hierarchical behavior")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/memcontrol.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..87ca7bc1aef1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4458,14 +4458,27 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	return -ENOMEM;
 }
 
+/*
+ * The store-plus-replay sequences of page_counter_set_min() and
+ * page_counter_set_low() must not interleave across writers: a stale
+ * replay can overwrite a newer one and protection accounting stays
+ * wrong until the next charge or uncharge re-runs it.  The walk in
+ * those helpers crosses counters, so this lock has to stay global --
+ * per-cgroup locking would still let a descendant writer and an
+ * ancestor writer race.
+ */
+static DEFINE_MUTEX(memcg_protected_mutex);
+
 static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	memcg1_css_offline(memcg);
 
+	mutex_lock(&memcg_protected_mutex);
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	mutex_unlock(&memcg_protected_mutex);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 
@@ -4548,8 +4561,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
 #endif
+	mutex_lock(&memcg_protected_mutex);
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
+	mutex_unlock(&memcg_protected_mutex);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
@@ -4924,7 +4939,9 @@ static ssize_t memory_min_write(struct kernfs_open_file *of,
 	if (err)
 		return err;
 
+	mutex_lock(&memcg_protected_mutex);
 	page_counter_set_min(&memcg->memory, min);
+	mutex_unlock(&memcg_protected_mutex);
 
 	return nbytes;
 }
@@ -4947,7 +4964,9 @@ static ssize_t memory_low_write(struct kernfs_open_file *of,
 	if (err)
 		return err;
 
+	mutex_lock(&memcg_protected_mutex);
 	page_counter_set_low(&memcg->memory, low);
+	mutex_unlock(&memcg_protected_mutex);
 
 	return nbytes;
 }
-- 
2.53.0

