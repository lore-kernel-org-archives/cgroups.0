Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7BF44063B
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 10:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788344809; cv=none; b=EEaR5VIjfFUcw236NlyFry0GOgIV3maF5yWMt9xOHmburJMn1WzPdC4kYupvVl6Il6rU8obqo/OUo5+wndiK2VvHFuUBt8Xh64kY4KO/fjRNBShlAAmfhbcqBDRBPW/nEU1X2Gmy35J9b0wUKfKflhSUCq90qLsWAGU1hHe5cEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788344809; c=relaxed/simple;
	bh=ni9ymu1bo/+HVfz4tuMZ5Mef8jLcWqHZ49PPQPF2/B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTkNcpTwilAGoUpvEex1N8KaiBuRHde6fuFItwSiBEdaEXMq1y0IiWACMNJ+ETd4kO+a+hHV5fFTqVR2jP1TeMT1k6aDNBifAPci6i9vjrWmYDo9Qvn8tKeqLlhcHk8fuuSOVevBbljK1aL7sPuS7aI7QvsQuuyOGVBS/OrolaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xvmKZEj2; arc=none smtp.client-ip=95.215.58.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xvmKZEj2"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ni9ymu1bo/+HVfz4tuMZ5Mef8jLcWqHZ49PPQPF2/B4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788344805; v=1; x=1788949605;
 b=xvmKZEj2IbgdY8wIzGU2pmVFftv4rYLtP+PYQWFZ4D2LS7Vg26fmHXGSBTNyPQF+XFwoLNX4
 E0DCeyqCU4V+3p3DI4k1Syhwub5EHW7RprU7YslqJ76WeY5fOEP/dTIQDF5ZOogcqaSS+5ay115
 I3fw271G+czuBlP6WAetjl3M=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fb81639c0672beb6;
	Wed, 02 Sep 2026 10:26:45 +0000
X-Mizu-Trace-ID: fb81639c0672beb6
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: cgroups@vger.kernel.org,
	longman@redhat.com,
	ridong.chen@linux.dev
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v3 3/7] selftests/cgroup: Add tests for type-change isolation accounting
Date: Wed,  2 Sep 2026 18:26:11 +0800
Message-ID: <20260902102615.79189-4-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902102615.79189-1-guopeng.zhang@linux.dev>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Add two matrix cases for parent type changes with valid child partitions.
Cover root-to-isolated while the child remains root, and isolated-to-root
while the child remains isolated. Check that only CPUs owned directly by
the parent change isolation state.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 131d8b4551ef..9a1cce4807b4 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -224,6 +224,8 @@ TEST_MATRIX=(
 	"   C0-1     .      .   C2-3:P1   .      .      .     C2     0 "
 	"   C0-1     .      .   C2-3:P1   .      .      .    C4-5    0 B1:4-5"
 	"  C0-3:P1 C2-3:P1  .      .      .      .      .      .     0 A1:0-1|A2:2-3|XA2:2-3"
+	"  C0-3:P1 C2-3:P1  .      .     P2      .      .      .     0 A1:0-1|A2:2-3 A1:P2|A2:P1 0-1"
+	"  C0-3:P2 C2-3:P2  .      .     P1      .      .      .     0 A1:0-1|A2:2-3 A1:P1|A2:P2 2-3"
 	"  C0-3:P1 C2-3:P1  .      .     C1-3    .      .      .     0 A1:1|A2:2-3|XA2:2-3"
 	"  C2-3:P1  C3:P1   .      .     C3      .      .      .     0 A1:|A2:3|XA2:3 A1:P1|A2:P1"
 	"  C2-3:P1  C3:P1   .      .     C3      P0     .      .     0 A1:3|A2:3 A1:P1|A2:P0"
-- 
2.43.0

