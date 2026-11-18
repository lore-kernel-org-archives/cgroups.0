Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795035836;
	b=r/pd8YypFApnmi+IpEe7dZxlYeb8nIFNgJJ5gaJMDYKYXvf6foe2ic24mNPtGmv2lxs3
	 ZrG4mfvDm+jT6i8F8cxXueCLZQhiajWsjnTAYqWdXX5QZZEgdsxvvyOjrGA942CGiCVSL
	 EpVRZYQOiXh+3weLAYEc22WDT+tnQmFLSh2R4oD3ak0+S0XrzPnEYyttk+kOj6sW+5Enc
	 DLSzB6fN0TYSncjlbyzgO7cyYdnh4F+bn5f39T0O8KQPZlxq7LxmlIKj4o7sgiHg4kWgS
	 25b/NZffusJk7/y6/j0Lk3LxZcWeWbz6g6diJzg6snms8wRLE7daca7OzWASFN2ng6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035836;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OzxS8FucW3HiaXjFt3oHPV/7/cOrPnUfOI6umwv44A8=;
	b=vk+JMpinhkUGTJEWBS7wRhhiY/GbM6lo9P9JxezCXKpAqglPMDL68NDrfORLCWO/kixL
	 OfIEqlgy+tHTZUo9XMWslk8WF0t/PNCof1fupw0EIqjnn8EXeRJFdojiA2TUbunJ6L0EP
	 TvKE5wtuDQqyJnD7GHK7UaslEVrDuewV2sfUJkfrsF/NjlJew40HHUBBsPJx3bAsiS8x1
	 iKICwfbU8albZi1ANH7sRAQ8UrdThp8HGNgzhMkYq0LEdc2iIqZWh2ovxwbSxOKa4HVF/
	 XeWHCnTY4BBUi03NSA/iudzVjkXUotUxOui3C9uFcE3klnbSIqYxf2I2kY13YLTOYPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D3lo9h+g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23ED60A5BC1;
	Wed, 18 Nov 2026 21:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D3lo9h+g
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035836;
	b=uh+xdzm07rqzRQ3Ja2W6WHwX0sOidRrC4gDFML+SknfQZKf0u1Um2HSppEZL/lz40sS7
	 X2qj3Bc9/WhDQqLI4l/lQMNbGEYDM/V1PvOmVx8EylE7BgTyrjXR770eNp4FgTXFA4Gq7
	 /70mCINeDhLKA86ei52OqR9sp69htmsG9qjevBfy6u/0hf8FxcOBsP2XhAr5GcPuUUztp
	 7IYp8WRWoB1ATIUM1cxCjP6oAEC8XCafOuEJQBLzXgPkAV+ZwQ08YIVmltMVCD9dlXtr2
	 Z/3irkzsm1LqQOG5lZpNBotm+Wn5NQQKhk6ozML51TsTC5BepjwUdt7rl3n3CwO30eA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035836;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OzxS8FucW3HiaXjFt3oHPV/7/cOrPnUfOI6umwv44A8=;
	b=axJF7Oo0N50wKMFvs0myxDJZzH0HhX5LUroBUTcQ/8eUwcrnSmk4wsnBdb//TI1ucIU0
	 v4aRWapU4v5SIDlCPrzQI9XakW/71MOIzFjd0bLIW4MNdnYzjZeJ49Qga6Bp1ayquMS15
	 WsJMp9A3NckBNvAQzonOryRJk/qVj83W0v+E9VGmDiCUdb2CKphw0wEzdvJiQQ32mKi7H
	 Jr6QN3xMLwWxoeE/O+ekM4hYdUQl7Hltt/5R5pbibnESph02YIYkc+rsgDqCg9/NNmXB/
	 39v7aHY0sW8pIo2ZTiT8sHPktcjRDzVMvZAoKSXTEE97AkhB7HCHN2mTCC6kSr+I+sw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BCB4A1F000CF;
	Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035836;
	bh=OzxS8FucW3HiaXjFt3oHPV/7/cOrPnUfOI6umwv44A8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=D3lo9h+gigqV3OulDUq27LKMkLt6nSjTbaVo2FxfQ/xK0hdn3RlotwC0ngw/LM9rn
	 8hA6UeaLi7c9m58rb87FOsp4UdJ2AP5RHcTNeY2YR5+dqdWfGHH6243V2zuSqPeKtv
	 8/zNvgyc7nRyGxlh2qyBbzXXHF0b133NONr6KbKrf2Tf8jBrEzEM7oadh16YY4XYy+
	 kSvm27BAy3ukpGOdmqpqKBvrRk901GbQhUgIpPGCo93G/1G8v1fZuDWZET7D6XSzmw
	 aC8cpwT8Fpbdbw7hKXhq/zMuPWe3i6xJUHAdXRRnlYRmm7t+c6i6LijQc8IQ0Eo/Qs
	 1kFD3fMq3y4vw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 53A354AFB4;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:44 +0800
Subject: [PATCH v5 12/17] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
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
Message-Id: <20261119-mglru-fg-v5-12-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=1308;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=GSfbPNgLMnXCEtSfL4kSp4PCNV1ejnHpWoKv9fS/jaE=;
 b=fzCjWB4x5yy6GmzZuPiQKuZftrRJcednIvgNY0u6IIjiMANZVD50MXigQUOLXSTn1Tj0Ir4M5
 KAHzmaqS4cFBX+0o23LoWpkoJV6E899oz/mVRQoPRYaHozTcuf+K8pv
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit

From: Kairui Song <kasong@tencent.com>

For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
count, so folios with nonzero even refs no longer have the bit set.
folio_pte_referenced() testing the raw bit misses hot folios at
refs 2, 4 or 6, under-counting the referenced folios of a candidate range
and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.

Test the refs count directly when MGLRU is enabled, mirroring the
smaps conversion.  The classical LRU keeps the plain bit test.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4bbe319ef86f..68f7a30e36be 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
-	if (folio_test_young(folio) || folio_test_referenced(folio))
+	if (folio_test_young(folio))
+		return true;
+	if (folio_check_lru_refs(folio))
 		return true;
 	/* ... or the PTE mapping was recently used */
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);

-- 
2.56.1


