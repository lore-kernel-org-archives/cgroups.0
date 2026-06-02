Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589EA2D73BC
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 04:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780375041; cv=none; b=gegy1Hk8JPg8aZswLmIg9ELeE/C5N2somxPx3CqKnnvOuPY/u2ikIQbd+lfz4ogf/4RsWvC0RltvqyiRni3iTUYVqAiG+K/hp4OK1RY3Cr8TJpa35nR2kzaQHbFYChoQpWvstx6lqX2IySTchnBLwRelQBTSWll/40r5o1EkfqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780375041; c=relaxed/simple;
	bh=9/SOrUNrdv5pDRn74T/OmcwpB6DT/cLzDd/WdzogI5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ax5BfRx+Sg67dQX5QpGbSiOinHWQIwgHos0hyq4kTDicO2Z8yZ03qNvDVwLVx2aqHSj03mWTvuBUGzzmF3q66pjuFUl0JvtCyBQEybQdIB8wwMHeZHClSmyzgx8fZj1RPxNnGmUBOVVsv3VEy0yzoF6ejrOucsAeZGfDUXeT7fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aWKTDbeq; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aWKTDbeq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780375038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=peuZHFf5XR1rBPnHRF4an7rYxjYHirpHAFohNH2pvbg=;
	b=aWKTDbeqiqB+uHFGWIC30xrjPt41MBLN1b0kXlMwUGcF4ftvwTmRbDxenuMK9YnGQnwhaE
	9IJ+LgxvFFSVYXBAJ+jeNE3qDoLgCsH8NOlefgmQsoXHcCp1BBo4QuJdrzuifzLuPun02A
	3YHaGqdFxp8ePm1KVR5FNJFMUYeZDRU=
From: Tao Cui <cui.tao@linux.dev>
To: longman@redhat.com,
	chenridong@huaweicloud.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	"Claude Opus 4 . 7" <noreply@anthropic.com>
Subject: [PATCH] cgroup/cpuset: Fix update_prstate() always returning 0 on partition errors
Date: Tue,  2 Jun 2026 12:36:52 +0800
Message-ID: <20260602043652.2380163-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

update_prstate() stores the error code in cs->prs_err and transitions
the partition to an invalid state, but always returns 0. The caller
cpuset_partition_write() uses "return retval ?: nbytes", so the write
syscall always appears to succeed from userspace even when the partition
became invalid. Return -EINVAL when err is set so userspace can detect
the failure immediately.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 591e3aa487fc..8605b4da610e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2965,7 +2965,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (force_sd_rebuild)
 		rebuild_sched_domains_locked();
 	free_tmpmasks(&tmpmask);
-	return 0;
+	return err ? -EINVAL : 0;
 }
 
 static struct cpuset *cpuset_attach_old_cs;
-- 
2.43.0

