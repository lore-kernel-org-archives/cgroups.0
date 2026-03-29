Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671533822BA
	for <cgroups@vger.kernel.org>; Sun, 29 Mar 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774806020; cv=none; b=Ki5/pZMe5y7HaN03gvTkNlO3AZTIxKxMe0PufThwmOD6DIgSy3vVL70+qb5B++EWDLkPePrtxNQqFNBP9AyujwYrJqj1eYLbpVXOHhy+PzdTTvxuRlvRyFAwaO/vGsL8NK3d5/sQvBkyQNhMNKTmSAyumow4EvaoqrQcob1+/l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774806020; c=relaxed/simple;
	bh=w4W7UP+ZQEJmoexj9KDvhDM1dp1MOJyJFES4rZlqUY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7XDqa1TsmhCOp7F9ejKFvcGwXXPvzifF6DUXY9PTEL+8eZ5LLbp4zAmj/uO3DXBJj+QXx7HrbGETNJUA0ZxPa22RFX5295jF5GEgitfiQLjNLSmHNRUo0NN5eC7mpEmEFUZu+iz2Jya4pvBQD36lxT114fmn9euH8r8FfyY8qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AM4Jo+pJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AM4Jo+pJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774806018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C0VwReO9RpU0du/pdr2lQ8z4eTzfYjZguiL25xTAtuE=;
	b=AM4Jo+pJQzEpA/oDmyyk/04+SVzzi+x+eYTge41IdepcoLFqQBn+GsgGXSFJIO1O0whUFi
	Pta1QtcodG+ef04OqchcPQ+pkZ7Y8P5IzHy1jINwVLWAwYGhh3chopQUY3A6dsLhg7hsr8
	AtviAVlSkGq7L3JlIRyYEzojAfeFF/I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-F7DUpheQPJ2t3IGUgqIbqQ-1; Sun,
 29 Mar 2026 13:40:15 -0400
X-MC-Unique: F7DUpheQPJ2t3IGUgqIbqQ-1
X-Mimecast-MFC-AGG-ID: F7DUpheQPJ2t3IGUgqIbqQ_1774806014
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CFC118005B3;
	Sun, 29 Mar 2026 17:40:14 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.75])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B65A319560AB;
	Sun, 29 Mar 2026 17:40:12 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2 3/3] cgroup/cpuset: Improve check for v1 task migration out of empty cpuset
Date: Sun, 29 Mar 2026 13:39:58 -0400
Message-ID: <20260329173958.2634925-4-longman@redhat.com>
In-Reply-To: <20260329173958.2634925-1-longman@redhat.com>
References: <20260329173958.2634925-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

With the "cpuset_v2_mode" mount option, cpuset v1 will emulate v2 in
how it handles the management of CPUs. As a result, the effective_cpus
can differ from cpus_allowed and an empty cpus_allowed will cause
effective_cpus to inherit the value from its parent. Therefore task
migration out of a cpuset with empty "cpuset.cpus" should no longer
be needed in this case.

The current code doesn't handle this particular case. Update the code to
correctly detect that the cpuset has really no CPUs left by checking
effective_cpus instead of cpus_allowed.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset-v1.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
index 0c818edd0a1d..9855de37d011 100644
--- a/kernel/cgroup/cpuset-v1.c
+++ b/kernel/cgroup/cpuset-v1.c
@@ -261,7 +261,7 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	 * has online cpus, so can't be empty).
 	 */
 	parent = parent_cs(cs);
-	while (cpumask_empty(parent->cpus_allowed) ||
+	while (cpumask_empty(parent->effective_cpus) ||
 			nodes_empty(parent->mems_allowed))
 		parent = parent_cs(parent);
 
@@ -297,14 +297,16 @@ void cpuset1_hotplug_update_tasks(struct cpuset *cs,
 
 	/*
 	 * Don't call cpuset_update_tasks_cpumask() if the cpuset becomes empty,
-	 * as the tasks will be migrated to an ancestor.
+	 * as the tasks will be migrated to an ancestor. If cpuset_v2_mode mount
+	 * option is used, effective_cpus can differ from cpus_allowed. So
+	 * checking effective_cpus is more accurate for determining emptiness.
 	 */
-	if (cpus_updated && !cpumask_empty(cs->cpus_allowed))
+	if (cpus_updated && !cpumask_empty(cs->effective_cpus))
 		cpuset_update_tasks_cpumask(cs, new_cpus);
 	if (mems_updated && !nodes_empty(cs->mems_allowed))
 		cpuset_update_tasks_nodemask(cs);
 
-	is_empty = cpumask_empty(cs->cpus_allowed) ||
+	is_empty = cpumask_empty(cs->effective_cpus) ||
 		   nodes_empty(cs->mems_allowed);
 
 	/*
-- 
2.53.0

