Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E087274B3A
	for <cgroups@vger.kernel.org>; Mon,  2 Feb 2026 20:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770063146; cv=none; b=n6zrQsbJdh157coSjjIkLNuA7rNLXTK8RMIjg48Lsiwx4/LXLCl9DQYrN6Uk/0Ytj2n/9EiK1rIH2fJB1ET1diqeZG0RtM3hsM6evK5HPJZmVL/3wueGheEBhgAgy58EfdrcOQPBvt/KDUgATJBp6eDjTQxakCqJOHnlhJrBCVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770063146; c=relaxed/simple;
	bh=ueRSvYYdurwtvG1dLZKyDVVAIWihUZ0006OF7PLyNaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z6YrxMMSIhBqzFUmFPRp0Z7zXClpzy26s2/oAcG8I+sXRCPPQtC1f2Vln2wjW5dTmvmE8gWe+qHcrJMrlgWDIzC4SLXuCqxCgUbj9jLTMwRogXWuIWA26QEZzfkdbNwCD7gBUByU4O5fzerxwdCGU3wblFUCr8c1V/kUiHHCDKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CBYO7CFa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CBYO7CFa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770063144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e/0NqJBMI2AZg98TeES+DEh0xbNUNHI/7I7le89mk0U=;
	b=CBYO7CFaTlIh95+eeSOKxPrEEFcryRcsiNgQbRfezJqDxJwgjBA9uqoD63+UKSj7eAx9vc
	Or8pZcNbh6mcReD9+bEDHEMWWEDn2qXF2qGK/aQRrVbhwhvN//eTdOqDf6inzic33NvGLb
	ynF/e7KOXQ9cJrX4ccrSCxV/oSUD8Aw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-T1_5I4JXOa-Yf87dyiwvIg-1; Mon,
 02 Feb 2026 15:12:20 -0500
X-MC-Unique: T1_5I4JXOa-Yf87dyiwvIg-1
X-Mimecast-MFC-AGG-ID: T1_5I4JXOa-Yf87dyiwvIg_1770063138
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5A5D180044D;
	Mon,  2 Feb 2026 20:12:17 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.20])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 37DA719560B2;
	Mon,  2 Feb 2026 20:12:12 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Chen Ridong <chenridong@huaweicloud.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH/for-next v3 0/3] cgroup/cpuset: Fix partition related locking issues
Date: Mon,  2 Feb 2026 15:11:41 -0500
Message-ID: <20260202201144.1669260-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

 v3:
  - Add a new patch to clarify the locking rules for internal variables
  - Defer all housekeeping_update() calls with associated
    rebuild_sched_domains*() calls to either workqueue or task_work.

 v2:
  - Change patch 1 to use workqueue instead of task run as it is a
    per-cpu kthread that performs the cpuset shutdown and bringup work.
  - Simplify and streamline some of the code.

After booting the latest cgroup for-next debug kernel with the latest
cgroup changes as well as Federic's "cpuset/isolation: Honour kthreads
preferred affinity" patch series [1] merged on top and running the
test-cpuset-prs.sh test, a circular locking dependency lockdep splat
was reported. See patch 2 for details.

To fix this issue, a new top level cpuset_top_mutex is added and the
call to housekeeping_update() is deferred to either a task_work or to
a workqueue.

With these changes in place, the cpuset test ran to completion with no
failure and no lockdep splat.

[1] https://lore.kernel.org/lkml/20260125224541.50226-1-frederic@kernel.org/

Waiman Long (3):
  cgroup/cpuset: Clarify exclusion rules for cpuset internal variables
  cgroup/cpuset: Defer housekeeping_update() calls from CPU hotplug to
    workqueue
  cgroup/cpuset: Call housekeeping_update() without holding
    cpus_read_lock

 kernel/cgroup/cpuset.c                        | 211 ++++++++++++++----
 kernel/sched/isolation.c                      |   4 +-
 kernel/time/timer_migration.c                 |   3 +-
 .../selftests/cgroup/test_cpuset_prs.sh       |  13 +-
 4 files changed, 174 insertions(+), 57 deletions(-)

-- 
2.52.0

