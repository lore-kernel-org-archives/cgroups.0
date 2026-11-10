Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794287037;
	b=MOPAqqHHGDooGMdeSxUNyawvfdd58cDlnBTAYpe7/A3zWKuSwduc2+lnGN1oGdxXkw3B
	 QAnLlZWtFZ9VBllQ3rjdqBecPWxqgLC/0z7MPYqEIdueI3ZnMAq2wncyMTP+Qwcd9CJQv
	 T3Ot92x7WzqvnAYqLxoerWDWWI4cwhosYi0RCc0m4sKnBIvMCd38zplqFHi0MD5OiX9Dl
	 Fng+LfXXDGeSbhPB0azMBGS5LVOBUt5EQOJLUAlwqrP650aU2CfOgqyMYSoAsiNtRHmiu
	 Q4MguRxS/2LR7Nt/4zat68+PZNWQLj3soZlenVjmWnvK1R5Zd6TIgNC0JyfBle4s4bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794287037;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oUe6Z2QxUFhit9Mfj0prUFMy4Y7QS/EGFDc3X/JxRXA=;
	b=SSXpyG3j48FaXWBuS/XiYj0vhB7JRBdv3H674JrZOh7AIvnPfRjaQ4fqDN29aOI3FZnD
	 IEmLRg2aSdXbAgfSvdjVL9ygByVpEeYfVYLeLqQzqT5fEd6ynghENjzwZhARtgIufng0C
	 ji5V9bIDtfc7l6QNtDFA3GrQtQgPydkBgsBrBH3AmJnPvKAH8+CNEK9BOcqCaCNHQBX1e
	 vCgF7PXNUGKe71/QHlsBMurAFxjl87pMCPcU/wITiW2n/pCx4kgTebQtFazGQuW77QR75
	 n2JPkyB1YDKSbOdB08/mp7D23Y0LH/h3WTKuozt5BP0KsisJP8PlEIKM4hjsCr/9Rdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pHvbJb1s;
	arc=none smtp.remote-ip=91.218.175.19
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEC7606B882
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 05:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFEC7606B882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pHvbJb1s
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3qDD6A35Divb+Nd9iQVZidv1S/fAwJC/J17yFOAav9E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794287034; v=1; x=1794891834;
 b=pHvbJb1sygW8bev4nMyE9Z0/DmFKRSGwdBzdNVBtqyMbhr6h36u8HDLfulh3SsFk1u6GyPiU
 rzzCqzifzGklYdpEEtGCkCNpvu6eDOe0mGC5Zj99G9HftZHRp5x8hscmeZ8ls9lrJFAmIzpFDIO
 UcVCaNyLTX/c3jTEPhfvx0J0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 49d56a5017530fe3;
	Tue, 10 Nov 2026 05:03:54 +0000
X-Mizu-Trace-ID: 49d56a5017530fe3
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v3 2/3] cgroup/cpuset: Allow top-level partition CPU replacement
Date: Tue, 10 Nov 2026 13:03:23 +0800
Message-ID: <20261110050324.173461-3-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110050324.173461-1-guopeng.zhang@linux.dev>
References: <20261110050324.173461-1-guopeng.zhang@linux.dev>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

When replacing a partition's CPUs, tasks_nocpu_error() checks whether
the parent's current effective_cpus is a subset of the new exclusive
CPU mask. The parent mask does not yet include CPUs being returned by
the update, so this can invalidate an otherwise valid partition.

For example, on an 8-CPU system without boot isolation:

  echo 2-7 > A/cpuset.cpus
  echo isolated > A/cpuset.cpus.partition
  echo 0-4 > A/cpuset.cpus
  cat A/cpuset.cpus.partition
  isolated invalid (Parent unable to distribute cpu downstream)

The update should return CPUs 5-7 to the parent and leave A as a
valid isolated partition.

Skip this subset check for top_cpuset. top_cpuset_sd_nocpu() already
accounts for returned CPUs and ensures that an active boot domain
housekeeping CPU remains.

Add a regression test for this case.

Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c                            | 4 +++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c405719ccd12..8b6831983803 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1232,8 +1232,10 @@ static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
 
 	/*
 	 * A populated partition (cs or parent) can't have empty effective_cpus
+	 * The top_cpuset check above also accounts for CPUs being returned.
 	 */
-	return (cpumask_subset(parent->effective_cpus, xcpus) &&
+	return (parent != &top_cpuset &&
+		cpumask_subset(parent->effective_cpus, xcpus) &&
 		partition_is_populated(parent, cs)) ||
 	       (!cpumask_intersects(xcpus, cpu_active_mask) &&
 		partition_is_populated(cs, NULL));
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 0288af1c2eb3..ee4d57b7e35b 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -554,6 +554,9 @@ TEST_MATRIX=(
 	" C2-6:X2-5:P1 CX3-6:P2 \
 	                    .      .   T:X4-6    .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
 
+	# A CPU replacement must account for CPUs returned to the top cpuset.
+	" C2-${CPULIST#0-}:P2 . . . C0-4 . . . 0 A1:0-4 A1:P2 0-4"
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
-- 
2.43.0

