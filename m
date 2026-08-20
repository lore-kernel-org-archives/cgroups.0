Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AFB445AD1
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229789; cv=none; b=ghLBPy83m1tJX75T43hAs/SMV4CM5qm5WII4ezAYulbUy/UZReb0wOxY1D5wf0u+2hV4ZXsJuPCBho8fYj/5vj615L45atwFStDPbc224laIhjbo06l1jTMjdi7KPq3A2jH/Quy0Mt/AFBshxQr3z73oJU23HQt1wpTwmTF/jXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229789; c=relaxed/simple;
	bh=POg3Yxmb/KxT6reCXyqQSfUcrWvjnynhAKq3TgWmEdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohZbEKYHiBCw9KRLie2mD54L0jEY3NdEzOO/ZLtsiE9kUApbiHot/8VRpGvlKl8GRCJFf0xIfGiB8/p2kU/IzIAY9/xyVc6dqIYFZTYPYAQHnvJXDUN6Cwv9+3RAIDKICsNR3tEz2fOy93zxtmgoNQDWZM2/Z0qr6Y18hBCZnqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xQu7jj2W; arc=none smtp.client-ip=95.215.58.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xQu7jj2W"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=POg3Yxmb/KxT6reCXyqQSfUcrWvjnynhAKq3TgWmEdE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229786; v=1; x=1787834586;
 b=xQu7jj2WAztPP9glmaZ4DsWmPGeQH49Mejek56fvnoTUQH5HbQ9DAGoM/jEH7zSsNHaseYOJ
 3owUxgbDDfXXm6+7jTcLxIxTTa2/A0wgLBMMH4awp+DxdR1qgZEmiSIOxRf2mTevRlFofXkFbR1
 fKuaTCePEUbf1Nzn83IwGdSo=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id a5daa1af638953d0;
	Thu, 20 Aug 2026 12:43:06 +0000
X-Mizu-Trace-ID: a5daa1af638953d0
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
Subject: [PATCH 11/17] selftests/cgroup: Test isolation accounting on direct child invalidation
Date: Thu, 20 Aug 2026 20:41:56 +0800
Message-ID: <20260820124202.517160-12-guopeng.zhang@linux.dev>
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

Offline all but one CPU in a root child below an isolated parent. Check
the invalid child state, the effective CPU masks and isolated accounting
for the released offline CPUs.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 35c19738aaa4..fb11a3ab0f35 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -330,6 +330,11 @@ TEST_MATRIX=(
 				   .      .     X4      .      .     0 A1:1-3|A2:1-3|A3:2-3|XA2:|XA3: A1:P2|A2:P-2|A3:P-2 1-3"
 	" C0-3:X1-3:P2 C1-3:X2-3:P2 C2-3:X3:P2 \
 				   .      .    C4:X     .      .     0 A1:1-3|A2:1-3|A3:2-3|XA2:|XA3: A1:P2|A2:P-2|A3:P-2 1-3"
+
+	# Direct invalidation returns child CPUs to the parent or its owner
+	" C1-4:P2  C3-4:P1  .      . T:O1=0:O2=0:O4=0 . .      . \
+					   0 A1:3|A2:3 A1:P2|A2:P-1 1-4"
+
 	# Local partition CPU change tests
 	" C0-5:P2  C4-5:P1  .      .      .    C3-5     .      .     0 A1:0-2|A2:3-5 A1:P2|A2:P1 0-2"
 	" C0-5:P2  C4-5:P1  .      .    C1-5     .      .      .     0 A1:1-3|A2:4-5 A1:P2|A2:P1 1-3"
-- 
2.43.0

