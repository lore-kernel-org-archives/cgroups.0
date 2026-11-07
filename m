Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794052897;
	b=dfUpzefUSzLlht0tSXIsul9a179BxtvEJfb9JUG2oowiwTXVo0h5mS7bR7Enx7YnFdCq
	 DfLi2tYToVuT+ECup3BemSyBUkCGnfPB2KpnUeIXwvIGWcPqOjQp2FyWHt9Qe1Kl2TtTy
	 3fY2pg11htIgHTtv2F/J4sf0SNj6AD/0pvAPUh96ALWXMvLHoA7xVsX4o92nrdI3//WQw
	 OGu1DmbnYk5183u+cjaFYKW7yQOmawMZAuTpvbzzaFEKhV+W2pykNjvbmoiR5EBvYo0Dt
	 lT6L48EvolsAswu99Cycm/NJaUBC1gpvM6FOdt8KYfmQPSdlYSCSfUXRqge9dmSXmNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794052897;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wElNnZ4hdxfiRXy4j7gbm0Wmawl6S57V0Z2kUwgAtHE=;
	b=XCWUHxEPq/koWf2/LA8kf9Z3CUix+JEbUWdbXu+r9i9jxZBw56p3ERd8pVK2Guu4Yjzz
	 gGYsMc9UcD8DJAd7Wc17njMvesGHKSTS24RBfbtz6gRiDsMDWxgfHhHSrewUSwJBOwLVS
	 y/iq0LZ9qEh2yuep0WQJFmPWQ8MwMun2+wumXc9CZC9kJm7J0GK9X78MUKmJo2DrhPqqG
	 oGhrBgG93esNpwTzQz9Y4ylDCBerbajjeKq1shbj6hDqUetwcQArPBqPP/w32cx71J8GL
	 YImQHJI1RyxsfM3JTjZsb0UVf/fJ8TtBfFe//sKUnOyJO3h7XSqny9DK2NY7QSXabCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qN7RNtVN;
	arc=none smtp.remote-ip=91.218.175.119
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE24606A326
	for <cgroups@vger.kernel.org>; Sat,  7 Nov 2026 12:01:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FE24606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qN7RNtVN
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=t6znqfsrDtxXSf05RcmdumzvabWUDmUMM6r+znXO2jw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794052894; v=1; x=1794657694;
 b=qN7RNtVNfFAGGNNtW6wp+M6EkYK9oUZ2dFzOuG7Tbg3TbvuFgiTChIpH9OwELixoh8lPmOJO
 OkdOATVGlof2yFJWJD4JLWwle45iOFE7equyl56qe2LryWaLD+5wvpTc0jG3mDwoHHSDfT4cfFi
 rCQ0z+2uxVT91Z4vuAXCI3Gc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 206b7a00877809c6;
	Sat, 07 Nov 2026 12:01:34 +0000
X-Mizu-Trace-ID: 206b7a00877809c6
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Chen Ridong <chenridong@huawei.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 2/4] cpuset: add early empty cpumask check in partition_xcpus_add/del
Date: Sat,  7 Nov 2026 20:00:58 +0800
Message-Id: <20261107120100.3587595-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107120100.3587595-1-ridong.chen@linux.dev>
References: <20261107120100.3587595-1-ridong.chen@linux.dev>
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
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index cf38e8708ddd..85e5b529d144 100644
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

