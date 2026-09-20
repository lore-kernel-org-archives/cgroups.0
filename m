Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17053CA48C
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 02:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789872810; cv=none; b=IGueMPgKmyQX2nrns74kY5wgmbQfTamgsLX8eaTT7bKQPDeXkxaoVKKQJBssYNXGSBgN9YcMbtQm+LjFy2QKnv7YvTiE4hWK33cS2J+P3/f5fD0sZJxGKevCNq9jkjeOWDDTBHzWWXtn9nlX9AH+sYKNAq8wOUmMqJYUwtYjVLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789872810; c=relaxed/simple;
	bh=MPN4ky136xVTlkaLlZT/h13xm3W+q3aKj+KQIr2znTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jOxxjlP0SciW205/fEx4Fb1uq1Ve29TW1kJnyFVucHzPC0mfyx9mFDXmO08zU1P8WuiREdk/KW/m5K3jjUGPdwxecHCSXzrnDcxrmDQ1gnmVj7Up4XN6Edw2p8k17ZZO5NZXK2Enlp4tTPDkOui9m/wIq3468338YTQ8joL/qyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZCR6sDZo; arc=none smtp.client-ip=91.218.175.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZCR6sDZo"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MPN4ky136xVTlkaLlZT/h13xm3W+q3aKj+KQIr2znTg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789872806; v=1; x=1790477606;
 b=ZCR6sDZo72GTwVqpKw0kfO5hGNL00ap/uvjXE8uzpQkjAQSyYBxyNc8UFqw+ZiTUtRRnH+Gr
 aCfQ4e7GgjdCldtOnfhGLgV2ZLbRvRwHWbmkslqBIRAXFACf9gm/5IjfFp0pcIXYtd98YX7wDGa
 m5n+wNyZpXs93uCneHXrjOTQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c0db634aa732d9af;
	Sun, 20 Sep 2026 02:53:16 +0000
X-Mizu-Trace-ID: c0db634aa732d9af
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
Subject: [PATCH v2] cgroup/cpuset: Remove redundant sched domain rebuild from update_prstate()
Date: Sun, 20 Sep 2026 10:52:56 +0800
Message-ID: <20260920025256.24991-1-guopeng.zhang@linux.dev>
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
Changes in v2:
- Rename the patch to avoid the misleading "defer" wording.

 kernel/cgroup/cpuset.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8f24171b6055..d58ecf56f384 100644
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
