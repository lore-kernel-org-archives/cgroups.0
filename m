Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA9C58FD11
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883084; cv=none; b=kAnBsiRysYvBONjqIPyAckrHTP9bpBMhHXEUGy7DxyD/nfA2Wfs4YwBt+bDW5wCYFsrbYM14cbhhr/BGCBMH7cvRRjfrOegIrB5ElCrkhnpqE4SxqgJ121eAVJXLph1AZU5pPWWHClAHBD9yFUYuSU4GfmC53291mnHBzEMo1cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883084; c=relaxed/simple;
	bh=sTxDvcBSc00s+E0SSNkYgU0cKv4ApygZkq2VbRV+db8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g8u05SMaLE/nYu8J4t4GQ/BbvpM5x+qKvSuCk3GFVpscN1rnvhut7xs9ZasB1t0g5a0sZNfe3RQo6Pp5n/p9+xr4Wj4nSo3yQ0PT8lmN3+5nOg0oyli4nisJcHyRtkxmzPnQ6OdqJLGL1rF/8cyF8LzFeK2kWfR5wtwO6xrQ0RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=mFTLj215; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=h7rBeBdc; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="mFTLj215";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="h7rBeBdc"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbiEl426516
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=VZAo
	AKs2Ax9DnjZGlZmzQZMg+pVNkC6x9N/eAHovH94=; b=mFTLj215gL9krPEnghEW
	BkCATtqnpnf81Q3cOJ9R2JvvxdtoE72lSDbkObhiFhaV6HBGqwfUdjUjppn5EdqR
	GwHg85a8euVyqr7aztrEESAwfVl2NJgSn+BiCgP2otwtdP7F+iBNyTJ5OvjqUH+X
	0/GGR+uLCd7RNZB7DA/wERFnd4GEGFJiQ9IhGZD/eiHLtXtg/5yvN1H5C94l/Swo
	KKGqTLtBwwSt89K+jVaHjX3t8EpIb3Am52sasc5eNersEdmkInGQu0yRjBqc9n04
	bNmOUNsFq8FBtcSIK5iIVMJLjcCWsoR5NGEGzKZirP//87jVf3mkCXbLf8IK/lPz
	ew==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmv7gf2d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:59 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fa5c5a4a6so104346311cf.0
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883079; x=1789487879; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VZAoAKs2Ax9DnjZGlZmzQZMg+pVNkC6x9N/eAHovH94=;
        b=h7rBeBdcXYe2SJISVDDSNG0X47NV0WDgEVVavayY7VS1nuxh/SqfICMVLc82yzpZ0u
         3BmX782mGaJAYOrZqxPgBg7oMLgUNSjoEgIHZJlyoBrqTyj6vk1iPHcE6PMnlKE9sO3T
         dow9Y/FtwQwDdBFR7UyjgJZzeLAa9oin73pfkVRoaJ7fQmvcu9h/4wg9SMwlAW3OcZox
         EtQYYiEZkMpUp1GqvTYeWljjQ+TRUTKkaSY4UKanvwHLWfhpOTIPK69u4GIViiN7I89c
         qx5c5IWfIsXjuwL5s0uSgmzEyOxOGLhW22I8DWTjrHZRmfBYFqE0tNo1CuqVsVf4CLMd
         W6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883079; x=1789487879;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VZAoAKs2Ax9DnjZGlZmzQZMg+pVNkC6x9N/eAHovH94=;
        b=e0q+CKc5gDqy3V5jK152J4bCGeuDXB7ZmyK3xhxm1N0DMZb8IZZl5KkhSES9qZRBFB
         05NBD9IYosOIm93LzBfh7FrgZl3mkfJoYbf4pM55tD73FW90pBXYzXB+//PFZzkMwUdF
         pzmYkXlcw0wFpViVCuIZ9ySp5QVIBznfvCOb5tZcOquhHKG9t6HAj1zgy2DRozkg/Ai7
         jLMHrt+JjiooRTKaM7CwNSaXaIndGh57ZFux3M3EelggVNziQwQZzgEFCBfbCNt/UZO+
         qxCKQ7odJOoeq47h5fLjqdJltPAUe/nB3QJRxLTGCmn7MEuEysATR5aQUlfnVDsZm0Lx
         4SxA==
X-Gm-Message-State: AFuF++mJLLBp1UCWfGzej3ArOJ+3Ojj4M5v2M83cj2uGmHLZNCfA/asH
	5723zRfurGRSfc3vEvhY5geKdmlUD2b3vsbeA50E1m9/GnhkpAvcpVCIuelQZi+jCecBhnwc6Tz
	uP8l+8tFFKVKQpGxGpVBRblh3kBU3ooqGrB5alfRQmj0q1xkq5R2JKQo=
X-Gm-Gg: AYBFou2Z3PYOWRPXGWkcrTK9INvn7SPeACIHSF+ZWvSIVx71EtlKUAdrBm0iy5lwtPJ
	FDlsHV2zKmls6e/svODESU94SZ0v9LT4QIsRzPCxlCuBaOu0Lu5/HW5c75c/BodyoA2qVeYTldR
	xmS4qmkZsOsTWipF92eD0sYEB+aLVyPiRjqgh6ll9QUfpc82ZHKiF1/NVKpVydPPBBUiNIbMO+l
	ZBx1rsKEBi1yFy5INZpEPKXGz9/h3/8c7u2gzRcnF+FTs07ssupneWO8uNR6wGRFfgUJI0sO1jZ
	O2rp5X0Tf+OJKM530osCOZKwzJbLLIr65Om1C/Hon5Emti+e7ORswsmMPCbCKYOzwImIuY33JnJ
	flT94BaNjUi6BNI+37gbnjJFMh7SVaJ4pwwXc9UJPgsCoDYRk
X-Received: by 2002:ac8:6f1a:0:b0:530:2146:81c with SMTP id d75a77b69052e-530547ebfa7mr375745781cf.12.1788883079056;
        Tue, 08 Sep 2026 08:57:59 -0700 (PDT)
X-Received: by 2002:ac8:6f1a:0:b0:530:2146:81c with SMTP id d75a77b69052e-530547ebfa7mr375744731cf.12.1788883078431;
        Tue, 08 Sep 2026 08:57:58 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:58 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:47 -0400
Subject: [PATCH v2 11/11] mm: memcontrol: constify the zswap and socket
 pressure helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-11-811e9f443409@columbia.edu>
References: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
In-Reply-To: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=2712;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=sTxDvcBSc00s+E0SSNkYgU0cKv4ApygZkq2VbRV+db8=;
 b=sJizXWoGo1rVvGoDXQiLVN33M72gG7xZZyNbel4ui+3OC9JpfjXFuF9ei+YJLkZw7mYNNJkGq
 7hffOHn34/7AqSurvRku8iBT7qln4VRWvcwQhBnarz3BH0ZJAGefK0G
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXw8BKXXRk1wSP
 qzs068I+jNhZZ1EAhtezjPAicTByBuwM++tzAipa0XbZ224sVzzPV95eB+rwQAOj8jkyels26XB
 Xq5RDV5aBIQBS4hThPar1DXyGfAQQ0TG8XtHcXRw2XcjTZjIpws9PNyMamO94kufEM+AUKv7C+q
 yKN9+7J2ZcMPDN9pEW4Y2lk0H+PIACwky7ImX8Igf4zCqPI6aTkJDfRoffO/reDBQOspJ+fpT82
 VBuUVoefIZI/b5zGlW7I1fcgPAAbKmrUhYVAkeX5ffp0jKy5OZQ2BG00bKpCYlu6ioyGlb+hW9W
 SgTZMS5UsHX8iLUBM+fpIQBfUDD4y7i+HdmHDODS8A1XIKsQpinvqYaglFr1jIqPZ2o+wEOhvKz
 JZQcg/3pNZRv1/AdcAf71ucKiM5W3xxGcpxUl17AQ1qS7i5sMsQXe81dkuIdOBgrITAcsYIe2mm
 sDoir/psyXC7Hy/fStw==
X-Proofpoint-ORIG-GUID: rFWxO0uU4Gk82NKbzdnL-oCkip9PpLrG
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXzcF4gdapxQC0
 TBD+4oBNiZYqzEz81xZgwSgPC7KYoC8bXlKFMWUZwJ0KEGT4wTXwnC5PF+Jo+ibK548y6uEQnmq
 GhJgQA3ndoE477vXuY8PxaVe3LBFckooAv4VfYNWNyFSXJngSpJ9
X-Authority-Analysis: v=2.4 cv=fpnsol4f c=1 sm=1 tr=0 ts=6aa03088 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=JrvLMZgmaQ4VKr8cMrEA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: rFWxO0uU4Gk82NKbzdnL-oCkip9PpLrG
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=10 impostorscore=10 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172

mem_cgroup_zswap_writeback_enabled() only reads the zswap_writeback
flags, and mem_cgroup_get_socket_pressure() only reads the socket
pressure timestamp. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 mm/memcontrol.c            | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9fade4667d9b..ae044d77c79d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1684,7 +1684,7 @@ static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
 	write_sequnlock_irqrestore(&memcg->socket_pressure_seqlock, flags);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	unsigned int seq;
 	u64 val;
@@ -1702,7 +1702,7 @@ static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
 	WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	return READ_ONCE(memcg->socket_pressure);
 }
@@ -1927,7 +1927,7 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
@@ -1941,7 +1941,7 @@ static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
 					     size_t size)
 {
 }
-static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4de2aee45ac8..517995e418b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6259,7 +6259,7 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	if (!zswap_is_enabled())

-- 
2.39.5

