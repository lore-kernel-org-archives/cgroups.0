Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D2C2FFF8D
	for <cgroups@vger.kernel.org>; Thu,  4 Jun 2026 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585385; cv=none; b=BjKppTof+Bo/U0EESGh0K4kcxxtHWKOCgmMqvN7fDxIEqsONRolFGf84WjFCyuCGIKG+pxm7BMNL4Muo2Ic8TNlqnsml1C2qfhq7GTgEOgy1LFk/gD2bPVC89aHuNt5UoFskfPuGtb1Mqth2n8GoqD8ZQQghWpa+vbIAvZ7H6hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585385; c=relaxed/simple;
	bh=las90fBDahkQ0pJECX7zGvWU0b3wJvuR06DUUT93s7c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=stSb29aCAsaFn9vC1vs/aj08Wd/knGQG+ZIhBnratvwfXOlnez5OC/aypFHzQf6AyV0/Owx5sDgZCaaFozNfp1PdmR15u3nHwSZE9xM4vccQkg8LL9k+1eJkc98I6V5aWHwOCpK3gkH7uHy/MpLcVLGJrmcF7oLh6wFslPD69VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GWL+XG7O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GWL+XG7O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780585381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+9Cz4HH/U7ooEyetyI1F0rDnPm0PfXM3vfkGb5GEMXE=;
	b=GWL+XG7OaKsheZtrpMrXRbwdtxAZbElDqgdG06l0KyA7dbb+889sJ5ewIGWDicb97M07jO
	Eevs8cRG1dyMStvQi8hmUsVBOGLkuKfTjEyvRg09wgmGpgODjdMySCgjzuggpAG7FsNbwe
	WxNBkawxstXztEEdxkvuFscjux2d3aY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-6Y3lKeGhOJ6GG2-A3C7P8w-1; Thu,
 04 Jun 2026 11:02:57 -0400
X-MC-Unique: 6Y3lKeGhOJ6GG2-A3C7P8w-1
X-Mimecast-MFC-AGG-ID: 6Y3lKeGhOJ6GG2-A3C7P8w_1780585376
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C59571955F28;
	Thu,  4 Jun 2026 15:02:55 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.88.175])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 26E971954193;
	Thu,  4 Jun 2026 15:02:53 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aaron Tomlin <atomlin@atomlin.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v6 0/6] cgroup/cpuset: Support multiple source/destination cpusets for cpuset_*attach()
Date: Thu,  4 Jun 2026 11:02:23 -0400
Message-ID: <20260604150229.414135-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

 v6:
  - Make guarantee_online_mems() to only return cs->effective_mems with v2
    in patch 1.
  - Remove obsolete commit description text from patch 3.
  - Add Reviewed-by tags.
  - In patch 6, add WARN_ON_ONCE() test in cpuset_can_attach() to
    confirm that cs != oldcs.

 v5:
  - Remove the WARN_ON() call as it can be triggered in a corner case.
  - Instead of passing an attach_cpus_updated and attach_mems_updated
    flags from cpuset_can_attach() to cpuset_attach(), re-evaluate the
    flags at the beginning of cpuset_attach() based on data in the source &
    destination cpusets in the singly linked lists to eliminate the
    Time-of-Check to Time-of-Use (TOCTOU) race condition & simplify the
    code changes.
  - Add back the dropped optimization in patch 5.

 v4:
  - Add a new patch 1 to fix inconsistency in node mask usage in
    cpuset_update_tasks_nodemask() and cpuset_attach() and adjust
    the subsequent patches accordingly.
  - Update patch 3 to set the update flags whenever the CPU or node
    mask is updated to address issue reported by Sashiko.
  - Update patch 5 to remove unneeded setting of old_mems_allowed as
    well as calling schedule_flush_migrate_mm() if queue_task_work is
    set.

Sashiko AI review of another cpuset patch had found that cpuset_attach()
and cpuset_can_attach() can be passed a cgroup_taskset with tasks
migrating from one source cpuset to multiple destination cpusets and
vice versa.  Further testing of the cpuset code indicates that this is
indeed the case when the v2 cpuset controller is enabled or disabled.

Unfortunately, cpuset_attach() and cpuset_can_attach() still assume that
there will be one source and one destinaton cpuset which may result in
inocrrect behavior.

This patch series is created to fix this issue.

Patch 1 is to fix an inconsistency in the way node mask update is being
handled in cpuset_update_tasks_nodemask() and cpuset_attach() so that
they match each other.

Patches 2 and 3 are just preparatory patches to make the remaining
patches easier to review.

Patch 4 makes cpuset_attach_old_cs to track group leader for use by
cpuset_migrate_mm().

Patch 5 moves mpol_rebind_mm() and cpuset_migrate_mm() inside
cpuset_attach_task() to make CLONE_INTO_CGROUP flag of clone(2) works
more like moving task from one cpuset to another one, while also make
supporting multiple source and destination cpusets easier.

Patch 6 makes the necessary changes to enable the support of multiple
source and destination cpusets by keeping all the source and destination
cpusets found during task iterations in two singly linked lists for
source and destination cpusets respectively.

Waiman Long (6):
  cgroup/cpuset: Fix node inconsistencies between
    cpuset_update_tasks_nodemask() and cpuset_attach()
  cgroup/cpuset: Add a cpuset_reserve_dl_bw() helper
  cgroup/cpuset: Expand the scope of cpuset_can_attach_check()
  cgroup/cpuset: Make cpuset_attach_old_cs track task group leaders
  cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm() calls inside
    cpuset_attach_task()
  cgroup/cpuset: Support multiple source/destination cpusets for
    cpuset_*attach()

 kernel/cgroup/cpuset-internal.h |   6 +
 kernel/cgroup/cpuset.c          | 424 +++++++++++++++++++++++---------
 2 files changed, 311 insertions(+), 119 deletions(-)

-- 
2.54.0

