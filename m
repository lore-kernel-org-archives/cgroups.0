Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34F238D401
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041483; cv=none; b=onaujN7mmVvlXdDuDmKkpLDPbS/0nMmQHfAAetNrEuCyKCXEf+eqzrCIG9o1N4Nq3dNiE5krYAhRHw8TtJ1wRpVhFfH2L/euKdVf1lCBaGKfXwpT5F4qPbeZda2FqW1zZGYwDBRPVmfrb81eoFFoon1wG+9QkToG5A3c5Ut+XUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041483; c=relaxed/simple;
	bh=pATEb7+A37imqMe9bf+I3NwYXUwlnPI/rW+mU57goWs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LiYJ/Rs/9SJ/FbND4uD+V+NrhFzbBjaTISmlfazeGyfd6Zsma1+CBwFMKUIAobXOHHWsCuXwwwvJKWq0jDkZS2yZ8zDpI3FchlmUAFIU9VoSzwi2SODeI0c5qMBnK9W0bABXBpcaZogBmos+ct7nN0sn0673z7NQL+1NvwAQdFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JehLxJuA; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JehLxJuA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786041472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+UJ/qH6m8w+SsoyS5gEBbGmGoBm9dLVAYOMv5Qfn9kA=;
	b=JehLxJuAPVsscMZe6Zw8hzRC1wOioAdbV7rwLWw3n+VGuTPkoYTrjYkGoUUodGKyG1QNru
	a173htTGBJ2qQjj5g7BabXb/eWI91ps7bgw/f9bHY0sHfwqvydOhT9IRnZb7BGkBpZhNgm
	SbS/+0+GTrFPAO3UK9rG2c0Mr8z2M50=
From: Usama Arif <usama.arif@linux.dev>
To: axboe@kernel.dk,
	cgroups@vger.kernel.org,
	josef@toxicpanda.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tj@kernel.org
Cc: shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 0/3] block: skip the blkcg walk in blk_cgroup_congested() when nothing is throttled
Date: Thu,  6 Aug 2026 11:37:17 -0700
Message-ID: <20260806183742.946953-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

blk_cgroup_congested() walks the current task's blkcg ancestor chain on every
readahead decision and, once swap is in use, on every anonymous and shmem
folio allocation.  The answer is almost always "no", but finding that out
costs two loads *per level* on two cold cache lines, plus an out-of-line
kthread_blkcg() and an RCU read-side pair.  On a fleet profile of hosts
running containers with 5-10 level hierarchies it costs about as much as all
of mutex_lock(), 99.4% of it under __folio_throttle_swaprate().

Patch 3 gates the walk on a global count of blkcgs with a non-zero
congestion_count, so the common case is a load and a predicted branch.

That only works if the count is correctly maintained, currently two teardown
paths can leave a blkcg permanently marked congested.  Today that only hurts
tasks in the affected cgroup, but it hurts them for the life of the cgroup -
readahead cut to a single page, async readahead skipped, and a throttle
scheduled on every anonymous folio allocation.  With a global gate it would
cost every other task on the machine the walk as well.  Patches 1 and 2 fix
those two paths and stand on their own as bugfixes; patch 3 depends on them.
 
Usama Arif (3):
  blk-iolatency: clear delay state when freeing policy data
  blk-iocost: clear delay state when freeing policy data
  block: skip blkcg walk in blk_cgroup_congested() when nothing
    throttled

 block/blk-cgroup.c         | 15 ++++++++++++++-
 block/blk-cgroup.h         | 25 +++++++++++++++++++++----
 block/blk-iocost.c         |  7 +++++++
 block/blk-iolatency.c      |  9 +++++++++
 include/linux/blk-cgroup.h | 23 ++++++++++++++++++++++-
 5 files changed, 73 insertions(+), 6 deletions(-)

-- 
2.53.0-Meta

