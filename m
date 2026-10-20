Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792490641;
	b=u4DX2PFJMOSE/Rq9IU9aVOOg4QkI20HZghfSVCCheddmzyDXUWjrF+il09giBFM9whHE
	 aEnqkns34Ge9/zwbhYqdS1/Ok+Jby67jjYI3vNLP6i/7qHOpDbPZsPuk8GwlK1OzTMWU1
	 crqpuZDe7nt8Z+M7tnMYUGUDvqjYN32ieBGpkLSzzKrcRqlF/aG4xzcLiEkkksDqTdeO8
	 UjaIQIsbEUf/jO3WiJnvFVEV1LOG7D7/MrtG9c0860dO88PTBrmKSlkBaZxp0rr9ogfBP
	 iQv3DOvi+70gRL00oZ48/M/xk7AZfBYF05U7zewyfREcbK2jJbmlliV878ZkGeoN3AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792490641;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2xqJ7ego2cIVHaasX6cs9qwWsOg7oxEQGC5sNjYglzs=;
	b=jLsxtqo+X5/smCga5tsf2ZGtqTbB1wUPcjKjQuXoEmA62hrOJ180cH4kjvpKijZWDcG9
	 EVz1B6mSCDrwBzRDy31U/y2ZpldmjSPB10GkgTjSNJZ51XHqUsOZROXHK44yC13PVK+Vq
	 jgnkjlIx4hV9FbudGy4tSdOSbgNzDcxj39Tc5Z5Egcbtx1vEPdh2dqrdlBXL0J3Uzs5x3
	 hJvgkdDsP2tE30Z7/2kTcmRT1eX8aCq0WnicA8KgChR/t2Qukqi25vqmldwO9iE7kY8lr
	 kyjqjD0ScvD3impA5Dtl+FaR4xHZiO7tUQ4LdFkn8CcRVRLkeCKUOIC6+ld4xbOasxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KcqkG6m+;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E1D606A31A
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 10:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07E1D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KcqkG6m+
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd5c9e52398so1079524a12.1
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 03:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792490640; x=1793095440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2xqJ7ego2cIVHaasX6cs9qwWsOg7oxEQGC5sNjYglzs=;
        b=KcqkG6m+FddXShT5NFcDWmnYQ0y0/jNU3IWdqux8C9SWGppxNhdg7QA4Wy7YdGot1y
         zUgA+Rz+0JmMN/Uu3eSYc2j5zKpkW8Px/4Db5rl4225rLqyb5yt4IvbdupYzPZrhtms/
         nfeLUZO03blFdLiLVm9l6viLKLjWpuhKNKz2no1Aocv0kIdy5asxv7ZNb9qWfBmj3Gvr
         FLyDZ86MrWswryX4hGbktY/t5aBw0YZYZg9/SToU6N9a3xCGyHF7kcOxFw7OqEmjnfBf
         a4VStnOc5jrB4COpFBZd/4644x8xJ0DsFrqVru44apl0Hr831a7nhRy6b+YrFWcv+CWG
         cMsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792490640; x=1793095440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2xqJ7ego2cIVHaasX6cs9qwWsOg7oxEQGC5sNjYglzs=;
        b=syyVvFbr8AI73HhlB+W7E6rDOMTG+KEwXDoW3Ifc0IVdZjnY1+BPecDxsZ99bhmaXA
         Sa1A+Msh2S9g42Gy6qVXAmOBvKxjRwKvb1ZV5Bdp0d0svf1HQI08a1Ibel6ABc43aCjW
         a2sYu+eEez9yu6Js4kdoEw8BMVgN0Qzmk0yqHtKGT2wHueGoWyIgfIPxUR2ahaEbLvVL
         9WBwOFfOk/kLkP1ZW2nsMpdrxqFcM4MGBw/ecm1QVHBbUqIsK7ZS0lET2VlA0eMjz8P1
         xaaXENC1QoCZKlgeXlMDKou4eeCXLzp5vpoSRF/1XWOpNMXxzQmtmmi0QFdmtkFqI4ph
         Uevw==
X-Forwarded-Encrypted: i=1; AKwUvByI5gbgT8qSd5CsQ31Aj2G3h1nf6/DglMszHn2tN+xV5SBf4nbVQZ5ji8rtALhwF2x8DH/uRRsU@vger.kernel.org
X-Gm-Message-State: AFq9FYJHyj5gE9C/IwOz0k0wmi1RRcaqOyis52JPcy5e0Yqa7rYCQOcV
	aweVG/VTvBG2nDp5UXsX9AJlAFyg9QjY8ewG/H/IXEgSA2RhFiNfnjEk
X-Gm-Gg: AYBFou3RsTZKmA50jyb18saGpgOsqQ1wqZk25NZXushV3IA7rabMJV78AMZ+SkMfqcq
	1oFe1AWah68QWaxzPUBKM1m3bDYzJHEHat5L9GczOzqgv4pD5ht3TMOm4IGUe6Wwzin1l8oDI5/
	fi/lBf0CJjk47f2/dvTyxkK5GfI3My4/PMgGYuLPzrag2SIqyoFy8g6BwTPOhxEUqwLR126LA3P
	Jdu1EFxC5sD+vSrswDtt9p4ALzVPoBAKq9Ppf5eewXhb6wphWrIkE0zgIqnOb82z57NjGRbKRzL
	mOT/lSL5SjXpxKZqjG3zLd/uaq8s7bZtgvv5S/LF/5TxZNqU01ZdGXjrcZr8/XwM5dRBZZ0J27h
	rjhUJVk2cx3UdVcIiYhlfniT4lbvuIrNVeHN+yC9DttJMmY+jC4Li/InuLYevi+GdkAvo/PLNF/
	E0uNNwhDzLc41YV05AEWW5QWUP/Omv71VYGla6NdEb8k1IWFO/OsZlxpHC8TlqUAhG7sgpyi2ZH
	OcnCGHNYzc=
X-Received: by 2002:a17:90b:582d:b0:3ab:c674:cad9 with SMTP id 98e67ed59e1d1-3acef519dddmr9226879a91.54.1792490640339;
        Tue, 20 Oct 2026 03:04:00 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad5c72df56sm3203446a91.0.2026.10.20.03.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 03:03:59 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	tj@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/hugetlb_cgroup: prevent use-after-free during cgroup offlining
Date: Tue, 20 Oct 2026 19:03:45 +0900
Message-ID: <20261020100345.1677643-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A normal hugetlb charge obtains the current task's hugetlb cgroup with
css_tryget(), charges its page counter, and drops the CSS reference before
the folio is committed under hugetlb_lock.

The task can be migrated while the allocation is in progress.  If the old
CSS is then offlined, its final active-folio scan can finish before the
charge becomes visible.  The allocation can subsequently charge that dying
CSS and commit its pointer to the folio.  Once the CSS is freed, uncharging
the folio accesses the freed hugetlb_cgroup, including its page counter and
per-node usage.

Keep the reference acquired by the charge until commit or cancellation.  At
commit time, while holding hugetlb_lock, move an uncommitted charge out of
each dying CSS to the first live ancestor.  The hierarchical charge already
includes every ancestor, so moving it only requires canceling each dying
CSS's local count.

This orders commit against the offline active-folio scan: either the scan
runs after commit and reparents the folio, or commit observes the dying CSS
after the scan and selects a live ancestor.  The retained reference also
keeps the originally selected hugetlb_cgroup alive through this decision.
Reservation charges retain their existing CSS lifetime and are not
reparented.

On an unmodified v7.3 kernel with a 128-page 2 MiB pool, a
capability-free uid 1000 allocator racing administrator rmdir reproduced
KASAN writes to a freed hugetlb_cgroup in three of three boots.  Controller
disable reproduced the same fault.  With this change, 5,000 rmdir rounds
with 1,075,055 successful faults and 2,000 controller-disable rounds with
1,707,348 successful faults completed without KASAN, LOCKDEP, page-counter,
or refcount reports.

AI-assisted source review was used to identify the race and to help draft
the reproducer and fix.  The interleaving and the resulting allocation,
free, and use-after-free stacks were verified with tracefs and KASAN.

Fixes: da1def55919f ("hugetlb/cgroup: add support for cgroup removal")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 mm/hugetlb_cgroup.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 3fb41311e4c7d..1e0dec070b05f 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -310,11 +310,10 @@ static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 		css_put(&h_cg->css);
 		goto done;
 	}
-	/* Reservations take a reference to the css because they do not get
-	 * reparented.
+	/*
+	 * Hold the CSS reference until commit. Reservations keep it longer
+	 * because they are not reparented.
 	 */
-	if (!rsvd)
-		css_put(&h_cg->css);
 done:
 	*ptr = h_cg;
 	return ret;
@@ -337,9 +336,26 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg,
 					   struct folio *folio, bool rsvd)
 {
+	struct hugetlb_cgroup *charged_h_cg = h_cg;
+
 	if (hugetlb_cgroup_disabled() || !h_cg)
-		return;
+		goto out;
 	lockdep_assert_held(&hugetlb_lock);
+
+	/*
+	 * A task can be migrated after selecting h_cg. Once offlining starts,
+	 * redirect the uncommitted charge to a live ancestor. hugetlb_lock
+	 * serializes this decision with the offline scan, which reparents
+	 * earlier commits.
+	 */
+	if (!rsvd) {
+		while (css_is_dying(&h_cg->css)) {
+			page_counter_cancel(&h_cg->hugepage[idx], nr_pages);
+			/* The root CSS never dies. */
+			h_cg = parent_hugetlb_cgroup(h_cg);
+		}
+	}
+
 	__set_hugetlb_cgroup(folio, h_cg, rsvd);
 	if (!rsvd) {
 		unsigned long usage =
@@ -352,6 +368,9 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 		WRITE_ONCE(h_cg->nodeinfo[folio_nid(folio)]->usage[idx],
 			   usage + nr_pages);
 	}
+out:
+	if (!rsvd && charged_h_cg)
+		css_put(&charged_h_cg->css);
 }
 
 void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
@@ -419,15 +438,17 @@ static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					     struct hugetlb_cgroup *h_cg,
 					     bool rsvd)
 {
-	if (hugetlb_cgroup_disabled() || !h_cg)
+	if (!h_cg)
 		return;
 
-	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
-								   rsvd),
-			      nr_pages);
+	if (!hugetlb_cgroup_disabled()) {
+		struct page_counter *counter;
 
-	if (rsvd)
-		css_put(&h_cg->css);
+		counter = __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd);
+		page_counter_uncharge(counter, nr_pages);
+	}
+
+	css_put(&h_cg->css);
 }
 
 void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
