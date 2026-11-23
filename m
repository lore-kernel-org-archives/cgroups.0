Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460003;
	b=uG+arzzinqUBYv7UfwWHxX1vYxsJ/Nd+iNBRuGvMbS5PsWDFo4TNmAHkJdtX3orL4T7w
	 Eq52dyK4SaBPKtTipLDzNt2dWELrvSG0aOS1UW4OGGGf67P5zB/dqOjxZlTTUi1bfyTjf
	 rL9FCCNgL3km1TfOFs5oa5nWHRoi/rL9x6CL1R1UbkmcFwzO+8r7Si2m+OegGrjEuZeaG
	 54XQsQ1rcKVRFk1JeCf5XapN95Y76sS+kFdKnTjUaiiJMRb+xtAUz48wJISUv9SwpRNBA
	 2W6zBkSzVeoolD/HXTDpE0Q+oXhmcoBqErIZ30O3tyvZx7GjHkqnmBsYvkzLVNOpzaA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460003;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+wxKwr0AUBQ7HPKVFsvVRhysvOdPNYac/4XTxhyTbxM=;
	b=HXHsqtc2dqyBFZGEgzRdPPmF1XvnPOaG5PzSEnm9j8uF+46uHTOeNOIk7VKONFvwMcX0
	 EsSFuvQojt3PtX2QW9Z6QOgQfwGZ1q+3iwFcz/iGpEEb5HelLPCtBOFn7JZoLz41W6bc9
	 HyDbD4M73obVv2jk/3ve+K8ltl2pFCDK9tQAYtaoM7u8QvIW6T/Qo9hIJiDKXVgeKnepB
	 BNWwMPWsttXXPncIMjH9OybG2f6SMiGCef9ONK7r5j7S6dCe1lQvp8Htt7+dVXLreoTmp
	 YvOYdDdwFvjiqeduc1tQcUVRNUv4kypNr5XxO8VXFK0rTOmpKmgCP7KMmYPvJkW7mvg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="hZm4Gy/C";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1318C606A31E;
	Mon, 23 Nov 2026 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZm4Gy/C
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460002;
	b=jbE5KYlXo3tTDI82I9lCHbVI432dR433YtiHse6vLoCtf42Ydr6n3VMFlLdeO6PFLJen
	 aJpbu9/XGFAjM2aI3v3fFiDr8rS89gumGpv1smBjYblPeI3bAy1JoraiRBP46zgOw1KBd
	 p1TxLc9/HovtirSL/RuhIHMbn5kuRxAKOHpmWkA3/UEFswB6b1EX7KrtKrmxzzL32fG9j
	 gVZnFY9yeKfkxl4auCg1ddRQ3/mqvAnbDMVv3V/l2HTN/OVfqvLwTqHhVezIKinfnvxBd
	 8S9psTh+o1foVRVWqHrpCMa9/jbGPWVddakS3ZpAz1QojvoAIO0aIJvrT8aV9T+DWbg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460002;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+wxKwr0AUBQ7HPKVFsvVRhysvOdPNYac/4XTxhyTbxM=;
	b=29BVlU2JunP+b+3Jzgz6CPAEXzXJwaDGBRUIbLUx7fCc07yh4Y1zwBH5ITp/7gt3/FC/
	 22qfW2kT8SvtmcTM7FSFtfJxjEfm15X/uyt5TTYnrDyhX1NbSmXLjDKotCA8t8Fd3DCb6
	 iTA8oV/27VWWlavp7EhYYLWG2YFbdhOI8fPpZO6a7DZ1GRMhkLgx9OttajYsR2I6vDJ08
	 +VSf2EXkAszsCkxz/SbQ0JHHW5he8kt45xof9/vngY+TsFkHAptlX7/MqqfbNh5k3ddgy
	 aUCKgO+FMWP7GHrJVh9RhkjVNzdwDltKgPqzFwjEKLzxo3NK2YgUFytWQbs5G395iAQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D22FE1F000ED;
	Mon, 23 Nov 2026 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460002;
	bh=+wxKwr0AUBQ7HPKVFsvVRhysvOdPNYac/4XTxhyTbxM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=hZm4Gy/ClI8J1x6AEuTLrcVAreI8T2KcHDqTKwIGHndDRltgDm57JjzZxk4UvcdSw
	 WoW0rm86cKCHZ6ibPv/C4efJcuE0h4zLTWTrL6xIGvOdM+w2UUCkCizFkzXRWiRc/D
	 YZrWalR1/bey0p1noYwS/U0Nv0diHeYjPJ8EIUKUTHrJKkKpB2RP/r4oElr8FqJGvg
	 uz6zFjIUqUYR3vqlU2rQvKOGqqc8G7zLvpl8Qc2m4pAbeOA/8inbLHJtcHVdIxMo6A
	 bRMLMvZP5Rz6HOfI/8XDJvVPwpsirk9Vv3zOXN09mK4Br/Uw/sA+TOVoInugWJaYYb
	 PvF/kMHeAVZow==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5A4E44C635;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:55 +0800
Subject: [PATCH v6 03/18] mm/memcontrol: avoid potential counter leak when
 reparenting local stats
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
Message-Id: <20261124-mglru-fg-v6-3-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=3407;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=DITLxusEF3jFekXchW/A6iHzf//ot6gPbXly+2fd+cQ=;
 b=oQEvwa9i+84qyXpmUPi7pXNiCe/5dSBG7wL+wB1oC2sXK73KSejhjUMAwogTXAJ3+Pcs3FOdO
 fyAevJbJU6HADPweDl0ahO3Xr133F1H4Ez41aJ+ynn60czLlmD8SsmG
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

lruvec_page_state_local() clamps negative values to zero on SMP.  That
is right for readers reporting page counts, but can be wrong for
reparenting once MGLRU updates the counters without the lruvec lock.

Reparenting runs after the forced stats flush, so a negative is a real
balance that has to move to the parent, not be discarded. We will
introduce lockless MGLRU promotion which may cause following problem:

 1. A refs CAS on a folio on the child's lruvec moves it from
    inactive to active, and its active/inactive counter update follows
    as a separate step.

 2. A concurrent isolation of the folio reads the folio as active,
    debits the child's NR_ACTIVE_* by delta before CSS_DYING is visible
    to it.

 3. The child is killed, and the two __update_lru_size() calls from
    step 1 land on the parent: NR_INACTIVE_* -delta, then NR_ACTIVE_*
    +delta.

The child is left with NR_ACTIVE_* -delta while the parent holds the
matching +delta, and reparenting the child's raw value is what cancels
the parent's credit.  However, if the child happens to hold few enough
folios for that counter to be negative, lruvec_page_state_local() clamps
the child's negative to zero, which drops the debit instead, so the
parent keeps NR_ACTIVE_* overcounted by delta, and its active + inactive
total overcounted as well, permanently: the child's local counters are
gone once reparenting is done.

So use a raw signed helper and reparent with that.  Ordinary readers
still keep the clamp.

Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
Closes: https://lore.kernel.org/linux-mm/CAN_Opa-+nb0vxQ+HsENCG2fEEMZoxG9Sy_DBC4CLkWjNLzDWKw@mail.gmail.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memcontrol.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..3f551e2e3206 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -562,11 +562,10 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
 }
 
-unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
+static long __lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
 	const struct mem_cgroup_per_node *pn;
-	long x;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -577,7 +576,14 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 		return 0;
 
 	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
+	return READ_ONCE(pn->lruvec_stats->state_local[i]);
+}
+
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	long x = __lruvec_page_state_local(lruvec, idx);
+
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -595,7 +601,8 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 
 	for_each_node(nid) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-		unsigned long value = lruvec_page_state_local(lruvec, idx);
+		/* Reparent the raw value: the clamp drops the child's debit. */
+		long value = __lruvec_page_state_local(lruvec, idx);
 
 		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
 		__mod_memcg_lruvec_state(parent, nid, idx, value);

-- 
2.56.1


