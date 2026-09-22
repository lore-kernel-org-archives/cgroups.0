Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E8C42E40F
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 09:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068865; cv=none; b=HqPAKMrxks/JPzNdhwT7vnbwrVFoN+oJ/c7Y6Ix0Ul4kwip/mc16GOSVkijMWW70hgooyXgmYy1bbNeDPrUc5JBNL2syCeBGvHt8mYyOjE8CnMvZM6tVPQ2JAohHwc4B4Ga9RAHfcF2Pk6WsENZ7L3BEBTurtF7074VKf/uah0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068865; c=relaxed/simple;
	bh=pauak53psAXKLYl2w6xPdGBF4uRbBTPOApr/KH0j4F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPUk3Ji/m+KqcCi2Y7dtMuTYSTpBiOnFQ/R+EgmBl2I8Hfh6OcJ5BPLgCmWLOV4DBpv5529xANLvCqvOJIbxMO8VBnZOR5SuUr/2kY/S8M2Ct8wAZyUgSJtI6fs6iG9xM0DB0eaeWrSqGvNLY0lmFkRRVCijj9lIOuZolDR0ibM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RaDRknwA; arc=none smtp.client-ip=95.215.58.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RaDRknwA"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pauak53psAXKLYl2w6xPdGBF4uRbBTPOApr/KH0j4F0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790068861; v=1; x=1790673661;
 b=RaDRknwAR3q1F1nXi0TrgJK9Vah6xNaq69HwgvHOcAx6MxmyWeCwqmgZvwD0hkeWQkahG5MU
 bjqjUfORI23+BJ/IEOTM2g0t1gJuYTf6cxIabozQeJFxFP3uXr9X5NUSSul0epUBdAGieHxGWsR
 IpXkKx7k0rbLiW7rwatlsS78=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 736ce81edee2f5a2;
	Tue, 22 Sep 2026 09:21:00 +0000
X-Mizu-Trace-ID: 736ce81edee2f5a2
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v3 1/2] docs: cgroup-v2: Describe boot-isolated CPUs in cpuset.cpus.isolated
Date: Tue, 22 Sep 2026 17:20:33 +0800
Message-ID: <20260922092034.68840-2-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922092034.68840-1-guopeng.zhang@linux.dev>
References: <20260922092034.68840-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

cpuset.cpus.isolated is documented as empty when no isolated partition
exists. This is not true when CPUs are isolated at boot with
isolcpus=domain. cpuset_init() adds those CPUs to the isolated mask,
and isolcpus=<cpu-list> uses domain isolation by default. They remain
listed after a partition using them is released.

Document the boot-isolated CPUs as well.

Suggested-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 2ec582985b5b..18a01ce4c334 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2626,8 +2626,9 @@ Cpuset Interface Files
 	A read-only and root cgroup only multiple values file.
 
 	This file shows the set of all isolated CPUs used in existing
-	isolated partitions. It will be empty if no isolated partition
-	is created.
+	isolated partitions or isolated at boot time via the "domain"
+	flag of "isolcpus". The latter remain listed even after any
+	partition using them is released.
 
   cpuset.cpus.partition
 	A read-write single value file which exists on non-root
-- 
2.43.0

