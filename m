Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4174744605B
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229797; cv=none; b=QFLncj+OheLephreMZkiq7+NFO0Ga1qt8sS1X1s2Zx9QgNvlRAmpxZoi1hSBWfCH/h/jvhJSYqzDgO2y3yejpr97yeh9LpuaLyhXK8ZX8PtY4aX7RBkRCV814+9u+Zfy0zWtI6a6t9wQHTi+OkGKlWp5xfotpB5RN4Okdl1tZkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229797; c=relaxed/simple;
	bh=4Z9moWx34vFyk0X2XPUJ28g4vrAgCQXsNoQyMW+kKNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1N85tIumZw4iDN3AFusEQ+TKIcVdeKjWKGegkTersU3A+whJmCOClY+8TH8ucV50F7JJO7vLFVeCzI63fQ40kw92jl2xflYBT+YFrOoIb74XhCijljEvZAwN3WAjmcUcuBmG85CsZmdgO0aR5pLf2xlHSdK9soGNzvtaF5DCB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tDj1Eu8q; arc=none smtp.client-ip=95.215.58.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tDj1Eu8q"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4Z9moWx34vFyk0X2XPUJ28g4vrAgCQXsNoQyMW+kKNQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229794; v=1; x=1787834594;
 b=tDj1Eu8qYLFLH/K5hi8oD7Lb7UaqCby8NwOqvguVJ5ledEvT6G3hnEEWG0G8UunnupbAjGlU
 V2Ka1dBjLYGKGVWxzVfMwG4ORYd4DuQ3FzQURyQLyHGpl/qdeGNS1aTt/BZLoAcAFCgsKkG1nCC
 Jj+KFNI04MyYG3LaCLe6RapA=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id e1761e5fbda85615;
	Thu, 20 Aug 2026 12:43:14 +0000
X-Mizu-Trace-ID: e1761e5fbda85615
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
Subject: [PATCH 13/17] selftests/cgroup: Test child invalidation after shrinking cpuset.cpus
Date: Thu, 20 Aug 2026 20:41:58 +0800
Message-ID: <20260820124202.517160-14-guopeng.zhang@linux.dev>
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

Shrink a parent CPU mask in root/root, root/isolated and isolated/root
configurations. Check that the child becomes invalid and that effective
and isolated CPU masks reflect the new ownership.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index fb11a3ab0f35..7345e89e22b7 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -331,6 +331,11 @@ TEST_MATRIX=(
 	" C0-3:X1-3:P2 C1-3:X2-3:P2 C2-3:X3:P2 \
 				   .      .    C4:X     .      .     0 A1:1-3|A2:1-3|A3:2-3|XA2:|XA3: A1:P2|A2:P-2|A3:P-2 1-3"
 
+	# A child outside its parent's new CPU mask becomes invalid
+	" C0-3:P1  C2-3:P1  .      .    C0-2     .      .      .     0 A1:0-2|A2:2 A1:P1|A2:P-1"
+	" C0-3:P1  C2-3:P2  .      .    C0-2     .      .      .     0 A1:0-2|A2:2 A1:P1|A2:P-2 ."
+	" C0-3:P2  C2-3:P1  .      .    C0-2     .      .      .     0 A1:0-2|A2:2 A1:P2|A2:P-1 0-2"
+
 	# Direct invalidation returns child CPUs to the parent or its owner
 	" C1-4:P2  C3-4:P1  .      . T:O1=0:O2=0:O4=0 . .      . \
 					   0 A1:3|A2:3 A1:P2|A2:P-1 1-4"
-- 
2.43.0

