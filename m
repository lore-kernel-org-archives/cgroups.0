Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536FB37F738
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 15:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783312; cv=none; b=CWrHggWySgWYdREzaeo/VOjz4mSuqVqQLtn5LekQfl8ChlUEFA755Dz5ltKQqotDmCS/70pAXtrBzYaSvE27U2zDCS69tuRmQ6pNY6ao5K0C7S5AatzAtJLq+6v11EhnhnsAZTOC6j7JjOkDwri6j19wM1+vKtIenB0L1raCs9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783312; c=relaxed/simple;
	bh=qOBjwCcfI5evA6OLYTxFgZKZTFT4cAFa94K+/RHug9o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hDwNe1j20dxr0HBAZYoDv29DufBkCHcCeRoxIlPRP9sTX/OjnRp4qp0fGR4rSniUeQh/m68Okv5WvDa1ZmFw3I65I+2dgzVNhQ6VMTSmpP6oqqrofBt3wLJlq3puLwYeS0IR1nuzUITNUcfNycZeEHHb3NXlM9eF7BKchK/aeOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YARfEmzm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YARfEmzm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790783306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ERP04hVaKtD7Z/9InYPyGlPl22CrT3NV1AkjD/nHO9o=;
	b=YARfEmzmX22pJaZkqXi1QMUxagQzEs3VMX3yFVKIf2DJ4SvsvJPV1A3hprYkuHMmZOjM1E
	9rUJT/YbdxceK7WoaUOZkzy4MaM2ADURYya3Ym+YsmbdGBqe2MKKcRPxlTZJYgc8v9zJ2/
	4JKuzO4W3x84ZMAkTxuXdtqgoCQXFsw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-hjsv9SoVNdufnbTH7-_spA-1; Wed,
 30 Sep 2026 11:48:22 -0400
X-MC-Unique: hjsv9SoVNdufnbTH7-_spA-1
X-Mimecast-MFC-AGG-ID: hjsv9SoVNdufnbTH7-_spA_1790783301
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDB63188305E;
	Wed, 30 Sep 2026 15:48:20 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 01A5F1800576;
	Wed, 30 Sep 2026 15:48:18 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrea Righi <arighi@nvidia.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH] cgroup/cpuset: Use cpuset_v2() in cpuset_num_cpus()
Date: Wed, 30 Sep 2026 11:48:00 -0400
Message-ID: <20260930154800.698360-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The cpuset code has 2 different helpers for determining if it is in a
v1 or v2 working environment - cpuset_v2() and is_in_v2_mode().

cpuset_v2() checks the binding of the cpuset subsystem is on a v1
or v2 hierarchy. It can also help to optimize out v1 specific code
if CONFIG_CPUSETS_V1 isn't defined.

is_in_v2_mode() layers on top of cpuset_v2() and returns true if it is in
a v2 hierarchy or in a v1 hierarchy with "cpuset_v2_mode" mount option
enabled to make "cpuset.cpus" and "cpuset.mems" behave in a way similar
to their v2 counterparts. However the cpuset hierarchy may still be a
standalone one separated from the other cgroup hierarchies.

Commit 90ac22ffef48 ("sched/fair: Add cgroup_mode: max") adds a new
cpuset_num_cpus() helper to return the number of effective CPUs in a given
cgroup. It is part of the "sched: Flatten the pick" patch series to help
flatten the cpu cgroup runqueue hierachies. cpuset_num_cpus() currently
uses is_in_v2_mode() to determine if it is in a v2 environment. However
is_in_v2_mode() can be true in a v1 environment where the cpuset and cpu
cgroup subsystems can be in two separate hierachies. The current use
case [1] for cpuset_num_cpus() assumes that it can return the number
of effective CPUs present in the current cpu cgroup which may not be
the case.

Fix that by switching to use cpuset_v2() which signifies that it is in
a unified hierarchy where both cpuset and cpu cgroup subsystems share
the same cgroup hierarchy if it returns true.

[1] https://lore.kernel.org/lkml/20260930081125.GF88198@noisy.programming.kicks-ass.net

Fixes: 90ac22ffef48 ("sched/fair: Add cgroup_mode: max")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4a2b6f154609..cbf67ad13874 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4251,7 +4251,7 @@ int cpuset_num_cpus(struct cgroup *cgrp)
 	int nr = num_online_cpus();
 	struct cpuset *cs;
 
-	if (is_in_v2_mode()) {
+	if (cpuset_v2()) {
 		guard(rcu)();
 		cs = css_cs(cgroup_e_css(cgrp, &cpuset_cgrp_subsys));
 		if (cs)
-- 
2.55.0

