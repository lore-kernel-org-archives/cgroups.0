Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883177;
	b=JtHVrWmIHl1AtsRk7m4H2RAg3ThLNiIvHDhc0xGWtlSs8vnCc6RsCTGD79p7hAH9hPpn
	 653/L7dbK//AI/yW0l9oSd16iE+5P/GFA0QHMyxX0pjEPC4LNiG8RHpwa/z0dT5YmGfs7
	 rKG8K9bhXxonIYwxCq88QS87D/858s7BQnzy7xF7qOqvJmRv/tXb7sU/5vcvnnLo/8Ckn
	 duPREwc8MGdiUbW6dk1ZoijClpiJyDrXMeKHv2o5xxgXmy6N/CxSYbi0N4thsqcu52tZB
	 kqbgrV9Xe7udOQ9j7QflczcBGvODIx0lkgljH2dq30kXBoH59Yx12Ev8toIWlGL2agA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883177;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=U7QPnMltm0NUA1TBoFVEGMv8tP5BZSUYF1lBRbJpUqE=;
	b=byVzOQQV5BiCSKwhB06z9Yy7C+W/ya4JIpZ2Wj13d16Vrm+zJM+0kidzpQD+ydXu1agZ
	 7NMRfDy1qB0EtHQ3xyeQuzM6UWWT6kyiewDStJQkK2jEUWiHgb8bG8LkZf8Gw2b0Q/XzD
	 megUN9YkVts2AaI1BvjQWjT9/j/xe5g9dpCZbuqHrtKguV05D8DKN/jZTwJh8BcSe2iXR
	 VgoF9joDKti8IE7wEXyEH5Q4FaNA4zfgUWxPPhGHuxOf2mF+uadG/DgjyBP98aBVoxj23
	 fpqu8RcXhwsyL92f/UhXssn3sDrZKkO+/LnOD8kKQHE+icDNcub4Dblc5HtqB0G8ywA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OWOkAeAS;
	arc=none smtp.remote-ip=95.215.58.239
Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2207D606D831
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 12:52:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2207D606D831
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OWOkAeAS
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=P5EDvk6rF/qCnD0K9efR1giZB/efgKEHgWhKG6KkDcY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793883175; v=1; x=1794487975;
 b=OWOkAeASOOYzab0z0xD+L69GxFgOK8SO1sE3RARiQVshHf0r2C13Rii5U9HJUBtQAh+jmzL2
 AFIWZfTXqFonE9Dhc50H4+U8s6NHKJV7cAM0onkwI2CJuRn0ZuH9QjpNHNXaUi7+cx1vBwr6dZz
 nXKQ+BoKGFhiGfbz1TE8FFog=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d32cdb94a89149b2;
	Thu, 05 Nov 2026 12:52:55 +0000
X-Mizu-Trace-ID: d32cdb94a89149b2
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Chen Ridong <chenridong@huawei.com>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 2/4] cpuset: add early empty cpumask check in partition_xcpus_add/del
Date: Thu,  5 Nov 2026 20:52:13 +0800
Message-Id: <20261105125215.2205892-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261105125215.2205892-1-ridong.chen@linux.dev>
References: <20261105125215.2205892-1-ridong.chen@linux.dev>
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
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index bc16fd1b1c5e..68b82dabbf38 100644
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

