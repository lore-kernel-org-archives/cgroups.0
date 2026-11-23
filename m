Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795459993;
	b=2mPffEmPGTrv1ZmYvz9CRsLiFAZbRt5mmGlsVfaBgetYO/0S3yWoOfjO5MXZnZy8/Jjk
	 6YpiHQs6QvIakgPGsJHT4io+DdP9+9ntF7Y61bij/WODFuhFXSzEDxVBR53c/zQXXIpQo
	 Qblpe19sWgtec4dih9lfZ0OCXTASXA5G5BqUVkQ6lmMi7sMH1t/lowW7YOhsINAANDRJ2
	 FN86S5Z+wDq3u3MMSlOA4clsCJ5dCdZCxpcnki6GIvV6RgnHlALXvNYCe1Vj4LvOX6zEC
	 JWHNLCTW38ru4E6SZjfctQ612LBcNM4UV34TmhzhwGvJ768CFdhUFumXfsZzND9XzFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459993;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=1rCE3K77C597tnpDa8DpHCzRg0yY18+BUyGptbSaO8M=;
	b=CeEx6NvagnKY4ElUH/EHG8jzXwj70iwvWB3oyIHQs61Z1T7YR58fFnaZBH5qgxmNY+w7
	 IsXt4v2pJcd3b6IbHfoYPaNE33tdCE54IHZ1A1CRuyMFiU1W80T35IWzN1NW3QchPAnyT
	 iGHIww0LhBLpOhNkOK5jQjK/lgLqOnDZ+9to8uKTJ6N7et/bb+rFCGaqlI3OB+XidhEIp
	 GSZw4SXsOss1tqMM0vs7mKjtAC4vcNvPchuOvERm10CjPe5w0zncqQFWq+Ado4PbiQZ2z
	 TSUAMoZj8ZYXnrcv3wlLk8E8oMeD1ax31hFLHVRTYJwAapGysrDW9P9SRxuLHwsMJUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SoqzW3ro;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9890606A32D;
	Mon, 23 Nov 2026 18:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SoqzW3ro
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795459993;
	b=bqhDcFLRttrhaMfzhfYIqqYHF5vH8qS8rizifTObbzmnr8Twidvfh+9RKu8JGW1GidIJ
	 cN3OYmTWCmlIEbx2kYwS6cq4tr9kc7lHt6u8UZQEIChcXPBjR7txPL9gpV7onNF+QmkBK
	 TKu6wpppshW/Rv0pOxCP4t4YeWf0un3HmZ3VRG+1ZtfnmTj3ubVNkm7MvSeSMD9oCwgzl
	 tt+fGQlP3zdaAuzlGimbkjkGuvq6UgRAPLlhEnL0h7O3kQpuBXiFL/weCzLVWh3Xz7MOl
	 qKxp/hFU/rPl4n8T9b4X/5+RS/EyqxVYCuTF8WmveDMemvFogIcuZ4p/cO5fuEUx5Lw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795459993;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=1rCE3K77C597tnpDa8DpHCzRg0yY18+BUyGptbSaO8M=;
	b=Kl1dxIjc2Rb7fApi7pkPOXKg2BpbGwenatCX5e1jveIyRQUiiRaOytM2mn+C0ct6Mept
	 S9Yi1/HEth80DAZi3Xw8R7pzKuGEDE3xUuMF8jSqqB/MCj+BRbR1btD3M+V+nuBST8AUp
	 QLvv+AauNXKF/NNfEENQWdpUkofnGliwE/2Gacm3ds2bTQ/FndEwOGZpikCOiPwHyPke+
	 gQ+sFYEKUUqK+SoOEfcJrD6I+ZgvTXYrtXMZj5+zIhNeSnmVb0zJRdwouTUaEtQ7f03Lu
	 9rmsQGVv5/+Px8J6XjqptZoy8AoBKkB6mNDSfDdKZht6/uq9V8rBpdfkwO3kcSuQJaw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 933801F000E1;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459993;
	bh=1rCE3K77C597tnpDa8DpHCzRg0yY18+BUyGptbSaO8M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=SoqzW3roBfAZ3tFOA8zhqdBmWzG3eJAbx5u8uC2YIErbKuw1WXJ/ttU+Qbm834M4d
	 ZKeKcQo9nFKaXf4YJiqWwZ/tAx/WQxJ/VNNXNVOA4HWlAh788Hw/6pzYGUEIj276ND
	 uzEGNMsf4058YXwvP8xPwoYiVKahcOGk5QpAIEVXeuBzcScj4qxM3Gbej3sdnz5Pdq
	 OmFeDhgkJ6ANMmp1zAk0agWA8XEm4E4fch6F4sgt30qzHgbACgq2l043J2ZSPj0wcG
	 TNjqyegDb3374F+bSHabFNNzzXSkUR50z1THb5LZNSwi4165e4eg/vFeQFkCI8pZEM
	 ke0l6ojUH+zhQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 19F304C61E;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:53 +0800
Subject: [PATCH v6 01/18] mm/mglru: rename the generation offset in
 lru_gen_folio_seq()
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-mglru-fg-v6-1-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=2457;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=on9PEefPrnrWULo5N6A+huTmLVTp8DOK4KQGDrtfCuk=;
 b=k5w2EsjoX/bzOEsAS9dWQMREbqipjNq4MTFKSvXR62sapovupL7OAfzxXHx/FEdKFSDvVsq/m
 LPR3LW9KAAICkw7ayuMLIbGlQoHMlZd+Jb96r6pjoa0gTwy/SGGSIPh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Ridong Chen <chenridong@xiaomi.com>

lru_gen_folio_seq() computes how many generations below max_seq a folio
should be added to, but stores it in a variable named "gen". Elsewhere in
MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
so reusing the name for a relative offset is confusing.

Rename it to "age", which matches what the value means: the newest
generation is age 1, and a larger age is an older generation.

No functional change.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
[kasong: dropped the comment table part, the series rewrites it]
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f6f4bc9a704f..2395ca8ee305 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -302,7 +302,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 					      const struct folio *folio,
 					      bool reclaiming)
 {
-	int gen;
+	int age;
 	int type = folio_is_file_lru(folio);
 	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
@@ -319,17 +319,17 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
 	 */
 	if (folio_test_active(folio))
-		gen = MIN_NR_GENS - folio_test_workingset(folio);
+		age = MIN_NR_GENS - folio_test_workingset(folio);
 	else if (reclaiming)
-		gen = MAX_NR_GENS;
+		age = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
 		 (folio_test_reclaim(folio) &&
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
-		gen = MIN_NR_GENS;
+		age = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
+		age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
 
-	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
+	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
 static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,

-- 
2.56.1


