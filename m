Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B933B3E0250
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 23:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787873484; cv=none; b=KMfp9uIbUgl1e3FD2huXYhZ5tmZw/VV5+sMOzGvZv77FiEyNfzcAgdNnHAS/WZ3GOFFb9EzOKrUGnJ93OxILF+5N+ONHFt23qDt7g5YX16zAlk/tBRtEqvvnsSWrwEqcfwPxOXCFbh6oeBiuinVfrsxx8abw4E0/Alv1BlaIa+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787873484; c=relaxed/simple;
	bh=/Etwo9DLyA1piEjryJIX/y39Y2LuaF2Cl5MFeAEYG5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AUYHFL8PfB8j0qi1y44eX06w/QETkcl2lyYwKb/3BBk9i55TauwFu9mVQW3xwIRkjUTP+t8JEsvVmJxr3zhdzZ0NO7p8OEcdjQrNFVd0RWGu0eyUFro6KtrjRqgbfMAenCGz6xT7x8QReaB/ETjG5sZiIfhrULmGK/0jQtq3xcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to; spf=none smtp.mailfrom=dama.to; dkim=pass (2048-bit key) header.d=dama-to.20251104.gappssmtp.com header.i=@dama-to.20251104.gappssmtp.com header.b=INdbKFdq; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20251104.gappssmtp.com header.i=@dama-to.20251104.gappssmtp.com header.b="INdbKFdq"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3965d3d9ab8so227754a91.3
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 16:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20251104.gappssmtp.com; s=20251104; t=1787873482; x=1788478282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dyiy2y/avbYOe0BnQSrLgYOVHtwCGX72+qfVpLstJvk=;
        b=INdbKFdqr+oOKdIS6fNi1KjYeQqVP7cMehmHLqCakBHQCuVKkVloj2KQZX+2BIBR4j
         7kx7j83xIdi5cJsqnzr0XtbKYuBqmf408X3Y2EtY2kDHueyXTQtEKwB3USshpEn5cQ6j
         ZKzYw1PXgAO+eq+bNA4DiecxtFzsaUpDox3y9M2kDqOta08fYRDnNYrHFTK+Qq33zqfk
         nL1JjiXnDvLpc4ObbkYQ+ze1EVBS8YI4DK0Yce5R7v7HIgvbm9HHjqja43njYFTk5Ao6
         3UPFGS5I9z3BQjaZ8QOLOd+GeRtxV2+Ffi0kyySfLCN1+ojKAIh/CkIsCJeAWhFofz5a
         UytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873482; x=1788478282;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dyiy2y/avbYOe0BnQSrLgYOVHtwCGX72+qfVpLstJvk=;
        b=Ft38eOWi1ioSguWvpRWmRbSMk+PoxBpvLgkzlZNYXpUFbmm3y4hFJvdjCsek7sC1E5
         Ac/RHeROtOmVDZ/JzHQi+wsLbA5P/zDMpdfvkte6hQ++FO3SLkzA5QN9Jqs21LD6uoPI
         G8E1y/I4p4968atYQGHeA+7rsIDy97P7xhlZZKHX7YPipIerfpVMTOz+Rt1zFuXhQs/w
         JagmgTntvVRnRfLgLjo+8i/AFDzT9SKVDSuuzqSqARIeqX+lhG8vyn2abG2iVN/6OPkt
         1YLhgjqtHK/kufhQG4utBBZzVAGkMRgyAmuaVeyxYejqUu89PEPi4CNHW5LMG0HgTdlG
         uowQ==
X-Forwarded-Encrypted: i=1; AHgh+RrqR5MsBP68dmiy6QPqfZ08wBiXROvm/n6QT8JvyT+zcghYHbNz6RgCbYUWyD2R6OWiFvQmaI33@vger.kernel.org
X-Gm-Message-State: AFuF++nobve9atvSPJLJji4oqZ0hahj92lcOH9eh1KBMSngCTkx9WFOh
	1K7J+1ZcQtjNARIUe+rScP/3DtgAs5qPP1xTCxP9pcpqt9kbQdF+5v2swvavQ/FCCUIO/xWuGhM
	4rDdI7i4=
X-Gm-Gg: AR+sD10gjt/4qJVy95iXy9oq2E7649pvpJE74zJDlekkeknpXkVqE6/UOvroNNJ/k7T
	4gtlUogAokoaHHR1qzOVmSVcrURObz1wSBB9Tx5uRSFzGbIqC74vgELCFLaaCujdXCEHlkqH/AQ
	jhFNTuLRmt0419UJwU1EaDW6ApweQ6KRx3pNsvQzHfgkkUpbS1mxtemm+HLkrf0d2Y+vDQmu0UM
	u7PVBZ15yOeN92N7936O5OVsYA4/mCzxuvcy+bExuS72wXEt9+tkSivMz4LrVKW40eDuui2mSPH
	I69fwUtFtjm75EAe6pNeeCYphbT+FeBaIHQOpfaw83otltmCYKoJHaGIdO9Fgc0cgu6IaNAhmof
	nQEG4RN6OXQKtr4UYpDhkW+oj1gOi+CBt9MCgRAiwSgI381+V9QbfjDdRFt1NJgc4JjHIyBOrOU
	3W4VZD59GrMSMSsKsPc1Iez1Y8SstCvVKBrcz6FT+N1Q==
X-Received: by 2002:a17:90b:1c0a:b0:396:54ba:8932 with SMTP id 98e67ed59e1d1-396d104e722mr3685624a91.16.1787873481701;
        Thu, 27 Aug 2026 16:31:21 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:4a::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1ab4e12sm4501710a91.16.2026.08.27.16.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 16:31:21 -0700 (PDT)
From: Joe Damato <joe@dama.to>
To: linux-kernel@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Damato <joe@dama.to>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Subject: [PATCH] mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming
Date: Thu, 27 Aug 2026 16:31:18 -0700
Message-ID: <20260827233119.411152-1-joe@dama.to>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Charges that exceed memory.max and return through the nomem label can
raise no event and simply return -ENOMEM.

A non-blocking charge can hit the limit, get rejected, but is not
visible in memory.events.

This was noticed in a production setting where bpf_mem_alloc() attempted
to refill its per-cpu freelists, which triggered a non-blocking charge
while at the limit.

Move the event so that it is raised as soon as the charge is known not
to fit.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joe Damato <joe@dama.to>
---
 mm/memcontrol.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..3904fe9a7b2e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2683,6 +2683,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
+	if (!raised_max_event) {
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+		raised_max_event = true;
+	}
+
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
@@ -2711,9 +2716,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
 		goto nomem;
 
-	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-	raised_max_event = true;
-
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, reclaim_options, NULL);
@@ -2773,13 +2775,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
 		return -ENOMEM;
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit

base-commit: 3d83758432b5e6ed9507500a57efb0f3af41ee7d
-- 
2.53.0-Meta

