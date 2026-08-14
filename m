Received: from mta1.migadu.com (out-107.mta1.migadu.com [95.215.58.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18AC4749C0
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 16:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786726638; cv=none; b=bGjYiJg7KLfvZrxGxnXH1LIa1KoumbNZnAjfFY3QvClY5gGBsfHjsuY+2nsfadEIfWpYTck6LvvdIDQ1iLNngutysAFakaBkMU3ivHCFfu7JJGGcV6thbLSB/iLMrOPnndorqjlzV+zRYBqsb71/ksBx1zIfYkYYbt6RQcCKCtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786726638; c=relaxed/simple;
	bh=fPRMeydFPOacpI/I32n9/H7y/IKP402K3H5iyrEKrso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tBn9h3EDrdn0k52o4yA4SutuTsWeWUoxTA0myWJKu4R8TmrklfSUpA2wYJYZ/Zt/UxudqK+zZFdbtFwZTl7lkC7YeMsKVrf7yYZ6cZ0MjmdJ1p7wICmHbX0d7mYzQaTDipyNUxBbx9lGIcg7lEfKLEhraE/VtxeDHqSv9nUwd4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vg9CAKiv; arc=none smtp.client-ip=95.215.58.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vg9CAKiv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fPRMeydFPOacpI/I32n9/H7y/IKP402K3H5iyrEKrso=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786726634; v=1; x=1787331434;
 b=Vg9CAKivrFyntQt3jgQdynfCD17pUrdo+qWRqenk/CCn0ioUZiNL6U3E77t0wI+Ptuyzoema
 qApivpl6wXZndn2CEcUdoO8+WdcBH6/ffr/hmN9GguPjqSdxBGlHPQ4ESW2AbuEjeeMYhDcXMkv
 luB4gS4uRhTuoOMjpnuMA61s=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:51::)
	by mta12.migadu.com with ESMTPS id 3c93d01ef2926fcb;
	Fri, 14 Aug 2026 16:57:14 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: tj@kernel.org,
	axboe@kernel.dk,
	cgroups@vger.kernel.org,
	josef@toxicpanda.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 0/3] block: skip the blkcg walk in blk_cgroup_congested() when nothing is throttled
Date: Fri, 14 Aug 2026 09:56:36 -0700
Message-ID: <20260814165712.510132-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

blk_cgroup_congested() walks the current task's blkcg ancestor chain on every
readahead decision and, once swap is in use, on every anonymous and shmem
folio allocation.  The answer is almost always "no", but finding that out
costs two loads per level on two cold cache lines, plus an out-of-line
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

v1 -> v2 (Tejun):
- Rename blkcg_congested_blkcgs to blkcg_nr_congested to make it clear
  that the global tracks a count rather than a boolean.
- Warn if blkcg_css_free() finds a residual congestion_count, while still
  dropping its contribution so it cannot disable the fast path permanently.
- Use atomic_dec_and_test() for the congestion_count 1 -> 0 transition.

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

