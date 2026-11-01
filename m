Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533361;
	b=DsUCmyxkrqp8CrxiiqDHaTz7RzwROntPTbnuNOIY3ww2PR9Y5hQC3bFcmcokUrsQ2FWG
	 uvxvWJKwIx2no1lwJNZmmIV9N5EP55GjFr3j6qeWvTCS8djC5Zzn4vv67yXW/7vc5lPOb
	 SMq+CB5d3En7uKV0IYJY9/rLc5jAzeoW3qvfYP3o4lcIA6hZbf2cG+r0XHytrnvs2JNEA
	 GX+sEGL/Z59kzkCrcxx5z4XNm+yxFpf7bcekjnit+0okdL1oQ0k+F+MEdNCSWCx1EufNT
	 Uj5ZaeNaaksHL0BcpRAhUCx5aKMr2b9Ms7sd/HwoKG0uvXlvGCHb0CZQcafwVFW29bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533361;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UHpXoPugAqHx4I5ouKjWjsQS5zcx6izGx0KtiwpJ9OY=;
	b=Dow8RRo+1HY0kf8y/cVvX1viTjKtYmXhpzTFvQrs6G500s3oxIhJQjwiasavnJXwLwPD
	 gp0rjDEne8o3AuGa91duNo+MWpKr3EbDx1PcgoCpEJQOLPef25MUBDyJrCMmAQqlXlNNF
	 b24mot4Xh60rRbxWkOJNmVGzM5jYLP9CUmkPeNoljbF6/TS+NQE3yhLsVwgcEWguFAjXS
	 3Ueid1kYqjed64J6Kv8Pa0UjIB5sR3PO+QVpnLSMJt+twh7ek1sfKT05qXeqZluuLruvt
	 HBI7bT2/8+Kvf9qMfbmbtZsgPOgI0i3J8QATFGd5bWSRIfvzoAlh2s3Y+XClOtPe3ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gbUW66aK;
	arc=none smtp.remote-ip=95.215.58.113
Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDD8606A325
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBDD8606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gbUW66aK
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=k0nX/8o+pq4RV2o6BwBi9o4kCopShjx8ODswENEcNdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533357; v=1; x=1794138157;
 b=gbUW66aKUTC+M9u3y0zzJIahc/zkBQ6RJPGsHNbu8Dxpss2jW85sh0VBALsNC6hCBXCgrNxI
 1xDIe2p0EY1gIxfc7Gz2evFvo8g7DD2Fc7UshXL/4QaspVHkiIf3XgCvNOtj1m8sMDKP241iQQ5
 mk25/ELdEagOcNLwHrYg2lDg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 292892e7b76a2c6a;
	Sun, 01 Nov 2026 11:42:37 +0000
X-Mizu-Trace-ID: 292892e7b76a2c6a
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Michal Koutn?" <mkoutny@suse.com>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ridong <chenridong@huawei.com>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH -v4 01/22] cpuset: add early empty cpumask check in partition_xcpus_add/del
Date: Sun,  1 Nov 2026 19:41:45 +0800
Message-Id: <20261101114206.2434398-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261101114206.2434398-1-ridong.chen@linux.dev>
References: <20261101114206.2434398-1-ridong.chen@linux.dev>
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

From: Chen Ridong <chenridong@huawei.com>

Add a check for an empty cpumask at the start of partition_xcpus_add()
and partition_xcpus_del(). This allows the functions to return early,
avoiding unnecessary computation when there is no work to be done. With
these changes, partition_xcpus_add() and partition_xcpus_del() can be
called even if xcpus is empty. The caller no longer needs to check whether
xcpus is empty, eliminating many conditional statements.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..72e1df1295e1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1315,10 +1315,13 @@ static void partition_xcpus_add(int new_prs, struct cpuset *parent,
 {
 	WARN_ON_ONCE(new_prs < 0);
 	lockdep_assert_held(&callback_lock);
+
+	if (cpumask_empty(xcpus))
+		return;
+
 	if (!parent)
 		parent = &top_cpuset;
 
-
 	if (parent == &top_cpuset)
 		cpumask_or(subpartitions_cpus, subpartitions_cpus, xcpus);
 
@@ -1342,6 +1345,10 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
 {
 	WARN_ON_ONCE(old_prs < 0);
 	lockdep_assert_held(&callback_lock);
+
+	if (cpumask_empty(xcpus))
+		return;
+
 	if (!parent)
 		parent = &top_cpuset;
 
-- 
2.34.1

