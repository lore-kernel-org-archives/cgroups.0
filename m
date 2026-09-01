Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1DE39B972
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 05:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788240176; cv=none; b=n+wB1Dbx8/iubQjT4SsLs6a2tboxMO6J4qaicHqUoDXWaDnPdpV/UBr4QgDwauBab+MNSaI45TjkVyaAsLoRFx0qFbRuPEzW/DWZF2R0aS47PRw7oIOFkffGjGqWmZhPqxhHH0Gyrfsidcgt3FHbJZmyqytOksP7dYaD+4HwuhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788240176; c=relaxed/simple;
	bh=LKe2bNctC1A/j7uhC7WkmhcWVRTU9Foz1HcENo/uvJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gcNKvH5cVcq2+k8PKZlwB1Bn/nW2GZG73ERlt93IynIve+DG+4ZkVkuF9+nLj74C5PD2Yelxdyjah5bTd/24tbGKzsJtbrHPNmd7knkpJKvkeI/ZGqbdD9wXGBxn+wTCfY7U5plsXJWj5zgusmgzx0n0NE6A7LyintwSd/T2AHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NnEZ5/P5; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NnEZ5/P5"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-855315ccb64so455879b3a.3
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 22:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788240175; x=1788844975; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=txHyoP6V8LSeV3HcUyvKh0AUgxf1/LIju6BYMJo/v9M=;
        b=NnEZ5/P5Lc0Zm0nGY8zofUcATHpHcV3LEkf0cGfgqNmVw/KIfXg6roswR6M4/NEhVG
         HeoQFuqtyvoIpsizNV9NOB5gP4FNbMKkdY/5EEkpQMxjNI6dOr55kJoZw8jvSurbf962
         XU0r4W+xSCwV81wHeVL0h8v5FNO79ONUGdV4dPjf4QEytX2gUX9WEqmGEHCRCrXHUw+j
         r9M7q60AVqPQ+TtY+aDF6E2dDN+WJHuOMD5dl8uIoexnX6YeEDVxueA6yJWqhQ495BKo
         lTpkVF20S7KoUx7MeGM1oot9c2BqLZ9no8KWOu2iNc60eq4VXJ+Xm9GlUdF5Np3JQdzH
         DX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788240175; x=1788844975;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=txHyoP6V8LSeV3HcUyvKh0AUgxf1/LIju6BYMJo/v9M=;
        b=hGdfHWm2nnuFR8zfsxLt2XsgeyU7VlFDTSKv/UtEukpsXF2UDk8dVGh3Kw/qphT5ny
         99EPQv4ljChAPBNFyd64LIVJGmhOmrN3agxtT2VcZiya37Tm6IQ0e0QgLoeN6wcAIaWV
         cf/aw58y8IXgLZgPn2Ee06Oi6pVTGumEZRlZUaVnpcWCFJTctH5d1jX7qOOWuTrkDfIA
         lZAHlGNcBhaWyJ1UZDOIdXTM6QxyGmlc9lRjVTcvQifnUbtX+WuT1+fazH1z+gwNlQjo
         kslQKcAgDopblZU8tKLNjZrYdr8nLHTmbcJb+e4E0ECA+GNQ8OBJQWkQn0xp0lMc44cx
         z5nQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr6AoGxirwzmJqkOEMzSOj1/CeApsxQhnFYwjBNVDPxt1eG/edrfEfLMCjx5RNDTrB5tJ1jfH3x@vger.kernel.org
X-Gm-Message-State: AFuF++ls3r465dLBec0OOyDjPes+ZN3S88nEoARtAF8tdcRfN8AD1W4E
	5gZi/hHuhBXjiDXM8PgAJM8CCuTLEoAU4s9o2UuFBP5MvG6BcuurgIw/H1WGf8YZiiGgJ7eH3G0
	gLWngUElv/g==
X-Received: from pfbfh35.prod.google.com ([2002:a05:6a00:3923:b0:847:a85b:6c23])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3692:b0:848:5f4f:289d
 with SMTP id d2e1a72fcca58-856277dba33mr51581983b3a.4.1788240174518; Mon, 31
 Aug 2026 22:22:54 -0700 (PDT)
Date: Tue,  1 Sep 2026 05:22:28 +0000
In-Reply-To: <20260901052250.154532-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260901052250.154532-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260901052250.154532-3-wfelipe@google.com>
Subject: [PATCH v5 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
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
Content-Transfer-Encoding: quoted-printable

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a small
negative number (e.g. -5MB out of 1GB). Because delta is declared as a
signed int and stored_pages is an unsigned size_t, C's usual arithmetic
conversions implicitly promote a negative delta to a large unsigned 64-bit
integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
to 0 and fail the test.

Fix this by declaring zswapped and delta as signed long long and comparing
against a signed threshold, ensuring negative deltas correctly evaluate
to true.

Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypas=
s test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
---
 tools/testing/selftests/cgroup/lib/cgroup_util.c    |  9 +++++++--
 .../selftests/cgroup/lib/include/cgroup_util.h      |  1 +
 tools/testing/selftests/cgroup/test_zswap.c         | 13 ++++++++-----
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testi=
ng/selftests/cgroup/lib/cgroup_util.c
index 2596c12cd864..ce2dd36291f8 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -172,7 +172,7 @@ long cg_read_long_fd(int fd)
 	return atol(buf);
 }
=20
-long cg_read_key_long(const char *cgroup, const char *control, const char =
*key)
+long long cg_read_key_long_long(const char *cgroup, const char *control, c=
onst char *key)
 {
 	char buf[BUF_SIZE];
 	char *ptr;
@@ -184,7 +184,12 @@ long cg_read_key_long(const char *cgroup, const char *=
control, const char *key)
 	if (!ptr)
 		return -1;
=20
-	return atol(ptr + strlen(key));
+	return atoll(ptr + strlen(key));
+}
+
+long cg_read_key_long(const char *cgroup, const char *control, const char =
*key)
+{
+	return (long)cg_read_key_long_long(cgroup, control, key);
 }
=20
 long cg_read_key_long_poll(const char *cgroup, const char *control,
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/too=
ls/testing/selftests/cgroup/lib/include/cgroup_util.h
index 5d39c709ac7a..13923534003c 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -69,6 +69,7 @@ extern int cg_read_strstr(const char *cgroup, const char =
*control,
 			  const char *needle);
 extern long cg_read_long(const char *cgroup, const char *control);
 extern long cg_read_long_fd(int fd);
+long long cg_read_key_long_long(const char *cgroup, const char *control, c=
onst char *key);
 long cg_read_key_long(const char *cgroup, const char *control, const char =
*key);
 long cg_read_key_long_poll(const char *cgroup, const char *control,
 			   const char *key, long expected, int retries,
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index 8f2c9aa4776c..11c67dde705f 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -630,11 +630,14 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			int zswapped =3D cg_read_key_long(test_group, "memory.stat", "zswapped =
");
-			int delta =3D stored_pages * page_size - zswapped;
-			int result_ok =3D delta < stored_pages * page_size / 4;
-
-			ret =3D result_ok ? KSFT_PASS : KSFT_FAIL;
+			long long zswapped =3D cg_read_key_long_long(
+				test_group, "memory.stat", "zswapped ");
+			long long delta =3D
+				(long long)stored_pages * page_size - zswapped;
+			long long max_delta =3D
+				(long long)stored_pages * page_size / 4;
+
+			ret =3D (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
 		}
 	}
--=20
2.55.0.970.g62bdec98f9-goog

