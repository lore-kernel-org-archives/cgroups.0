Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF36478E36
	for <cgroups@vger.kernel.org>; Mon,  5 Oct 2026 10:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791197013; cv=none; b=SCQY1wF/CK3a6ysyUs57qg1dQEaJAGFzYG0hDAD9pizoNxfuKWr/bOwcXBTp9LgEAjNJrnUN3uUr3aOTaj0glVYs6rUQUY9hD/SU0SwgDhIpcG/85IiqYLEWMJZpeCKY4FGs6FcRweiQ7Zj31SBgm0MF2wvLBboVMuwDftpJrF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791197013; c=relaxed/simple;
	bh=MnsiDEqJnb4T//6WE5x5LJlKc86KP2STmSRUpBXHhJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L0eeV3LZAXbTVS/O/gVKZ5SRvG4J6FRsaN/U/TsXRcvKB8Tb2pmmNLhOeSQGFdijVa0qpk4mAgfH8XMdsaZgg4ZrdvFFtMjaV0y2hnngpkfZ21j2IKA/R7ozfEcRFp3LaWJGqX1oJ3YTMRVBbabqed1J23x8VCRFbUxBmdl3NpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQcKR0nL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQcKR0nL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791197011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hIf+LbEnAibRNW0LghjeWrQApvOlkEKDvJZ+yAUOTXE=;
	b=DQcKR0nLmJbGhqizIAVWQaadp+yXge7hhAYnBRgin6XkxH4TTT+Zi1cFRadB7gsPuS3ZI2
	imZxrYl7LJdI0aRYTrShIDacMIpdDXs6sPdS1jzbiUxglGc7Wj5NOA0ZfRvmjAC6fypnUV
	ipRclxSFDJA84E0uwtEMv7ed2h3L1NU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-c7oRkp2wMLa74nXPJ94IhQ-1; Mon,
 05 Oct 2026 06:43:26 -0400
X-MC-Unique: c7oRkp2wMLa74nXPJ94IhQ-1
X-Mimecast-MFC-AGG-ID: c7oRkp2wMLa74nXPJ94IhQ_1791197005
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F7371954239;
	Mon,  5 Oct 2026 10:43:25 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CED7B1956044;
	Mon,  5 Oct 2026 10:43:22 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH] cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug()
Date: Mon,  5 Oct 2026 06:43:10 -0400
Message-ID: <20261005104310.1068789-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

It is reported by sashiko that calling is_in_v2_mode() outside of
cpuset_mutex critical section in cpuset_handle_hotplug() can introduce
a TOCTOU race where cgroup hierarchy may have changed from v1 to v2 or
vice versa after is_in_v2_mode() is called leading to erroneously skip
the allocation of tmpmasks or incorrectly modify cpus_allowed masks,
resulting in cpuset state corruption. Fix that by calling is_in_v2_mode()
after acquiring the cpuset_mutex.

Fixes: b8d1b8ee93df ("cpuset: Allow v2 behavior in v1 cgroup")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3f52717c1965..2a4b2cdbc866 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4044,15 +4044,16 @@ static void cpuset_handle_hotplug(void)
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
 	bool cpus_updated, mems_updated;
-	bool on_dfl = is_in_v2_mode();
+	bool on_dfl;
 	struct tmpmasks tmp, *ptmp = NULL;
 
-	if (on_dfl && !alloc_tmpmasks(&tmp))
-		ptmp = &tmp;
-
 	lockdep_assert_cpus_held();
 	mutex_lock(&cpuset_mutex);
 
+	on_dfl = is_in_v2_mode();
+	if (on_dfl && !alloc_tmpmasks(&tmp))
+		ptmp = &tmp;
+
 	/* fetch the available cpus/mems and find out which changed how */
 	cpumask_copy(&new_cpus, cpu_active_mask);
 	new_mems = node_states[N_MEMORY];
-- 
2.55.0

