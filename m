Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F09F4B04BD
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 05:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786340800; cv=none; b=IU1AveFjqas+FxhT7v5Dnh+RcTG8zIdiF/HsviAj8DBpuMU8aGNMVtx+0f5ZNkOiBHhOwB6VOxcYTwxhzandwSiQoqaEoLYNSH+rE0yplvGTU3G2GS5Bz2yoCcm24RfYdEKty2xJ2S9+LubfxZwoBtMzII6C6eWchMxOoiq84lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786340800; c=relaxed/simple;
	bh=xl10QUz+gzTRAGL9THnBRDwCl/VTrpzoIwrgNOtpKZ0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mWOx4xyovMSt8wl5Qss22Z/IBMtlICVvafnoKxcnnGmpXjuBkT/5D1wx83JhYhH/eP4e1aE0mlEfWyf3QZ6pBZu3BcTMfXM5UOcohiXqdrEAlUzKBBk8qnIVbbzTHx2/YOKkytdfUWp1eIrK3TpiiVZQzz6kuAY9Cak5PZLdjeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QTQgY9fA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Mf0O32Cb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QTQgY9fA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Mf0O32Cb"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67A5Hm9r4074085
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 05:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=1Dj7BlpoxGwRzdnJpfUKDq
	CArhBsuZ4in/P+GRdEWqs=; b=QTQgY9fAYtMRz6rM9nNNt8WssZlgBY27uWyUgR
	rUVr2NOXrPUO16WgjZSlMemU94ve0SpjoiXclan4muYXdXfyaqnzPbdO/8VpxjD0
	mxpDrb+A6sEoK0th5ON+3mAcBT0BZEoeshPvnfW54LxQQUoJ8WPCBxX2I87b3tWo
	4TSdez3eeCLdxOpZ96Kc8kOXH+1fVZZygLfS6II4Aykjk7DXHYZaicxkvZih23GS
	nnVnRadCZ9w522uzUMjKWUE/pBl6BPOaylzvdQm1q460ZK+F4FxygFWY9v74FvuQ
	xZ2/6euTzZXZO72PbpvlSELyks/npMpvjesjTcp7pR6USQ5A==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fwwmgvgmp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 05:46:38 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb467e56aaso1886175a12.1
        for <cgroups@vger.kernel.org>; Sun, 09 Aug 2026 22:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786340797; x=1786945597; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1Dj7BlpoxGwRzdnJpfUKDqCArhBsuZ4in/P+GRdEWqs=;
        b=Mf0O32CbvaZ9RHwC2u/BnBka41pWIdds1TiLZxdQ+h0vRe9ufKP4dJncfAiaujN7nN
         EkFzNnNoLmUyLE43T08C9xwBxanyxw05/QAnjoi4i+y45Rpp1G1KqqSZ9GzZqqqcgTiM
         K5Bs0uTOkrSAnuU3sLP0LUXN75kLntIw8Itdzdmsnr4GLnbceYdtEQA+loFhlODmnvN6
         67K0xhjVekOIr8yk4hGpNPWuY/9B/JpIur0li2AN2541Ai1OqakoQ2DG7k4gE2Dv94IL
         uQ0AN9CsvV/YjpauzKvNi4BY5gtvukIcJyuMFPdVpZfz75ngLitVbGVn9p4hAvpoxMPB
         R6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786340797; x=1786945597;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1Dj7BlpoxGwRzdnJpfUKDqCArhBsuZ4in/P+GRdEWqs=;
        b=Q/dyy29pRyWB4ZSMOvroySXD0hzh1eMybINl5tBa/r7g2D3Hzpq4pYU/FTMidRyrB/
         wslSgjJDjBA9EahNOcVDjF+0l1KHf3qi1jpwGdIRhQS9dLj6z160LPVEO+68K2JJEaEE
         r0mxZliO21TgUzmEmFsWLPkvoSdQNp/NsGsWj+/DBOCCcHaqrWfWenAoCo8Tk1Yg7yE+
         39TqcKF1XzrmUixyAqVobI4GsqrqpZXOu0ngN0k/H+vPn/SQ8pBQigwiI903uOsN+UU1
         pFT5q803G24m5zDbrmLmjdcQMxWHrru6j/xbuNBjLbEw8R8gn2bTjHwMAxw2bbaJfm09
         5Fpw==
X-Forwarded-Encrypted: i=1; AHgh+Rp3dzDXyaALtdk0yQyP3oEVa0qMMgc7R0QPXOD9Lu8RyH1Oj4dW17svgx/JV/CPwfXVoIRDo4CC@vger.kernel.org
X-Gm-Message-State: AOJu0YwBqNlhAcaspG/3uuQsvSWMWgpZIDl9wVhcmUVN2TIKwIk0Xjie
	VYzyxdHZ7+iETWj4cRUIEwNlKoNIv6RyMTgOeYAFw67ZfyyBM8V3yzh0sFCuPaGe9+VYYjZ9ggd
	v+1MB6t8cIktKE5scPpaaBOhtA0b/sAZ73+Az7fAAMpSRv8rm0clo0hoL8e9F
X-Gm-Gg: AR+sD11Y2EqdpL469X5R9KKV1gU6ph7CDvB5eC+YOFvTMPGh0P2VeFH02GfMmZmXrPw
	xvhIMUGbnO/u20heCT4HP9nQDk8H1hS8S0Tgf0Gj/PHBM7pjfHmkbFPhfUI9eVUgaHlFDETOozf
	URo8d28ahbBPP3Afkb9gvBdHvVon37wZYVtB3IIL/S22AkSH5R38+btX1QrltZAF+uSotZO51Hg
	m+bth8BftSJAAWhAWJK9/LICyNYYLeLzqhFlt/ZogekbAFrI0piOlycTfK9bSf9Nu4JkmXaM98e
	9gWHgz3NBHQLpSFfwTgj19sv0bqYywgomHcGZUQ1Vvy3eaOtOKl0HhrowruBJERcALMxQ1EVP0F
	vchB94zhyR/ExulFzJdd8NDEgJ/magVo=
X-Received: by 2002:a05:6300:670b:b0:3c3:a1ed:3c23 with SMTP id adf61e73a8af0-3cb85ea6f5cmr48532877637.23.1786340796737;
        Sun, 09 Aug 2026 22:46:36 -0700 (PDT)
X-Received: by 2002:a05:6300:670b:b0:3c3:a1ed:3c23 with SMTP id adf61e73a8af0-3cb85ea6f5cmr48532843637.23.1786340796277;
        Sun, 09 Aug 2026 22:46:36 -0700 (PDT)
Received: from hu-guptap-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bebde308sm39107186eec.20.2026.08.09.22.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 22:46:35 -0700 (PDT)
From: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 11:16:30 +0530
Subject: [PATCH] mm/memcg: fix NULL nodeinfo[] dereference on late-onlined
 nodes
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIALVleWoC/x3MTQrDIBBA4auEWXfAmB9Mr1K6EB3NQByLkhIIu
 Xsky2/x3gmVClOFd3dCoT9XztLQvzpwq5VIyL4ZtNKzMspgouQiSvbEEjLKvm0Yd1s8ekdTmAe
 rh3GB1v8KBT6e9+d7XTdGHwzxawAAAA==
X-Change-ID: 20260808-memcg-nodeinfo-null-guard-dce5f63a2349
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-arm-msm@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Prakash Gupta <prakash.gupta@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDA0NyBTYWx0ZWRfX0zRu+OKwBok1
 FlrhdPcYBGwT3g08sFqKhWoxkoreXMMptix0PfnIBBZORP2ysS5hW6sonz/PWJw6o8NH1QNqZHb
 /TJdqFaicUuvdkVKWvrBaJTqLQGhczw=
X-Authority-Analysis: v=2.4 cv=HodG3UTS c=1 sm=1 tr=0 ts=6a7965be cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=GS4ghhMgoEJMoUnwAloA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: 7IZEuXRcd8qZJ_1_IOXzKCEX1zy8f3NB
X-Proofpoint-GUID: 7IZEuXRcd8qZJ_1_IOXzKCEX1zy8f3NB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDA0NyBTYWx0ZWRfX4VoQfvswcZ9D
 fGWuzX41mmEtagMvQ3qiySRNhpG3X/ru8HFbxCYW91hb6xuRU+Aqm8onpRV8ZJOyL6EBYuJFnwY
 Jl51PT1GF3pvmVQGA+1t2xPm/ZOcs+4icACM+QUFA4HDkoEqZROObt/yjcNe/l37iUQx7Owiwvj
 P4rRFgBqU4fHaHSZA8SDXUqqIeIN1l0t9OyLTiP2QhPkIj6eYJ+5KcBcGH7aYdI9ZVnfAty5YNa
 6l17uauZyibk7Vcdz2g+1Gb6iHqkeA8N/LjXnkOPhP/1iWv7DaQu5XNYSAR1h8vpen7V+zbyDYW
 ApQRF+7MkfM21Q2jPMv/ateMthaeeAvi4yL3Pb6eLdsds9SnEgr7mdN78kmcmkqLZkU5onRzN9G
 LoJIpnbHnITW6eXgLOOr8tZkxIxFpeThxPAyMsINvjVcZwrTLyjtafYeayg9L+UTSmRmWwDZwRj
 l/SBLjIwuO0q1WZzndg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_01,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100047

memcg->nodeinfo[] entries are allocated only for nodes present at
css_alloc time. When a node is onlined after a memcg is created its
nodeinfo[] slot remains NULL. Two call sites dereference these slots
unconditionally:

lruvec_stat_mod_folio() calls mem_cgroup_lruvec() which reads
memcg->nodeinfo[pgdat->node_id] without a NULL check. On a system
where a node is onlined after the memcg is created, any folio stat
update for that node crashes with a NULL pointer dereference:

  Unable to handle kernel paging request at virtual address ffffffbebf7e1908
  pc : lruvec_stat_mod_folio+0xf0/0x444   [6.18.21-android17-5]
  lr : lruvec_stat_mod_folio+0x88/0x444
  Call trace:
   lruvec_stat_mod_folio+0xf0/0x444
   folio_add_new_anon_rmap+0xac/0x2b8
   do_wp_page+0x768/0xc80
   handle_mm_fault+0x37c/0x8c4
   do_page_fault+0x140/0xa1c
   do_mem_abort+0x54/0x74
   el0_da+0x48/0x8c
   el0t_64_sync_handler+0x20/0x130
   el0t_64_sync+0x1c4/0x1c8

__invalidate_reclaim_iterators() iterates for_each_node() and reads
from->nodeinfo[nid]->iter without checking for NULL. for_each_node()
visits all possible nodes, so this is reachable whenever a node is
onlined after the memcg was created.

Fix lruvec_stat_mod_folio() by checking nodeinfo[pgdat->node_id]
directly and falling back to mod_node_page_state() when NULL, mirroring
the existing !memcg early-return path. The fallback must not go through
mod_lruvec_state() since that calls mod_memcg_lruvec_state() which uses
container_of() to recover the mem_cgroup_per_node from the lruvec
pointer; passing &pgdat->__lruvec there produces a garbage pointer.
When nodeinfo[nid] is NULL the memcg has no per-node accounting
structure for that node, so node-level accounting is correct.

Fix __invalidate_reclaim_iterators() by skipping NULL nodeinfo[] slots.

Also switch lruvec_stat_mod_folio() to folio_memcg_check() which uses
READ_ONCE() to safely read folio->memcg_data in an unlocked context.

Fixes: 6c77b607ee26 ("mm: kill lock|unlock_page_memcg()")
Cc: stable@vger.kernel.org
Assisted-by: pi:claude-sonnet-4-5
Signed-off-by: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
---
 mm/memcontrol.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..2a6f02956b89 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -977,11 +977,12 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 			     int val)
 {
 	struct mem_cgroup *memcg;
+	struct mem_cgroup_per_node *mz;
 	pg_data_t *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_check(folio);
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
 		rcu_read_unlock();
@@ -989,7 +990,18 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 		return;
 	}
 
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	mz = memcg->nodeinfo[pgdat->node_id];
+	if (unlikely(!mz)) {
+		/*
+		 * nodeinfo[nid] is NULL when a node is onlined after the
+		 * memcg was created. Fall back to node-level accounting.
+		 */
+		rcu_read_unlock();
+		mod_node_page_state(pgdat, idx, val);
+		return;
+	}
+
+	lruvec = &mz->lruvec;
 	mod_lruvec_state(lruvec, idx, val);
 	rcu_read_unlock();
 }
@@ -1320,6 +1332,8 @@ static void __invalidate_reclaim_iterators(struct mem_cgroup *from,
 
 	for_each_node(nid) {
 		mz = from->nodeinfo[nid];
+		if (!mz)
+			continue;
 		iter = &mz->iter;
 		cmpxchg(&iter->position, dead_memcg, NULL);
 	}

---
base-commit: 075b74841bd0065a3bda3440873c747938e69b68
change-id: 20260808-memcg-nodeinfo-null-guard-dce5f63a2349

Best regards,
-- 
Prakash Gupta <prakash.gupta@oss.qualcomm.com>

