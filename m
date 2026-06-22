Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF38735F610
	for <cgroups@vger.kernel.org>; Mon, 22 Jun 2026 22:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782168329; cv=none; b=cPNvXauup0fnAYZ86fPheWhUtGJ8TQXG5u1etHIYqfTyhYN6D6Dhfkl2CBIhd/U6irL1GWzUzu7V6QMqAMw1Yt87mGcgsmvBgFeeiM7FccIUO609XUkBfXxoVgftQ9EIj6DPSKPTgjMgds9dkkS0y9fJPF7xhrnzGhf+uj0DY4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782168329; c=relaxed/simple;
	bh=zkBIJwpkIi0JaBuKTi7cKmsmRG5zhv9onW9eRTGQ00A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gl/y4+Rlc5sjWM6MO5kyRUEAFv8e9MwUogrQoaWhmM/P1SIfx2ZgkFS8Mncp6OX+1pZg4kv9uyivspRPmCyhqLKsiblJRVNHXoSI7l2AtkNa22v9WFc2Yyix7mHTym5HacVxtk6I9FujCMhlfV388/7jRIhBWofzQiAVMSr0ncE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K31F+GRg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K31F+GRg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782168326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=H4GokJW/ci2sYJrkfXxAnZ8xYn+j4D86CiZxC/r1JEI=;
	b=K31F+GRgf6KOWKcrjDJPh/aw2BOuHNiA5J7lbaUlpFhZqjgy+L6DplcvrtHzGFdoSPbjLl
	H2EXfgbAiYz1Y/arJQaqTulo7QJHfP14363HxWl8jNv19l0tvK9bqpcpT2GLMAXnC0sefz
	xFsmY7bp2V8URytELwTjCuvId/PSxik=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-505-YV-wSE-GMGe2Nm03WoYN2A-1; Mon,
 22 Jun 2026 18:45:23 -0400
X-MC-Unique: YV-wSE-GMGe2Nm03WoYN2A-1
X-Mimecast-MFC-AGG-ID: YV-wSE-GMGe2Nm03WoYN2A_1782168321
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D4C2195608C;
	Mon, 22 Jun 2026 22:45:21 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.2.16.103])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8637A3189;
	Mon, 22 Jun 2026 22:45:17 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 1/2] cgroup/cpuset: Avoid unnecessary cpus & mems update in cpuset_hotplug_update_tasks()
Date: Mon, 22 Jun 2026 18:45:08 -0400
Message-ID: <20260622224509.1927419-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

As reported by sashiko [1], cpuset_hotplug_update_tasks() may perform
unnecessary task iteration and updating of tasks' CPU and node masks
when mems_allowed and/or cpus_allowed are not set in cpuset v2. It is
due to the fact that the temporary new_cpus and new_mems masks do not
inherit parent's effective_cpus/mems when they are empty which is the
expected behavior for cpuset v2 since commit 4ec22e9c5a90 ("cpuset:
Enable cpuset controller in default hierarchy").

Fix that and avoid unnecessay work by adding the empty mask checks and
inheriting the parent's versions if empty.

[1] https://sashiko.dev/#/patchset/20260621032816.1806773-1-longman%40redhat.com

Fixes: 4ec22e9c5a90 ("cpuset: Enable cpuset controller in default hierarchy")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index aff86acea701..bc0207fd6e57 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3925,6 +3925,14 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	compute_effective_cpumask(&new_cpus, cs, parent);
 	nodes_and(new_mems, cs->mems_allowed, parent->effective_mems);
 
+	if (is_in_v2_mode()) {
+		/* Inherit parent's effective_cpus/mems if empty */
+		if (cpumask_empty(&new_cpus))
+			cpumask_copy(&new_cpus, parent->effective_cpus);
+		if (nodes_empty(new_mems))
+			new_mems = parent->effective_mems;
+	}
+
 	if (!tmp || !cs->partition_root_state)
 		goto update_tasks;
 
-- 
2.54.0

