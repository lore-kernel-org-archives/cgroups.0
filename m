Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793786350;
	b=005RBeR1ON68QA9LcFkdnsGF1WnkYC1HQHbkPEyoY9uYuT+sbX5EshP+2VBUKUuy4bSE
	 YTbxxTBPVZBpfE2BOKXmAw8bJBKAW/9nd0WS0ExpTW7Oq60EVYgjVogmxshao2I9ou2ha
	 fIJq1PXFslneg3vziZNk0OlyZNNzMVu6YSK4yakeZ3YVy4wnb51QEPxq8h3u8snXVVQNF
	 bozG+gWCEQuk7t1P6ijk0COG5Mgc+OY44ZQAJ4fpgtF2ZgSWXR858tYxhVAD5Jm6+t0mc
	 YXQgIjjxcDS4vQ6yKK/YAWuoLBoITYxqMnQel/3ISSfIZsDLc1a9GHN8Fl3xT/CZEOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786350;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hhEgGsFrhB7fn+QYkE62uO6FmTu6zV39mSaIWkH0dJI=;
	b=EMtSSjMBf2uLKw7VRBRlvMu3HnpTdpZKK5o3RtSzo8Bt7fc6xXIvuDjkJachXkXQbySm
	 eyvkDjoZtBvQB3vzG3+6kf5CGhN4WrZufYyX7xcIqc/+w9liXhagElwrDtb61HkkGPbj4
	 nTvwcgjmQ//6HAyIkRWexfKZgi1Gsw/VQfrH2NEKtPc808W0VXhkQHBb1p6qgkZTDwTOP
	 7nRbckUTGtu1Li7aB+IhjczjgvqfyS7vb3BvPfQEVa5cP9JKJsEiZhaVfI9i46QNqVlyE
	 pgtZvjEuATW+xCWJNLmgWjG30qFhMs2+mom/IhgWXDwUVyC8/4q9h0Zcq14qZuXCxPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqlvqBAM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEE3606A330;
	Wed,  4 Nov 2026 09:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqlvqBAM
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793786350;
	b=R0hNYq0Lr+03WyHBH58qFLa/eUmyh1HJQ+QHW21ZzjzTCArjWpUKhNxx+gASxrso8OWS
	 YBKbqxybRy/tkjKg3D/hCXxAYRwYYJ23AH/mpDADYKGNsb+r1w8AfuHU3A0HiyFHI0lHd
	 zg6ZFSIG5+u9WJSGsApH9pWMFzpcm+3W6Mprkea0NQfJnG68PMyZY8KB/WyCmERzhW0ZZ
	 3ZenzRjSyJu536qdqqxPBJxhMlKp2f7AQ2TO0448nSVxYh5yiNdKi0N62ARhlK9tJuNud
	 SGapb6SM5HEO5BEAWcvVQmzqZoUIwFZnUda2cnTrq/rUV46iBF5Z2FN0B6WhDK4Y0MA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793786350;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hhEgGsFrhB7fn+QYkE62uO6FmTu6zV39mSaIWkH0dJI=;
	b=p2ZyTODOWqTaZwCMN++dOiR+JVOf6MfjuReeGw/EtvuChs5LKYNpxGfzRDHVMR3mog+b
	 Z6aDnKhreqiXy6OqF6H/GdW+4hqC4QeeFd42OKYkcAx3/VCoJ0qif5svtt8SfJo7JRwn5
	 0+TV5vm28J09+8a5oGeCItzX4w4uYsGasknAFD6uLdlCApscoalW/5Y1jrNsGkb3rScXz
	 pEKzq7BezmioZx0S8eHng1ghweKXxQEWSGbr4tv8XFEOHLBFis/H+EiYP1TAAZREcUJ9s
	 vjW45X6DLrPmJxJa6hvCmEA0lJ0Inej9McysSyDMSBsyyyXXQYFWDppQ214ygmHIIiw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B6DEC1F0093A;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786350;
	bh=hhEgGsFrhB7fn+QYkE62uO6FmTu6zV39mSaIWkH0dJI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fqlvqBAM7VJ0X87CpOj7BJJC0BrgxnB8FhIzUDjE3pjB9kc5gwVSJuL2HIA+rm0UO
	 9wfTZIMaO5D9oJKd4MiignFK2tsqZGQDF1eaR9g2lepep8KlXpsKzrZaVht1QZ8yf7
	 QMIzIHyUrhPVtqssKyCc0gaEG7zoZ76L7SN4pWw+VTzTw2NHzB8pN4HoBBDGaLJXEC
	 4SuMumitrxeWyItltFzL2W7JQ64GX2vme6UN1fg/VNFsVOQ7ksFa/xQlsrIMgwefRJ
	 0t/Eu1zW1pykdPeu/pEdEzlkRKKddf4Cmx4Ui9XkyO/BzT+SohuhfypIs3WOWRLCTH
	 KQadwEopSv/tg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2882A46D8D;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Wed, 04 Nov 2026 18:59:08 +0900
Subject: [PATCH 1/2] mm/huge_memory: set memcg_data before a split page
 leaves the folio
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
Message-Id: <20261104-kpagecgroup-split-v1-1-f70e947fec85@samsung.com>
References: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
In-Reply-To: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tao Yi <escape@deepseek.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793786347; l=3540;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=cwh5/ANoMn3q9VykAu3ZRo+0WnStzvXM2AIm27t94Zo=;
 b=LfLHZKKD4ZZoASkLp/QUsGDpPgsHyik7sI6TFEG8bIwDQ7hcqjurrCS9tT9tVzD2uMffIdinU
 W/ilRC7e8NWCpqe/mTE/+m/FmR8U19gtyf7Q6smPjJhulLiU663ynWV
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

__split_folio_to_order() copies memcg_data to a new folio after
clear_compound_head(). Until then, memcg_data of the first tail page
holds the folio's _nr_pages. page_cgroup_ino() can see that page as a
folio in the window and take _nr_pages for an objcg pointer. Reading
/proc/kpagecgroup as root then oopses while folios are split to
order 0.

Copy memcg_data before the smp_wmb(), as before commit fa23a338de93
("mm: separate folio_split_memcg_refs() from split_page_memcg()"). Add
the paired smp_rmb() to page_cgroup_ino().

Fixes: fa23a338de93 ("mm: separate folio_split_memcg_refs() from split_page_memcg()")
Reported-by: Tao Yi <escape@deepseek.com>
Closes: https://lore.kernel.org/all/20260907124001.1544655-1-escape@deepseek.com/
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Tested on x86_64 with KASAN (7.3-rc7 and mm-hotfixes-unstable) in an
8-vCPU QEMU guest: six threads read /proc/kpagecgroup for page 1 of 64
THPs that debugfs split_huge_pages splits to order 0. Base oopsed in 6
of 6 runs, 4 of them within 1.5 s. With patch 1, 8 runs of 300 s had
no oops.

Before 7.4, page_cgroup_ino() and folio_memcg_check() take non-const
pointers, so a stable backport needs "struct folio *folio" there. The
hunk applies to those trees without a conflict, and the build then
fails with CONFIG_WERROR=y (-Wdiscarded-qualifiers).
---
 mm/huge_memory.c | 17 +++++++++++++----
 mm/memcontrol.c  |  9 ++++++++-
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 14599d0fff..adc5a47ee7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3768,7 +3768,19 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
-		/* Page flags must be visible before we make the page non-compound. */
+#ifdef CONFIG_MEMCG
+		/*
+		 * In the first tail page, memcg_data still holds
+		 * folio->_nr_pages. Lockless PFN walkers (page_cgroup_ino(),
+		 * page_owner) read memcg_data once the page is not a tail.
+		 */
+		new_folio->memcg_data = folio->memcg_data;
+#endif
+
+		/*
+		 * Page flags and memcg_data must be visible before we make the
+		 * page non-compound.
+		 */
 		smp_wmb();
 
 		/*
@@ -3803,9 +3815,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 			folio_set_young(new_folio);
 		if (folio_test_idle(folio))
 			folio_set_idle(new_folio);
-#ifdef CONFIG_MEMCG
-		new_folio->memcg_data = folio->memcg_data;
-#endif
 
 		folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d..c244d56446 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -375,12 +375,19 @@ struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *fo
  */
 ino_t page_cgroup_ino(const struct page *page)
 {
+	const struct folio *folio;
 	struct mem_cgroup *memcg;
 	unsigned long ino = 0;
 
 	rcu_read_lock();
 	/* page_folio() is racy here, but the entire function is racy anyway */
-	memcg = folio_memcg_check(page_folio(page));
+	folio = page_folio(page);
+	/*
+	 * Order the memcg_data load after the compound_info load in
+	 * page_folio(). Pairs with smp_wmb() in __split_folio_to_order().
+	 */
+	smp_rmb();
+	memcg = folio_memcg_check(folio);
 
 	while (memcg && !css_is_online(&memcg->css))
 		memcg = parent_mem_cgroup(memcg);

-- 
2.43.0


