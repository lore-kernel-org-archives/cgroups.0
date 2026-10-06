Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEE837BE6C;
	Tue,  6 Oct 2026 17:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791308155; cv=none; b=MzjxAXAdzOch1eyzCZi2SYg1dY5DLSgxWa25g0mlk+SWsJQzm8z5+3Sqgtvjg6KdauZO5Hp0vdyXnL8BBttaxEVRCq+nPti4baJ0DFqTj8edzBkwr8XBjEedtlHtgC1k5Qf00xy0jyTqF1fDYEn7RtGosI3+oYornUM8sBT3aFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791308155; c=relaxed/simple;
	bh=3PHxfy44ueqEECZvpxH6GtKowBvztYpyUkuV0+vh1Ic=;
	h=Date:Message-ID:From:To:Cc:Subject; b=dGk8bHGRn/ZvSWd9yxatORi28mFlkaHPRbXkYJPlWIp6GbbK6gEtheUDrKZsChHMkjrJ7qPUcJAe7ckW4DfNDizoiwHw6LjsT9fiH2ahorkoHYL0JyrgD83x7NzvzBz8Ce8ZT7ynM4/GXJj6MbAWGUYdnpWlwLE/6qrzeuVP7W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AAj72/GB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AAj72/GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FABF1F0089B;
	Tue,  6 Oct 2026 17:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791308153;
	bh=Nw1XUf6ETcnOGKrSuNKQAKotVEwuPtqzIuy/Ix7cfJ8=;
	h=Date:From:To:Cc:Subject;
	b=AAj72/GBFqfJkEx1UDGYid+eDMjpK6Ti4mZbLHgqIbbjiUs7SLxKhhV5eC/hsB3Iw
	 UTL9ulDpVAMPxi9KKmhV8VZ4y6WmpiIjQMBY4HwIwvSvO8rDYkS9DN2IHyOCEopuLk
	 7fMlRP7vz/71SbdUYFmOZ9wMz5R/maszFobUD7ZXMoniO4REImwCMceDlFAetwfRD6
	 OidhKA4w/N3GrWXAtK+eUZVyBlDeXAAiZSWQK2ehUb3B8CSvAaVRwnkdgNpGMXQJZ6
	 DaFkw/7SaxY8pYTlXsxK2AVLinJKh0O1kikY97WtR+tPKqFlG/LjnroYnsBQWuX3Xz
	 FAFlHGitw543A==
Date: Tue, 06 Oct 2026 07:35:52 -1000
Message-ID: <e2cbf80a5cffa62a2dfcea51b4fa7ac1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Fixes for v7.3-rc6
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

The following changes since commit 31c88350b7dd1522792f726f79607f31bb55c50f:

  cgroup/cpuset: Return PERR_NOCPUS in remote_partition_enable() on subpartitions_cpus conflict (2026-09-26 08:07:26 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc6-fixes

for you to fetch changes up to b8eb5fd5bdb4c03758b056c70e5e1d962ca89757:

  cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug() (2026-10-06 06:36:51 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.3-rc6

- During CPU offline, the active mask drops the CPU before cpuset updates
  the effective CPUs, so a task placement in that window could find no
  active CPU in the top cpuset and dereference NULL. Restore the NULL check.

- The cpuset v2-mode test read the subsystem's root pointer, which is stale
  during a cgroup filesystem rebind, and the hotplug handler evaluated it
  before taking the cpuset mutex. Record the mode in a flag and test it
  under the mutex.

----------------------------------------------------------------
Waiman Long (3):
      cgroup/cpuset: Don't access cpuset_cgrp_subsys.root in is_in_v2_mode()
      cgroup/cpuset: Handle cpu hotplug race in guarantee_active_cpus()
      cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug()

 kernel/cgroup/cpuset.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

-- 
tejun
