Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C619443E3A
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229764; cv=none; b=taIcpbq0IHYKlknlky68POmtcmBYHhjhtVRwPxpOo0aENffQ06u3gIkDpP0g4xv8RIqa2GzLb/v4lZFXxvojIa9+PEX0cmB1XiMXjFA3BwdJFP+oiCJkvx8u0+7xWgfH9WKsd8DnOIIrlJQuiWE3KHS3Znt4VlyuY6zh2WCqC/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229764; c=relaxed/simple;
	bh=H6Kjnog+dQT7tN4C/3rC+dGe+xz2UZJm2VHn1zFbXB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkSCuzbUvTBQnItSPizq9opI/cmx+kqvwURhZhFn+FEkD+Iqi4/644Inz3UsYg36gmeg8UskLtJ7dbALA2z1P0oSFCNM5FNmnxUMRu5DklQHNWqH8pcbPRAfvNI0HhIv6L4Ji4FstmHe76HaBDcAHRCpxPnYvdtLWDuzza6VePg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O2ohWaeN; arc=none smtp.client-ip=95.215.58.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O2ohWaeN"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=H6Kjnog+dQT7tN4C/3rC+dGe+xz2UZJm2VHn1zFbXB4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229759; v=1; x=1787834559;
 b=O2ohWaeNEOCr1kGLYHQFXDRPjw9DiWgibmb1cp805Ngqxkuz9hD7jlUs5iMEA/zo8Xy/Je7/
 GrRrI8tfPAG8Tabm4OqMxVTqUdzvJEYv6JFYIA6NQus1EnI+qNE3NQ1ZgN9NCuEcMf12ZFiohJR
 TiTpM1x3bWp99+bYTYIhspFM=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 2f77a85c6204a7d8;
	Thu, 20 Aug 2026 12:42:39 +0000
X-Mizu-Trace-ID: 2f77a85c6204a7d8
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
Subject: [PATCH 05/17] selftests/cgroup: Test isolated CPU accounting on type changes
Date: Thu, 20 Aug 2026 20:41:50 +0800
Message-ID: <20260820124202.517160-6-guopeng.zhang@linux.dev>
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

Switch a parent between root and isolated while a child has the opposite
type. Check that CPUs owned by the child keep their isolation state.

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

