Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795460024;
	b=jjrbnDxhBU7c+BaTBA5g3OZ5VqDxbIVvi/iy4AEGmr231Jd1YG5G3cSH3Y3I7WExmq86
	 apBLYtmlXqbghr/SsQEgjAtjkJ6DqDaLNswjmovRmtDhw0tEwHsgZI76KC9VRdafdS0y8
	 FLIaMPm+Nhiy7HY/KzIQqQGchBezTIOVH1dhWPqiH44oK5JGT4BNmy0YoG3gnW9cxuRXO
	 Vp0zwDKkL9NymgkMsJXtw9plp76zQ0KriHWHjGmS1bSO1nl5dgsbY2IIPHKOHbg2PJ5JX
	 PPQcmNzwJoQ78/kOy2MKg66JovzEeLUx2/0ULbC2E1WbQnDKaT/CXj+hiO8NjPnzCWA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460024;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mw7v666B0O0bXEelFGMEGNGOC4m5brM448d+fEgwE4Q=;
	b=QLS1VpEhyI+yJu6O9LOEKxn31Zykndli+uJoUz5FRK/KDOjEn6wPBCp4vs10zZEDx5Hk
	 QRvjL10LuXei1gFx+5DZ9xDLF/51LFnqEw81eRSX1vzz62UaDqIP0rcmikDodam2+4IfI
	 cAmLkCGYxRAq5VprpFomeF8nI4pCsw+3SeldPw9yr2S/pKb/JJULzLpk5zjh+GFBmuJPK
	 JmSjb9NjdxwHh01UAG1S+xaqhWuj5Zsp8QaguoOTZxQkCtaPs/Q+1XYelUNl9CnEbU2uR
	 3EBS0y/xNTgi/hBxhS3CbDeTgSwiKu49z9tkxljp+9Wz8+FKTGetz6OOWto+A72ts5A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mOiEIFaO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6059A606A334;
	Mon, 23 Nov 2026 18:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mOiEIFaO
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460024;
	b=z2GzWZiDNaVs4LZlZKHjbxWru7y34/egki64secC2NKFZV6BUgD7Wd0E9J5ZuciMWEh1
	 vF8ciNqlX/yX0VwUCZ4waYwWYMRGNwMUJTMuijIrwmvoh3om/z+Sf1phoyX1iwIvFXN9U
	 6jBh7FbM3uV1tMy/ZiytIwhaJlWVeIoqUHextC0HBtZqDpyr1njDCKpSmv7UT+6Ew0uWs
	 AgrbEeXr1G1s67PWOaiNa5SN70WFfK5j0sC18WVP10JF2eVIChugvT7ElZyqfA5WFa4fe
	 Q3Waat2yS2JJjwxSrdfWl4Eah2xobvYmlmYOEoxXPX1QGIP+b7cnIqg9y4hz0BtTgeg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460024;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mw7v666B0O0bXEelFGMEGNGOC4m5brM448d+fEgwE4Q=;
	b=gMCnIn4aUXDGhBcxa3kkZfBTuDvWZebB+1s8WRwntyhxCVkKAhJ/g9Mvudg5Ja5ToDyt
	 Vw4mckQamSR+/11JAovekklejIfVzW5/nDl82K/h3cU6bbZvw2TFMgZZNiMkTwv6Snsf1
	 9lV/ne9cAD2gseClZRfX+iRrH5sjATUSyHQA1Ypij2y3Jv3nmBgNjoolcIMKxxbA5oNRJ
	 iLvIe5UeqesCWlWs6Qk6+WgLrVlBHf4nJ7UpeEYNjZw3Cf/Gs3aHnTGD8Npgq82X+ekFf
	 ZJJ9PpQlLIVtTVxYuTVKy4L/rd4cBU4iH78+NOJb/rJwluKw1Xp7t5ZWV9pSu3Gl+WQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8BF3B1F01572;
	Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460024;
	bh=mw7v666B0O0bXEelFGMEGNGOC4m5brM448d+fEgwE4Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=mOiEIFaO4VIpA+R/yd/1YUMV7KeiI2oBhzBt+l00H2YWPcLqv6gx3cgP+6HMUV98b
	 I9BovPzLz8Q1IYRnkGRZlca4wUhahQpfq9ByR5Fjtjq1o/mKY8dZyW8sdaX9LQ9UIr
	 6g2VHOANTZN/Ex0rcLJXSJVJMZSWEiWMyB1nn66NXfPKWNQ7zWlokuYgELitD879Fk
	 mYNe/Q3oX9bVTqxUbKwQ40kX/rpYfH2atRTPMk9cRZYF6qf/Pec79coDd32GpYy5OJ
	 IT9TmGfI6q9s2vKSAXl/AhL+xENuKlA7HLpBF6CxLYTFIFooE8xGuUzGH6orGuluT/
	 CuqpZ24qtXYhw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D6E814C665;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:07 +0800
Subject: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
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
Message-Id: <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=2081;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=svKswWLQsOqCODPXI2P9d3ZShVpGHldhUm7oZl8WLHs=;
 b=uGyjbdLY9Xmj/REU9NlfpO+n2XY34DVfiQMG2A8ErYXhlavxnUkdesLKD0RF2+NCUWBfn8wnX
 n5ET/23+qQAD8v/x6lWvWEUPWgb1QREe0OKsx1v+54gfQ08nLyRKQjZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

The behavior of updating the folio's access info isn't consistent for
huge mapping splitting or ordinary unmapping. The page table's young
flag has to be translated into folio's access info.

Right now it only checks and sets the folio's referenced flag, which isn't
enough since folio flag updates on access have their own rules. Ordinary
unmapping (zapping) calls folio_mark_accessed(), and it also checks
if the VMA has recency to avoid false updates.

So first just use the right helper here to be more consistent. Keep
accounting the young PTE as a cache access, sticking to the current
behavior.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 75e8641bf9ff..fa9f6d21e786 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3122,8 +3122,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 
 	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
 		folio_mark_dirty(folio);
-	if (!folio_test_referenced(folio) && pud_young(old_pud))
-		folio_set_referenced(folio);
+	if (pud_young(old_pud) && vma_has_recency(vma))
+		folio_mark_accessed(folio);
 	folio_remove_rmap_pud(folio, page, vma);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
@@ -3245,8 +3245,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
 				folio_mark_dirty(folio);
-			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
-				folio_set_referenced(folio);
+			if (pmd_young(old_pmd) && vma_has_recency(vma))
+				folio_mark_accessed(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
 			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 			folio_put(folio);

-- 
2.56.1


