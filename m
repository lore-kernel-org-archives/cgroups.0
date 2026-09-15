Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C4E37187F
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514446; cv=none; b=ONV3LiptzEwo0DEygeSwazWv9iptrDtkc/5714NTxI0HUu+yoKAE15qsnJmlmWPEk3PLT1GLsmpKM7oqjUqMDTgLAJYC+NR96bw5bQtjKFykysKbW7L7jp1aTQ2kvEEzg+CKkLTlayHTzfeatRG2RgKyQqM4DuYKoR7z/6sYzno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514446; c=relaxed/simple;
	bh=9okpZMTMnyXLmB2Ry6c0Ho0fpCdh1VUMQUGi454i+qg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HgZR8Hi2iC7cmKdBLmO33xfxdafhGF1uKMrluLvmdlv+bBtwFyXRWPHGfFwaXxtJUrvatrmxts5OnXCokvhg3IZW1TnvHX1wJIbu7Vw3gJh8B1PWyspTE6I9VPgy/dkZ7EEtgbC3AILkdBsyp5IImouFo25e4oCaNyMNWu2GGj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=KyNFFuFb; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=z7s1AkiX; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="KyNFFuFb";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="z7s1AkiX"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbTRR2571529
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=HMhj
	gHsliwPh5UROcPmv09nrjwRg6d7C9/cMqZ3ArSQ=; b=KyNFFuFb9uuMNkmZ/nGZ
	MJxQuTaGbvpjICGU6Ngu4s/VAVoknIB+GaN/H/ipDGxEBq+pRj2Ja/zCsTaNyMh8
	rTOgf2pf2FBnV+O4Vrj6n4TRBTaeqpKC0yCpqjinkj1J635s46VL0nCAwmfyDXDv
	21nj21VnC7bjU8uQ98XSkcPNx2DUQuBA5Oz9EHiMP/h5PZhblHSVwq/PAdjJl8dg
	4RrUoFbY+u9DNOSI2/UXiXR7I4qivI4I50mklJ/B/osSLT3I7+Nl5XBsTeXOfZB8
	HMyB0aorOW1vIrddY9qQ4mkdBe9dVSnWmpY9MgN2oJRiiPS1SaTwDP5jxKEO/MxW
	pg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwd9t1r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:42 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93918756165so967785885a.0
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514441; x=1790119241; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HMhjgHsliwPh5UROcPmv09nrjwRg6d7C9/cMqZ3ArSQ=;
        b=z7s1AkiXtAylW3LflXZWUQawdrHChcWUiCKy40Dxj1tMHNz8IUv4Nto05pyLnd1bqm
         pl46LqabwE8+VLMIsaISQg/ik4YwZh4pNcE6nBKq3L7JLw83nW7rVtJOHNb19SHz0qT/
         hFAHjqLqmiRAlizrYiiIeBwbR7fOH3Y6bW1Ub8B3xWSQi+354AfOmTPJlJuEMbgKh5DA
         uXvQdFtEA6Q3V/du1AFUM/V6hyBgQ0nS1cR5YWq3pn9QxdsbDxKI/+syKf3t76CJZW6s
         5FK75Ti4YSEzTe19mmX9f2ugm/rXYqmBmvRErblOmTx5k/9GgMeYZSS+jrdli1Y4eOBI
         px1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514441; x=1790119241;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HMhjgHsliwPh5UROcPmv09nrjwRg6d7C9/cMqZ3ArSQ=;
        b=lvGr8AdY/RUJ8hGtE6/2l88u7ERnHlwwFYWRux28/ayN63/KMZjx2p0b44UCIgf3Dx
         3JkUMJ2oEgPGQuXdy5QvH0wSLwKgVfOoBhEXb56Js0Ar5yCPjs1WGFi2H8W2onXMhej6
         f7xpP10LgqXEHfgZ8KECaDlNzJNTcHNlpdp7CmKKlH6gaSzC5EtN4JOZw3WYH1cpH+gS
         sZo/7XAjMBi4r8OqTESN+Xqqq9AS1aX3qkGrAlSDTTBnNnC7HDmVqbqfXuqs0RHR79Zw
         PYedtV2w5ITwl2pZuWUKsypkThDlP5MHBDuQ+l9vL7JN00iffuK8wNgJQ4aVA8VC1zQt
         IUXg==
X-Gm-Message-State: AFuF++mFwapsrE2UHeN+1hkGfy+SlOaiEsM1la0d2jWMeooNKJ2IC4AP
	Y9NHkxIoRaS3hplFeJNFs3TguuhfVbOqjo/DDssbegRGXj3wC9K8C6HHWu0pN5Qa7UhFlYhOfS9
	WpveX0DTjfXjIIL1bhpPC4sybDsneQdm/qjWpcNG3a7sC8NG6xcxy1ClkhwxXUVA=
X-Gm-Gg: AYBFou3Ngi4AtyDsmPC39BJt8SI455UzKBbk9UrDPSfMWtQ0GgHLwMkTX7Ng+83Go+d
	Jl0+QO22R0wuSASZNgL6oenN9AzXSZ7P2rH5su9em2BRXMQN6FIkx50PpHXhWR97Ek0Eyxe4R+T
	zRcLnk4TRpjD4dyupPjgYhMUCB8bPVX3OQmKSQuZtPU35ZK9edWX1g283CSBNuxJ2OHUaoaoIX/
	Dgkh06fR7GoF9oF1PZXEfjkXhTICDkFvvhnNBYxc9s/q0yLWXQFgRVT2ZxgvMUj1Gon4vg41zEB
	RlYGI9WC3SOo0vdak8ZnqKeWCIV4hje73w1tpHV3j8iC6e9UCK4r8n9FK3Wh+XdWO0gZZngn973
	sXRyfObWTNTwJ6D/TtjljbXgcSLXikKYBmbON3s4XmtJm9qfR
X-Received: by 2002:a05:620a:2715:b0:93a:2239:4ac1 with SMTP id af79cd13be357-93bb787fabamr64991185a.32.1789514441307;
        Tue, 15 Sep 2026 16:20:41 -0700 (PDT)
X-Received: by 2002:a05:620a:2715:b0:93a:2239:4ac1 with SMTP id af79cd13be357-93bb787fabamr64985185a.32.1789514440925;
        Tue, 15 Sep 2026 16:20:40 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:14 -0400
Subject: [PATCH v3 10/11] mm: memcontrol: constify mem_cgroup_swappiness()
 and mem_cgroup_get_max()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-10-c239a6010b58@columbia.edu>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
In-Reply-To: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=2036;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=9okpZMTMnyXLmB2Ry6c0Ho0fpCdh1VUMQUGi454i+qg=;
 b=fi/2DRaM94/2tgQrx1Km8UqYFSnS643KGtWcuw4p72BsEv73LKIWc+7o20uPW2rGtmzVXgwVD
 NdaMZWxQM9QDr1iBOLN5X4QSyCwbT7wdxmvFu2Zj1i7et6qcP0Mi0MV
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=JeEpPkKV c=1 sm=1 tr=0 ts=6aa9d2ca cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=LvCEVWXYBYKFGHUOtEoA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: iKBSM-wFAfbDtJ4rAfzeiYMTmYhf5V5c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX0nZFSUF0AzZS
 1nttLRKXlFrIz5DVfUj/S8ZDmjmPL0DVY0JqsUn7glry+P6E7f4chyU6vfp93hx+cI9Q04Qo7Yu
 DwYeq2JAokAZfkHSyAkhb7+jF3U7rROP/E1KevCSFkhB4JIOTPVrNvSxcXa+bfUKDU/CR0o1ssN
 CzfRU8hXl9f+NPlLsGsE6Ulxf+1xFkg//zP+b8JUfwJlGrqGAIrLk4WQYlTYKfix+NIxD71J+Kk
 hniCdOIZwP09Rsc3rDkOQMgx3YoxSjuF+JISvAg3MiP6cX8t6t7I8iCjNmqwNHbIUrPnWZ7JvLL
 +4Kg7JGncPlA2xnl06Nr5gFYEUTmln2c5a4R35t/uZU3bz37LJS03pS+jBr9DTdhRNYGezPuc18
 RvEr4C1ucrIY87EvmrG2uR1JMGDcUB8+W422wy9WdtVHfbHeDmx6Wf3OAY6tMspA56vX84EU5GJ
 SuGtEnMPklpWs04hczg==
X-Proofpoint-GUID: iKBSM-wFAfbDtJ4rAfzeiYMTmYhf5V5c
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX7KEZcE7J0CV+
 P9tZyrbqTXXvlB3713k+IGcMsL6w4Niw1tDUCtAy0qlYkd3RlHfq9cwkpuhKgXZcxilfw6wJlHp
 Xc6QiQnBDDjAOp5SuCGaH9YSbf3596xcZn4eVnMFabDjz1BdoqQD
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=10 adultscore=0
 impostorscore=10 malwarescore=0 bulkscore=10 suspectscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341

Both only read swappiness and the memory limits. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 4 ++--
 mm/memcontrol.c            | 2 +-
 mm/swap.h                  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9beb065c0879..f11899085473 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -941,7 +941,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg);
 
 void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
@@ -1372,7 +1372,7 @@ unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 	return 0;
 }
 
-static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+static inline unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ebf325af7acc..6e3731b97690 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1884,7 +1884,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 /*
  * Return the memory (and swap, if configured) limit for a memcg.
  */
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	unsigned long max = READ_ONCE(memcg->memory.max);
 
diff --git a/mm/swap.h b/mm/swap.h
index b3b54c28929a..1957960dc60d 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -82,7 +82,7 @@ enum swap_cluster_flags {
 
 extern int vm_swappiness;
 
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+static inline int mem_cgroup_swappiness(const struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_V1
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&

-- 
2.39.5

