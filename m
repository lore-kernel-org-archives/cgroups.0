Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A724344046
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514437; cv=none; b=Zq8HbuX93NTreEoaRDk6kwdh+mcdCzPrYiM1E8ValIMOrhVcKhgqEhcugkLeaFC6ukwAWcWHANgp9hh8npzl4mdQWTfV4Z4VbrgcZqUMolbfodNeHxprg3ZUuCiTLcyuVRLnOWaIVbU7SfmuVzJGD26ik49x1Zq524v4tTUbUZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514437; c=relaxed/simple;
	bh=QU3UUXZVJYXJfewV6rqLP/CJmky95kyoP/VKGjLhX7Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QB88MNHX2Sf3JdzFwICAWDHTlIkn8Z/g8jyvbFWYdgJKsNs+Ui+9urS9OVRfTlJ9ZRy9guGQgBTDap2d6kEvh02eMnxDO0QN6jRiiC07legoM5RqJMIZ0ecD8GJwtEIdi9W6pEJJD+zqSsb4qWEJkuFdBQX5ZhcM9CeCeVmyUk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=kJo8qCDv; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=lAxpUVaR; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="kJo8qCDv";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="lAxpUVaR"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMc2Wl2572909
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=syzB
	FL+Amg6nq5QuTRVjxU89GS8pkXXrDTFoGCnbJAM=; b=kJo8qCDvINEVZqP/5oth
	HLfSBaOLnWVkh7Re2h5liuZWA82jqqvlBWzwiOotHwZJh4aXBRx4H18KiT5ztxIf
	2Yu1WLF1GYjfcjoGfm++1wmUhLPTC9W8kCVZsiuQHjw/SAuPQzKPyLha+DmMc8Dr
	LSFoYs987JATwwVrnE7c71/2GbM9B+i7KBDpy5896pyNa1XsJtPAcxaOs/jruQCz
	+m7cTVX+opvJXhb4R5RgPp0n2bKb83efc4RwIlldPELbRHxzhzCnX1WIGGYaACCj
	pNFMW4DiNLBS1cmUIWTFYC16us+OV8Bl34S2O9/ZWQs3//qbkEUhrjjkNO4H4v0F
	Yw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwd9sxw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:29 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9308eafb465so1253883085a.2
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514428; x=1790119228; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=syzBFL+Amg6nq5QuTRVjxU89GS8pkXXrDTFoGCnbJAM=;
        b=lAxpUVaRcm0bZXx6/c4zRi/vOHnDpL1xfM4Ho7ZxpMR70cUX3z3IlPQEIYP3hoVv09
         AO78s0FF9XoA3LWcJrTzfL3a9bb25uIXs1dCAzIBoaYm9EQhjyN2wlfsT8t58in0I+1G
         NpIA0EMYktNQzf0EsQeTVGsfyGnfw2+QeXSOoVBlqT5nAKZDCU20Dq4GhuykgYiONhJN
         zC8XXNxSll1CqMsSaHR8mZnLyOX+0Bx1avtUG4gcMeHp2RYaT5ll9BDbfAMg4KxVgnjc
         ysdpZEnEzcD+D3LmbTMxF/tOrh63/W8FNw2KJTJhjyW2VuxjUGngRmFl3lPSubDsJlvm
         IdpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514428; x=1790119228;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=syzBFL+Amg6nq5QuTRVjxU89GS8pkXXrDTFoGCnbJAM=;
        b=fCjlo2Tx39zLWBIPal6jfYVAMuCuuAdOvxDJRzBn5sYy5KseCpw6VM6NS7lEYVCc1n
         r9XF5oD6Jn7rwU96VOzUgI7xg2d7OVHPswPYwi3FHpon99KdRyHkJorYW0+Wq+7hBZCh
         9n1G1G6WmHQWnv29hDRNCUhB0NkFlTgTEas2aU41v8tGpyDjrnxQUxKC7BqM0YQRVpgV
         2hg507YS29NpgisFX3Nai+8IYFyj4Wj0w9HCc4p8cxtjHoik+UdJeaeJFUyGUJ5JMwHb
         BXEXE3ygDO0rWPhCZ9LhktJQr9z/Su+hGU224W8rGGsorVi9QJr4tS0zwfRiAZSJTV7U
         01cw==
X-Gm-Message-State: AFuF++kZwb+eicTHraKD8XvZMKlrESdwG+UO6sPu/g3RRUNKBPgPyNNQ
	Bp1btfZHt8O5ZBQOGUdfaVDjYFoZwjsg90YV2PK0P6feyfbvrR8pn2gR8jiq4G51w5HuuwFmIy0
	3cfUDUZksk+8FS9HnEj0Z7b0FpQM+m7j6uRTDfkIpkim9tCuzYlS82jQ6WMx+dJE=
X-Gm-Gg: AYBFou3GffC4U1IJaz+0wvIUoMgef3L5jZe9HpnjASTPrICZRGtLgpQJW3zbuATpoja
	sIYP8gc9rypuh82JgWNiPpAclHpb+ABO5AhzH+NOA+Ae7QODT5LXKUd4KzOiJL3Z0F3XchtIlA9
	3UJaneU++6hCtwSiz9+jVjHgNL94Nb9TrF7Tk93RgrcRhkQBVP5DH3UfpmnIOiXMrXJ2IBm8H+4
	naKntF7Nx8Jh32Cy88nqOIihI7zTcLL5ERMZ7gLt90HFnG6qfqWoGWNzLJ/IrTZW+EOx0gX22Qa
	TzBAwX7GGFZIiu5IbZaOswfGGvTyWUDK4TmtbSlrdi6xlerbLccU1AR9cukKiYmoJMWOFYRRP97
	dApkmDduju2qGEFhkF3s1RcdjIG7PI9+mI6GTbMsCl+LozjPR
X-Received: by 2002:a05:620a:2711:b0:939:869:a8bb with SMTP id af79cd13be357-93bb7715c0bmr57406685a.14.1789514428294;
        Tue, 15 Sep 2026 16:20:28 -0700 (PDT)
X-Received: by 2002:a05:620a:2711:b0:939:869:a8bb with SMTP id af79cd13be357-93bb7715c0bmr57399485a.14.1789514427821;
        Tue, 15 Sep 2026 16:20:27 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:06 -0400
Subject: [PATCH v3 02/11] mm: memcontrol: constify obj_cgroup_memcg() and
 friends
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-2-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=1873;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QU3UUXZVJYXJfewV6rqLP/CJmky95kyoP/VKGjLhX7Y=;
 b=JA48nYviRKcNhLAAS6ffUDuwEht6UL6bjWqY7JWZ7J4zMmEDDLksEm2DyPuq8wbZkrLnj2JIK
 0WWHvP/d3RCCkeC2+GDxfaabWve5E+SsXaz8G4xxUSWglk4KCH+Uvzw
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=JeEpPkKV c=1 sm=1 tr=0 ts=6aa9d2bd cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=HbpFEVrQSsppjrtFf58A:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: OMsNC7ppW0g0z7grSVu2lOzRN_b6KrNd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX8OX6fusDOLOG
 JRF+IEdTu0DyTwR1RtJpjm+nInK0wF1MaIeMh6n+sI622JWrQ0S805WnzmKwBeNuMha14hPW2TV
 NthTayRMYiz11VU0iRttGU7KEEqdF+W/IT7ojUJIx/zamKeFY+bkzCGJ+l334tVNkPkYICjGNM2
 OUDxvBvB3U4Dm0cKrg+0nQ4ddm2NYMR/X/6Fy4FhGzLq87gAnxqb1A51cYsinC8MCQnYGVGx/mJ
 u98DK/8udRdcdW2S/zB0Pq0XDEIxuWSPm9tsotjKnkmhp4cfrbQY9A3k+onitYy+PYtTPq5YrQ8
 pLrKy9ps5gU0xLQ+GajtniffQWAYJ0b0GCDJQm5DSpE0ZBFpjEGma8D3NBFDprVz0jGN6Hr124T
 7XoFAZ2QmBrwmCjPuPaYHBXn7G0TsTsgKkDiHBNq6lJrKb3nTBo6Ojzx/ENojl6mwccIehg0+Zl
 EpZ+fbEtdig/RVXvWXw==
X-Proofpoint-GUID: OMsNC7ppW0g0z7grSVu2lOzRN_b6KrNd
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfXzzl91HL7ADqW
 h1LDQxvcG1RVw3HB9V/ckFfmtL2NZD2g/0AnKQBYuvFNz3t2VUqc34iATTJ1XP5ukn/JCqKdji3
 EDg4yQ7+H7GrP2PKJwDacePdExhWRQykRIVnav7fx+oUwewpbwnM
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=10 adultscore=0
 impostorscore=10 malwarescore=0 bulkscore=10 suspectscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341

obj_cgroup_memcg() and get_mem_cgroup_from_objcg() only read from the
objcg. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5a5ca6814782..65cb45f4be32 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -396,7 +396,7 @@ enum objext_flags {
  *
  * The caller must ensure that the returned memcg won't be released.
  */
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
 	return objcg ? READ_ONCE(objcg->memcg) : NULL;
@@ -505,7 +505,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return folio_memcg_check((const struct folio *)page);
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
 
@@ -1075,7 +1075,7 @@ void mem_cgroup_flush_workqueue(void);
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }
@@ -1104,7 +1104,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }

-- 
2.39.5

