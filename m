Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1868F3E5EF7
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 08:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153801; cv=none; b=Utq/Z1BL0RxexH5p0YZ9g9cDLbjAQiNHVPOpUYv7idhn/zCJuiXEAf7WfdSQ/nEws6eQ3WWy6W6r+xXb28SEVe04p5usfyrYffi5SS5mdZQzzf0hwqmzkEKm0aveFY4Yyzr9JjlgII8lpD/k9+qWjhUPekoPlgx5F37MAT5UVO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153801; c=relaxed/simple;
	bh=dnPq4pRHlT6hpC3lghdvKVIgRaHtyf+n6DAJtS+2gSk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ByrEzPukOq3AbpZk4Axlw6kgT/XI6LHon7yIxTti76TgWc2S/VsmlZqgXVreuR98EO7xYmkQHVlwHxXm49POCnU0Kdwck+JUXv/GTfbEAs9cBn5Bfme0aSAULdsAVFNXjw70xAB4L1TRjI1Zhbmq9Wm53Q3y6Qxr7lLPIufvUZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oXZF0OB+; arc=none smtp.client-ip=91.218.175.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oXZF0OB+"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dnPq4pRHlT6hpC3lghdvKVIgRaHtyf+n6DAJtS+2gSk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790153798; v=1; x=1790758598;
 b=oXZF0OB+RmD1ab//9L5cZkloiO/n5jwMqKIhXAmLw8oQMSx01KHbWJKNDs3pi0AcXov9BFlj
 DZcCPXAFG/tHpnopAoOfAv31RtBK6NhraJo+kf8gJLaQKaM1TK2YNCc8d8CPq45bhGcRoqkh8Q8
 Ut4CcAiIJ7FE6fxYkZC00BjU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a3c32f82d4955334;
	Wed, 23 Sep 2026 08:56:37 +0000
X-Mizu-Trace-ID: a3c32f82d4955334
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
Subject: [PATCH] cgroup/cpuset: Cancel CPU transfer when housekeeping check fails
Date: Wed, 23 Sep 2026 16:56:24 +0800
Message-ID: <20260923085624.172022-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Widening an isolated child partition to include the last kernel-noise
housekeeping CPU invalidates the partition, but the CPU transfer
computed before the housekeeping check is still applied:

    WARNING: kernel/cgroup/cpuset.c:1315 at partition_xcpus_add+0x61/0x70, CPU#1: sh/1052
    Call Trace:
     <TASK>
     update_parent_effective_cpumask+0x320/0xa30
     cpuset_write_resmask+0x1e6/0x7c0
     </TASK>
    ---[ end trace 0000000000000000 ]---

This can be reproduced on a 32-CPU system booted with nohz_full=1:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir A B C C/child
    echo 0 > A/cpuset.cpus
    echo isolated > A/cpuset.cpus.partition
    echo 4-31 > B/cpuset.cpus
    echo isolated > B/cpuset.cpus.partition
    echo +cpuset > C/cgroup.subtree_control
    echo 2-3 > C/cpuset.cpus
    echo root > C/cpuset.cpus.partition
    echo 3 > C/child/cpuset.cpus
    echo isolated > C/child/cpuset.cpus.partition
    echo 2-3 > C/child/cpuset.cpus

The last write returns 0 and leaves the hierarchy in this state:

    root (cpuset.cpus.effective=1)
    |
    +-- A (isolated):       cpuset.cpus=0
    |                       cpuset.cpus.effective=0
    +-- B (isolated):       cpuset.cpus=4-31
    |                       cpuset.cpus.effective=4-31
    \-- C (root):           cpuset.cpus=2-3
        |                   cpuset.cpus.effective=<empty>
        \-- C/child (invalid isolated):
                            cpuset.cpus=2-3
                            cpuset.cpus.effective=<empty>

Before the last write, C owns CPU 2 and C/child owns CPU 3. The last
write changes C/child's CPU mask from 3 to 2-3, which would transfer
CPU 2 from C to C/child.

The housekeeping check invalidates C/child, but delmask still contains
CPU 2 while addmask is empty. partition_xcpus_add() therefore removes
CPU 2 from C and warns because the new partition state is invalid.
CPU 3 is not returned when C/child is invalidated, leaving both CPUs
unavailable to any valid partition.

Handle PERR_HKEEPING like PERR_NOCPUS: cancel the pending transfer and
rebuild addmask from the CPUs currently held by the child. This leaves
CPU 2 in C and returns CPU 3 to C.

Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 753aa65afcd7..a4ead0d3c872 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1929,6 +1929,17 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			    /* Adding to parent means adding isolated CPUs */
 			    !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
 				part_error = PERR_HKEEPING;
+			if (part_error == PERR_HKEEPING) {
+				/*
+				 * Fall back to returning all the granted
+				 * CPUs to the parent instead of applying
+				 * the pending change.
+				 */
+				deleting = false;
+				adding = cpumask_and(tmp->addmask,
+						     cs->effective_xcpus,
+						     parent->effective_xcpus);
+			}
 		}
 
 		/*
-- 
2.43.0

