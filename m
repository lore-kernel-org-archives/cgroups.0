Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D792820AC;
	Mon,  8 Jun 2026 03:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780890182; cv=none; b=WP1cDZi1aeGvj1XEp22Sgmbb998Y3PQOHYCr5YTtuIOrfr4omunmYA+mrxw1CCUdVGfolbB0qWpcZ4OO6f/mH854oSM7yRqxbkgA0dHIn5Dhnn3lqLfus2irmGwj/tEh50tA4vojxXGEfc8c7piQ4OdPpRCv/feri4QguHCLhSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780890182; c=relaxed/simple;
	bh=eInO9g70fqDrEqZ8bgT7GrO+EXJa436H97cNbrwSAsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRR3O0T47t4Vbw6Gw9iyYAeDrH0OcKJC86ityyZCP/NPNLYzMJENMmG4ZrubLk9Rcnqli3SDmogXtecZmaa2s88Ap6g6/D+ceQSRMWrC9TgqPLjGEOjMWzZd3CBZyx5HjpwA/ltCrrr0klfwToy07jhws2K6GO03noGeqWFjjZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D41Iapm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D41Iapm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1F31F00898;
	Mon,  8 Jun 2026 03:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890181;
	bh=QSu6XsEiboRL19rJVWEiFsNcMRrFU8VXRLqsphg+RLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D41Iapm4tXqr9Ba5E+mBBRULkFhOthmZ/kCNgUh3KHXBEZtxqOUL0uh0RPVQUrrLf
	 aA5985WZ0YdB/TPxUgWPK8zWajdGX1N75ign661nUvcGvVuB0WXesX4q6eiDHqy9B6
	 poYoWwIwO2P8VgSsJ8ciii49If7XvmzGt5cGiXw3XJznRsQG44tp3dilXRKXECWrZT
	 KVTPsCpl85zbSYKBhvwd0uZ10Lpmh3V3QzFYEHG8Jp02aYAEHFothj/C6y2cgSyvvn
	 /CVeoPr/Jmbe/1mamqhptaWQaYqlPKhooc1f1aQCGZI0DIRWJtmRQj5tyOFfZoLWTL
	 qJjenKf+xAcXg==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()
Date: Mon,  8 Jun 2026 11:42:42 +0800
Message-ID: <05799877e720dcd300e2ddd4625e8e162959d7cc.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

blkcg_print_one_stat() will be called for each blkg:
- access blkg->iostat, which is freed from rcu callback
  blkg_free_workfn();
- access policy data from pd_stat_fn(), which is freed from
  pd_free_fn(), while pd_free_fn() can be called by removing blkcg or
  deactivating policy;

Take blkcg->lock while iterating so the blkgs stay online and both
blkg->iostat and policy data for activated policies stay valid.  Use
irq-safe locking because blkcg->lock can be nested under q->queue_lock,
which is used from IRQ completion paths.

Prepare to convert protecting blkgs from request_queue with mutex.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c75b2a103bbc..b55c43f72bcb 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1241,17 +1241,14 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 	if (!seq_css(sf)->parent)
 		blkcg_fill_root_iostats();
 	else
 		css_rstat_flush(&blkcg->css);
 
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->q->queue_lock);
+	guard(spinlock_irq)(&blkcg->lock);
+	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node)
 		blkcg_print_one_stat(blkg, sf);
-		spin_unlock_irq(&blkg->q->queue_lock);
-	}
-	rcu_read_unlock();
+
 	return 0;
 }
 
 static struct cftype blkcg_files[] = {
 	{
-- 
2.51.0
