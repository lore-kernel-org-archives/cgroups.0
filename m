Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD1638DC6C
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 03:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802501; cv=none; b=sNcnVndXjmwdjHqxVXO8hZ5DHcdgEs/IEvWL5D6Nfw+HEZO6bEJHg1xBaC7JV84UUYWGF4mS1b0qNRRNzURS/4Xzq52bw84ZfuibCVGMnYpC3lgpGDb/aZfD97JeeqgkCKIZtzmJx9PTeFC+nBVP5PDU8AXF5MHaF+143EVih9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802501; c=relaxed/simple;
	bh=jG3ZUwUSX2nXMfyOcYVc2Ml1gXEQdWUYtyfSCh9PfM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nv5R45XuWyxwIUQXrfaCYbZwE/WxM2Mc43lkjUzi0D1OygS8mdOBTTGklswoyQbx61lMm7KnVdudplXA4qtWyFLe7mjaCCgyYjgGEQyq6ASKp7jCy9gWprj9TYZpUylSbJXq4W8wsiTqV6Jvl6sDGjt3oS1AVeUssPeg3cJ3ivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ClntCoV1; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ClntCoV1"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8544b721ce9so1292216b3a.1
        for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 20:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787802499; x=1788407299; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mytL1u/OX7fzFYMNNheR2pN3dLSUPiAgBvRmO/dMr4Q=;
        b=ClntCoV11Kwm4S2U4C+FkpgI2rwE/JjYupK7YDGM1pCBtYv8DenIbSz7ihpLJSqSgF
         0TVr/ODJt+f/I3eFbWFrdXnbqS/TR0t5tfyc79YqJ34T/JSGBd6v5hKUrkLjsYafdG4O
         xKeDy01lhcaXy73PB1A3XE67WIpY9fYv/1AmyyM1YA95diyVY9BdTBjH0Zb5/gcxQtZR
         tFRACUffgj9FN0PRkiu3cWbed/HKgZsZKnSKKqLED78A/LsiV3r7tLJ3rQAamZcz5VO6
         OhYAr1/VH4zNMpeoxqQrQKeNg73l/Y7UeCUjS2Dk62q79NQDFTbvAx+gNbJqdORmFSzG
         d/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787802499; x=1788407299;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mytL1u/OX7fzFYMNNheR2pN3dLSUPiAgBvRmO/dMr4Q=;
        b=JfGIu3eUcFAQtLumJxPblSz3Fbjx18L80Uw0tCFVCi8MS02uXfmyS73xRGW/MFsUgU
         9u2hIbK6marNPPpg+feW5VHevZGJb/Q9+vVWLwtWtHmiV7hGMBugmI5b3OokU0LHVRX6
         8MXgCi9Wk+uqvrsddeqs0sugAmYmwGqLNrt8L5vDHJtMOZVM6Hjeptk11KGoTQEAXYYN
         0xNtCAhdDS2jquupN7i7oN24bPGDUDpU4XyQcyrdid9WBM8bbwTcrgFNtNt8PDj/ZGiT
         vhMvJFgS2Gld2CUPAPjSF51L35Wdz+kK9E+t/dsfqHIFJ2Q8WPfG0GkH/Fv+visX0t1Z
         FB1w==
X-Forwarded-Encrypted: i=1; AHgh+RrLb2tAW41l6E68RELokLrA6suzXWxsbd9QpwwZvOGCLrG2LZpPUwWn6h5qukq8QwjquvvSm9G1@vger.kernel.org
X-Gm-Message-State: AFuF++klyZYt1G4Fy6SXCY/Xu8L2IBVlKLFnZk+ZZ2Drt73wK8JPuUqE
	bBwW7UFqWUd31eO8sSyvGq+bTV+saeZ6k1JslgdOKZMQjuMmRy6fKkUjMgbG2RbRBiWKSGF0kuG
	2dyMs9780GQ==
X-Received: from pgnd25.prod.google.com ([2002:a63:7359:0:b0:cbe:e216:e75a])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1392:b0:852:131f:b9d2
 with SMTP id d2e1a72fcca58-853721a4ffamr20661049b3a.2.1787802498954; Wed, 26
 Aug 2026 20:48:18 -0700 (PDT)
Date: Thu, 27 Aug 2026 03:47:42 +0000
In-Reply-To: <20260827034807.2822234-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260827034807.2822234-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260827034807.2822234-3-wfelipe@google.com>
Subject: [PATCH v3 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
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
negative number (e.g. -5MB out of 1GB). Because delta is declared as a
signed int and stored_pages is an unsigned size_t, C's usual arithmetic
conversions implicitly promote a negative delta to a large unsigned 64-bit
integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
to 0 and fail the test.

Fix this by declaring zswapped and delta as signed longs and comparing
against a signed threshold, ensuring negative deltas correctly evaluate
to true.

Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypass test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index a7ff525c1267..9e7d4fce3af8 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -621,11 +621,12 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
+			long zswapped = cg_read_key_long(
+				test_group, "memory.stat", "zswapped ");
+			long delta = (long)stored_pages * page_size - zswapped;
+			long max_delta = stored_pages * page_size / 4;
 
-			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
+			ret = (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
 		}
 	}
-- 
2.55.0.887.g758fc8c411-goog

