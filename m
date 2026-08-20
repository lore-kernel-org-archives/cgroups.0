Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6E3445AFA
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229807; cv=none; b=uFlaun9Wi74ec4znaMDEjg8TDg6JWBmkW02SmjOUBRpoRG+dv2r72J/lEFei7X/iAq5/Ah6nuDaf2x5N9KhFex04aCCd9e1w1lq2OKZF2I7Bp14AKT14kwMHcykWlrbS/H0mmE9SBbkDeis1XFn+pZjryAMO1xRYdltsaNYkgcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229807; c=relaxed/simple;
	bh=pu6refSfYxSkJMyw2ARvUY6sO8y8LnRIQ3GF4cCNz14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpZxED/GDHeQh/uHt4k/jt15aqtVSYUR1OWb63GDLUO3a0SuSoT9szsg5rXXVz4XNftSopKkxDOdnqj2zW63hgMAQsGrMXDKyuD8pDSlHJ4proFCxInbljJJXW/TBFprDuk9+y5BB+2J2MtRS3aRWdJd35RMwHcIdJwpooQzs2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QAcNK528; arc=none smtp.client-ip=91.218.175.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QAcNK528"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pu6refSfYxSkJMyw2ARvUY6sO8y8LnRIQ3GF4cCNz14=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229803; v=1; x=1787834603;
 b=QAcNK528VxlQcDkKhlyMaXonG28/2aXERseGGAMS+gdYAWIrbTxqRN4D66fjbA969fp1b1OC
 CoEWEZRP+XotnBgHe0Gl5pe5EdJq6N1PsMe+nvbvIyzejt2tbafWvmUVocaXbOdhbC8TaSqArOG
 D1O/p/9sSNC4viUd7U7thgpY=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id f9c3cf2986d85fb6;
	Thu, 20 Aug 2026 12:43:23 +0000
X-Mizu-Trace-ID: f9c3cf2986d85fb6
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 15/17] selftests/cgroup: Test shrinking cpuset.cpus in a remote partition
Date: Thu, 20 Aug 2026 20:42:00 +0800
Message-ID: <20260820124202.517160-16-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820124202.517160-1-guopeng.zhang@linux.dev>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Cover remote partition shrink with and without a local isolated child.
Check that removed CPUs return to the top cpuset and that child
invalidation preserves isolated CPU accounting.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 7345e89e22b7..ad01016ddc8d 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -520,6 +520,15 @@ REMOTE_TEST_MATRIX=(
 	"  C1-4:P1   .   C1-2:P1  C2-4:P2  .       .  \
 	      .      .     .       C1-2    .       .     p1:3-4|c11:1-2|c12:3-4 \
 							 p1:P1|c11:P1|c12:P-2"
+	# Shrinking a remote partition must return removed CPUs to the top
+	# partition even when it has no child partitions.
+	"  C1-4:P1   .      .       .       .       .  \
+	    C1-3     .      .       .       .       .     p1:1-3 p1:P1 ."
+	# A local child invalidated by a remote parent's CPU change must return
+	# isolated accounting to the remote parent or the top partition.
+	"  C1-4:P1   .   C3-4:P2   .       .       .  \
+	    C1-3     .     .       .       .       .     p1:1-3|c11:3 \
+							 p1:P1|c11:P-2 ."
 	# Cpusets with empty cpuset.cpus should inherit parent's effective_cpus
 	"  C1-4:P1 C5-6   C1-2     .       C5      .  \
 	      .      P1    P1      .       .       .     p1:3-4|p2:5-6|c11:1-2|c12:3-4|c21:5|c22:5-6 \
-- 
2.43.0

