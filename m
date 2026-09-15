Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A06E4D0A15
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514449; cv=none; b=mdD1kdBcLaR6JNEvKLXZFQNCKqfsF+osTstDGCyXSYM3hr93DbjSaSoN9ZCk1GD3eDaVGtj92V2SeTRhKjcJWJws8MmSVu2m70wa/PkDXxatFuhwb7ZtMhxufhLWibxr4P5oYJPdo0A51Z0whCHcI8049/yuwArWTzrlo7vZXWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514449; c=relaxed/simple;
	bh=gfXjN3rS0S5wCNAreZHf2pNt2WW5g1ntWcz0DrURYW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BGo5zL92te6OqJkcBsL37Ezn60VGJ2jb2qi9cYwTJRVXf29apR5PCeZkYeVjSGi76Det6kNe7v2CCyDZfa0jrOpSFYyEKwgwxC+b+BcZlkgUJH5AIp9h2qEg3xYxuLxzL+PvYyBC9lrFvrGHUt0IMz7gLuzQ7j+gy2GqKCWK82Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=G3xvhvKA; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=szBaoADf; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="G3xvhvKA";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="szBaoADf"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbm9s4082509
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iohs
	tel+U4w+qu+f/b24Nbqr30/JwqG/BmuqFbjm+rg=; b=G3xvhvKAasRnOUA3QkA7
	O2B5Z0uiInOE5axuO7zjxdNfV1nMjxqGzRKfdHZwtNs2v9I2fhaAU7pVLB8HUXuf
	cKtVAxN2asgbRT4r6Wpi2IBwWrRh9eFjrQ5WOWL2kb1U+4zKRW9Y/+7o7PfyFM4/
	DVaAmcDH0BxcI11Au0LNcgLdDlOs7Keee1puvS7aMma0BOSR+srHsynPKksRBr+o
	3PZhy3uWAN4MzQkWSq7F468MzGFeVeFJ2ylwfqNEnOXVv5+/ERAZbGzEQsZ8ZjoL
	rLTMjcFh7/EcT1HlVmFRhF7QZk8BlETzaj46KlNU/L5UhjBxVbIQ97Y5ALCt37OL
	3g==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwaj2ja-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:44 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90cddf4f59eso105737216d6.3
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514443; x=1790119243; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iohstel+U4w+qu+f/b24Nbqr30/JwqG/BmuqFbjm+rg=;
        b=szBaoADfXnZAssFEiXlHHQMp4E4hOxrapfcw20dRAjZlksx4CLSzgRTHQwW1+XHi7A
         adx1jUjKSnLO0VWirGiMsbZ0NBkiHcfCtwkLlL3OqziUiydwzqTYvpGF0zBHq+UCG4Sx
         wEdAvp3C4GPZAGm1onv0ljyYJsy3fBsxDgKcOieNUhHvl57QI/iaR6neiKg4Ac9l1gqy
         HLjR4cNOubk1DOTeqUVqhEapOjzos7aXBfwGMws+pS9hdAMaHqI/zDxAgKzcqaycePUr
         tQGB76aiczO7nP4UsMUf+vq7/KYUNCDwHFIOH3ASdjq1L0oObPMYH8EmVKgAX7kyPeGA
         tDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514443; x=1790119243;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iohstel+U4w+qu+f/b24Nbqr30/JwqG/BmuqFbjm+rg=;
        b=YpHz+vwbMXW+ER+UtN0srcb5xlgY+X298mVq2laj641Q4BXAhl40VbU+zMVWX3sLpW
         ZACRQPx6sjTelrnaPEfk5tSSZmMfY+2GAoa+6IejUMDdWe0aLS7TIlM+lIbnLISQo+G5
         RDLjZzu/fatFe5pa3PO43bqD66g6aBgfvlvD6ExR6d+37/sF4hbHLFehVDZouC2GY/tq
         FwXMbamAGghFBq9gjpLCoqDOmPXBsj+HfH/cG5hrdCkEj37mQE5vbXS4d2+fWmE3Z7C7
         OL8nC/JeBZSGFji6MtkTOx7etmSKvSNYOrZ1Uzmb+ZEMidYDDs/jpkwUq+mbAA85fGLB
         Lz3g==
X-Gm-Message-State: AFuF++mEZSi/K/D1d/lStbg2cr+Wtmq73uyBXht+simzyhbnqp+SA2PS
	cPHO6wx3Z4OcMwJYO3MNNjnYaqYulpCLSb3REElGySmCJui6kLaZDBnJ562ytKxOZkhzUsKaAur
	CFTv8YPczPHaoiMb8pcS5Ane0Bo9CE3fwnv+qIk/YQ0fpIJZuI7BVufZcwl0W4OY=
X-Gm-Gg: AYBFou2Lw8DSDOmPddl5RttOBOotg54z3ul8kBHcLGhDYvEa54Rz6zHmuYguLZSnDRq
	R1LoSfAnyKged50xfuD6MpS8pw5TnvqBsqD4L69p0OzWhBMoIK+5/ib0oAaOZ9PS5lGQZZhIk0u
	1rA8cKyqgEhKLuREMKrK5eoF+sZbWf3FCenhuX9CF/79d4LLScufmsXnWPmqTpdCMrrOAgUyQJT
	L735iuoQ7iBifNMlLOybLn4bZsMXGi/H7axNRL0ud+1l3ZhQnfArlw9eEt6KBxlb4IJFdX2sUiN
	V2BwomhlDelMErVwFWKuFgBY633yIjc4HvG2igFYctMYrph3u6N6dO8GTWMMAC/ACjN5zfEsReK
	oUQDb6o4/i6pMg78726Fmh7Ync5gV5UpWw658uQ3yVFQ2Mc2o
X-Received: by 2002:a05:620a:25c7:b0:93a:2e8:5afa with SMTP id af79cd13be357-93bb78f8162mr56613185a.30.1789514443493;
        Tue, 15 Sep 2026 16:20:43 -0700 (PDT)
X-Received: by 2002:a05:620a:25c7:b0:93a:2e8:5afa with SMTP id af79cd13be357-93bb78f8162mr56608185a.30.1789514443031;
        Tue, 15 Sep 2026 16:20:43 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:15 -0400
Subject: [PATCH v3 11/11] mm: memcontrol: constify the zswap and socket
 pressure helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-11-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=2733;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=gfXjN3rS0S5wCNAreZHf2pNt2WW5g1ntWcz0DrURYW0=;
 b=emYpUpxeMYySXBIAaFOu0+xjuyPwfYFvwTaSgzFVe1rapWKm637OoQF7dwjdaMdFk0pkiDQN0
 2iGK6p4657BAVZ8kUeMyipu+wfuTYfdoQtzBPFfXoE1Jh+I6JIxr+tP
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: w5IRrvbcTtvXCtYpfMr5SUAywbIsk61n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX8sB3AWrQ2lmn
 If2LP0jz+NjjUk9OIT9S7rWrktnoYPxfsyrzT21EpWq702rtza32/VTxTpdNGDubjhgdCdEi7KG
 yeCD8mZoKdYTxMLHXzHt3e8/5L6bBuSLdfLV6H1zPtOkh5Vj6YWdvjp5JDxcYeR2Tt1wPEZU+oG
 Ycw5hTNF6L73GDrYB2kJZ+GSkJvAM4MuLyuvhJJW2yGAH5wEpggJOCQP4uM9kQzDgKsTzSy2Q5Z
 NGGctA4QNEWfn3LXoWbsbeqJXQ0QX98Wc7Gb6qOOwfyZJhGvxriWSCZ0c4KjnZSj4+L0pnc/Gl/
 EtKLQt7WTpkP8k0JSEsd6CctCQzKTVNlm+vwe8iBZDd8RwW6AQJXPN4vHEqwjEabXJLzEd10GIU
 ZEhUcv0nCJymROIDY/qRLh57kRp5bsBUEJ4eAX8tTVxSm+Ar5Q8owbra9nKvdQd6babfMratOUN
 IC8lJe7bWRHcaIrnj8w==
X-Proofpoint-ORIG-GUID: w5IRrvbcTtvXCtYpfMr5SUAywbIsk61n
X-Authority-Analysis: v=2.4 cv=JP2uIMKb c=1 sm=1 tr=0 ts=6aa9d2cc cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=JrvLMZgmaQ4VKr8cMrEA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfXxPpszOzB56p9
 K3GJDQVq41/N4pQmoqrN4hBcsZbHxw026Xt9i7IghCE2xV7GGnjSSP4Zy41pHi2TBR0a2ThJvIx
 6UuNyJog8cYrkgJi+m9xS/RNB402ZwroVE1TnDLaM5BVPt5ltDb6
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341

mem_cgroup_zswap_writeback_enabled() only reads the zswap_writeback
flags, and mem_cgroup_get_socket_pressure() only reads the socket
pressure timestamp. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 mm/memcontrol.c            | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f11899085473..64c183be8cbf 100644
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
@@ -1937,7 +1937,7 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
@@ -1951,7 +1951,7 @@ static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
 					     size_t size)
 {
 }
-static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6e3731b97690..d0f1b8782009 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6304,7 +6304,7 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	if (!zswap_is_enabled())

-- 
2.39.5

