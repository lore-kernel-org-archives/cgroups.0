Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796903A1690;
	Mon, 14 Sep 2026 20:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789418211; cv=none; b=oBSEFxnFn6MzxpX9GJ8mcDdEsV1XRLKkEaIR/OMjAhVfV6vy4l7jkiBjlw+NSAWBUKFOmhZ6lx2mFoDyFm3HZB9TBW4CsB9Ed/jMcWi/xdfuSRrhppTE7oqbif82PiS2z+Ib1crLSCnfBNx+PPAFSbc0HmoHtNKhv6VIuVVolZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789418211; c=relaxed/simple;
	bh=/sNxzbddZxqlcZceQW1zIwaoQBVW4vEyJ/85AKT6/0U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=QruXegeqaqMxoY8d3owTxVj4F+Zo/hp0/kGpx1JXmXu4RTE9hKRlb+wRemhzZI7PZFuiHFLk87uBYeClGIYxQ3qudU5Lwsr6c2lkiboT49B8xOE1Rwt+orFoACxZM2RDdKPxd848wji3yWfCsno+eR7H/r+1JIsxs0SW8TmqLAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFUlY8Zx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFUlY8Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B521F000FF;
	Mon, 14 Sep 2026 20:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789418210;
	bh=bcOX7r1Cj9VeZWKm8zDkuf0BISjIkiCvFWWoInxB8sU=;
	h=From:Date:Subject:To:Cc;
	b=EFUlY8Zxcn4IMHCDhXLwi3lLqS8BIc4GDHJBEys/ooFDVHK5zIcC03PPr+MAyT+r+
	 udFBWZMIvzD3eqXcutwtyBDBRvrZB+8Bqf9XyNfqHr1+2o1mATnzDnWIuf1/GiT/H4
	 rnargqIQ7Cnr9tdTSfBmfshE/xxfklIxUx2ODBp47Pb/oma7CNe6byrx6a3F7XqR6F
	 BT9KW0AChvQ21t7etBW5/bd3balwiTVChKV6+qY8Yl9fln6W1PysJ6YrNTSO1LnqP1
	 gRxJOPZhf/qNM+DTKPrA9KGz0Y74qHaabIOoTPArxd4+wFTmfXhXE3kCulfgods8ie
	 C3WavO0elK6zg==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Mon, 14 Sep 2026 21:36:39 +0100
Subject: [PATCH] selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap
 writeback test
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-test-zswap-wb-ignore-eagain-v1-1-6fb715c22cd8@kernel.org>
X-B4-Tracking: v=1; b=H4sIANZaqGoC/yXMwQ6CMAwA0F8hPdtkQyEZv2I8lFFHOQyyDjES/
 p2px3d5OygnYYWu2iHxS1TmWGAvFfiRYmCUoRhqU7fG2Rtm1owf3WjBrUcJcU6MTIEkorGu8de
 WiJyBMiyJn/L+7ffH37r2E/v8LeE4TpUhhdJ/AAAA
X-Change-ID: 20260914-test-zswap-wb-ignore-eagain-0195c36aaa90
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Usama Arif <usamaarif642@gmail.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Harry Yoo (Meta)" <harry@kernel.org>
X-Mailer: b4 0.15.2

The zswap_writeback_enabled test fails when a write to memory.reclaim
returns -EAGAIN, which means less than the requested amount was
reclaimed. attempt_writeback() propagates the -EAGAIN to the caller,
and the test case is marked as failed even when zswap writeback did
happen.

This heavily depends on the performance of the backing swap device.
Reclaim does not wait for writeback (on cgroup v2), does not count pages
that are under writeback as reclaimed, and memory.reclaim gives up after
MAX_RECLAIM_RETRIES passes without making progress. On a slow device
where reclaim does not make any progress before writeback completes,
a write to memory.reclaim fails.

On a VM with zswap enabled, where IO delay was injected via dm-delay,
the success rate of the zswap writeback test drops dramatically once
the delay reaches 11 ms: 7% failures at 10 ms and 79% failures at 11 ms,
n = 100.

When zswap writeback is enabled, ignore -EAGAIN from memory.reclaim and
determine pass/fail based on the zswpwb counter because that is what
zswap_writeback_enabled actually wants to test.

With this change, the test reliably passes even on a slow swap device
(tested up to 1000 ms delay). This makes the test resilient against
the performance of the swap device.

Assisted-by: LLM
Fixes: 158863e5d7cc ("selftests: cgroup: add tests to verify the zswap writeback path")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
- Huge thanks to Joshua Hahn who kindly helped the investigation and
  the discussion of the problem.

- LLM was used to perform experiments with injected IO delay and
  to investigate why memory.reclaim fails (and verified by Harry Yoo).
  Everything else was handcrafted by Harry Yoo.
---
 tools/testing/selftests/cgroup/test_zswap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 1ac779072775..d50acc1b83ac 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -346,7 +346,16 @@ static int attempt_writeback(const char *cgroup, void *arg)
 	 * it can't writeback to swap.
 	 */
 	ret = cg_write_numeric(cgroup, "memory.reclaim", memsize);
-	if (!wb_enabled)
+
+	/*
+	 * When writeback is enabled, memory.reclaim may still fail to reclaim
+	 * the requested amount of memory due to a slow swap device.
+	 * Ignore -EAGAIN here. The caller determines pass/fail based on the
+	 * zswap writeback counter.
+	 */
+	if (wb_enabled && ret == -EAGAIN)
+		ret = 0;
+	else if (!wb_enabled)
 		ret = (ret == -EAGAIN) ? 0 : -1;
 
 out:

---
base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
change-id: 20260914-test-zswap-wb-ignore-eagain-0195c36aaa90

Best regards,
--  
Cheers,
Harry / Hyeonggon

