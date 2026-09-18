Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA1E4C33DF
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 10:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727267; cv=none; b=P1ZtlEkZorkoP+16j5HGo70ohYTuP9vTVs4u8g4sa0ptvzrYpuctYb87mn5hbL5+plwj7RSnmtRF+5lxreposbqmql4ENwXt2kaONHPpr00l2gYBU+/q7Ler+FVRUcjVgX8XfgE0veEFZm7xxTPPUxbpZnSGam1T1DYIgmSeK1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727267; c=relaxed/simple;
	bh=kEBV1MZWFCtTPCV1cihYzzw1Ket2/eXrbj/GtNAj6IM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HTbJtDGf4T5PGMPe4eyDXYaDN5Zm8sUubLLf7lLS3MuTgUNliV9P+Gmrj/6mZouTA1+OUZ8Ab5AU4Nk2bXJZOJl6f7Y6ckLDnytUt4Gy45tg+B/ziEjh5uwKDHskv0peKGGq8BPsbl241W/K5OD2gfM99S6CAl6G0Ri1O3rLN+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qD6nU4Cw; arc=none smtp.client-ip=91.218.175.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qD6nU4Cw"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kEBV1MZWFCtTPCV1cihYzzw1Ket2/eXrbj/GtNAj6IM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789727263; v=1; x=1790332063;
 b=qD6nU4CwigaYD7Ai0NW4Lq4Ix8NmBas1jt8hDjDIClo+W1zhSr8zocTiQmEmaINkH6L1ppmr
 /Mx7DBuW1hT461RqH0tRL7OVtGuo1C3ANqn//CBF+NMvm4eG5xru2T4vp8RAeEKNnOJ0sn9gvkr
 2G5QvZTYBPY64l1gqQMLOxgk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3028a3006954f039;
	Fri, 18 Sep 2026 10:27:43 +0000
X-Mizu-Trace-ID: 3028a3006954f039
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] cgroup/cpuset: Defer sched domain rebuild to common unlock path
Date: Fri, 18 Sep 2026 18:27:30 +0800
Message-ID: <20260918102730.72263-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Both callers of update_prstate(), cpuset_partition_write() and
cpuset_css_killed(), call cpuset_update_sd_hk_unlock() immediately
afterwards. That helper rebuilds sched domains when force_sd_rebuild is
set before releasing the cpuset locks, so the check in update_prstate()
is redundant.

Commit 3bfe47967191 ("cgroup/cpuset: Move
housekeeping_update()/rebuild_sched_domains() together") removed the
same check from cpuset_write_resmask(). Remove the remaining one from
update_prstate().

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8f24171..d58ecf5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3039,8 +3039,6 @@ out:
 	update_partition_sd_lb(cs, old_prs);
 
 	notify_partition_change(cs, old_prs);
-	if (force_sd_rebuild)
-		rebuild_sched_domains_locked();
 	free_tmpmasks(&tmpmask);
 	return 0;
 }
-- 
2.43.0

