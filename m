Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA10372EDD
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 03:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790738343; cv=none; b=BfQGGMhiQoL/dxsxsrvTR9ZwxvSkQrTI+uX/wHazb4067l/t56X19Ly5fHG8MOA8AEXb1e9hHWyRSIJRmvBYP4NCfethXM9600MkgpMpiXlbVEZGSXUGm/b8DlSP8JY/nuRitpy9jHCg5xqLi2VrQOUVtBZ9dOVnqclWxQwrwKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790738343; c=relaxed/simple;
	bh=ini4BKUGWpzHTTuOSBl1okOeuQrXaJGpj6/XxFlfXOc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FxaUcEqsBJ7RO0w+pXik8zde9XLMVZXhboLfI9qj3+G+Fme4mjQS7PXyzjHyV2ZMFFiXR818shty8qq6IJ4ht5hWe8cGFdWCg6d2lhJgnTXpGG+i8i4iJob6bxl319EbVq/4rSSeQ9Zk2q9G5nfX8RMI/58/i35kcF0f5vUtRxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U2Jd13JK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U2Jd13JK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790738338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Rk1VJPS9HqUKF0qFZ/pgkNZdCmAerFa88QNXJ8Lu9qU=;
	b=U2Jd13JKcQhDzGwDqPvYT1JsHAz9YZwct8hJafsuDDucEIT64x+d4lre1HwpXo39qEjJoe
	BX0Rd+oFI3JTB9jy3OZwi9fflzjwca1CB/B5BgkiLCc1W3C4C1J1usU1DbpUeMmTENF2Mv
	Rmec7C0yWoaZX/Ao4LQ0lsTWy3Mf4/o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-198-c1k1KSUEOKyJQ9KZmFJdQQ-1; Tue,
 29 Sep 2026 23:18:54 -0400
X-MC-Unique: c1k1KSUEOKyJQ9KZmFJdQQ-1
X-Mimecast-MFC-AGG-ID: c1k1KSUEOKyJQ9KZmFJdQQ_1790738333
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48E861955F22;
	Wed, 30 Sep 2026 03:18:53 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5EBE0180034C;
	Wed, 30 Sep 2026 03:18:51 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrea Righi <arighi@nvidia.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2] cgroup/cpuset: Don't access cpuset_cgrp_subsys.root in is_in_v2_mode()
Date: Tue, 29 Sep 2026 23:18:33 -0400
Message-ID: <20260930031833.660267-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

After seeing the patch [1] to guard is_in_v2_mode() with RCU, it makes
me realize that is_in_v2_mode() may be called in a context where a new
cgroup filesystem is being rebound with stale cpuset_cgrp_subsys.root
pointer. Avoid this potential UaF situation by adding a new cpuset_v2_mode
flag which is set when the cpuset_v2_mode mount option is used. This
flag is written into only when cpuset_bind() is being called with a
stable cpuset_cgrp_subsys.root value. The is_in_v2_mode() helper is
modified to read the new cpuset_v2_mode flag instead of accessing
cpuset_cgrp_subsys.root directly.

[1] https://lore.kernel.org/lkml/20260929084124.626693-2-arighi@nvidia.com

Fixes: b8d1b8ee93df ("cpuset: Allow v2 behavior in v1 cgroup")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

[v2] Update the comment as suggested by Ridong

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 19661df6244f..4a2b6f154609 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -152,6 +152,12 @@ static cpumask_var_t	isolated_cpus;		/* CSCB */
  */
 static bool		update_housekeeping;	/* RWCS */
 
+/*
+ * Set if "cpuset_v2_mode" mount option is used
+ * Cached at bind time and not lock protected; accessed via {READ,WRITE}_ONCE
+ */
+static bool		cpuset_v2_mode;
+
 /*
  * Copy of isolated_cpus to be passed to housekeeping_update()
  */
@@ -439,8 +445,7 @@ static inline bool cpuset_v2(void)
  */
 static inline bool is_in_v2_mode(void)
 {
-	return cpuset_v2() ||
-	      (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
+	return cpuset_v2() || READ_ONCE(cpuset_v2_mode);
 }
 
 /**
@@ -3664,6 +3669,8 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
 	mutex_lock(&cpuset_mutex);
 	spin_lock_irq(&callback_lock);
 
+	WRITE_ONCE(cpuset_v2_mode,
+		   !!(cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE));
 	if (is_in_v2_mode()) {
 		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
 		cpumask_copy(top_cpuset.effective_xcpus, cpu_possible_mask);
-- 
2.55.0

