Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793786350;
	b=IX8Dxm1rPG4KMYU1PKw6O1lYe+Ckeo0FILEEaU8l5PHftR/YNw39qBH/qulSO8QvZ2pP
	 zuKTHJiBIHtFunSWzV2LZgSLFdmEbSxWAIUbWPvw+8r7wU3LehKQ7W1gTZikIG79YcX8K
	 3tvWyNBSpy+0vNDaStqJXh0iH737gCtuYKWBgkvmXQtiuFjX6clr7ncm1n1fsb7S9qRm0
	 F6MZBSa5HAnNr0u+oVMNqwcjcvnj2d8xcweVBhmjoOU86jDpmWR0gzDbQkUjUzNLz7Xid
	 ey+zqfi1knb1/s7zJBDcztOBDMMRNAhmK2Lx3CVnPrkvOUmKbGiKmQNyvRPDVMR640g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786350;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=idiDEZyV2AKslTWp8TVyyW6q1t+3S/0RWjaWZEHTHTM=;
	b=yTGwABtqXHR++e7/Pte2xH1oBgW/4/U3vRc2amP8tkBUBTMeF71fAw80c+Zi8qdKAeLj
	 WDV/IIbxqp6hn5sxZEKKSqGYadD4aXcEHY+4MoXQ+hmJL8NBfwPtvHp4skdky4sOvhlbr
	 kY3iRwqfFvauAUtJ9/jVTJak/jdfzH6HZMrXlQQZPhqKdk+dnNXLMnLHACoBlM5dYO7cl
	 /FoBJFXG3LSYLTfMES2O/T0MKYR7E3vz8KXRTWtGr+8W3RJmIqcbNxSwVMPlioyrAUeVw
	 khdIAAkd2YHbp6a5VFtslrb8QJSeMnOPfnaQlaGU6NtGdOnfJKemGjV964yKMZ5CCnA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIhLCGZt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC0606A32D;
	Wed,  4 Nov 2026 09:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIhLCGZt
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793786349;
	b=ItzxnYiXt18cbh7Q1pMaBccH4dGH7YRZq0eox+GP2qXQ1gwdbeVkr1bwCZTR4OJX3VFc
	 X2GSCfpNatJj4CW2EN1ncfc4FI2g56p9dSJnT4GRP9+7PBM1E8cARxwcoVZ7Y9KZ0J7kT
	 SOye3OniTkwpR3CLKd7Yw7bW1id9cbbjd6EAj3XKVIITYaRG9MsMvzkYCpK5OkOOe+7PY
	 5UwCPum8wW2y+k7iQ8a5/6QwEO/z705jBUb1mb0qQoZMCJsCwSG8gLnYLhOC/ctN3tNFi
	 5iaS7YSJjj6o6wx06cqgKQw/caplMRN4xnni365aVEbuJjxTvZ3xUMFMiez4tnR3meg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793786349;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=idiDEZyV2AKslTWp8TVyyW6q1t+3S/0RWjaWZEHTHTM=;
	b=a87bdR/tMxDfOESEh099KXtq3DxQHDkMdJFV8O4Qz9WINF1DNW+4KYv9gf4td6ElgBIh
	 CVMhVWAJU7DKccOa9FZ/Y5wVTBoilCRbGFhUF6HsPOMfZu+P74be9Zp1Tqw8Rp6vtfKRE
	 nQpg8bqWN1l+6RBTjUiQhLviZo4i91K68swBbHX3r9yPia8PdkLFxPlMm86kuSlFWQeoC
	 TJASsVtyzODke3xXbNXtb9KqIOllM3aCOf80LwCNxkUb49mQakIdlHvTS3Tb1ZcEXVYrK
	 Ri/wtooKiO1jQO/jpUSmNmY8S1BqKQVaAGZ3quhQ6tM1OBK+Hbncrrl+4UjXeaEUptw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B71031F00A02;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786349;
	bh=idiDEZyV2AKslTWp8TVyyW6q1t+3S/0RWjaWZEHTHTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QIhLCGZtJs6IGwSjiOefaAYyWxn2wAz34QveAFQ6O7AAHx34oWeVq1gyKG8HRVE0K
	 rCs39YHJzMo1h4DnHmPOQ9BDnd1unn/dm6Kis6ccRHV7wnAEhDEuL9ltl3Lr2SY5ve
	 psKClZfoHaCcaLH75D5UDDXm3HKwlfoC2wNjx1lCCCltgC3pMLCXX19Zk/97HLdoJo
	 YukWLbe1vWbMCKlKMM0KOqwPGxUCNPPrP82xzf+IuqdOSivvaJaYPK2RJ/GKhuXKgP
	 XueUPkbtZzrwq1yrX53dCpLnrgoz2PLhVl9MqMC5u3132XDnKDmkdf0jR/amEAEaDP
	 oRsK1L9jkuboA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 37FD646D95;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Wed, 04 Nov 2026 18:59:09 +0900
Subject: [PATCH 2/2] mm/page_owner: also check PageTail before reading
 memcg_data
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
Message-Id: <20261104-kpagecgroup-split-v1-2-f70e947fec85@samsung.com>
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
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793786347; l=1494;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=Tqm3nbQI1nWClGneJZ4Vn7FgKvDR6MGrjq0L2fxkJJg=;
 b=jF1VyraheDQeftMsTSeeShKLufOP/x6ZE8gVhGZ9J5wjIN48n1F2UD5mWKXUqYitdOutXoi71
 O73YaVFvaRmDVw6oCDkIzhWabi9SfSmF0DAaIx8yLkW/5QSQ3GX9K2Z
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

print_page_owner_memcg() loads memcg_data before it tests PageTail().
In the first tail page, memcg_data holds the folio's _nr_pages. A split
can make the page a folio between the two loads. The stale _nr_pages
then passes the PageTail() test and is used as an objcg pointer.

__split_folio_to_order() stores memcg_data before the smp_wmb() that
precedes clear_compound_head(). Also test PageTail() before the load,
with a paired smp_rmb(). Keep the test after the load for a page that
becomes a tail in between.

Fixes: 4996fc547f5b ("mm: let _folio_nr_pages overlay memcg_data in first tail page")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Needs patch 1 for the store order. Found by reading the code, not
reproduced. The page_owner oops seen with a delay after
clear_compound_head() is the window patch 1 closes.
---
 mm/page_owner.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index cfc31c92d7..058d4dec84 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -564,6 +564,13 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	char name[80];
 
 	rcu_read_lock();
+	if (PageTail(page))
+		goto out_unlock;
+	/*
+	 * Order the memcg_data load after the PageTail() load. Pairs with
+	 * smp_wmb() in __split_folio_to_order().
+	 */
+	smp_rmb();
 	memcg_data = READ_ONCE(page->memcg_data);
 	if (!memcg_data || PageTail(page))
 		goto out_unlock;

-- 
2.43.0


