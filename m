Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1B03A63F2
	for <cgroups@vger.kernel.org>; Fri, 29 May 2026 21:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780090135; cv=none; b=WkWnZwwqk4gV92ncpshg9DXYe1jTrJRZDgL/RWGIiKS7G9aiRCiAWpskI+CJqiRul/MV4AvJsDkDqtkz3d0FzPYwWrfkD6aByAMXJe8QGkkqVlh79aplGk6XjRJXjwySnVeok65GdbFhNrXqIcauFkEj3OdbUntsngOz2lKXG50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780090135; c=relaxed/simple;
	bh=0cshPsnQwIcr+5VqQYjEZhIyyxzr/OIau2ixJwZ9yYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sNOTUAcCQ4BSQmUjyrEKjAReetqnoA3/tsv1wdLnJYIu8KPYLTK/EjWnW4eibBhkT+4l17zVYuSk3s9cBBCNQF5Wncjr7SNFeMHog1sjwLckc4gVQQ4W1VRoEV/413IPTTsM5/rt31cz1ZZhR4Xft9qPIGnKsZbBOgQ8AUrLuzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=giy7tgtU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="giy7tgtU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780090131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Uv6Y23LUodS/Zv6jMai00tlGP+SaZfgHwcOOf6Yl5Z0=;
	b=giy7tgtUeEBfI72v4Gaq+gl6mY1qrbn419WXTj9+AUd257m1cVYJsRyyJPBv0K/KgTLtyK
	f1S4ta8fYhkF74vJdXO31icilDChPrphnZikHTMoTJbxw0xOhSbYIIs2j7/oW69qMppPvB
	+KrLqXSphz0ljRg7McEEbHsTIh5AHJg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-I4eyyDWgOPGxTvESxo86Cg-1; Fri,
 29 May 2026 17:28:46 -0400
X-MC-Unique: I4eyyDWgOPGxTvESxo86Cg-1
X-Mimecast-MFC-AGG-ID: I4eyyDWgOPGxTvESxo86Cg_1780090124
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FAAD180034C;
	Fri, 29 May 2026 21:28:44 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C1D0019560A3;
	Fri, 29 May 2026 21:28:40 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Chen Ridong <chenridong@huaweicloud.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aaron Tomlin <atomlin@atomlin.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v4 0/6] cgroup/cpuset: Support multiple source/destination cpusets for cpuset_*attach()
Date: Fri, 29 May 2026 17:21:02 -0400
Message-ID: <20260529212108.120506-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

 v4:
  - Add a new patch 1 to fix inconsistency in node mask usage in
    cpuset_update_tasks_nodemask() and cpuset_attach() and adjust
    the subsequent patches accordingly.
  - Update patch 3 to set the update flags whenever the CPU or node
    mask is updated to address issue reported by Sashiko.
  - Update patch 5 to remove unneeded setting of old_mems_allowed as
    well as calling schedule_flush_migrate_mm() if queue_task_work is
    set.

 v3:
  - Rebased to the lastest linux-next tree.
  - Keep cpuset_attach_old_cs as suggested by Chen Ridong and replace
    patch 3 by a new one to make it track task group leader.

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
  cgroup/cpuset: Made cpuset_attach_old_cs track task group leaders
  cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm() calls inside
    cpuset_attach_task()
  cgroup/cpuset: Support multiple source/destination cpusets for
    cpuset_*attach()

 kernel/cgroup/cpuset-internal.h |   6 +
 kernel/cgroup/cpuset.c          | 424 +++++++++++++++++++++++---------
 2 files changed, 308 insertions(+), 122 deletions(-)

-- 
2.54.0

