Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125E4486629
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790159851; cv=none; b=k0SDTKkjOl1GR+zDAd2nal2T4eiK0rwDUJ67zstp2V/1//ZYftKtLwZrmH/0gz47NPgi/Ca26JMdN1RmJIc+i++FsyLmHaGhdWGhFNHushnXHgdJk4Onpuo2/49ctbTi3/BBcd9qxViGpfju66ZktM7wDns0kSNyAKwmljAi538=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790159851; c=relaxed/simple;
	bh=Bq0ff2gv/UHRjarH2GN7xGen9tMW4H7bNXzTOHWysEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bk4DE1eSyzBtTsG2pNN3sExcLmTMEny+Rb1hFeOqbBXehe3nCRBvB0hkXBC/1JtmJ/5dnWKy/paKONsUWnr1IOFv1tXXsGjW9vvUNR3TdKxi4qbbEQ6ejHFfu480G64LmbdOf91dW3we9zbffj43A7pd31lDBswDs0JeuQxYRqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K3EfguS3; arc=none smtp.client-ip=95.215.58.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K3EfguS3"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Bq0ff2gv/UHRjarH2GN7xGen9tMW4H7bNXzTOHWysEQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790159826; v=1; x=1790764626;
 b=K3EfguS3Cl1NhWUozDiSVUFS0U/tvshJmQv0xSHvgpX0B5pcxoflv4OZEWrhpdp+O15pLbRg
 x/Am/kxErAjte0bSHtzoUFDrgu4iGFB5F5KaZ2AWNTGf6CIwAhGGU0edFLecLEvd4koSyBqUR6R
 pNmMJYbKS7o6Vw5G1ZBM+L/8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 68f248386876b284;
	Wed, 23 Sep 2026 10:37:06 +0000
X-Mizu-Trace-ID: 68f248386876b284
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
Subject: [PATCH] cgroup/cpuset: Invalidate remote partition on housekeeping conflict
Date: Wed, 23 Sep 2026 18:36:57 +0800
Message-ID: <20260923103657.186937-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Widening an ancestor's exclusive CPU mask can add a boot-isolated CPU
to a valid remote partition root without touching the partition's own
control files. The partition then load balances that CPU, silently
defeating isolcpus=domain for it.

This can be reproduced on a 32-CPU system booted with
isolcpus=domain,4:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir -p A/B
    echo +cpuset > A/cgroup.subtree_control
    echo 2-4 > A/cpuset.cpus
    echo 2-3 > A/cpuset.cpus.exclusive
    echo 2-4 > A/B/cpuset.cpus
    echo 2-4 > A/B/cpuset.cpus.exclusive
    echo root > A/B/cpuset.cpus.partition
    cat A/B/cpuset.cpus.effective               # 2-3
    echo 2-4 > A/cpuset.cpus.exclusive
    cat A/B/cpuset.cpus.partition               # root
    cat A/B/cpuset.cpus.effective               # 2-4

The last write returns 0 and leaves the hierarchy in this state:

    root (cpuset.cpus.effective=0-1,5-31)
    |
    \-- A (member):           cpuset.cpus=2-4
        |                     cpuset.cpus.exclusive=2-4
        \-- B (root, remote): cpuset.cpus=2-4
                              cpuset.cpus.effective=2-4

B is a remote partition: it takes its CPUs directly from the root
cpuset, and A only passes its exclusive list down. Before the last
write, that list is 2-3, so B holds 2-3 and CPU 4 stays in the
root cpuset as a boot-isolated CPU. The write widens A's exclusive
list to 2-4, which additionally grants CPU 4 to B. Nothing rejects
the grant: B remains a valid root partition, and CPU 4 is still
listed in cpuset.cpus.isolated while sitting in a load-balanced
partition.

remote_partition_enable() and validate_partition() already call
prstate_housekeeping_conflict() before granting CPUs. The ancestor
update path in remote_cpus_update() does not. Add the missing check so
that the existing prs_err path invalidates the remote partition instead
of adding the boot-isolated CPU.

Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 753aa65afcd7..362e5b5dccaa 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1699,6 +1699,8 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		else if ((prs == PRS_ISOLATED) &&
 			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
 			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
+		else if (prstate_housekeeping_conflict(prs, tmp->addmask))
+			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
 		if (cs->prs_err)
 			goto invalidate;
 	}
-- 
2.43.0

