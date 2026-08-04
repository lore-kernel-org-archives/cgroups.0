Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CE433290F
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 04:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785817288; cv=none; b=H/XWEmbeqn60GCkx8hwTdmhgNeMYten1i/M9jgpfaRGUr2KnCWAfro9O8HEucignf2sM8n8XJYdTbBoyQEqljGWVx6JQJXbunM+plIUoJAlRYcC17tdy49Fun9CYVXr1mVRp22WBGRjXFGFl43hlnLRx3xBUeVLhtw6y3TcSkyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785817288; c=relaxed/simple;
	bh=JD1AvwQ5UXWFZTP1zIISu/PE9c1xITWEefPIXoyw37M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FPRF34uPa2l1tElTuYzlecY18LnVpHOZGsZOrOmT4Pc4PaIuyjFkZiHHIbm/WtNaZ4eloCJe0gsWFczCSo0qT56NYmcG8XRPtgUqXHXN2JtycdDLJkNDLI07X5FH2W8sABxV7zxS5e24ZjOcOv9CFC/kjlv/rfpaFvDPyTcaLaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kwBHyF6D; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kwBHyF6D"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8486c3411c8so5850706b3a.2
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 21:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785817287; x=1786422087; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TR4qhJ/Sx3Yvhb5MktlPGJQjJ+lc6YwHU5a7NNiYmZs=;
        b=kwBHyF6DPgRmkdM8FmyC/W8Swk03OO56SnQjUudVu1nTAE7OnrqH93/tJ0bU+JK5XK
         PlZCF+xjdKEILDE4p2VHCD+J8dOB3z64w9UM8ZESSj2YEUPoZduchfIuwc8uEAjzZnmw
         FfCvRangQP/4+W3+5JnGYrBRPpXvoWNRsqS7Z2nF1U0dCVaPejBQolTZ3ZA+w9Bh9v+c
         ANXTehB1PQqccbErIddRmxqbh9TRTJEEG2WKItthAuA9eSZMT3N6LuSOMa6K0256zbS+
         lw9i/s+aBOqpo5P+eVIDve79E+4sEX7zYZ8A4D2UEX2FFCqXDVVUp5rsc4P+xcT6oYlB
         zHPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817287; x=1786422087;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TR4qhJ/Sx3Yvhb5MktlPGJQjJ+lc6YwHU5a7NNiYmZs=;
        b=qFLLKGK9axMZz7wjQKNsODFPG+Fcv1VR2EoVn2b1eBGnDwXrCX385U4zNyblXQPzCR
         wMY5NxmJfWadv1FBbWWWDofDWr0JYWl0OXhicfXY9sxrOISDbvMBNDLd6Vx0OcB7Fuxx
         ipmbsfmoR/S6x6H+Yik6hPBqfgs/+aB0IF/iZvqDZVeSsqfDHsxcPzmhQdCYNxuV2Wj4
         HJGQ5KXq6thF/whBWHZKUTMfU+wBTxyybDO+4yTRnorU4wTpsgyGXhIkerkCRlBRKTcS
         MT6PMR0JBmFzY2nuDAs1SMX8Q4KfAxQj7jO59erT2WOgQlsJgFjEDqGKCKfXGIEPAv0G
         5nGw==
X-Forwarded-Encrypted: i=1; AHgh+RrlSyCdUur0RJ+F1GXNu4fI/tQ8dgwkU9+tkGjQS3GHEJGyJg+B5EHLi5x9YsyA11KA0RaQAJJa@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/N66eE/YkBsOWaN1rH3muivn7sBjMvgzvfTpO2Dc3FQG3Y4vf
	/b8THdYJ7SW4IEbbzuOUFpHD4BOsMwpaTGpqtYS1AbFjSDKxZLbllCMt7szyXohQwVgdReMRKe7
	/iqm3RrXPEw==
X-Received: from pfks7.prod.google.com ([2002:a05:6a00:1947:b0:848:4f56:7671])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c82:b0:84a:6540:3389
 with SMTP id d2e1a72fcca58-84ee47f5779mr11550310b3a.10.1785817286673; Mon, 03
 Aug 2026 21:21:26 -0700 (PDT)
Date: Tue,  4 Aug 2026 04:20:45 +0000
In-Reply-To: <20260804042053.56940-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260804042053.56940-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260804042053.56940-3-wfelipe@google.com>
Subject: [PATCH 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
 promotion bug in test_no_kmem_bypass
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
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

Fix this by checking abs(delta), ensuring the test correctly compares the
absolute difference between system zswap and cgroup zswapped bytes.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 312d51887a1d8..7bc2519862f7e 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -624,7 +624,8 @@ static int test_no_kmem_bypass(const char *root)
 		if (stored_pages > stored_pages_threshold) {
 			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
 			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
+			int result_ok = abs(delta) <
+					stored_pages * page_size / 4;
 
 			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
 			break;
-- 
2.55.0.571.g244d577d93-goog

