Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06A22798E5
	for <cgroups@vger.kernel.org>; Wed, 25 Feb 2026 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772036612; cv=none; b=AOHtCcz63Jy1EH5kIIo/Mum9V3OJUTG451NaD5sYvLS6ODmaBiGxuLkEE3ASKj0NJtBQ5bAoTXYczvXYrjagZRYjzDbtqczCEaA51ezATvwdKWsaJjTiGobCqMJqraViZZukZGoY09aq0HibM0u7vbHjrXsaJTYemM0wylulmc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772036612; c=relaxed/simple;
	bh=fyqiEs1EuuVUOIDIMvOlnTBOoBH0P3X0OoipczfIoXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPhWVjC3daeiye+M4lixO3ajSrCqv6JXdyvYtxcBTskEIrNYDqVxq4xuqwYDo5KU3RzQiGadMkoBb3EcY1LzWo/OJUv5AcrpKKKN9JY9DV8tlW61TxHCNzVxtFQE1WS3QCOqMz3yuiX1xlby+POC29GpUs6LpwJH4ilR6TlGcsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OaqZiziQ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OaqZiziQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=D3TwUQqJCu3pPi6QJD2PSAqbuKObzu+ex5JuOKPtNo8=; b=OaqZiziQmIk9V5oNMOMkyB5ORT
	uf+ivgFyc6+IheH/I0+KuTa3nsdRvPhQzL+DfjJvByoBnf2+OeYFk6vvVW6HozwbW+c8W9UviTk/W
	EHyn167alq1rhv6oHL6+fm2Y5lzO0cPyKOmqXTM9YfqJVUkIgzcRs3aZkGUE5M3K2XSUHpX/iwh1y
	rzbim0lz2YJQIHtq/HzJFywQYD6BFTmypsWm3sovph95P2qP7Yvnxxlv1Q9c3hqTx+chWQ/9lFwlO
	EFiHYiTl/AJ0hJbDDIOtiuHlOAL5DKTJhu5Jr9e5u7/VGkTFzozbHar9XdUcjhGDceXR5MyGbdzHZ
	iSEGOfnw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvHfV-00000001K4q-32eU;
	Wed, 25 Feb 2026 16:23:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 2/3] memcg: Simplify mod_lruvec_kmem_state()
Date: Wed, 25 Feb 2026 16:22:16 +0000
Message-ID: <20260225162319.315281-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260225162319.315281-1-willy@infradead.org>
References: <20260225162319.315281-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the new memcg_stat_mod() which does exactly what
mod_lruvec_kmem_state() needs.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memcontrol.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b356ef312bc2..8d9e4a42aecf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -815,24 +815,9 @@ EXPORT_SYMBOL(lruvec_stat_mod_folio);
 void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_virt(p);
-
-	/*
-	 * Untracked pages have no memcg, no lruvec. Update only the
-	 * node. If we reparent the slab objects to the root memcg,
-	 * when we free the slab object, we need to update the per-memcg
-	 * vmstats to keep it correct for the root memcg.
-	 */
-	if (!memcg) {
-		mod_node_page_state(pgdat, idx, val);
-	} else {
-		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		mod_lruvec_state(lruvec, idx, val);
-	}
+	memcg_stat_mod(mem_cgroup_from_virt(p), pgdat, idx, val);
 	rcu_read_unlock();
 }
 
-- 
2.47.3

