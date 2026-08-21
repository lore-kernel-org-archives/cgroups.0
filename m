Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD9137267E
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 05:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787288717; cv=none; b=O2An2KbhZ/c+fJJAAW21lIuap4tB+WNasH6x9cWUT0IwTKF+8UOzPOa+tYFAuUQv/XIxgV6beFYaij3wqC+Zhqxgj0r95SP3320theGSTrJ87HC284oasewrT+eUdP++QRHFnRs1eXdHjnYMy4xryVf15gTDzzanh++Fb76DVeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787288717; c=relaxed/simple;
	bh=l5idBfOCsttOVVmfmLkwG1q+MlHBMS77pst0UKAT4Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WfcqA1+2NUrnEaI9f3Rw2o18Cdc7F5orri30mr+Us+E4L92qrLXCSXw+hjd2aPdYigwqqpbCdzvfpQkCKxY4SzTxl4Q6OZXVANp8LI9DH3nnCN1MP3p41J3vjQoqG9NVHk/HrPDASqJEdXwZiCkdgFrbCzbb+6XZy6myawnNNtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A/oQkiSt; arc=none smtp.client-ip=95.215.58.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A/oQkiSt"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=l5idBfOCsttOVVmfmLkwG1q+MlHBMS77pst0UKAT4Jo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787288714; v=1; x=1787893514;
 b=A/oQkiSt9jGsi3YvP4zjvjWflfel4S3gsaM/XA1v4RsLG0GE5s3l4bBJ06YUXRyciFZIMN+O
 NYspWoymK4pKbdj2EE4wkrVe5keF0KeT1ZkBdZ3c9A30CmoIH9dK+TMCMNee+/dnwSJAodXP9W7
 2B1le81tVJPGLAp+IZ6M9ciE=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:44::)
	by smtp.migadu.com with ESMTPS id 60ca7f2cd437be0e;
	Fri, 21 Aug 2026 05:05:13 +0000
X-Mizu-Trace-ID: 60ca7f2cd437be0e
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <christian@brauner.io>,
	Meta kernel team <kernel-team@meta.com>,
	driver-core@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] kernfs: remove kernfs_rwsem from dentry revalidation
Date: Thu, 20 Aug 2026 22:05:03 -0700
Message-ID: <20260821050507.2161607-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At Meta, we are seeing important system daemons that poll cgroupfs and
sysfs geth stuck in kernfs_dop_revalidate() for minutes. The two that
hurt most are the ones we can least afford to lose: oomd, which decides
what to kill when a machine runs out of memory, and below[1], which
records the telemetry used to understand what happened afterwards.

kernfs_dop_revalidate() takes kernfs_rwsem for read once per path component
of every walk into a kernfs mount. Linux rwsems do not permit reader lock
stealing once a writer is queued, so one writer -- a cgroup created or
destroyed, a device renamed -- parks the entire incoming reader stream in
uninterruptible sleep. Daemons polling cgroup files in a loop are exactly
the workload that turns this into a convoy, and cgroup churn is exactly
what a busy machine does.

Nothing the callback reads needs the semaphore. kn->active is an atomic_t
already tested lock-free elsewhere, kn->__parent and kn->name are RCU
pointers, kn->ns can be compared rather than dereferenced, and
parent->dir.rev is a plain counter.

  1/4 uses the parent inode and name the VFS already passes to
      ->d_revalidate() rather than recovering them from mutable dentry
      fields, comparing the name by explicit length
  2/4 annotates the directory revision counter for lockless access
  3/4 compares namespace tags by pointer
  4/4 removes kernfs_rwsem from the callback

LOOKUP_RCU still returns -ECHILD. kernfs_iop_permission() forces every walk
out of RCU-walk before children are revalidated, so lifting it here would
have no effect until that path is fixed; left to a separate series.

Readers walking cgroupfs and sysfs while another thread churns cgroups,
renames netdevs and adds/removes devices, on an 8-CPU VM:

                    kernfs_rwsem read   contentions   revalidate among
                        acquisitions                  top call sites
  before                  48,593,360     1,744,517    #1 and #2
  after                    1,280,280       429,846    absent

Reader path-walk throughput improved 35-53% over the same workload.

Tested against an unpatched control of the same tree, built and booted with
KASAN, KCSAN (default and STRICT), PROVE_LOCKING, PROVE_RCU,
DEBUG_ATOMIC_SLEEP and LOCK_STAT. The deactivated, renamed and
namespace-moved reject paths and negative-dentry invalidation all behave as
before. KCSAN_STRICT over 180s reports no data race involving
kernfs_dop_revalidate() or any field it reads, and there are no KASAN,
lockdep or might-sleep reports across millions of concurrent path walks.
The only kernfs KCSAN reports are in kernfs_refresh_inode(), present
identically on the control and addressed separately.

Link: https://github.com/facebookincubator/below [1]

Shakeel Butt (4):
  kernfs: Use VFS lookup context in d_revalidate()
  kernfs: Prepare directory revisions for lockless reads
  kernfs: Avoid namespace dereference in d_revalidate()
  kernfs: Remove kernfs_rwsem from dentry revalidation

 fs/kernfs/dir.c             | 76 +++++++++++++++----------------------
 fs/kernfs/kernfs-internal.h |  9 ++---
 2 files changed, 35 insertions(+), 50 deletions(-)


base-commit: 7079a12d7506b07fb53b54a664bfad5fa9b16d70
-- 
2.53.0-Meta

