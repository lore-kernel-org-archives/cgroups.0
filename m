Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E2F357A5F;
	Wed, 11 Feb 2026 09:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.70.160.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770802961; cv=none; b=VPbua8ownPLq4hCSnq5Va79CjTh9Vj7OrNYvmiIJ3/rmeLzMwz3KMuLmfwd0MHtt9pryBnf2cWeLJ0G84RMasMsTqfIRm0QGE5LV6cmSyFGxt1ciuQm3gehIH24UXdJ5mzkCH33douZ3lX4ir36u55iPr3CcCNYUqjXVmOmctXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770802961; c=relaxed/simple;
	bh=a6KVuLJD/m17KuZkxlh2stQWouYfoVpFMumuJtdmn/4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PZePNI5X1XMURm7gLb6fzz9b3jgC1hRWdRaOyUoV7Ir+QevNJW69dJG86reHwrrBi9+ZNFDLB39lxvoMkZ718cxL0+HWIgWyu7zEmM31PT9pgg3+WckJalzuS0HQq4SqRTmyjyUjGpHuPFZ3O0A3H+baMFlZ6BGWnhqt9uVoZWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=honor.com; spf=pass smtp.mailfrom=honor.com; arc=none smtp.client-ip=81.70.160.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=honor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=honor.com
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4f9tFq3p0MzYl0Cl;
	Wed, 11 Feb 2026 17:20:47 +0800 (CST)
Received: from a009.hihonor.com (10.68.30.244) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Wed, 11 Feb
 2026 17:24:04 +0800
Received: from a008.hihonor.com (10.68.30.56) by a009.hihonor.com
 (10.68.30.244) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Wed, 11 Feb
 2026 17:24:04 +0800
Received: from a008.hihonor.com ([fe80::b6bf:fc6a:207:6851]) by
 a008.hihonor.com ([fe80::b6bf:fc6a:207:6851%6]) with mapi id 15.02.2562.027;
 Wed, 11 Feb 2026 17:24:04 +0800
From: zhaoqingye <zhaoqingye@honor.com>
To: Tejun Heo <tj@kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
	=?iso-8859-1?Q?=22Michal_Koutn=FD=22?= <mkoutny@suse.com>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, zhaoqingye
	<zhaoqingye@honor.com>
Subject: [PATCH] cgroup: fix race between task migration and iteration
Thread-Topic: [PATCH] cgroup: fix race between task migration and iteration
Thread-Index: AdybNwZS+sZmTTYERMSkjhIWOJQnAw==
Date: Wed, 11 Feb 2026 09:24:04 +0000
Message-ID: <8092ea7ae48d4a988fdcb7390e1be0b1@honor.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

When a task is migrated out of a css_set, cgroup_migrate_add_task()
first moves it from cset->tasks to cset->mg_tasks via:

    list_move_tail(&task->cg_list, &cset->mg_tasks);

If a css_task_iter currently has it->task_pos pointing to this task,
css_set_move_task() calls css_task_iter_skip() to keep the iterator
valid. However, since the task has already been moved to ->mg_tasks,
the iterator is advanced relative to the mg_tasks list instead of the
original tasks list. As a result, remaining tasks on cset->tasks, as
well as tasks queued on cset->mg_tasks, can be skipped by iteration.

Fix this by calling css_set_skip_task_iters() before unlinking
task->cg_list from cset->tasks. This advances all active iterators to
the next task on cset->tasks, so iteration continues correctly even
when a task is concurrently being migrated.

This race is hard to hit in practice without instrumentation, but it
can be reproduced by artificially slowing down cgroup_procs_show().
For example, on an Android device a temporary
/sys/kernel/cgroup/cgroup_test knob can be added to inject a delay
into cgroup_procs_show(), and then:

  1) Spawn three long-running tasks (PIDs 101, 102, 103).
  2) Create a test cgroup and move the tasks into it.
  3) Enable a large delay via /sys/kernel/cgroup/cgroup_test.
  4) In one shell, read cgroup.procs from the test cgroup.
  5) Within the delay window, in another shell migrate PID 102 by
     writing it to a different cgroup.procs file.

Under this setup, cgroup.procs can intermittently show only PID 101
while skipping PID 103. Once the migration completes, reading the
file again shows all tasks as expected.

Note that this change does not allow removing the existing
css_set_skip_task_iters() call in css_set_move_task(). The new call
in cgroup_migrate_add_task() only handles iterators that are racing
with migration while the task is still on cset->tasks. Iterators may
also start after the task has been moved to cset->mg_tasks. If we
dropped css_set_skip_task_iters() from css_set_move_task(), such
iterators could keep task_pos pointing to a migrating task, causing
css_task_iter_advance() to malfunction on the destination css_set,
up to and including crashes or infinite loops.

The race window between migration and iteration is very small, and
css_task_iter is not on a hot path. In the worst case, when an
iterator is positioned on the first thread of the migrating process,
cgroup_migrate_add_task() may have to skip multiple tasks via
css_set_skip_task_iters(). However, this only happens when migration
and iteration actually race, so the performance impact is negligible
compared to the correctness fix provided here.

Signed-off-by: Qingye Zhao <zhaoqingye@honor.com>
---
 kernel/cgroup/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5f0d33b04910..a34d46c50194 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2608,6 +2608,7 @@ static void cgroup_migrate_add_task(struct task_struc=
t *task,
=20
 	mgctx->tset.nr_tasks++;
=20
+	css_set_skip_task_iters(cset, task);
 	list_move_tail(&task->cg_list, &cset->mg_tasks);
 	if (list_empty(&cset->mg_node))
 		list_add_tail(&cset->mg_node,
--=20
2.25.1

