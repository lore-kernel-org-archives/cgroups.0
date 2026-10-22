Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792635733;
	b=y2mv7ddPcYGoqTKI/Oiz8+SB13qYFP0YJdl5TTgdG3RVwEJzlLKF6ioZhTRKaDHU4For
	 zhCiRBLcpLEM3T882r+3tUGT5sXPvZt7ICPFMbFsy4bMOZhYhOTCoa6/mnHBrNvR2xWC2
	 DZBsaXMLJmQLYoCkWYuMzdchaHCJ19KuXgcizLnHMTQjejgz9hsI8J7VyvQA3mj3nVQqj
	 lBxf4k8vTodNUkudcIBNShMtzlvipaxCCmx1Hf43xBLjvTkaFxdVCquSbhLdJ0IFFZh1n
	 gZ4VRhPChIDjOT0Gwkeiqpa6esFSu6jNQPfZmK91k79Mr5fiwsHWIp2rue8yjBHz8rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792635733;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/vcgmKyU3N8wJBKLGR6NXqrqBGbIingVRqEmBp0Pmd0=;
	b=maAFvLPjvVaG/2YHYCHoeTROngUEBahErQQ+rdlKXcY3T1fCbjHte6NIv++sZi8/Bawk
	 XPKJP0Rg4sFyqodsnrxjmA8BgjKOJev6daieKYAfUKltBzYdcFyaPuwbiUp+z8P6qe0dY
	 jQFbQm6ZegTV0J1SQux9E8A3bQAuKVBcZm41N0gJ0d1BPpzNciUkGLmnXiLTQmMOmIAjj
	 DyUFHF0m4TYs3QHL2c536eAc8HgRYvmKET4DojiL9z5aqNr9hD6ThnG3cIXqvAOph1OWb
	 1bfzG9O1ZseItAIalc5smAs8X5b4Y2EWPcDAOyC2e/rN0FEVnoEFQbInxtY3tY9NlpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=f8PycOzu;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0757606A319
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 02:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0757606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=f8PycOzu
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-35943f55c06so583473eec.0
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 19:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792635732; x=1793240532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/vcgmKyU3N8wJBKLGR6NXqrqBGbIingVRqEmBp0Pmd0=;
        b=f8PycOzuoHqsHt9XMwudJkKP7dilV/zrdLicO6TZrc6NettYJkf0P+LgTLjjzakNmO
         Pcr5N+Xv3s33kB425p5aLKJqDwB7qfm3wxfc8M7POF4R8wGFLmNNMQ/DQqGRCay6eW5e
         F9gC1ZJq6q5ICA260meKms8x1E6l7ARthBc8tKTIgeFIP9sJW7ilqrS8l6Bmjcq5+6FI
         qjluXcwq0kL/dtysM6fEAwFNsRigfd2f1WJQ1XI2vemss7q4SHmGP9nZLkE9udwnhekr
         BLrw2rg+OQku1v5lLMiELNcTdFKpQb7HYOKW1JDYWfSGA+V7Fiu23M7In5707INDjYeQ
         5leA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792635732; x=1793240532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/vcgmKyU3N8wJBKLGR6NXqrqBGbIingVRqEmBp0Pmd0=;
        b=Cq2IdNzcczhTDimES2nzia0VXijAVygEctZ7Z7tzRj+ONxAzu9ZndRtLRMOsWF9Rrk
         JADra+OsnRNvRPG1k3TMcDUkpX0s/5d1EvIx7wJzlP401DsMYDkcEi0PUF1UPtQ1xl0O
         kGH8ZihC4XCEOAGreG+LKAb1aKSZSLTr/kJ9q+oHB2RVe8vUzMeYL1s53AZyzYkJR/29
         h2cStRIKT4gL9lmaWl2KM51N9InjH4CbLmOmcwHb/uGPu4VBgKelEM0KLy2mdoBYTp6Q
         7nrxfcMSQIEfGfYNoenpwbkfnUQVIe8yFZkgPIcWX/Qfe3ifjtfSofmXU+Q/mF0GC2i/
         4x1Q==
X-Forwarded-Encrypted: i=1; AKwUvBx6baCqj4RnEpowyymK+A8Gn4cRr1xMJpaLX3NkvCqIf/F8Zl4wvnVzjBO/dDPA54Ye3lhbyyBr@vger.kernel.org
X-Gm-Message-State: AFq9FYIbp+bfdVMifnTN1qCX/QbdAm5MxlvdsIQIaDYB+dd8BodtaKlv
	39wvWSa186JtVO+elycyjdK43bRiMgg/j/wqmAmFzDyggdXE5t35extJ
X-Gm-Gg: AYBFou3LVGtjOnQOykYprBUOR4T/z69G5nIpZr8ZaIyOOEQJ516XN1eYVLRCK5JTmAV
	4Wibt6KNl0pweWjjhq0hAGqr0zjiHBV4AHfdJnDcZkSOhuaNfsFt+gDTULW4E3F9BC0Us0CA+Ix
	N0yqSEWXaI5wIgjdPqhgpdIjt7cWXlcCiepxwt43JrSjy4dW1yL/Nya76xGuVatcr+C5P6kEo5l
	7wWDBYD4OxkjWkZZe77Q4k8gtOR2EhtbpPxFjvowxqFb+DHA5h46APk8+RwkewZCPNJfZpJzkQ7
	EHhn1u4x4k/+G0OvcSJyZ1Tr49DBqI8jMkmrqVFSRHAfZEBo3n0T8d43r5sCUKtkXgYb/d095lV
	CmkqSm0Rj5vajormG/e+FleGukq3weIuWcTK4gO0gsBcxKamMvkWOrLwNLMgkM3yYRgCsGLOjwi
	u5qJmF3D/rZZFw06w4qj+/vTDHoWXVWUI0Vh07PvT++LoVWZC52cDh32bdZrnIs7eJ155PRVCu6
	DxDmEQS57Qkt3oop+ybHB0bwGCXMI0Gz4itaDgsINR2qGhmIHrZ/fHjd1QIVSZTik6c4AIA/fmb
	6q9sE7RB7aWTog==
X-Received: by 2002:a05:7300:d407:b0:362:2e2f:c261 with SMTP id 5a478bee46e88-368b15180d8mr1246173eec.27.1792635731887;
        Wed, 21 Oct 2026 19:22:11 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367411bd27dsm12328555eec.17.2026.10.21.19.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:22:11 -0700 (PDT)
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
Subject: [PATCH v2] mm/hugetlb_cgroup: prevent use-after-free during cgroup offlining
Date: Thu, 22 Oct 2026 11:21:46 +0900
Message-ID: <20261022022146.506005-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261020103057.8066217f6f6fc5b3ed84c90b@linux-foundation.org>
References: <20261020103057.8066217f6f6fc5b3ed84c90b@linux-foundation.org>
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
with over 1 million successful faults and 2,000 controller-disable rounds
with over 1.6 million successful faults completed without KASAN, LOCKDEP,
page-counter, or refcount reports.

AI-assisted source review was used to identify the race and to help draft
the reproducer and fix.  The interleaving and the resulting allocation,
free, and use-after-free stacks were verified with tracefs and KASAN.

Fixes: da1def55919f ("hugetlb/cgroup: add support for cgroup removal")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
V1 -> V2:
- Remove the redundant disabled-controller check from uncharge, as requested
  by Andrew Morton.

v1: https://lore.kernel.org/r/20261020100345.1677643-1-4ncienth@gmail.com

 mm/hugetlb_cgroup.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 3fb41311e4c7dc..6921b185726662 100644
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
@@ -419,15 +438,14 @@ static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					     struct hugetlb_cgroup *h_cg,
 					     bool rsvd)
 {
-	if (hugetlb_cgroup_disabled() || !h_cg)
+	if (!h_cg)
 		return;
 
 	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
 								   rsvd),
 			      nr_pages);
 
-	if (rsvd)
-		css_put(&h_cg->css);
+	css_put(&h_cg->css);
 }
 
 void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
