Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9638F446073
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.126
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229815; cv=none; b=b+3ouvGUVH54pQXYJyDx2xgkr584jGxk5I5+cA122W0ErLNpkXsn4eC286iynbzgXtKdtEejANpKBvEvC9XdDymCc7tg/tNwrgrCffwBX9snmG2tzNcq1WHYuF0XW8PwbxK2llzdHMPpKPWCybvvXKc+iPockIxJKHfLMN4pnzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229815; c=relaxed/simple;
	bh=pK2UsGJfwtec3f0LENGJa1zke896ry16GtXsQEokZvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlvGJs3r73KB8KnJ0oMnYVEth5HVk/eVwqJa2UKjj4jWTdGoKRTFaD7qgxP6dwO+OlSs4QoHoYPFyC64Ln6BKMz+egwWJzjn1QJC87H9M9jEfeqXNuFglLA8CnilSltUT8RkMZKbDo6Kl+wl9nLucn5Ntx1wFaPqfrCqRztFEug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iZzX0qaB; arc=none smtp.client-ip=91.218.175.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iZzX0qaB"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pK2UsGJfwtec3f0LENGJa1zke896ry16GtXsQEokZvU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229811; v=1; x=1787834611;
 b=iZzX0qaBEnwZb2E2tvM3ONBH0hN9bFw5oyct097jc6QxCUpYoYRnKpTd6/qbeyymxm0fjD39
 5nxafAxWVdl5Mrd9rCa4MXv5oQEp6uZgXMeiKtawKdtq6WeQHb0xdagWe2QqNMrx6DladeKNgrF
 SfLgIpYNjq2gzE6ELkPWoYfA=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 9ee3676ab93f26ed;
	Thu, 20 Aug 2026 12:43:31 +0000
X-Mizu-Trace-ID: 9ee3676ab93f26ed
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
Subject: [PATCH 17/17] selftests/cgroup: Test isolation accounting on propagated invalidation
Date: Thu, 20 Aug 2026 20:42:02 +0800
Message-ID: <20260820124202.517160-18-guopeng.zhang@linux.dev>
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

State-matrix cases exercise a child invalidated by its parent and a
nested partition invalidated through an already invalid parent.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index ad01016ddc8d..89f54c689336 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -340,6 +340,12 @@ TEST_MATRIX=(
 	" C1-4:P2  C3-4:P1  .      . T:O1=0:O2=0:O4=0 . .      . \
 					   0 A1:3|A2:3 A1:P2|A2:P-1 1-4"
 
+	# Invalidation propagated from a parent returns all descendant CPUs
+	" C0-3:P1  C2-3:P2  .      .      P0      .      .      . \
+					   0 A1:0-3|A2:2-3 A1:P0|A2:P-2 ."
+	" C0-5:P2  C2-5:P2 C4-5:P1 .      .       P0     .      . \
+					   0 A1:0-5|A2:2-5|A3:4-5 A1:P2|A2:P0|A3:P-1 0-5"
+
 	# Local partition CPU change tests
 	" C0-5:P2  C4-5:P1  .      .      .    C3-5     .      .     0 A1:0-2|A2:3-5 A1:P2|A2:P1 0-2"
 	" C0-5:P2  C4-5:P1  .      .    C1-5     .      .      .     0 A1:1-3|A2:4-5 A1:P2|A2:P1 1-3"
-- 
2.43.0

