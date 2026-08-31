Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31284A2A73
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 16:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194279; cv=none; b=cLdXKfpA9xAFwykI27RrHJVanHELLxZ1B8fQ8PjNNcPs/Ghs+EfB03ibfSDk2H4F9Cwn0bGFdhNpJMxUsbgFu/ulyhG6olr2nCkB84x3lMTMRilA5PyRE/4bd72vUwVCYr/6qFfKUaJ3HdmI468jBhsfCam1Wz8L2FGZiWL2XPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194279; c=relaxed/simple;
	bh=PKwARw2KbFSmGIOyQgOWgTdCsHCypuENVQPYBlHabig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecuspgZSux7qMG/OUSDXpPzXba7js2P6NJS+MeRVwlaSh4zNCb3NLy37qtSHEGsXVmyPHN4127/bs2xcOjZWjpVvdZZKaCNHEOWMtPHFEPBwJoKldFjOBU4hT8UzzKOcEC4ala65tH/JhLa8jFUNOmJipcQRLb+6OtmFRkTnPB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NhMMScEC; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NhMMScEC"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-459281bc13bso2939439fac.2
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 09:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194277; x=1788799077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x77j6vdZ8LqsWXipiJe0J8DOL7X4B8I6QMSB+YfLeSc=;
        b=NhMMScEC4aVNhUD8AbEq8e717vgYClbGN/HCQ/5dnyw17zcWAAcx5ibhqJty84/41y
         Q7MI2/eiOxQ+R08yEncHkjW/W2x3pW0RGFy2WdmeD7ub+sNBa8WyKlj+F68Ry2hARN1u
         1/YwCOlg5wxKBkxudafrCXtegn6tOMV+e95BSdAvW4pm34AbmTUd70Cm9ONieOFmvxrq
         DbuZrhvUyQEzD+q4Gi0H0QhJEtqR9gRseLgjhCs8fFgDCFM/akiezrx5WC1ecYMcCXJg
         JS10T1pHOaGVXZU4N2rLC0rEr/W6Dz+3JNI45A008I03xl9sLU7mYgyxpqlEGxi2Ovne
         EGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194277; x=1788799077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x77j6vdZ8LqsWXipiJe0J8DOL7X4B8I6QMSB+YfLeSc=;
        b=LRKPnk1LGSnOAf1FZ2Bgj7XRz/f/1Tvg5BqIjWa4yXpyG5hGuMqf4klTUd4q6F/ECs
         gDdKBj2m883ee4rB4cpQpp5zvlEledNZRWS6viBhwdrvWJmrfH2rb3pHgtykFYXQhnNZ
         nPmPHT6Oi+Pe2UDSqbLUffxH36MjU0vR6CZ/poXIF3WKQUW/wThm5+1EquX2icUFqmdE
         zFB7Rjq31m8g0DDN5p439VS+ImGYj2OGvQL8GkijWbCcS/eVQHGNlvIfb9ZyE7xne3HK
         zG3a4wuXrh7mJgOyYSmnMB6nKR/AZOI1dWU8oMnbZauxLTTROr1fmAYbOsfNipU3q5Eu
         IBEw==
X-Forwarded-Encrypted: i=1; AHgh+RovM8cnhhQsbMdyGpu5HpFliK7W8y3NcNkm2GyfWYR0iFA2FNU85Aei/DPNycSXc3eoFc+DKlZA@vger.kernel.org
X-Gm-Message-State: AFuF++mBW8hCn3siDxoMesu8bx8pwLeH4kmHEd2XJqWMuB72iWwdWPXa
	FCPnpILttoVigT4vU8UOMY5jpQyN0QTS7wuvdalaQAR6wgiDvnXRIfrR
X-Gm-Gg: AYBFou3yCs31oQfrBCCZKF68Tp3m+twRo4JFzle5u8YhY67MGRyf7hUGA86Zsop5I9H
	ECewICXi2AlajWfGDF9DBiYdP4C/hRcB/3e1NQuJ79lTQtDHqw53/DmdWJf3w/qq6qwEaiDs+L2
	9tIicQSgxj2o29mfEM990OybPOd8TbpecdhEa4NvGB4fmVcTkNNZ+e6XMaLXrAc03o8U5B3HTm5
	Ip9+S8HsjB0qGteuNVHcJdDtWkbyUvsXIvuruj6/u9hlxfI59AG3QF68ncZs3sSXmCnPIoiXaO1
	o+QTb2TMUG+k4uwEAI2H7YKXwYFqHiJ5RvkSaFX05/rdTsSfjvVhMQQCK71Md1fL+V0ftee9pjq
	peM63fhA2khrWzLq+ZHeniyYoRGwhNC2emSpmJ303Hs1eHL3bRVQrevIa5hVMtfoFkbqpJp3LIn
	BsHTKD57+tYhl+faj5ZRSB9/auHVav3/0Y7tb4vJ/DRVrvlSNhhxepQnyBXXHGU8yozMJxK4g7P
	p1UAKrKMzOzGxD26Rtv
X-Received: by 2002:a05:6870:3313:b0:448:3eb2:8c8c with SMTP id 586e51a60fabf-46835d7d79fmr26983191fac.6.1788194276047;
        Mon, 31 Aug 2026 09:37:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2c::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a545dfe6sm11149786fac.14.2026.08.31.09.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 2/7] mm/page_counter: report the number of pages charged
Date: Mon, 31 Aug 2026 09:37:46 -0700
Message-ID: <20260831163752.2193337-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an optional @nr_charged parameter to page_counter_try_charge.
On success, it will be set to the number of pages actually charged to
the hierarchy. Today this number is always @nr_pages, so there is no
functional change.

Of the 6 callsites, only one user (try_charge_memcg) uses that
information. The number of charged pages is added to
current->memcg_nr_pages_over_high to indicate how many pages it charged
to the hierarchy while over high.

Today, try_charge_memcg requests "batch" from page_counter_try_charge
and adds that same amount to memcg_nr_pages_over_high on success, since
page_counter_try_charge's only source of charges is the hierarchy.
However, this invariant changes later in the series when stock is pushed
down from the memcg level to the page_counter level, and a page_counter
charge can be successful without growing the hierarchy size.

Plumb the new parameter to all callsites, passing NULL where the source
of charge does not matter to the caller, and passing &nr_charged in
try_charge_memcg to account the hierarchy size growth.

No functional change intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  4 ++--
 kernel/cgroup/dmem.c         |  2 +-
 mm/hugetlb_cgroup.c          |  2 +-
 mm/memcontrol-v1.c           |  2 +-
 mm/memcontrol.c              | 10 ++++++----
 mm/page_counter.c            | 10 ++++++++--
 6 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc871..89a083f16fbf7 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -71,8 +71,8 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail);
+			     unsigned long nr_pages, struct page_counter **fail,
+			     unsigned long *nr_charged);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4683f3d680226..fbbbd0b09d290 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -736,7 +736,7 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 		goto err;
 	}
 
-	if (!page_counter_try_charge(&pool->cnt, size, &fail)) {
+	if (!page_counter_try_charge(&pool->cnt, size, &fail, NULL)) {
 		if (ret_limit_pool) {
 			*ret_limit_pool = container_of(fail, struct dmem_cgroup_pool_state, cnt);
 			css_get(&(*ret_limit_pool)->cs->css);
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index ecb6e0b7819a0..6df4a69b0d529 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -274,7 +274,7 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 
 	if (!page_counter_try_charge(
 		    __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
-		    nr_pages, &counter)) {
+		    nr_pages, &counter, NULL)) {
 		ret = -ENOMEM;
 		hugetlb_event(h_cg, idx, HUGETLB_MAX);
 		css_put(&h_cg->css);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index bf2c7d53b01b1..cf514d1bd7c38 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2194,7 +2194,7 @@ bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 {
 	struct page_counter *fail;
 
-	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+	if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail, NULL)) {
 		memcg->tcpmem_pressure = 0;
 		return true;
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 93c2fa04da4fd..71410084fa7fc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2663,6 +2663,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
+	unsigned long nr_charged = 0;
 	bool passed_oom = false;
 	unsigned int reclaim_options;
 	bool drained = false;
@@ -2680,13 +2681,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+	if (page_counter_try_charge(&memcg->memory, batch, &counter,
+				    &nr_charged))
 		goto done_restock;
 
 	if (do_memsw_account())
@@ -2847,7 +2849,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_charged;
 			set_notify_resume(current);
 			break;
 		}
@@ -5771,7 +5773,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	rcu_read_unlock();
 
 	if (!mem_cgroup_is_root(memcg) &&
-	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter, NULL)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_private_id_put(memcg, nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127a..a934619cc7bf7 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -111,13 +111,15 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
  * @counter: counter
  * @nr_pages: number of pages to charge
  * @fail: points first counter to hit its limit, if any
+ * @nr_charged: optional; on success, set to the number of pages actually
+ *		charged to the hierarchy
  *
  * Returns %true on success, or %false and @fail if the counter or one
  * of its ancestors has hit its configured limit.
  */
 bool page_counter_try_charge(struct page_counter *counter,
-			     unsigned long nr_pages,
-			     struct page_counter **fail)
+			     unsigned long nr_pages, struct page_counter **fail,
+			     unsigned long *nr_charged)
 {
 	struct page_counter *c;
 	bool protection = track_protection(counter);
@@ -162,6 +164,10 @@ bool page_counter_try_charge(struct page_counter *counter,
 				WRITE_ONCE(c->watermark, new);
 		}
 	}
+
+	if (nr_charged)
+		*nr_charged = nr_pages;
+
 	return true;
 
 failed:
-- 
2.53.0-Meta

