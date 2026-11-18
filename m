Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035832;
	b=wXxrUZtLxfM/kL495nz/KN0OZX7QNneAjw9LeKiWm0hrvlwgH5H5Hi1d9kDUkcKSu7q2
	 uK07n6DfP5qMrK24D+J5znr+USOfE27Yov5ItLcHkhEP66lPiwzlpJnowQ6bOpry5FOFv
	 aInbNYAmiaY9c5Fo65V/d1rAqpkEKK6xzagu7ZVfpIeaD5iJWMIfl962Jx0h79wPjQ/oi
	 xaolH8U2ktf4/5m9vdqEiOA+A2upw0sBbWEhPQqnFa9t4Ybb4H8TDJbTKhsDW7ZuSfADI
	 Mbu5IS2Um2i+0OuE7Wv+MtgVQEmNzs/mZOjvt+FU5xSP1gM80JuzeZYYDXt0ta+lLgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035832;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/khA+oF1NJDS5uVoY78aHVaoSy/kwoqmB5M2SwuXaHA=;
	b=Pnm5yMf2/9UMpk+VYKpqzso91tfF41mMl8IE51CXfjdjEXgXLEC+aVZw4UI567pSdECw
	 FebaYE3lbCiwaL/1IkThYH9LQYDK96cU7IAbBxujRrtuPD6MkzhK5mPyeZGDhyzJ8iwXO
	 AjwscTMqnNSLYt8mHGcUa+CvTjlz1B2St7rF7Q3C4Drbf32okDk0sMa6q72qogTvNgpKu
	 R1oS6xfhbkFYli+AQqpbso1oCb+IZug47VSFCMn/nHmrJU7sZIzQjscvg2Pw6gjYLJhOE
	 KiTy3kdVZEvy9qA2M7+xnIuXekN5wLup0IqC1GsMRqTxLr89dvC21I87IklcoWQutnw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aEDRo2il;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8007E60A2615;
	Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aEDRo2il
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035832;
	b=TUM106WwBmaxsTl6Htd/QQmA8ke5jTZ1FKiGsU/l72zoNMFjoIEwtiWwihhsRNZHu0He
	 U9pjQ3QGiOmkVXx0QvIojNdGHrRg3uYtwpgaGpbmp9LKV6xxSAZuTPqIJ74W/vu+sIH5O
	 ttf9gpduYPcU5Y/eegMc7HrOUwKhPJpXawsUD5eGGdMrZduRZF7AWxo/lbCRJ4jOF8C8m
	 u0sI/Wwpw6H3BgolQ+OlZ1XHwDSeUY8n/EaGD+Zk7eXGe2KjzziGcOiZFCCvLQwbF8Mwk
	 CeiqPtJ9a9Hgg61UWehpSl2Cs9b/iZGeLyXqlPW+EHUcYyPVr7+dqwnjuW39y0NPn8A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035832;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/khA+oF1NJDS5uVoY78aHVaoSy/kwoqmB5M2SwuXaHA=;
	b=RlaJRTTNeRscDYRy104APTsZhzLoGAAWDEY3gtErBlrgDMhtE46rHkFFtRVUk/CFC/o1
	 gGF4Ahlzw0mrxUJzQ8HqD88KGwyb25mttn0oEXiJTJuhkjrVTZItx9E5tHb+Z6iGV3p1d
	 f86QipBni4+6VrmiQS6IeBDVyhi1KnCZuu+H2EIQ2OMRGlAp5wOXuEjUc2LeWMXXBzWWV
	 NPFuMhht7bE/5/PYjn9unw+hPQus4CY+dAJPL8S9NDyhetFlIVb2PZxd2JzQ87Z8cyFfp
	 Bcuw5BbFQzfdKixI9wNhgGlzA/hJ2clT7kJRamicWGyeg8ucwabOED31TIDM5RepgnQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3A87D1F000D2;
	Wed, 18 Nov 2026 21:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035832;
	bh=/khA+oF1NJDS5uVoY78aHVaoSy/kwoqmB5M2SwuXaHA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aEDRo2ilkTOIDfRNT+0BADSj/zxWIyqRHY4k8jxjGpHZVfDjHdlZJqjU3ba/RPqav
	 OXLzs+khFA40f/6QolNkljPYiuXXWS9/54/Y0ugb0MmQ73D0N4b+bClRXcQHX+71d+
	 W7vq80q6PRI9B0XSAH3kbuxGFJCSFF05LLRm4U2O2JpewkWcngBDcbEk4ZL4hkvYWZ
	 DHbofQYqX2R+hWsu6SAyYFdMXMkytXmJi/Im2kOml7v4+8UxBZQtX8zAda7wd6tyAT
	 XE1B71PcM+xD57AJz6V5m0XUdRr8hu8juYtsDnnbJbuXGYCYAzdk5Ymst7kn8mW6Mn
	 s9Qb/5Sqziodg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E4AFD4AFA4;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:40 +0800
Subject: [PATCH v5 08/17] mm/mglru: move add/del LRU size accounting out of
 lru_gen_update_size()
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
Message-Id: <20261119-mglru-fg-v5-8-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=3201;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=IMx6xZ1UYdgH8/pT8EECvr4VEPMQIFmzT2ojfi7j6eM=;
 b=5efdLIptwvbgkU2KOfLszIx7r/dpPWPZvzbfRP4VYmt9+JKNeYASC6zRHEvWm4MXQ2GGkSK2H
 EP1AAwudZXQB3k7st+uKT1b9Nc6IWqzONeHGo92DEWSw1p97bWfZDUw
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

Pure code shuffle, no behavior change.  lru_gen_update_size() now only
updates the per-generation counters plus the promotion move; the
addition and deletion active/inactive accounting move to
lru_gen_add_folio() and lru_gen_del_folio(), which know the generation
and can apply the active-window test directly.

The unevictable case is untouched: unevictable folios never enter
lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
before.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 180db43c3a85..b15c3618a1f2 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -322,21 +322,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	if (new_gen >= 0)
 		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
-	/* addition */
-	if (old_gen < 0) {
-		if (lru_gen_is_active(lruvec, new_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, delta);
+	/* return now if not a promotion */
+	if (old_gen < 0 || new_gen < 0)
 		return;
-	}
-
-	/* deletion */
-	if (new_gen < 0) {
-		if (lru_gen_is_active(lruvec, old_gen))
-			lru += LRU_ACTIVE;
-		__update_lru_size(lruvec, lru, zone, -delta);
-		return;
-	}
 
 	/* promotion */
 	if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lruvec, new_gen)) {
@@ -391,6 +379,8 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) != MAX_NR_GENS);
@@ -408,6 +398,10 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
 	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, delta);
+
 	/* for folio_rotate_reclaimable() */
 	if (reclaiming)
 		list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
@@ -432,6 +426,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	unsigned long flags;
 	int gen = folio_lru_gen(folio);
+	int zone = folio_zonenum(folio);
+	int delta = folio_nr_pages(folio);
+	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
 
 	if (gen < 0)
 		return false;
@@ -445,6 +442,9 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
+	if (lru_gen_is_active(lruvec, gen))
+		lru += LRU_ACTIVE;
+	__update_lru_size(lruvec, lru, zone, -delta);
 	list_del(&folio->lru);
 
 	return true;

-- 
2.56.1


