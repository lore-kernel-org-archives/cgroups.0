Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83841378D8A
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787911030; cv=none; b=C+7YtrvAsjserZ3n4VES17RalMoeJBUp5q6b44F4LNod3rJPikbsDcZe6lrQLtuTfdrQOsebXjSKyOWfSa/UglPzP953Dg8Asxb4eLyZVUBwr8ANmh414oPtoMAGMf1KUWLB46PtSqy66r2ZS6n9X8dddNiGJo55K6GYXMZMFYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787911030; c=relaxed/simple;
	bh=ni9ymu1bo/+HVfz4tuMZ5Mef8jLcWqHZ49PPQPF2/B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtufXGpd3itkryLK7ID7Csssz0hlgxelowQXFPAnCBqTwI/iVo4dtQEMxaZ4SKVUyt8fWXWgZwjr9CL3fMFNIXausz8uGBpTH/voQc+lGCv8UokQnpv0me3ifpye4o3oKDfuWlGnpqZ7hDoCDUskuOV0FCU1d6oYE0PNuAvtTPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B0lFen04; arc=none smtp.client-ip=91.218.175.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B0lFen04"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ni9ymu1bo/+HVfz4tuMZ5Mef8jLcWqHZ49PPQPF2/B4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787911025; v=1; x=1788515825;
 b=B0lFen04UbW1tpr/myxjJXKBtCRQWCixCCqdO2MrOXRgv7V1zA2Z+9bwYP4H311u/6sIzBFS
 iIRMif47uM7xcG2VEyMpj4hunmLlCAm4sN7ZEPefDoPWWsWWiOLnP7Lin5DlAgUOGT/C+0jDZ21
 QCJQU5IVg+qFFAgfFKYB5/hw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6645ef0daf58a982;
	Fri, 28 Aug 2026 09:57:05 +0000
X-Mizu-Trace-ID: 6645ef0daf58a982
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
Subject: [PATCH v2 2/6] selftests/cgroup: Add tests for type-change isolation accounting
Date: Fri, 28 Aug 2026 17:56:39 +0800
Message-ID: <20260828095643.13395-3-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828095643.13395-1-guopeng.zhang@linux.dev>
References: <20260828095643.13395-1-guopeng.zhang@linux.dev>
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

