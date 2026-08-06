Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE192BDC2A
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786040682; cv=none; b=acBY7t+Q+HNUCnGVMp6s6TTmJ1lrE6rz1Wm0OGxpj7pVsJlpoqIaC89OIyNTCFXW+CUUX2Py1ZVcluDdWUEqoerGFZ7ypGn910xQ07Vdpx8oPQiQ8Hhi2qWo0XKcV97VfGP5BgTM6NZpedjXyYe0isnc7XiRUJbYN13EYzOD8o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786040682; c=relaxed/simple;
	bh=Drl6pgIsG4MeakX++5WkDrM+xS1Z/CS0rRPzAlwNF8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WBZsoHLSkL423TPU9RynAUBl3w69N700FkqHb+fXdkiXlJZFKInFoI7u5jLlpuHhefeGlhE0Z0jt5b4oPk7wgHTrS7lIWVkC0L5tIj6mVc0KRs8IBTDDQImRgId6OPw09wgJXj7GsK+OVQBH6SCz+XfdQMnV6HoAXxTA4OWfuOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zbb95CYI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zbb95CYI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786040679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eDz9E568MotxR3+S9hrXjCNiUKmMbJuSpoRSuTy9vwI=;
	b=Zbb95CYIUkYrSDrLmqrwhLCPlAIg3WIQHMnFRrCy/y/Fp0mNQxMqXJEst9Kle5x4M62UCG
	J39lu3OzqUIUJMmd0VRxDJfE288g5HrVKiqJWImXMyM4HrqjLTd57RgBpXi8Dz/6vYMJVz
	Ash3hISD4hCJOtUxamVdXi7uGjvxE3U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-cRadgUPLNM-vesmcECZ9Lg-1; Thu,
 06 Aug 2026 14:24:36 -0400
X-MC-Unique: cRadgUPLNM-vesmcECZ9Lg-1
X-Mimecast-MFC-AGG-ID: cRadgUPLNM-vesmcECZ9Lg_1786040675
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 449A71800650;
	Thu,  6 Aug 2026 18:24:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.255])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D1104180034C;
	Thu,  6 Aug 2026 18:24:31 +0000 (UTC)
From: Audra Mitchell <audra@redhat.com>
To: david@kernel.org
Cc: jocolema@redhat.com,
	raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Fix unbounded loop within try_charge_memcg
Date: Thu,  6 Aug 2026 14:24:28 -0400
Message-ID: <20260806182429.1841095-1-audra@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Originally nr_retries was actually nr_oom_retries and we used it to track (and
limit) the number of times we entered the mem_cgroup_oom path and then attempted
a retry. The purpose of nr_retries counter changed with the introduction of
9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
to retry within the desired nr_retries threshold. Later d977aa939fca
("mm, memcg: unify reclaim retry limits with page allocator") changed the
nr_retries counter from 5 to 16.

As the function has evolved we now have multiple paths that have a goto retry
path and we have lost the original purpose of the nr_retries counter, allowing
us to take a goto retry path an unbounded number of times.

Fix the unbounded retries by nesting the code in a loop and decrementing the
nr_retries counter correctly.

Signed-off-by: Audra Mitchell <audra@redhat.com>
---
 mm/memcontrol.c | 153 ++++++++++++++++++++++++------------------------
 1 file changed, 76 insertions(+), 77 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..781bcced5848 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2607,98 +2607,97 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
-retry:
-	if (consume_stock(memcg, nr_pages))
-		return 0;
+	for (; nr_retries >= 0; nr_retries--) {
 
-	if (!allow_spinning)
-		/* Avoid the refill and flush of the older stock */
-		batch = nr_pages;
+		if (consume_stock(memcg, nr_pages))
+			return 0;
 
-	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
-		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
-		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
-	}
+		if (!allow_spinning)
+			/* Avoid the refill and flush of the older stock */
+			batch = nr_pages;
 
-	if (batch > nr_pages) {
-		batch = nr_pages;
-		goto retry;
-	}
+		reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+		if (!do_memsw_account() ||
+		    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
+			if (page_counter_try_charge(&memcg->memory, batch, &counter))
+				goto done_restock;
+			if (do_memsw_account())
+				page_counter_uncharge(&memcg->memsw, batch);
+			mem_over_limit = mem_cgroup_from_counter(counter, memory);
+		} else {
+			mem_over_limit = mem_cgroup_from_counter(counter, memsw);
+			reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		}
 
-	/*
-	 * Prevent unbounded recursion when reclaim operations need to
-	 * allocate memory. This might exceed the limits temporarily,
-	 * but we prefer facilitating memory reclaim and getting back
-	 * under the limit over triggering OOM kills in these cases.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC))
-		goto force;
+		if (batch > nr_pages) {
+			batch = nr_pages;
+			continue;
+		}
 
-	if (unlikely(task_in_memcg_oom(current)))
-		goto nomem;
+		/*
+		 * Prevent unbounded recursion when reclaim operations need to
+		 * allocate memory. This might exceed the limits temporarily,
+		 * but we prefer facilitating memory reclaim and getting back
+		 * under the limit over triggering OOM kills in these cases.
+		 */
+		if (unlikely(current->flags & PF_MEMALLOC))
+			goto force;
 
-	if (!gfpflags_allow_blocking(gfp_mask))
-		goto nomem;
+		if (unlikely(task_in_memcg_oom(current)))
+			goto nomem;
 
-	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-	raised_max_event = true;
+		if (!gfpflags_allow_blocking(gfp_mask))
+			goto nomem;
 
-	psi_memstall_enter(&pflags);
-	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
-	psi_memstall_leave(&pflags);
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+		raised_max_event = true;
 
-	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
-		goto retry;
+		psi_memstall_enter(&pflags);
+		nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
+						    gfp_mask, reclaim_options, NULL);
+		psi_memstall_leave(&pflags);
 
-	if (!drained) {
-		drain_all_stock(mem_over_limit);
-		drained = true;
-		goto retry;
-	}
+		if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
+			continue;
 
-	if (gfp_mask & __GFP_NORETRY)
-		goto nomem;
-	/*
-	 * Even though the limit is exceeded at this point, reclaim
-	 * may have been able to free some pages.  Retry the charge
-	 * before killing the task.
-	 *
-	 * Only for regular pages, though: huge pages are rather
-	 * unlikely to succeed so close to the limit, and we fall back
-	 * to regular pages anyway in case of failure.
-	 */
-	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
-		goto retry;
+		if (!drained) {
+			drain_all_stock(mem_over_limit);
+			drained = true;
+			continue;
+		}
 
-	if (nr_retries--)
-		goto retry;
+		if (gfp_mask & __GFP_NORETRY)
+			goto nomem;
+		/*
+		 * Even though the limit is exceeded at this point, reclaim
+		 * may have been able to free some pages.  Retry the charge
+		 * before killing the task.
+		 *
+		 * Only for regular pages, though: huge pages are rather
+		 * unlikely to succeed so close to the limit, and we fall back
+		 * to regular pages anyway in case of failure.
+		 */
+		if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
+			continue;
 
-	if (gfp_mask & __GFP_RETRY_MAYFAIL)
-		goto nomem;
+		if (gfp_mask & __GFP_RETRY_MAYFAIL)
+			goto nomem;
 
-	/* Avoid endless loop for tasks bypassed by the oom killer */
-	if (passed_oom && task_is_dying())
-		goto nomem;
+		/* Avoid endless loop for tasks bypassed by the oom killer */
+		if (passed_oom && task_is_dying())
+			goto nomem;
 
-	/*
-	 * keep retrying as long as the memcg oom killer is able to make
-	 * a forward progress or bypass the charge if the oom killer
-	 * couldn't make any progress.
-	 */
-	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
-			   get_order(nr_pages * PAGE_SIZE))) {
-		passed_oom = true;
-		nr_retries = MAX_RECLAIM_RETRIES;
-		goto retry;
+		/*
+		 * keep retrying as long as the memcg oom killer is able to make
+		 * a forward progress or bypass the charge if the oom killer
+		 * couldn't make any progress.
+		 */
+		if (mem_cgroup_oom(mem_over_limit, gfp_mask,
+				   get_order(nr_pages * PAGE_SIZE))) {
+			passed_oom = true;
+			nr_retries = MAX_RECLAIM_RETRIES;
+			continue;
+		}
 	}
 nomem:
 	/*
-- 
2.52.0

