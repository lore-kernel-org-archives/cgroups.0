Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794775723;
	b=W5VoyJZI8b3epZPNUAs0kbfP3ZYwjOf7hCNr9UF3JUUG334RFfHXZP7vREU9ALpTTsum
	 SAF67a0wSTnFscndlOAMcZYf7n8fppLF5NTce6je6biv6ORsOo9eIcNmE27hioGD3aF7j
	 k95CvvvbSN8lZkp6E3diWQ73pfw7iKAF1aMrkP5zxaI1rsg5ODS5YjdOS08q42oshgqjk
	 bsAvX7ROJ1PywwGz/YDSO5Pm8EEtw6eB+mSAymunapItL+0lI6XTDnqKsU/EN86QkRhFL
	 +tXeKSBlg7LW65Uy0H2IGgOTIpPk6yJafWPkuarov+kGYNXb2w+EIWwoDPvH3+W1yaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794775723;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject;
	bh=YXZFSoyqHDpxDPbL85Hd+JvHtAklYY9AhdF+mYJH6M4=;
	b=xT6A3qcJBhOIb+xJ7z+oK0bMFzl7k43TgleNKWCSFGqAT8RgeDPlwNTcmA/4y0u+b4lE
	 V80w90Y/java2aLaH/a0R/ZtzQBWN+Xyz6iz/AeSAQ7R955byn/byqKQUbrJKtXTOpI6c
	 zZT+3uzkv2IwmoPrZ6BFejrjUFvyWBQBJaTJ2WMX/HUdp/LVfNkKZVkjuf824UJdwwcsJ
	 MDXU07Ri13pvsld1yO06EUHVhmjSO4Po0psw6H6WVC/Z5Mp9puSjMaCEzLTwchspZfp+N
	 lQ8V/5w9ysFqQb72au2XDHlz191PX3Wy+9VMzqBGrMzsmoLeRKL4wbnOx87V+P9OjSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CL3+OQ3K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAF8606A323;
	Sun, 15 Nov 2026 20:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CL3+OQ3K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39DA1F000C4;
	Sun, 15 Nov 2026 20:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775722;
	bh=YXZFSoyqHDpxDPbL85Hd+JvHtAklYY9AhdF+mYJH6M4=;
	h=Date:From:To:Cc:Subject;
	b=CL3+OQ3Kg1EMfhonk48DtoCk4qu0AVNYDJxGCbKtLtAGloK7rDD+Or0Fh1HofXf7t
	 I/Q3V0IbNaBqF8gG5jQhTutrZSsucOx6IemfHnEFaVqV9V+0QC2EUnvNJfoNLBJtIp
	 zv4HUuY/M7M3HOit9QGea8+HQCzinOX3Q1VN95nRexRCva/yZqNWdHd0Cc0OXpFVjy
	 L5q30ZnOJJdXh1UhFw0/yqcpPDOmPP0Pt3SO3250fGycYLBr9ivvZ1/V7MvZQb/fKf
	 ov+7e9mKiSB3SEzWUPmg+ewc5bC9WTKXd/S7sgOj0s0RAY9OxdPZGY7Tm39Q6BJNS8
	 o9RN2AZETuSlA==
Date: Sun, 15 Nov 2026 10:48:42 -1000
Message-ID: <7a3f079589dddf1444f015b874f1b9ed@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Fixes for v7.4-rc2
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Hello,

The following changes since commit 518cec2def9992192291f5028edc077fb2e475e9:

  cgroup/cpuset: Integrate compute_partition_effective_cpumask() into compute_effective_cpumask() (2026-10-26 07:44:43 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4-rc2-fixes

for you to fetch changes up to acec9637e03ca54bd3c3a0c1a6ad5c6dfa07c0df:

  cgroup/cpuset: Don't revive invalid partition without active CPU on hotplug (2026-11-15 10:15:12 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.4-rc2

- A file notification racing the file's removal could re-arm the
  notification timer after it was shut down, corrupting the timer wheel or
  firing on freed memory.

- The v1 freezer could leave an exiting task frozen forever after its cgroup
  was thawed or removed.

- With memcg built without the block cgroup controller, memcg reclaim waited
  on writeback and could deadlock against a filesystem freeze. memcg now
  selects the controller.

- cpuset partition state could go wrong when CPUs move between nested
  partitions or go offline: isolated CPUs leaked or went missing, invalid
  partitions kept exclusive CPUs or came back with no usable CPU, and
  expanding a remote partition could fail. Separately, a forked child could
  inherit a corrupted memory node mask.

----------------------------------------------------------------
Chen Ridong (1):
      cpuset: add early empty cpumask check in partition_xcpus_add/del

Christian Brauner (1):
      memcg: make MEMCG select BLK_CGROUP

Mani Tofigh (2):
      cgroup: arm the notify timer only while the file exists
      cgroup/freezer: walk exiting tasks in the v1 freezer

Ridong Chen (5):
      cgroup/cpuset: Reset partition data when an invalid partition stays invalid
      cpuset: settle isolation state when CPUs are given back to parent
      cpuset: generalize the validate_partition() interface
      cgroup/cpuset: Remove redundant WARN_ON_ONCE() in remote_cpus_update()
      cgroup/cpuset: Don't revive invalid partition without active CPU on hotplug

Tejun Heo (1):
      cgroup/freezer: Fix exiting tasks left frozen forever after rmdir

Waiman Long (6):
      cgroup/cpuset: Fix incorrect CPU accounting with parent's effective_xcpus expansion
      cgroup/cpuset: Recompute effective cpumask in update_cpumasks_hier() after calling update_parent_effective_cpumask()
      cgroup/cpuset: Do housekeeping check when isolated child with root parent may get more xcpus
      selftests/cgroup: Fix "test_cpuset_prs.sh -v" failures
      cgroup/cpuset: Protect current->mems_allowed read in cpuset_fork()
      cgroup/cpuset: Correctly set isolated_cpus when switching partition state

 init/Kconfig                                      |   1 +
 kernel/cgroup/cgroup.c                            |  22 +-
 kernel/cgroup/cpuset.c                            | 316 +++++++++++-----------
 kernel/cgroup/legacy_freezer.c                    |  40 ++-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |  46 +++-
 5 files changed, 251 insertions(+), 174 deletions(-)

-- 
tejun
