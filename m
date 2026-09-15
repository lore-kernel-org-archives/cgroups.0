Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470B94BA9FD
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514439; cv=none; b=ihrRJ+se2oMGXC15clpkVHsowk27lB4lBD6NdbVeYen1FDDZixEDe5umgo+Rw4MTLcttjRO1XIJBqaBNf88N0EYEudbamHt7V6imEhDhh516+ehJ90QrS4Ki8PGG+XdvwUZ01nSfCfkqxrr8rq9W11X/PhLsiF/ZHaQu2LUTtDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514439; c=relaxed/simple;
	bh=XYSX1STKs7pY2BJKy0yWW5bNGeM0JlasGEgQi71dfYU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lKkoS1029KaqcW4c5ZXY5fCwNfJg336TjllhpyL1yY7YuLoHpiPppSw59vfjbMK9LIpw9c7PPAIMR+MzmUmiYx75q3RUkN3rEK6jKJTFf4g5azFqJ8T3YQYA22kOdZdrpZUXWDcqsPMFeZzJp/yTE6JpB77YyZrTz3yt/OxEujQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=cGCg8xNz; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=vptd5ddQ; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="cGCg8xNz";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="vptd5ddQ"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbaNj4081924
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=zYst
	SgtBe8Hq4n42OjIRpApB464faVan/JfjqkpIk4w=; b=cGCg8xNzEcxZDSZEQJrG
	5wDBt7ZPPO7H7lMeSyxZ6VLAl5vmdsgxOH/kjRmnAnJOkePo2KkJ2PVnIlEJoY8I
	u79tIXjIcUW11nfnic3Wt+RaMrpmXozc+dStJrZruVZI8JYh/RrkNX4yEhRUzbC6
	Wfx0/2xwJr+9MD4kWxmUPRqggE/tcQvpVCOvWkxxFhjfM2qvQ14sFwiu4PO5DT1b
	4MPvShLyJH3qa3byy7FfEeHhxfdPHxHJFNSWsDXbjFs5CYq4j/LkuJBXhfbzha0R
	I5piae7jXD7tj1SjGEH7aCZwp1RMwRrT+mRU7kQIICTnWNm1Q88D0Qvc6C4kX+UM
	iQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwaj2gq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90ce8ad8002so113947326d6.2
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514435; x=1790119235; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zYstSgtBe8Hq4n42OjIRpApB464faVan/JfjqkpIk4w=;
        b=vptd5ddQIrhthpT4v/blw52MnRlk0gHsEoPVuUYwlRISiUm/eBPc4xqhjYBfvib0ED
         zSJFZMqaQpPSXdHlsotuUB3tlgP0nEg9B/kdg+XZZ1DXfjChd11yGFxi4/sb9K9PYhvB
         ERM2+XLfI/E5kSZEudrcu/ybmgoOj1C4cMejlSrdBRtG7FWry3kSWmnJK7VuwoQ+l9Dh
         gARFdykGJN0NRYZteNtcLlFwXoI94ExtJOI36OIfSfwJkxnMh1PWHa7zz9F3dFSCo64W
         Vdh0ZkV+HGKTS2dZq+dUF8OA3B5YDIbkFqme4GFd3Ety2f/GGjqS1bAf2c3dwQvQoIIR
         NvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514435; x=1790119235;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zYstSgtBe8Hq4n42OjIRpApB464faVan/JfjqkpIk4w=;
        b=fwV/a8JA2pcn0bKVn5rt6PMuK/j1Np2ceTwMAvHBjZiVDcKW0APon+Wc7AUtcBylLY
         ynNWlo0o59GcvOl4ldoRcFffHgz4ZR1hP9zhWl8jgpVxhVU7yK4AvCCEgGRBCFmQBxe9
         PDQ42uDx6x46qnAJAt2NPqYbAVCcKLbHpiEnCz5ytTRaU+pUaZ4pGBHb4GyEtFly70YJ
         A/+kHtJv35ypkuQdfvBnON+xbcethGEENDwV/NThm9OPfbWGevVicWRbjPi+E0YCwtpU
         losfBPl0MLS1kwB2CGAGjISlHebwSwa3Vz5AhMqkfvVutRyQi3om0QkQLONFBotmRBFN
         MjMA==
X-Gm-Message-State: AFuF++mn85s1KZ+MuKaLnPy6aHzje9mcqxfVpbnOvowZLi1ItV+15zaH
	IVU+Umbdo8gf4lCK6V7Chb1BSp1gKqK+b9LfWPxLR4PVNHJvo1que/1Ik5GGpxXdzxFdOP+4YGJ
	hUYnD+W4y/mcbgI99XDz0nTQJFvt79NsedpnYVdKfO4/a2D3i7kvRux0c5zZFZ7A=
X-Gm-Gg: AYBFou2VrNfjuB5pBWSps47AyKpYQeviYpTADt31v3YkoackI3pQhyR3SvBfeXDVMHF
	UEcPDKf7TiBu2hlyB9hcbnJfKVYXUNa8q+6pbaNh9wqUTK4vp35EB3hJS2CSOZduFFZ0kIAqs/w
	JCJtrHXqyenOeIxTQ2f+zRsj+yjqssNLG4GhcMHOP5c/wk2EGrXOr4KGBO4pOVP+ldGggepr9EG
	9Cj7pYcqpA4uwI/vtpM046ejbscW9wtt/jTMfZ8hdt4B3vqqlk4BbW/nu1GDnhC4cZAtlb8dcNJ
	zbl8DIz5FMK7mK/lQek8LjpaU0xHvrJ/7mt+/Tpnmg1O+kxwIbFrm8BQMhjafpWidhb28YO9dc+
	xEOONgM0YZX/uCpMAmolnoorZKpWe9jLljW78nngDLRig5SVX
X-Received: by 2002:a05:620a:44c4:b0:939:4b31:4669 with SMTP id af79cd13be357-93bb78819fdmr56114385a.29.1789514435345;
        Tue, 15 Sep 2026 16:20:35 -0700 (PDT)
X-Received: by 2002:a05:620a:44c4:b0:939:4b31:4669 with SMTP id af79cd13be357-93bb78819fdmr56108785a.29.1789514434915;
        Tue, 15 Sep 2026 16:20:34 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:34 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:11 -0400
Subject: [PATCH v3 07/11] mm: memcontrol: constify the reclaim protection
 helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-7-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=3509;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=XYSX1STKs7pY2BJKy0yWW5bNGeM0JlasGEgQi71dfYU=;
 b=XMrYI16sLOgXeu9GkCuBWqYbFcUTVRSbq0eIip6J9+7GUVK0b2AW8AUTUaE5Pl/y8q5w6PDb9
 0to45QH3WCZCbT8l/vlyV5g6u/GPPekY2Us02TcbUO452qgcavZeFPx
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: kDtbcFj6U6OvulYbF9tHvOY1rQygGpEc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX6Rj9UIoL7UAD
 gRR1ECa0KX2MX0C8Q+icqjzyaqfV5YsJ9oThT8sv9cIi0Fp0dZQCBVDhDcq7yNtKUGSGF8Qj9sf
 zbB0vNf1opUUwkLORNH4ZxJpKxesKOeNknRXZrrt9u1aLj5hxxcs4KSCYdtJR/mplcLCsdiRFbA
 rucjpFeqZcqJY5/ltf9WIUO44Up1Ic5S/0mfF2jWWMBEeyJcJp8txZwEAZ84TBRQXpxUaXm9fcL
 KFx4Dl8eVehS92k5Ie8wJHMLed3AZ2lNMj+RUDKN6e11o9FumlPmChw99IYij4vtRmVRKCmhXSw
 oAPmIgmOpsZkU36KMe8Cwvub1jaulXjOaXUK1xh1MgGn666eA59ozlkDm3pkwSJmZ4knHFmFlUP
 zE2joWijTdW1aHWz1+Y/KV3DBFnt4fAR+4lNGptePFSAo+5y3EBlIa6eLnjS5F9xEU4B08tf5Cf
 VWFVCUGfr44FlHz44xg==
X-Proofpoint-ORIG-GUID: kDtbcFj6U6OvulYbF9tHvOY1rQygGpEc
X-Authority-Analysis: v=2.4 cv=JP2uIMKb c=1 sm=1 tr=0 ts=6aa9d2c4 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=Qozanl9KyY-oOybludYA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX6SRel4Rig6KE
 zwFm+dxvD+2ZR2Im4++J7ukdX6QaZc6EUgTwCIdVowFrVKeELNybBqbq+1QiCwQg5MDo/vS+Ag/
 Eu6XOtoakbTz5L9E7Lxw87pyEk8Dwj10ZZqvrAJi6g35n1HRZMfe
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341

mem_cgroup_protection(), mem_cgroup_unprotected(),
mem_cgroup_below_low(), and mem_cgroup_below_min() only read the
protection state. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 01f74413fc79..22067899eb6c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -570,8 +570,8 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -625,8 +625,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	/*
 	 * The root memcg doesn't account charges, and doesn't support
@@ -637,8 +637,8 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 		memcg == target;
 }
 
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -647,8 +647,8 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 		page_counter_read(&memcg->memory);
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -1149,8 +1149,8 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -1163,19 +1163,19 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	return true;
 }
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }

-- 
2.39.5

