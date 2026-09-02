Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E379A453A55;
	Wed,  2 Sep 2026 23:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788390197; cv=none; b=Ro50uuWHb3Zp/apGYS001xm8N0A657Cg58j+FrD62m/pbYW9kM+BnoYwOhm7hx5dWLkAMNrUz1esP3op5AFE1atKsW62c8H3fTf0koBEFvAkPCi93QxMoctg474sKRlM1PMdqQ4dlr5XwHThS/5ckPFw4somCW1Lw4cCI4M6V/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788390197; c=relaxed/simple;
	bh=ALQBHKdgV9XkgPvCN52f3Het2eAgYEWkpQ5yeWDDvek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNlgHzShOJiqaq6oeolKc9EQeJQ/LNkJQ37ztBErUNZ7XH09WcbjIEGO+er6i2AQZZE6+Ci9JKLo7UpUDmHVLdMWXeF3vjpRE0TAcGo2JMb2uIDjMkGXCjPGyJzCZ9p3782WrJTV0dbfrN8j4PaNKN9lu0sTkV5/Rd0GvMw9SqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3dpZ21W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3dpZ21W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435871F00A3A;
	Wed,  2 Sep 2026 23:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788390195;
	bh=Gfakxnm96pGklzhCfGWbwyW7CUOm85Y3B7BmNPYSD5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3dpZ21WfmMzi0OvBkXeyA8ncIqBdMGFdEd1I9eTRdFGE2/Rcug2WexFfMp7wNrZQ
	 WUX9Eu1Pak2wwSX7QuXUEzBBDJPUcEVDNXSwfRPGcGNnvMvt9m6lKsskbQ+fX6UmPy
	 qLANNRFMscCXvSXZEX+pKeegyieeWSOuDgIz67a1hYZ5LWAGMUNkU8d7mEOViwZ7SA
	 2S3CBlCF0yytTTAyjpC8VYrTeLc823JlS8c5nFnP9Y+kWmT9t2VQg0ycKniVw7Qjey
	 vWksZxwkhfqkvpllf475i0rA2A0vZklejKbRrZK8jc6NjPF9aajNH8ylQ1mkhQwr2c
	 DJW+ia4AsEH/g==
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+bb2e19a1190a556c01b1@syzkaller.appspotmail.com,
	Tao Yu <tao1.yu@intel.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] cgroup: Return -ENODEV consistently for a dead cgroup
Date: Wed,  2 Sep 2026 13:03:11 -1000
Message-ID: <20260902230313.530839-2-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902230313.530839-1-tj@kernel.org>
References: <20260902230313.530839-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cgroup_kn_lock_live() returns NULL when the cgroup behind a kernfs node has
already been removed. Most callers turn that into -ENODEV, but the
cgroup.type, cgroup.max.descendants, cgroup.max.depth, cgroup.pressure,
cgroup.freeze and cgroup.kill writers return -ENOENT. The divergence is
accidental. Return -ENODEV from all of them, matching cgroup.procs and
cgroup.subtree_control.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c3a12fee7528..37bc8a67a40f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3791,7 +3791,7 @@ static ssize_t cgroup_type_write(struct kernfs_open_file *of, char *buf,
 	/* drain dying csses before we re-apply (threaded) subtree control */
 	cgrp = cgroup_kn_lock_live(of->kn, true);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	/* threaded can only be enabled */
 	ret = cgroup_enable_threaded(cgrp);
@@ -3834,7 +3834,7 @@ static ssize_t cgroup_max_descendants_write(struct kernfs_open_file *of,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	WRITE_ONCE(cgrp->max_descendants, descendants);
 
@@ -3877,7 +3877,7 @@ static ssize_t cgroup_max_depth_write(struct kernfs_open_file *of,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	WRITE_ONCE(cgrp->max_depth, depth);
 
@@ -4193,7 +4193,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	psi = cgroup_psi(cgrp);
 	if (psi->enabled != enable) {
@@ -4269,7 +4269,7 @@ static ssize_t cgroup_freeze_write(struct kernfs_open_file *of,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	cgroup_freeze(cgrp, freeze);
 
@@ -4331,7 +4331,7 @@ static ssize_t cgroup_kill_write(struct kernfs_open_file *of, char *buf,
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
-		return -ENOENT;
+		return -ENODEV;
 
 	/*
 	 * Killing is a process directed operation, i.e. the whole thread-group
-- 
2.55.0

