Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3458B3A785C;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785786443; cv=none; b=hxF0XY1+jjAzfToJwxLISrwp+Tz5RgWS37DfhwzbS+953zHEvM5N2NNuF6s/3tbAwxSYHwmDOmmDkA2Ceg4NVUySWRjJ+dYTQ3KW8IZ2Q1HjWldkuruNnZzGc8dDolp8ZGykzJx0Le+bTIokajKtoD297k4VPezKej+8ov2pCgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785786443; c=relaxed/simple;
	bh=sFUdOmE7PPq4dTTxszgE5i0xfhfb5mMlbqX0i1zr9aU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nd2kTDoSF4uATPyWDtsCeCOmJLyJKWomh4sLuhb0t4B1DJi8uwmhjfJqT6yKuDKiNLdOHGtj78YAD0xVg3bxbqiPdOuLJxqjGwwdBw40EfgdutLNuC2vMK4g4tATvsRItUmWEMzL+yaXaEJmJgdLGRSQgMAaKeC3iiooRlNcHac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUq52jCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUq52jCl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0011C4AF14;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=sFUdOmE7PPq4dTTxszgE5i0xfhfb5mMlbqX0i1zr9aU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZUq52jClfqCojXBb7kZZeNU1BU0+C14rPWs5LSmrSLot7mRQPqxYH7HZN8pT4lyIv
	 XJKm+VV9jWxwZOIbxBfBm0drKR8pQX8YVsh/ZTV7tAlGDznW98wxaWmAaLpBgDjvfK
	 O0pBgmRo60yQhS2T85Sx9edHG+54OcMp+2x6Dnrcp0wiFSfNRGmqsGK94o9gVtEJIE
	 5kbKn+diWyCivlu/yL9VSo+WVPKBm8M6OfxAJ1tsuQU8dFF4C4EuB+6EM0S7LKLmcQ
	 dcnc8fB/eMTj8GYwv8Bn4uQxqZ4ctz7QjaILV1dnDsh+XL8a7DF+0n+mU1y//xtwz4
	 ZGZOaLcmkMzug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AA8C55822;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:04 +0800
Subject: [PATCH RFC 08/15] mm/memcg: add folio-based lruvec live helper
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-8-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=1942;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CYaQx+ZxB9rM3tJj/qRBO+O5Fxa1QWpmGb5iZwXshX8=;
 b=++Am5L1YzqiSnxDr9o1VMbCVEwEukS5UN1/zmmuMnpfuljIk/qOzAXVOhUiwyoRYhYQDYt45R
 xgE/vtt5N5wAukyhcBnL6BpQE79+Z9dNxi2hwZQC227lqiolRkVLMAv
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

Add a helper that resolves a stable lruvec for a folio under RCU
without taking the lruvec lock.  It takes a folio directly so the
lruvec lookup happens inside the RCU read-side critical section,
which a lruvec-based interface cannot guarantee.

The lock-taking variant now inlines the ancestor walk instead of
calling a separate helper.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 68f363000d7f..ea0111392b9b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1506,6 +1506,44 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
 	spin_lock_irq(&lruvec->lru_lock);
 }
 
+/**
+ * folio_lruvec_live_get - get a live lruvec for a folio under RCU
+ * @folio: the folio
+ *
+ * Computes @folio's lruvec and walks up to the nearest live ancestor
+ * if the folio's memcg is dying.  Must be paired with
+ * folio_lruvec_live_put().
+ *
+ * Return: the live lruvec, with rcu_read_lock held.
+ */
+static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
+{
+#ifdef CONFIG_MEMCG
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat;
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	lruvec = folio_lruvec(folio);
+	pgdat = lruvec_pgdat(lruvec);
+	memcg = lruvec_memcg(lruvec);
+	while (unlikely(memcg && css_is_dying(&memcg->css))) {
+		memcg = parent_mem_cgroup(memcg);
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	}
+	return lruvec;
+#else
+	return folio_lruvec(folio);
+#endif
+}
+
+static inline void folio_lruvec_live_put(struct lruvec *lruvec)
+{
+#ifdef CONFIG_MEMCG
+	rcu_read_unlock();
+#endif
+}
+
 static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
 {
 #ifdef CONFIG_MEMCG

-- 
2.55.0


