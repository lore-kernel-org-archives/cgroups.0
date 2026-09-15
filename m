Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DA23F1ACE
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514436; cv=none; b=uIaXbds1Nfv1xIFlAdJMhyokdVbPlAENMXyfHVsn8n/3l1hpalODfKaKWmeZanRg17/4LHVqKh8FQFRDbEogncJriM0ocMWqN/Z/0/NhipCBXG2AXROqWrOXc2h19T2iqqX7FIEvP/18jzXxl1un59mSsXtwYg4/rlj9IDMRQYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514436; c=relaxed/simple;
	bh=kVidRnCSLCRIDy0LcPsGCW6n4LV3v1+7iiJ/4lJYABM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=E/8KvO7Bq7HIXoIWckENCQkvv/Q4h8f3k6i3uDD3F2B/Um+8wtnBWhniWnsbT2Uk9ZoN8JRaEXoOKBRWAUnx3OeYKf1ihG/XDtm+68E6Srz/TfQydW/ZWVCFuQsdMurCTp4wj3hd1CtDKpzkbAhOkHBjA6Q1VlLgmEYarCXE9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=lav8+JiM; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=1VtJuAqN; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="lav8+JiM";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="1VtJuAqN"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbOAU2692855
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=QWwaDMx47FvPA0K/+SVrw7qA3B
	/CVOWD7eNhZlTng+o=; b=lav8+JiMyMkKi9wR9Dww7nF594s5bZDigLUeYTG+z7
	XGiio/3e6DVGS4XhOrCK1Hv7tVy3wuqisMGIOheolIcwOzuFunyIqgcgRWQRgAZW
	TxAPWuNWkQ2rvufrVgf6gSZ2c2vtq5s/x8cMNek8H945TYQdNLsrwdgVku2THdK/
	5SilvzzX4by/UbX/9q3eRLFp6bwar58ce5p5u5blhdLRQslAP7Kvx+HFIlUDvqYm
	AQ1EenPAJGNjv58pRWEs5wv3WNiDRXVSKv8mejPI6f0XP1R+gfC/0C40PDF/mqNE
	sJNyFRaQ/uRomqFBnl6eAv2TBV/XNKjLIBUNluy8TVTg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gq9n5uj3p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:26 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93909014c85so951172385a.0
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514426; x=1790119226; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QWwaDMx47FvPA0K/+SVrw7qA3B/CVOWD7eNhZlTng+o=;
        b=1VtJuAqNtU02vifMDMELpksetLgTaAABT6/gZBdvqwXP3CdbEmtc+2eDDXUk636vY/
         S/Cbu8WabYyoIF2YSxJwZNGfl5R/zzPBOdbrNzZlU+2QyZb7f0T4BsLEsJzUITWjbBxt
         wOpJJQUiK1bItvwwvuORx1tS8EvO6t1F+so1vyMi/o10ieYQLUTlIOVGKBx7vENLLDvw
         zlYj85Lh2cztN0WoycfeXEj9402AkOsJZAFZuTshhf8cIPtY0kWH5Qjj6pO9IQmjqMgk
         OLqP9h40251mENCXcj4Nd4qnG7wP4GDztRNEiQyQsUPaEjv42hi5mToMh5Z834uglpH2
         OgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514426; x=1790119226;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QWwaDMx47FvPA0K/+SVrw7qA3B/CVOWD7eNhZlTng+o=;
        b=Ypdg5l8PKwNvnHXYxfXH6Bkjgg2kezZtXSmaCf9x3WASJFr2slcatCU1PT/DREKAoY
         Z1dsqYrPQzdiJRUkYqDpjRoGJBFiIzUMBXXgh18CfLLb1C8r1brcXr9Sv/JexxSxLRTu
         71b1D5DONGTJH+WVJAkY4LXWUs+OiZHtf0UrjT0CYQz7vYztiS0pRQdFxIteLRFuKcSF
         +8beQQGGtO5SBaLmrnt0VcrGkZpVxpitU819NjIWUu2SEWuSVQzhlbgZ7esv+avJYQLv
         0KidJ7LLWO4gxAwaaaHMQhRbPNMmY5u/+IzqM8Oc6OmI/ZZkvowj/VDFC3JlmGGvsM00
         AEQg==
X-Gm-Message-State: AFuF++lukbEGr2OIDsGo987NKYG1rDB/33zsHdf5mxlCjjWmPOtCWgRA
	R4YfdKBPs0Q2P+3dN9onvdlqoJ8jNgbjYahnlQfRpMLNtR098gJCzUNZ7IUw95X7P/NTROMwIwQ
	qDS1QS6+GF/OWOQSTdhOxTOmERHx7jS9HHYu3y32F3GQJh2rpB96A7pL7MK4r2jk=
X-Gm-Gg: AYBFou19G96RwZZlwSnbPXu1TkZKuWST9VLEl3M9dooRw450nwsC8ePuoqpMSImSefP
	F9dNH7UKsI2LJTv+GtSVyETd4QIpUBHPDwXo19FK07876hzH+cIwV2Kao5r3QG6t/+yPQDrbuvS
	HwT7y1nao3DB1Yt4pEqloKcV/Gk29lRxIsO4Kzsix9QYVkxkobdVbOzvDo+h4obRAGKgvcNRH1Y
	mzTFhbElytUq8rzbDtrbWI41AGNZM5SGTrKT7zoU8FT75fOaT1frh/GJls4/KmGcXc21bkPO5IW
	sFCCI3NE/CpP1uzaoij/IKV/wXZPZsm4xuPHVQlaBpLakX86B/XkagO58bJd89X5wwqskVjyEEK
	wIYg/QzLOrWqlWToHTCqnOO0y2z5ep7C0idDXSb+LR29eDlfM
X-Received: by 2002:a05:620a:17a3:b0:939:8905:ce9b with SMTP id af79cd13be357-93bb77461a9mr62666385a.17.1789514425632;
        Tue, 15 Sep 2026 16:20:25 -0700 (PDT)
X-Received: by 2002:a05:620a:17a3:b0:939:8905:ce9b with SMTP id af79cd13be357-93bb77461a9mr62660985a.17.1789514425107;
        Tue, 15 Sep 2026 16:20:25 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:24 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
Date: Tue, 15 Sep 2026 19:20:04 -0400
Message-Id: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKXSqWoC/23NzQ6CMBAE4FcxPVvTLhWKJ9/DGAPtAmuAGgqNh
 vDu8nMxhuMkM9+MzGNH6NnlMLIOA3ly7Ryi44GZKmtL5GTnzEBALLRIeOFqco8GG1Ny41rfc5X
 FCSphlT7nbN69OizovZq3+5b9kD/R9Au0NCryves+62mQS2/zUwE7fpBccAQjbQYAKrZX4+qhy
 Sk7oR3YchHgF9F7CMyIlhLTQqlIifQPmabpC25Hi/wMAQAA
X-Change-ID: 20260807-folio_memcg-const-4a67e40d485b
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=2734;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=kVidRnCSLCRIDy0LcPsGCW6n4LV3v1+7iiJ/4lJYABM=;
 b=IUUOAnE370UfZHmbfJ+hzfZc13IWrSCvHO1T7L1Q8AxoiMiDM9A+vJqtBHulacRIVh0hjFl35
 /GfS9f4r1csDMdmNpv3fw4T4amusHZrD7r/pgt+UN2gUz0GBkO0L+Lo
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: ZRg_jcOktN6sXCewPmulBNbtF9z9uobG
X-Proofpoint-ORIG-GUID: ZRg_jcOktN6sXCewPmulBNbtF9z9uobG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX0pmIgRL77RiP
 RPg/+Z7HcqrYKd3vei1TLi6tja81nNFQF6airWjIUGLT+s4u2vNJeE3A7A1HxRbNP2a1BHbzNfk
 R7Hc9BvuA2a2zD1w8nA9sWiv76krG1HyacdU6ZRWGNUmmeJANRzviccf4cbiNs8d7EGW9O8JR0n
 9ACwqAE+IatE2Vo39yW5T/M1bKTJi0S8d6c2AjJDWk831RK+bR/8IJwgyCvLmTUfcFKNkPhjf+v
 tE2rhJZbE+4ht3rVwoDRbY+PiIwsUPpCmzRtUH8qYjn3tNcotzDssewXauh8wnhFM0uZf6qQGEY
 ak6Z8cy/hJit0UvgmgQn2BTmFmmcSBBSS8SG6paWMDZkPGQ2mawiPFmUnYuG6ok1u5P6mmdQ+Tv
 y/70Cy/OCLg4T9yTa/6w33wAVlExQzzCTxxz9TRHaarjK3IrqGTorsYvF7NOOsxEnuW3F+5B4sH
 jdJ1RdPIezmMQp9gNMw==
X-Authority-Analysis: v=2.4 cv=KZVHIgYD c=1 sm=1 tr=0 ts=6aa9d2ba cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=bC-a23v3AAAA:8 a=b6ln72opZJ-VCPk_GP8A:9
 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfXxHVOcOmSsZWs
 aC6qtjlk7KmToidVCyIuk1mniwHwpf2aGxtqzFJs4j6cRk0yAt7z9kAEyGJUH7XENwpQ24kMgcg
 N8MAWeQIYAKHG/PZo7AN9QW8ulMLHNzJIxwMMSAc6jDW0lQ6oANR
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 impostorscore=10 bulkscore=10 clxscore=1015
 phishscore=0 lowpriorityscore=10 adultscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150341

The memcg accessors, lruvec helpers, and stat readers only read from
the memcg, folio, or lruvec they are given, but take non-const
pointers. Constify them, along with the page_counter readers and the
swap I/O blkg helpers along the way.

This started as a follow-up to [1] that quickly grew in proportions :)

[1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

---
Changes in v3:
- Patch 1: Constify get_obj_cgroup_from_folio() as well, per Sashiko
- Patch 3: Use container_of_const() in mem_cgroup_get_zone_lru_size(),
  per Sashiko
- Patch 3: Note that lruvec_pgdat() still returns a non-const pgdat and
  does not use container_of_const()
- Patch 8: Constify the local memcg stat readers as well, per Sashiko
- Link to v2: https://patch.msgid.link/20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu

Changes in v2:
- Patch 3: Constify the folio argument of folio_lruvec_relock_irq() and
  folio_lruvec_relock_irqsave() as well, per Sashiko
- Patch 3: Note that mem_cgroup_lruvec() updates lruvec->pgdat in the
  per-node structure, not the memcg, per Sashiko
- Patches 3 and 8: Use container_of_const() in lruvec_memcg() and the
  lruvec_page_state() family, per Sashiko
- Link to v1: https://patch.msgid.link/20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu

---
Tal Zussman (11):
      mm: memcontrol: take a const folio in folio_memcg() and friends
      mm: memcontrol: constify obj_cgroup_memcg() and friends
      mm: memcontrol: constify the lruvec helpers
      mm/page_io: take a const folio in bio_associate_blkg_from_folio()
      mm: memcontrol: constify the mem_cgroup accessors
      mm: page_counter: constify page_counter_read() and page_counter_margin()
      mm: memcontrol: constify the reclaim protection helpers
      mm: memcontrol: constify the memcg and lruvec stat readers
      mm: memcontrol: constify the swap accounting helpers
      mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
      mm: memcontrol: constify the zswap and socket pressure helpers

 include/linux/memcontrol.h   | 212 ++++++++++++++++++++++---------------------
 include/linux/mmzone.h       |   2 +-
 include/linux/page_counter.h |   4 +-
 include/linux/swap.h         |  12 +--
 mm/memcontrol-v1.h           |   6 +-
 mm/memcontrol.c              |  57 ++++++------
 mm/page_counter.c            |   2 +-
 mm/page_io.c                 |  14 ++-
 mm/swap.h                    |   2 +-
 9 files changed, 159 insertions(+), 152 deletions(-)
---
base-commit: b08a65b93426d86e3f354d655d6225397b591877
change-id: 20260807-folio_memcg-const-4a67e40d485b

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

