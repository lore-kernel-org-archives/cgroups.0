Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723961;
	b=RwPdY4G4TCX4Lo6ha15/y6cSgzd+YuGfvDCzZ6tSkqiTODyadpBJRgFuBQv4qlQvHfti
	 wk8eh1YetA9GjkYren2Jrz4SqocKBzveOuN++y/3c7VqXsjpPbsQFay/DbFZ1kJFdB2Qo
	 fkz8BB+F+rXgz5t+GqMHSgkw81DdqDZeFjdaU5XtU0hB+ltvIbDv6tx3iTIt5dp9xaZnR
	 v8+MmYkj5Jd8llxmmu6PpEzAIgXusajutprZ5K/Fgeyk7IXxb+19LlR7pZk42I1lMw7Aw
	 KrHKtwUM/UTBy1bWQX6iQgeG3YqWoKvTIW2n02LIZwQyBx1DEEWRXr4atrmYMUS7gKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fE5v4ca1Aufck5/eL12cyLA8FcbOpfZPaD75Cvy3E00=;
	b=at8wIrfImGpCaQL2pFyEsHupTwHOefDl1rnmgkb5HJ4OQyn01TvPez0uKtABlGQ9VSaB
	 pH5DqKEv9vYSkGSuZduraWXGRZh5SYBeFYTmN7gE42p0Fg+E1lGSRnBwcA8XKEWQStcZ1
	 RSIUSEoMMaCEnsuPBh1+ZefOmgOQVcue0LdYxuraUefv2rUEe0JW7OFznsGlq0uzigjW3
	 43+HtXxSsCC1grl9xsJo3jlTW5+t4cbMjschAFAnukClSuDvwfGBcF6aCcTX/OPqrnMhZ
	 ocRpncL6zjHQW5pKOxAJo9R67n5hlxqm801YIQGdznbLsbCLxlS5o/4dmlLU2H8Jo8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l4rOQbM2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886086083621;
	Tue,  3 Nov 2026 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l4rOQbM2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E72C1F000C1;
	Tue,  3 Nov 2026 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723961;
	bh=fE5v4ca1Aufck5/eL12cyLA8FcbOpfZPaD75Cvy3E00=;
	h=From:To:Cc:Subject:Date;
	b=l4rOQbM2wW+LLPY1yUcUj6FenR+4lJF8foqE1Q3zADJxNCXVyi0Tq5CpRIh+sRhfj
	 elM3tKwEncQRmpCFKatjsz9FXNZ6cbFPIhFnPeIoPMQuFFt/n3+zaQ/UCwKF20Odxx
	 Uvu+DpYv2LGThG8SqR8OZG8nynvkJS+kMB4Ui/db98ca7o8Us5NVeffOeu00QSbgR5
	 SMddDtEhGeQ9qeStps8Crh9+ktrfcdqlXnmF9eCbxmCamiwq38/jFyhjxEwUCpeIwt
	 49br4Wy4LEXUnxrvQx63yauDEqwCZD5PFqYA+9iSMyZwhfQcnCXfpKvbhYv18jbD1M
	 uRnenNWGr9EKw==
From: Sasha Levin <sashal@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/cgroup: test_zswap: use the total RAM in bytes
Date: Tue,  3 Nov 2026 11:39:19 -0500
Message-ID: <20261103163919.641249-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
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

test_no_kmem_bypass() uses the totalram field of struct sysinfo as a
byte count, but it is in units of mem_unit, which can be larger than 1
on 32-bit architectures. There totalram also can't exceed GB(4), so the
size check never triggers:

  test_zswap.c:609:24: warning: result of comparison of constant 4294967296 with expression of type '__kernel_ulong_t' (aka 'unsigned long') is always false [-Wtautological-constant-out-of-range-compare]

Multiply totalram by mem_unit as an unsigned long long and use that for
the check and the values derived from it. Nothing changes on 64-bit,
where mem_unit is 1.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Found with 32-bit builds of the selftests (gcc 16 and clang 21 with
-m32, with and without -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
KernelCI's 32-bit arm builds show the same warnings. The changed files
build without them now, and the x86_64 builds don't change.

 tools/testing/selftests/cgroup/test_zswap.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index d50acc1b83ac8..223e2eb1329ab 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -597,6 +597,7 @@ static int test_no_kmem_bypass(const char *root)
 	size_t trigger_allocation_size;
 	int wait_child_iteration = 0;
 	long stored_pages_threshold;
+	unsigned long long totalram;
 	struct sysinfo sys_info;
 	int ret = KSFT_FAIL;
 	int child_status;
@@ -606,10 +607,11 @@ static int test_no_kmem_bypass(const char *root)
 	/* Read sys info and compute test values accordingly */
 	if (sysinfo(&sys_info) != 0)
 		return KSFT_FAIL;
-	if (sys_info.totalram > GB(4)) {
+	totalram = (unsigned long long)sys_info.totalram * sys_info.mem_unit;
+	if (totalram > GB(4)) {
 		ksft_print_msg(
-			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
-			(double)sys_info.totalram / GB(1));
+			"requires less than 4GB total ram, total ram: %.1fGB\n",
+			(double)totalram / GB(1));
 		return KSFT_SKIP;
 	}
 	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
@@ -622,12 +624,12 @@ static int test_no_kmem_bypass(const char *root)
 		return KSFT_FAIL;
 	if (read_min_free_kb(&min_free_kb_original))
 		return KSFT_FAIL;
-	min_free_kb_high = sys_info.totalram / 2000;
-	min_free_kb_low = sys_info.totalram / 500000;
-	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
-		sys_info.totalram * 5 / 100;
-	stored_pages_threshold = sys_info.totalram / 5 / page_size;
-	trigger_allocation_size = sys_info.totalram / 20;
+	min_free_kb_high = totalram / 2000;
+	min_free_kb_low = totalram / 500000;
+	values->target_alloc_bytes = (totalram - min_free_kb_high * 1000) +
+		totalram * 5 / 100;
+	stored_pages_threshold = totalram / 5 / page_size;
+	trigger_allocation_size = totalram / 20;
 
 	/* Set up test memcg */
 	test_group = cg_name(root, "kmem_bypass_test");
-- 
2.53.0

