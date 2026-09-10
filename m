Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD423AF65B
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 09:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033587; cv=none; b=RumEXEOh7BQeaG20JAV9sfeYqh7fDjkyuzbWxdYnUdFWxLnkWKAnTGGDJa/AO7tFb7OWqFohlQq+329nUd8JsgC9hZ/3GCqJmYXymOgWECKlLGYY+Pta2htLhyBokpNRCvbeP1Bfo2dsahgzJvXxyPVG8ha4eYRn7or0ZoCZ2Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033587; c=relaxed/simple;
	bh=1s0sTBKgmDXAyT/yWUt1Cx4H07lp4AXlO812CGcK5cg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g1EWyZ0x7lMRrKxvV228lT5hrQwAsYPv6LPC+AIKbcAzpjKgy/bMNbjqLfnJWeBAG/bu/Si0oQqS3SSqPOOFnqvntIQkFXR3F2pt1P6zyuFKOgH9WCZC3jN4uVr0CB+lyHav4UrNStD4/cVG7ytoH6/DRcln8sQM+MV/SIOlHY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=blMD8T1A; arc=none smtp.client-ip=95.215.58.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="blMD8T1A"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1s0sTBKgmDXAyT/yWUt1Cx4H07lp4AXlO812CGcK5cg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789033580; v=1; x=1789638380;
 b=blMD8T1AfzsQdjle660JGRIK4zfXJSdA+KEA3EIQHXyiL/KZL8vf4Lmq3SG8qrgicr8VCgBv
 326qLFJCQJ6RP92ZwSDIzaKzwOuxvE4jux6ijJsDbpX5c+i/OlH5gncrTQqLjL/qU1m4OuPywsy
 o+WppX6FhQl3/RCD59UOHPNE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 23d0f6ffbb5a8dda;
	Thu, 10 Sep 2026 09:46:20 +0000
X-Mizu-Trace-ID: 23d0f6ffbb5a8dda
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>
Subject: [PATCH v4 0/7] cgroup/cpuset: Fix partition transitions and invalidation
Date: Thu, 10 Sep 2026 17:45:39 +0800
Message-ID: <20260910094546.5852-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several partition type-change and validation paths use effective_xcpus,
which also includes CPUs assigned to valid child partitions. As a result,
changing a parent between root and isolated can alter a child's isolation
accounting or fail housekeeping validation because of CPUs the parent does
not own.

A proposed parent CPU mask needs different treatment for children which
would become invalid under that mask. CPUs they can no longer retain must
be accounted for under their new owner, including in the parent's
housekeeping validation. Otherwise a parent can pass validation with a
boot-isolated CPU hidden behind a child which is about to become invalid.

There are related problems in the paths which apply CPU mask changes and
propagate partition invalidation. Child validation can use an old parent
exclusive mask, CPUs released by an invalid child can retain their former
isolation state, and a later hierarchy walk can incorrectly make an
out-of-mask child valid again. Configured masks are also published too late
for partition update paths which inspect or revisit the cpuset.

Factor the child invalidation checks into cs_partition_error() and keep the
complete parent exclusive mask and the remaining active mask explicit at
its call sites. Use directly owned CPUs for root/isolated type changes and
housekeeping validation, invalidate the appropriate isolated ancestor when
the last housekeeping CPU is returned, and release partition CPUs after a
failed type-change validation.

Use newly computed masks when invalidating children, update isolation
accounting according to the partition receiving each CPU, prevent
out-of-mask children from being revalidated, and publish configured masks
before partition updates can inspect or revisit the cpuset.

This v4 contains only the seven cpuset implementation patches. Patches 1-3
correspond to the three implementation patches in v3; patches 4-7 add the
related fixes for child invalidation, propagated isolation accounting and
publication of configured CPU masks. The selftests from v3 and the
additional regression tests are kept locally for validation. I plan to
submit them as a separate series after these fixes are accepted.

Testing:

The previously reported local results, using the selftests retained
outside this series, are:

- Partition type-change tests with isolcpus=domain,15: all applicable
  tests passed.
- Housekeeping CPU-return tests with
  nohz_full=1-14 isolcpus=domain,15: both cases passed.

Changes in v4:

- temporarily drop all selftest patches, including those posted in v3,
  as the current test design needs rework and some cases are redundant;
  retain them locally for validation and submit them as a separate series
  after the fixes are accepted;
- rename child_partition_error() to cs_partition_error(), document its
  inputs and keep the complete and remaining CPU masks explicit;
- add the related child-invalidation, propagated isolation-accounting and
  configured-mask publication fixes as patches 4-7;
- keep child containment, invalid-partition recovery and direct isolation
  accounting in the same patch around
  compute_partition_effective_cpumask();
- use the newly computed, unfiltered exclusive mask to validate children
  and account offline CPUs released by an invalid child;
- prevent a later hierarchy walk from revalidating an out-of-mask child;
- update isolation accounting when invalidation propagates through a
  member or invalid parent;
- publish cpus_allowed and exclusive_cpus before partition update paths
  inspect or revisit the cpuset.

Link: https://lore.kernel.org/all/20260902102615.79189-1-guopeng.zhang@linux.dev/

Changes in v3:

- factor the child partition validity rules into a preparatory patch and
  reuse them for trial ownership calculation;
- during trial validation, subtract only children which remain valid under
  the proposed parent CPU mask, covering both PERR_INVCPUS and PERR_NOCPUS;
- keep cs->effective_xcpus as the default isolation-accounting mask and
  use the directly owned mask only for a successful root/isolated type
  change;
- use an isolated child for the boot-isolated trial-validation tests, as a
  root child containing that CPU fails immediately with PERR_HKEEPING;
- make the isolated-ancestor walk safe when it reaches the top cpuset and
  clarify the member-transition handling;
- force hierarchy propagation after invalidating an isolated ancestor and
  verify task CPU masks and descendant partition states;
- move the test process back to the root cgroup and clean up nested
  housekeeping-return test cgroups on failure.

Link: https://lore.kernel.org/all/20260828095643.13395-1-guopeng.zhang@linux.dev/

Changes in v2:

- split the type-transition fixes from the original series;
- merge the child-owned accounting and validation changes;
- validate trial CPU masks against CPUs owned directly by the partition;
- handle a root child returning the last housekeeping CPU, including
  nested isolated ancestors;
- use the common partition-disable path after type-change validation
  failure;
- initialize boot-isolated CPU data during selftest setup;
- split the accounting, child-owned validation and housekeeping-return
  tests.

Link: https://lore.kernel.org/all/20260820124202.517160-1-guopeng.zhang@linux.dev/

Guopeng Zhang (7):
  cgroup/cpuset: Factor out child partition validation
  cgroup/cpuset: Account for child CPU ownership in partition changes
  cgroup/cpuset: Release CPUs when type-change validation fails
  cgroup/cpuset: Fix child invalidation after parent CPU changes
  cgroup/cpuset: Fix isolation accounting on propagated invalidation
  cgroup/cpuset: Publish cpus_allowed before partition updates
  cgroup/cpuset: Publish exclusive_cpus before partition updates

 kernel/cgroup/cpuset.c | 277 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 247 insertions(+), 30 deletions(-)

-- 
2.43.0
