Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA653932E5
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 22:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788562272; cv=none; b=KKKCNBhdRdTYCGZoXGGPZMkx077a3jnicmVVuXLoz3oUepqXOU4lQ1bOQzYsq1UB3tLU3YTXQooBoUlDi6BHFNkBC6YREGknROUd4XxekkTfxsKmid4GSXGiICBieGstngHmm2g2WGSIHnCM+xBnjDmx44RMhsFa+iEMWHsQEGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788562272; c=relaxed/simple;
	bh=7Rr4cZf23G1AhSmC6yHNaypWuZm8NnD+lG4o7s9xYsQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kwo7d/5ooFOWUPJWdIPlAjqjmArxIz0+qL8z8V59oKP2RR2MkvAKk/zNDv5JVLKi+Obl+BPCkLtpBRXU4h2EzxWT3Ys9RFVEgf4DKuGy64lt49MRWXDjc4pBSNebFn02dw2lNvhumIRmpuGR1eHHmGbBZAN0/XsPXG6bg8Lpmco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pMPWpmHv; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pMPWpmHv"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso1794439a91.3
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 15:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788562270; x=1789167070; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VNAQcGgCzsGn8fB04Y1RcaGfsgoCFdcws+Wtu5yA69s=;
        b=pMPWpmHvPvN5zEtwTLfiDUwwtHC9VZdApTNgYP7e3Ok+eo1Xts9Fvyb+b8istJf6St
         4Vn5dsgfbIag6TjgVEKTt5ds6e7AB1uARD0bDhOn30lv7W92DLAiWMEd+ixT/wf95ywD
         i6VaHyXO5Ru0Mh+Hc0nk64A3sCiglprJBxBEZHv18R0mTGNteQIFVAlfDC/e2NFPDdGl
         +6oei6f+NNsnLAZ6BjU5BOW6scwTLSTTRuAQofF7T5aQGRtWFos//U/Na2v0LK2I3lR8
         MccdtCStSJXqxtu02pILHGq95bkGtgoRimyoXtpWDw9R7MT0DpvYrPAOYRQ4LBTYWZaU
         j0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788562270; x=1789167070;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VNAQcGgCzsGn8fB04Y1RcaGfsgoCFdcws+Wtu5yA69s=;
        b=d4oR6SThokn6FQfHTEy0D5uhEDYoB+ONTISSV+gUY3QvHmitFSWXT/hz+y5n1OY/hd
         D9h6SuLvZpz8YkaOttdrHJCOa2fgmEgsp44GGYnGzeGTIYJiwZA/gtrFsSimV8dX1pT8
         0FPmDN1JZqe4K56c6CQzE/JyL3nJTZcSjqXOPiNTeD3zM1Rw6PWrwnyVNQ4XgSDodEwD
         DLuaTwH08o8SMT0+jWCLEGNnre+XGBgyDRYOI+kUnvd9kMiX+i4mxgsDKDjgf4CKa6l5
         4Nz/hZnRZ9G3fO6J9EzhH06InTVg2CqfrsgrB7mzHxKemSHgrXx0/TekCmjPqod3+zJW
         ausA==
X-Forwarded-Encrypted: i=1; AKwUvBw88AL85Z2XLaUulhB/FyyxIrjsyWOo4tvR5CA318xR8nn/Shnp7gZkJ8ab3mb0AJvsQmJNrKc0@vger.kernel.org
X-Gm-Message-State: AFuF++kZVjAsSYmd+BjMyk43VGM0H85k19bFZuUort+lg3TOPUERX/xK
	NLqfa4DeEF8eNyWKXGRe2CsUGn0GidU2X3J+TBPYvPqnG/nsfCTULKIkOrSkDfxf3M7Fpb5IyuP
	4PJoIy6l6lA==
X-Received: from pjbsj10.prod.google.com ([2002:a17:90b:2d8a:b0:398:ff5d:7e24])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5243:b0:38e:c232:9d3f
 with SMTP id 98e67ed59e1d1-39b2614df1emr14776303a91.5.1788562270186; Fri, 04
 Sep 2026 15:51:10 -0700 (PDT)
Date: Fri,  4 Sep 2026 22:45:15 +0000
In-Reply-To: <20260904225103.2955759-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260904225103.2955759-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904225103.2955759-4-wfelipe@google.com>
Subject: [PATCH v6 3/3] selftests/cgroup: test_zswap: fix implicit unsigned
 promotion bug in test_no_kmem_bypass
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a small
negative number (e.g. -5MB out of 1GB). Because delta was declared as a
signed int and stored_pages is an unsigned size_t, C's usual arithmetic
conversions implicitly promote a negative delta to a large unsigned 64-bit
integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
to 0 and fail the test.

Fix this by declaring delta and max_delta as signed 64-bit values (s64),
explicitly casting stored_pages, and comparing against a signed threshold,
ensuring negative deltas correctly evaluate to true.

Fixes: a549f9f31561 ("selftests: cgroup: add test_zswap with no kmem bypass test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index f4ee440b3c66..6e7ee11bc97a 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -632,11 +632,12 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			s64 zswapped = cg_read_key_s64(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
+			s64 zswapped = cg_read_key_s64(
+				test_group, "memory.stat", "zswapped ");
+			s64 delta = (s64)stored_pages * page_size - zswapped;
+			s64 max_delta = (s64)stored_pages * page_size / 4;
 
-			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
+			ret = (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
 		}
 	}
-- 
2.55.0.979.g7e5102b832-goog

