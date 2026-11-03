Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793721299;
	b=dD/4sCg8lgv2EP6DvQ/B+aU6EkQN1feCZxXv3HxSY6LFVD5Lttb932kDEwnmmIaXzm8O
	 6SSWD46OfeAe/1cHHUcrIM+blNz2l7dM9zunyp+jgzR3AzfFqE4ReFAk98J3qZQ+Y66wD
	 o0WjlM1/t1oCHn6UPRsGL4zn+WHxhoaJSVML9Ar4iXkaBM5CNZ/UFvgJ6cCFEtEt/wTuP
	 SH2nmn36kn00RLLRTif21Fa/Y2SKmpn3KgAiWtSdJHPDeE6dxgFch7eS1xVIe2KyCPm6c
	 JTJefeIL2BsAvdyExzCf+uiiPVMsebfGPIEuW3oJg0bddeKFhZPjWQuAOD4iWKnskNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793721299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O/jUknsydqahcxESJ7eAS0pyf88Dhlfftx821T6uSIU=;
	b=CDamAV2aL03W9zkW/p7mVmD4LKrSAHGkFTuyyT/gwXW3kFSa76XtdbUJbh7HmEMbFCWn
	 kubFm5xQe4abRV7azhXBDRty0RcM/VUHLRcuA9ZF54HLo2HllhyEr6xSNHWkm/WUDwql6
	 9DQrUruh3e6d0K0auqExbxbTPB81YSV6dj5CSZSf62ropR/ISy6GDFZ1U8cFbeeNYbt99
	 GzJTXNnJcXY3VFEBRk/z07sjFfM9ZHnT9OPBBrfWfwhgWWTas3PyQUb4u+KQ6spY2e7Ju
	 uJbw8CCLbDlEhbasuWgGV2vsmSvmwWuGDFxcH8T+ShEMTs0MNK14Y96YKl/NxnIj/FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LhJtAzid;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20633606A33B;
	Tue,  3 Nov 2026 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LhJtAzid
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E061F00A1B;
	Tue,  3 Nov 2026 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793721298;
	bh=O/jUknsydqahcxESJ7eAS0pyf88Dhlfftx821T6uSIU=;
	h=From:To:Cc:Subject:Date;
	b=LhJtAzido5Pe5ihl8fxiEg46QKwuK908HCgwtjhnQbkDmIasZz64TkoKMXKOZc7Vn
	 MVAK++JAzdBxFurU4SuzXMoPjb9T+tnjcwydP4JYn8gbc69NPI1RdCuf7r/ZWs0uHz
	 XgsX9OZ31Z9J8E4ALLsUXmWaMIrkTBw63xoiL3gA4PveJp8SP/JSsJF7uQEqzXVQfb
	 5UbMarVD9TOZumQt1rzIjkXEIRQYEjGf9mhjRddlNz2LB6wR1eOkek+74kdrmQ6m6d
	 mftcY3B6zoyRkEQQzZ8WV5wcEmkIhUlzrCAC54SoU1wuHtc7Lfdti+mr8bAEIGhTYi
	 EY9wt+vkIKuzQ==
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
Subject: [PATCH] selftests/cgroup: read and write size_t with %zu in test_zswap
Date: Tue,  3 Nov 2026 10:54:56 -0500
Message-ID: <20261103155456.534684-1-sashal@kernel.org>
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

On 32-bit architectures size_t is an unsigned int, and reading and
writing it with %ld warns:

  test_zswap.c:34:29: warning: format '%ld' expects argument of type 'long int *', but argument 3 has type 'size_t *' {aka 'unsigned int *'} [-Wformat=]

Use %zu.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Found with a 32-bit build of the selftests with a 64-bit time_t (gcc 16
and clang 21 with -m32 -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
KernelCI's 32-bit arm builds show the same warnings. The changed files
build without format warnings there now, and the x86_64 builds don't
change. The other selftests get the same kind of fix in separate
patches.

 tools/testing/selftests/cgroup/test_zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index d50acc1b83ac8..9b5769b417410 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -31,7 +31,7 @@ static int read_int(const char *path, size_t *value)
 	file = fopen(path, "r");
 	if (!file)
 		return -1;
-	if (fscanf(file, "%ld", value) != 1)
+	if (fscanf(file, "%zu", value) != 1)
 		ret = -1;
 	fclose(file);
 	return ret;
@@ -45,7 +45,7 @@ static int set_min_free_kb(size_t value)
 	file = fopen("/proc/sys/vm/min_free_kbytes", "w");
 	if (!file)
 		return -1;
-	ret = fprintf(file, "%ld\n", value);
+	ret = fprintf(file, "%zu\n", value);
 	fclose(file);
 	return ret;
 }
-- 
2.53.0

