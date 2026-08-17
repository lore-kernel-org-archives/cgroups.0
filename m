Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8853AFD16
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 10:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786962880; cv=none; b=aUr2Dy1Z4IfG2XENa3nBQ8a7WfkpEEy233gLpHtGHI0TccUgGpRu3V26+Uzi8lxViJWNASjceJltR5gnR9Q0CP7VWymE9SCZPLqN3I6DxlGJuNg7GbTwxR87m8dU/XUM9RKUZKwxTLFE6cHdd2vgcXMzWYvnpTDC55AR0TBvm0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786962880; c=relaxed/simple;
	bh=gKrpg8U7j7EBMwRqFOyixJHjTHd8xe+nJDZuRrGLG4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kztjt/gt35ihhs216RCxFvs4Cg+/L+t4T9UbiXVIenEc6j2uRNhe5dBooLo+JCGaxotsmf49SDXr3/8mXzlfWwfPtsLv/KZcQdPH//uO6XQUxlwIqlsNqjm3jvxorZnfP31fxBMjGlpMwTP8k3JgqiNyPz5bDYuISDsd71jlbpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nwb7HJ9p; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nwb7HJ9p"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39c86ce9e29so25555351fa.3
        for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 03:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786962877; x=1787567677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z4LaCEquN0Z047/3Rwp1z8GkQCCa4hzM+M2Iotc0RKY=;
        b=nwb7HJ9pkRaFVLMDAQYQRLL6fZzGL0c0VPeMIKX4QnL9vzCWv6GJ6MOsotQvORlsJa
         Ete0I3OhIMaGt/WsOkfQTdFvvJCM1re2IK5o60KvaMGH/pqLgVvkj75do3n3XYLp+xxN
         YmDY7+d943oeFFmkOtMF2Iu5/OB6V27F3lzj2uPS/bKufFdDX4Fz902H6LzT20wmJyxC
         pmkZU8I+eUXXS0M3ayJ8lOLjpti7XFrpuieG9+OmhdNWm1tUKrt6ZQOX3+x0oMZCa9bB
         JPFdPRxNlw0ug5Hyx85GyP5y61/iKF3KF/8EiGKD70wtUZJnDDdD+T2BWyJTe7/vHrBf
         fOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786962877; x=1787567677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z4LaCEquN0Z047/3Rwp1z8GkQCCa4hzM+M2Iotc0RKY=;
        b=eiK0YOnKLlgkGrY6fG7iB2rbsGcIca52h/OI56qyby4vIGvG4TFWnmFrZI/X1r1HpD
         ptGVXWhpI+ViosepdHaGvPfnyeIjuOw5DMYPzaZ0L7OdATMrHRpH4IEb1bTFBVGz38Bf
         4puqEqz0lBGJ6EhZizmPcCm9bDVG4KeiU5Xm1brEJEMx8TWlDsEwxCeRMyTHG+5nlSF9
         Pl2z6qLG3GC3p1K3HgcOiXW72i6PYj1fzkjtCZEY8zGayTnviY3/ruo7gj7Cc7tNjQAq
         cQ0K7hKf0gq6M1VS8cxHNBcatYNdZyTdvgbQQI1UjUQrmxcL5wiRL3A9bnOXMdcJEwv1
         N88Q==
X-Forwarded-Encrypted: i=1; AHgh+RoQAiX80jIHJcfWsXC2t2CMK6/V6De1FpRu9Y2Ih68unhsSXIQebqYuvUOBTLewefl2Z8Jm9Ln1@vger.kernel.org
X-Gm-Message-State: AOJu0Ywty8Cx26z2yF5DKx/2fTRaJa/viYSirLYrpUwyCDHhBQWOJkgP
	quP/UOqn/lX7hKFMfgIDSUOna01W0qzBg7zLftpO/1UAUPiIjOEElyes
X-Gm-Gg: AR+sD12cc5pBZVo1M9qYhMc3DR9jWxW+2h/t41GNWfIsDCrTgXqrJ9Z4rcCLr70sI26
	+zKPqk0PKKzETBDWaeNkUtYuadnN4/V6FPIuZ6jI8HNPi5HLih5hMuDFDhuHozILoS1aCFUlwBJ
	g5lsUY/n7v8BWKEY7mliFzYibpCxvIiYg7yU585YbJLAb9IgAo9FKjYGhsobnMr1e3o/76xhyHe
	/vT7eUw4v7KuudEFY17KjuiQHVFvpBxiTReIlRHjLsGLA7NghzfajooCtMmK+kdGS0AJAbciz8Y
	HMQgYYrUBIAi2GVMGHcSCYgt9NssPbtGeRSIYrqfkkHQfxc2pyUYWz1j6I053SP5iJMES0Qcfoo
	rE9igPJ3n4Az8F4oeTFbM/HR08Nf8D5UhRdhLOqOYuhPPve11gPaLUVAICbdwcJNSNvnEqwa8L0
	7GCVv7HkHXGyPFJM8cXSiAsuCRjEhST0i4aGsKtYS21XbZ
X-Received: by 2002:a05:651c:220c:b0:3a1:4f33:f625 with SMTP id 38308e7fff4ca-3a14f340463mr12014321fa.31.1786962877044;
        Mon, 17 Aug 2026 03:34:37 -0700 (PDT)
Received: from c.. ([213.165.253.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a16b1a98dfsm3389391fa.21.2026.08.17.03.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 03:34:35 -0700 (PDT)
From: Narek Jilavyan <njilav@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Narek Jilavyan <njilav@gmail.com>
Subject: [PATCH] mm/hugetlb_cgroup: call page_counter_set_max() outside VM_BUG_ON()
Date: Mon, 17 Aug 2026 10:34:33 +0000
Message-ID: <20260817103433.191266-1-njilav@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hugetlb_cgroup_css_alloc() rounds the counter limit down to a multiple of
the huge page size and then applies it inside an assertion:

	VM_BUG_ON(page_counter_set_max(fault, limit));
	VM_BUG_ON(page_counter_set_max(rsvd, limit));

With CONFIG_DEBUG_VM=n, VM_BUG_ON(cond) is BUILD_BUG_ON_INVALID(cond),
i.e. ((void)(sizeof((__force long)(cond)))), whose operand is never
evaluated.  page_counter_set_max() is not a predicate - it performs
xchg(&counter->max, nr_pages) - so on every non-debug kernel the limit is
never applied and the counters keep page_counter_init()'s
PAGE_COUNTER_MAX.

That is user-visible, because hugetlb_cgroup_read_u64_max() recomputes
the same rounded value and uses equality as its "unlimited" sentinel.
PAGE_COUNTER_MAX is LONG_MAX / PAGE_SIZE = 2251799813685247, which is
odd, so round_down() really does change it and the two sides disagree.
With CONFIG_DEBUG_VM=n:

	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
	9223372036854771712

and with this patch:

	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
	max

A debug option should not change cgroup output.

Call the function, then assert the result, as v6.12 did.  Use
VM_WARN_ON_ONCE() rather than restoring VM_BUG_ON(): the two are
identical under CONFIG_DEBUG_VM=n, and checkpatch asks that new code not
use BUG() variants.

Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Signed-off-by: Narek Jilavyan <njilav@gmail.com>
---
 mm/hugetlb_cgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index e0083de1ca..ecb6e0b781 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -97,6 +97,7 @@ static void hugetlb_cgroup_init(struct hugetlb_cgroup *h_cgroup,
 		struct page_counter *fault, *fault_parent = NULL;
 		struct page_counter *rsvd, *rsvd_parent = NULL;
 		unsigned long limit;
+		int ret;
 
 		if (parent_h_cgroup) {
 			fault_parent = hugetlb_cgroup_counter_from_cgroup(
@@ -118,8 +119,10 @@ static void hugetlb_cgroup_init(struct hugetlb_cgroup *h_cgroup,
 		limit = round_down(PAGE_COUNTER_MAX,
 				   pages_per_huge_page(&hstates[idx]));
 
-		VM_BUG_ON(page_counter_set_max(fault, limit));
-		VM_BUG_ON(page_counter_set_max(rsvd, limit));
+		ret = page_counter_set_max(fault, limit);
+		VM_WARN_ON_ONCE(ret);
+		ret = page_counter_set_max(rsvd, limit);
+		VM_WARN_ON_ONCE(ret);
 	}
 }
 
-- 
2.43.0

