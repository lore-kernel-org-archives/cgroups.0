Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A6F489883
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671976; cv=none; b=B/izSddQ0NSB47+zoCHsLDHw3HrYgRN1TI0vvZNqUxZpmJmOtiQ8L5BDm7uOLaJ0P/bieRNwnNHV0KRn6oFvbdT0WcOud1LhnjTovzU1Z6zB19hJ5is5TTkDCNjr1LZTFCy1KAOzjdy9dxWwM5MK7S0UC5LDmztgwuDyrILybpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671976; c=relaxed/simple;
	bh=Ng2X2En18m+Jw7WfQX3hDEj1QTM7CjxLX2o8m/jXjDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPLLQRE5oveozjgFQqr8dBFO0IWwIHBC1KtYJ5CD5hS1m1HL/gu67tPPRU9CYfyb4e72EpqVdovbYdn70R/8YbEgCLHnPLP0WiUV0uWa5nznmw9aDpInuRVWlnKkxVG4TJ2jy0Neujcd1+GIC2Dfby5pt5gkr2KO+1P8JSIGaxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=njJBwHq5; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="njJBwHq5"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4a43c2a126fso2213021b6e.3
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 08:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671970; x=1788276770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=efoGnqCiYbC3GQtG+3aDF+oz3AA7LAoLSzZXQ/arlkM=;
        b=njJBwHq55vl5xsBKNmbe7vPbr9FdmrN0dn31gyEqpiMrdw5saRqggzSEBJv3/i9O7M
         cwkaljQUKeFVkBZpWdwFa0SJte77QB8DrE6Uey0wJu+PQqlBCWjARqe14r6ECgtTXNSE
         GO81B9pL0WIXGicwSwMCRJOEgzhr4D3S1eNhQhD/qhlB/dlbjGZm/6paAmikDk+d/PIB
         ZcfuqHggJQfQjBphpV9J6NzpCjaJtA2hZ4nF6qo2TBhj6qQWe4lPSdBzIJs2G6aN/189
         JpbAtVE7gHuejqDTrrRBvbMnzsOqm7HotEGo3n1hxLsD50f9tbHGmVt90H3mToFq4b0Q
         5v4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671970; x=1788276770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=efoGnqCiYbC3GQtG+3aDF+oz3AA7LAoLSzZXQ/arlkM=;
        b=YVRhlkpnu20qmQedgfoEcsVXstG0IV0+1AkK7Vsz9bzZwW+PqtzmrsJq/S1CUg1E0G
         Ay1sOnkCUTklJ890hF5t/gFSYzFOmR0wj+hHJWv+ZuyFgTL4QPcEPXdA1+vpulnkLpJA
         4QR4FzKfnoZOSRNWP+I8tBQW4+4zow1BiJ7wwcNiCCVX3DCyJ3JVoD2JZQx2MA6ciWab
         5e994lEwBfdzbYFOPbS5AZb1cVBxgRCIdYjN++KDJ/4Zqqzjzln3TCZ8qc3x16yENTLt
         eGL73be1/YfeocnbdgJtkQMInmK5aZSY+y4aOcARRp5tNadR1XfvmYtv4JaZlK2+kyoz
         ZxtQ==
X-Forwarded-Encrypted: i=1; AHgh+RoxZ1/pESAE+nzinwe7COpP9KK25/paoJaueHn6nCt7PhkkWtGgbXKO64/OMLK30Qji+mQcto7q@vger.kernel.org
X-Gm-Message-State: AFuF++nMQkcC7jF9Pm3fLb4ZQUJKHwY4puJyqlGazJZhTtnAZ9kyjg6s
	CpJSvqQxbskZA0VTeFgZRaPP1NKPvq7V1QP0hpq/zResOKDjfY0W9q/P
X-Gm-Gg: AR+sD11Y1AjlVOY4OxYAq/QdGfC+jGbKzM0Q2HaDmC4MN7j/cqVzrXRqUiVnzoVuVUj
	D9NT4otTGp+Ypu7M5ZT/Qyk2eZsi43i6nRyOCvW5YNHpdun0Wwzni72PvW3E2K4gaNQ980nVlF6
	Ru8IiRMgF5SKAqkiLTHn+J0t8/3iLEKkkZIrrf1/LeTUkAkUgWI2giZFM/TmulPbaoth6EN/2m9
	igM+fAWeLL/AzuyvSKNU9/GFTZ4GUkZSYqRWs1mzIJWeD3Qi0mLeTKAnPrpZFZEbZFC0RlYoN4I
	R4lDR4fKIzAf5o/o0COSOAosMWHNGhyiS92GjtqaizwTBeCIy6fpiIkeY4X+ASi91hOZfJXLVgL
	jNDCEYsBMSqzgZUeZkytJNsfiilDJKWsAf2x0rHglgQdecyvFGwEKo51H27jpBkL6Tc6/6rIYz8
	DtA+WjfU5EJKFVp4uuWEublQlkYWpqSc6/WhRAdK1Z/Ptz4VQxhU1LsOAby7KybL2MB/xkv5zf7
	E8KTQkWnVZSOqMwHvXh0A==
X-Received: by 2002:a4a:dd18:0:b0:6aa:de9e:e223 with SMTP id 006d021491bc7-6b16b209b13mr18223935eaf.9.1787671969879;
        Tue, 25 Aug 2026 08:32:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5e::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463831d1e61sm7536265fac.8.2026.08.25.08.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:49 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 05/11] mm, swap: enable THP swapin for vswap entries
Date: Tue, 25 Aug 2026 08:32:31 -0700
Message-ID: <20260825153238.2695446-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Swap a large anon folio back in as a unit when its vswap entries share a
contiguous run of physical swap slots on a synchronous IO device,
instead of always falling back to order-0 faults.

A zswap-backed or mixed-backing batch is still refused, and the fault
retries at a smaller order.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     |  5 +++--
 mm/swap_state.c | 17 +++++++++++++----
 mm/zswap.c      | 19 +++++++++++++------
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index dc4dd72ce73b..62f7b82427e2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4823,9 +4823,10 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	 * lack handling for such cases, so fallback to swapping in order-0
 	 * folio.
 	 *
-	 * THP swapin for vswap is not supported yet either.
+	 * Vswap entries are checked later, under the cluster lock in
+	 * __swap_cache_add_check().
 	 */
-	if (is_vswap_entry(entry) || !zswap_never_enabled())
+	if (!is_vswap_entry(entry) && !zswap_never_enabled())
 		return 0;
 
 	/*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c0441783b8e7..5cfddec8633b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -174,6 +174,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 	bool is_zero;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	enum vswap_backing_type type;
+	int ret;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -202,11 +205,17 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return 0;
 
 	/*
-	 * Reject a vswap batch so swap_cache_alloc_folio falls back to
-	 * order 0.
+	 * For a vswap entry batch, reject if the backing is not THP-amenable
+	 * (e.g. uniformly ZSWAP, or mixed). The order-fallback loop in
+	 * swap_cache_alloc_folio will retry with a smaller order on -EBUSY.
 	 */
-	if (is_vswap_entry(targ_entry))
-		return -EBUSY;
+	if (is_vswap_entry(targ_entry)) {
+		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+		ret = __vswap_check_backing(ci_dyn, round_down(ci_off, nr),
+					    nr, &type);
+		if (ret != nr || type == VSWAP_ZSWAP)
+			return -EBUSY;
+	}
 
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
diff --git a/mm/zswap.c b/mm/zswap.c
index 9a00ee049cf4..f16c0b44b5d5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1629,9 +1629,9 @@ bool zswap_store(struct folio *folio)
  *  will SIGBUS).
  *
  *  -EINVAL: if the swapped out content was in zswap, but the page belongs
- *  to a large folio, which is not supported by zswap. The folio is unlocked,
- *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
- *  do_swap_page() will SIGBUS).
+ *  to a large non-vswap folio, which is not supported by zswap. The folio
+ *  is unlocked, but NOT marked up-to-date, so that an IO error is emitted
+ *  (e.g. do_swap_page() will SIGBUS).
  *
  *  -ENOENT: if the swapped out content was not in zswap. The folio remains
  *  locked on return.
@@ -1652,10 +1652,17 @@ int zswap_load(struct folio *folio)
 	 * Large folios should not be swapped in while zswap is being used, as
 	 * they are not properly handled. Zswap does not properly load large
 	 * folios, and a large folio may only be partially in zswap.
+	 *
+	 * A large vswap folio cannot reach here ZSWAP-backed, since
+	 * __swap_cache_add_check() refuses such a batch, so hand it to the
+	 * phys path without warning.
 	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		folio_unlock(folio);
-		return -EINVAL;
+	if (folio_test_large(folio)) {
+		if (WARN_ON_ONCE(!swap_is_vswap(si))) {
+			folio_unlock(folio);
+			return -EINVAL;
+		}
+		return -ENOENT;
 	}
 
 	entry = zswap_entry_load(swp);
-- 
2.53.0-Meta

