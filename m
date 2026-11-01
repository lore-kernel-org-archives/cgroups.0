Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533353;
	b=gQmSQPy1vY2IGsj0r0CWg2OIt6Ade3Xul4g3OWJWZ+2/OxoaCWwHvlcofqKSLOkD5feu
	 aQWgfIWrwXPUwmgXZ/dYYL3sBnuRIh0WWEOAChcYvrovc78NsGEyITWA4jwW6/QxvGHqq
	 BMTY04xedd8T6s8LUcJlb27cpLoUZA9vp/bFTNDoABjyec9cMXzQVt98Om/sOC6ih/RwK
	 Br3nFG9x56XmV2WHeFv21yw6P8GDqE5K+Rq98YigVS4TB6KU5Q/KDhGPXa8/Jp8oEjb8A
	 BU9MyiZ19q/oydWUROaVBLtKPmBmxbten81SI1sTiBEKbjpUqhaqOy3nxc+YAaguskw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533353;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EanTznwx/0Aj/s3QT07UfcluAx0YVeP46HRwNlIZl5E=;
	b=o96aTSUsGVZcTra4l3h7BqVB9D5VsYNpw5G4GIMtlb8d7D3AkMAR1bFoML5I655XyWjC
	 01fj2g7WAYWPI4OknC4OfkgUWuEtMfO0lITXNtjiX5W3YOHXdG4jB4zzlmdJTENNO3AL4
	 IrYsXoceuKVXMqxpUUEz9M4i1FAlbyZHJ997K8TqrReMVm5gzzB4LoE93Smz1ewbecn7X
	 OVmQ9eUve51f1At1uZStxiOdhmXlGDwsDKGnb9j3YZVN4fUOyUv5jFOMyeG3r81DkbVsZ
	 mEPam+A64o66Jl0Ny/QlwnUJyVjM8f27PPu03A7KiiIv0StL90cqe0ym82SvC9/sf2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UjDyLK65;
	arc=none smtp.remote-ip=95.215.58.110
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EABF606A325
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EABF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UjDyLK65
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YY39keWneTLPZBamDlcA7DQOVwj7BemwZtli7jAgQeQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533350; v=1; x=1794138150;
 b=UjDyLK65y8cXHndyuZCZP6rjM+eF76MZb/tO8XI3/+58gj33DMrcbOgYHECBFxcwn8Zkn7By
 GYl4+76ONHeXw8taBYvdveO4pMCoL342V/7DN8OCQIBjyIBH2MRlCE1csgvTClNMlec/cRJ/Zv8
 5r7eNO5bCSSLKiLkw8pdUdpY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 25a5b28c65c94713;
	Sun, 01 Nov 2026 11:42:29 +0000
X-Mizu-Trace-ID: 25a5b28c65c94713
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Michal Koutn?" <mkoutny@suse.com>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH -v4 00/22] cpuset: rework local partition logic
Date: Sun,  1 Nov 2026 19:41:44 +0800
Message-Id: <20261101114206.2434398-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

There have been quite a few partition related fixes recently, most of
them caused by the scattered handling of partition state and the
isolated CPUs in different code paths. This convinces me again that the
rework of the local partition logic is necessary, so I am restarting
this series. As it has been a long time since the last posting, this
series is marked as RFC v4.

The current local partition implementation consolidates all operations
(enable, disable, invalidate, and update) within the large
update_parent_effective_cpumask() function, which exceeds 300 lines.
This monolithic approach has become increasingly difficult to understand
and maintain. Additionally, partition-related fields are updated in
multiple locations, leading to redundant code and potential corner case
oversights.

This patch series refactors the local partition logic by separating
operations into dedicated functions: local_partition_enable(),
local_partition_disable(), and local_partition_update(), creating
symmetry with the existing remote partition infrastructure.

After the rework:
- The code is reduced by about 90 lines (568 insertions, 657
  deletions), and the 312-line update_parent_effective_cpumask() is
  removed.
- Both local and remote partitions go through the same
  partition_enable(), partition_disable() and partition_update()
  helpers, and are validated by validate_local_partition() and
  validate_remote_partition() on top of the common
  validate_partition(). The structure and semantics of each operation
  are much clearer.
- The partition fields are updated in a unified way. The direct writes
  of partition_root_state are reduced from 6 places to 2, and the
  writes of prs_err from 12 places to 3, most of them now done in
  partition_state_update(). The isolation state of the CPUs given back
  to the parent is settled in partition_xcpus_del(), so
  isolated_cpus_release() is removed.

The series is organized as follows:

1. Infrastructure Preparation (Patches 1-3):
   - Code cleanup and preparation for the refactoring work

2. Introduce partition operation helpers (Patches 4-6):
   - Introduce out partition_enable(), partition_disable(), and
     partition_update() functions.

3. Use new helpers for remote partition (Patches 7-9)

4. Local Partition Implementation (Patches 10-13):
   - Separate update_parent_effective_cpumask() into dedicated functions:
     * local_partition_enable()
     * local_partition_disable()
     * local_partition_update()

5. Optimization and Cleanup (Patches 14-22):
   - Remove redundant partition-related operations
   - Additional optimizations based on the new architecture

base-commit: 6d0933ae9d46674a6ea63a87e9e9ab4e662670c9

---

Changes in RFC v4:
1. Rebase on the next-20261028 and adapt patches 3-22 to the current
   partition code.
2. Add patch 2 to settle the isolation state of CPUs given back to the
   parent in partition_xcpus_del(), replacing isolated_cpus_release().
3. Fix several issues of the hotplug, prs_err and remote partition
   update handling found in review and testing.
4. The issues fixed by Waiman's series [1] are also covered by this
   rework, and its new test cases pass with this series applied.

[1] https://lore.kernel.org/all/20261030190701.78308-1-longman@redhat.com/

RESEND: https://lore.kernel.org/all/20251225123058.231765-1-chenridong@huaweicloud.com/

Changes in RESEND:
1. Rebase on the next-20251219

Changes from RFC v2:
1. Dropped the bugfix (already merged/fixed upstream)
2. Rebased onto next
3. Introduced partition_switch to handle root state switches
4. Directly use local_partition_disable()—no longer first introduce
   local_partition_invalidate() before unifying the two
5. Incorporated modifications based on Longman's suggestions

Changes in RFC v1:
1. Added bugfix for root partition isolcpus at series start.
2. Completed helper function implementations when first introduced.
3. Split larger patches into smaller, more reviewable units.
4. Incorporated feedback from Longman.

Chen Ridong (21):
  cpuset: add early empty cpumask check in partition_xcpus_add/del
  cpuset: generalize the validate_partition() interface
  cpuset: introduce partition_enable()
  cpuset: introduce partition_disable()
  cpuset: introduce partition_update()
  cpuset: use partition_enable() for remote partition enablement
  cpuset: use partition_disable() for remote partition disablement
  cpuset: use partition_update() for remote partition update
  cpuset: introduce local_partition_enable()
  cpuset: introduce local_partition_disable()
  cpuset: use local_partition_disable() to invalidate local partition
  cpuset: introduce local_partition_update()
  cpuset: remove update_parent_effective_cpumask
  cpuset: remove redundant partition field updates
  cpuset: simplify partition update logic for hotplug tasks
  cpuset: use partition_disable for compute_partition_effective_cpumask
  cpuset: use validate_local_partition in local_partition_enable
  cpuset: introduce validate_remote_partition
  cpuset: simplify the update_prstate() function
  cpuset: remove prs_err clear when notify_partition_change
  cpuset: remove unnecessary validation in partition_cpus_change

Ridong Chen (1):
  cpuset: settle isolation state when CPUs are given back to parent

 kernel/cgroup/cpuset.c | 1225 +++++++++++++++++++---------------------
 1 file changed, 568 insertions(+), 657 deletions(-)

-- 
2.34.1

