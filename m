Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7C73EBF3F
	for <cgroups@vger.kernel.org>; Tue, 31 Mar 2026 08:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774947062; cv=none; b=akqksXj1tNTA3D0XIAxx1+INSHjcX4fIdnSFN/l2A76dFlMeoAD1ILa9MBpq6v7aQSKSf4a9+bqVNJWhIhCLnquxU32Kp7mPAbwgeYZ4xrljruM7S+YPC+2BggE7VfdmsX3sgnzEEnyl53oCuY7WjiZI+ovuDL6pMY3pOW2U8uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774947062; c=relaxed/simple;
	bh=O9alaEbUrmSP1l1r2uxblXiWWZrVr4jLSCPHzLx3cKE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Eb1iZgMhJrzwbGklR7opS6j9w1oh/MYyuRuavNnUs21Sa84Lhn2/EBke1+AtlFG1ZH0TjrEPoeH2vVaEA7kQSU3KTnI5H+OzZnsr40JagzR6iFTKhdMR3LMLFIAJbOjg9RmVnNLA1leR9Pf5AQowTByLz9bjfLFsuQ3+xcgLQHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o/DYA0xn; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o/DYA0xn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774947058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rBfxzG2jzPOmQSrb7bP9sSmrE4XYtLM5eOde2/d1gZs=;
	b=o/DYA0xnP38Fsx4B9HGfnhYFc1q1RxfHxJeeGfXFRuSYcy1/1U0tRPRcMLL0V5uxscXD+i
	W8SHqOrVSKbPuQfF2aC93lHHyZbMmZ26srW+98DPFV/CGs098UUw/SoQ8rt8vkwws4KCPq
	3WAYYJeIRZQVzVlnr0MTLsIaMtG7vAo=
From: Jackie Liu <liu.yun@linux.dev>
To: tj@kernel.org,
	hch@lst.de,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH] blk-cgroup: fix disk reference leak in blkcg_maybe_throttle_current()
Date: Tue, 31 Mar 2026 16:50:54 +0800
Message-ID: <20260331085054.46857-1-liu.yun@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jackie Liu <liuyun01@kylinos.cn>

Add the missing put_disk() on the error path in
blkcg_maybe_throttle_current(). When blkcg lookup, blkg lookup, or
blkg_tryget() fails, the function jumps to the out label which only
calls rcu_read_unlock() but does not release the disk reference acquired
by blkcg_schedule_throttle() via get_device(). Since current->throttle_disk
is already set to NULL before the lookup, blkcg_exit() cannot release
this reference either, causing the disk to never be freed.

Restore the reference release that was present as blk_put_queue() in the
original code but was inadvertently dropped during the conversion from
request_queue to gendisk.

Fixes: f05837ed73d0 ("blk-cgroup: store a gendisk to throttle in struct task_struct")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b70096497d38..c377241ee13c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2022,6 +2022,7 @@ void blkcg_maybe_throttle_current(void)
 	return;
 out:
 	rcu_read_unlock();
+	put_disk(disk);
 }
 
 /**
-- 
2.51.1

