Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA54E3B9942
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 07:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787209814; cv=none; b=ErMNAHp/QYLXtV+l7poBszlOnxAWJEBepfnwXCjpkgWPfK8eOjXPrsPKuFTj9F13PEpLeksKBtJMnn1BSgQJDx4hSRU1LG8xZxBOZes04oKZSDIf/D9AJ8EkAkcp/wTN63z74R4RQ57303rrNk1YC1JdVjEg2iXB0rUyCc5qths=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787209814; c=relaxed/simple;
	bh=2+3QA95E2Qu2z4Bb6C3P8E4Hs/HGV5s2I/yaYEntkPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dvDFCU9Akg0LdJNhrKjREzbqRfvlBCaGQ0DbslAQwJINwijWePt2D/TNxzlKEcYyvoKfOELv9E3Hqf9cNBFUmqgsp6RyrI/D9aM0qi3m/cx3689HWmaBCOE9AtbKv1scN5NwWAVtzqSW4M2zjX2xytldf6DtLFhlj5+uI0TOg/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LIQ35nAs; arc=none smtp.client-ip=91.218.175.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LIQ35nAs"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2+3QA95E2Qu2z4Bb6C3P8E4Hs/HGV5s2I/yaYEntkPM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787209808; v=1; x=1787814608;
 b=LIQ35nAsg6QJauv+pYa4RnQF6Ym2wlWvjOYeLoznppA0uVJXFftwqfpwq2+vet7yMx0CffAO
 Op+lFbTnu67gjWChUDwyWQwYJtvBGAM7I3Ni9EMND2ezOF46q8JRztzR4/USjWCEl7flpoiXb7V
 UbKbUNIGqVY4ibbEcbbgYnUo=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id f83ced2c4d3f1100;
	Thu, 20 Aug 2026 07:09:58 +0000
X-Mizu-Trace-ID: f83ced2c4d3f1100
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter
Date: Thu, 20 Aug 2026 15:09:44 +0800
Message-ID: <20260820070944.31451-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongfu Li <lihongfu@kylinos.cn>

cg_run_in_subcgroups() discards its arg and always passes NULL to cg_run(),
turning the (void *)100 from test_kmem_dead_cgroups() into NULL so no
allocation occurs.

This makes test_kmem_dead_cgroups() falsely pass without exercising the
"dying cgroup with charged slab" scenario it intends to test.

Pass the arg through to cg_run() to fix this.

Fixes: 933dc80ec262 ("kselftests: cgroup: add kernel memory accounting tests")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 1db0ba1226b9..98e9f9f45ab9 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -145,7 +145,7 @@ static int cg_run_in_subcgroups(const char *parent,
 			return -1;
 		}
 
-		if (cg_run(child, fn, NULL)) {
+		if (cg_run(child, fn, arg)) {
 			cg_destroy(child);
 			free(child);
 			return -1;
-- 
2.54.0

