Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D20264;
	Sun, 12 Jul 2026 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783878382; cv=none; b=YmDiINhxtLlF4qC0QVB7uqDp9MbnMExfCmpnlpDb/1dt8LSlQiZ+2wkJ4O3AaJjga7tCB+SMW5j7Sb0H0s+nnp9a4M5jXKkKDz7JdlcNQ2D2N5lEOJhN65QLe0Ktkcv6ux16bXFxd2yVw/K/WrP1bg+oZrsTZD/hccAazQ1SaF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783878382; c=relaxed/simple;
	bh=Ev5wa60DEOwIxPeL5BdpvBH45SUZ+vQMZKUDXqJJwKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lnxaUhSE/P6wPXfIRykv1f/l5hdbpB7zQZy3zzluStNPahObwOnTXY8XHmA3ruetEcxIR6EVDeczRQR2yy5vbS65CoPzDejkSECX0GTOYBSKBt/FM0soFBxeJ0hpipatG6uKS9BhXk9T3mnB5GFd4fa/eI33ON6KvoDyx1pocO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVmMcjmT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVmMcjmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61B11F000E9;
	Sun, 12 Jul 2026 17:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783878381;
	bh=kRg62pWz4XkNJnNd6d1PFoQbgUxWyXl6wWHRhz0Nf/4=;
	h=From:To:Cc:Subject:Date;
	b=bVmMcjmTIRgcQD44b2YW+cHjRS9OhfbABXW3GMNvXTXy/TQZCqqCw0vkkb/JjWNDv
	 OY+ZlQx3RQFcNXNmKs6iCVxOaMC3Oa0gmWh4gHqt9tdahcRK7Vr1GNxCsTH5BhJSzR
	 wYskKq2OeYRPTzcDHZC4apr5vbFSgjnkIoueVZS5Mk4etvBlfJpC4XkOCkjKvdkSIU
	 PAsqIeKNWVRaC4yJKLU/+2iJEH+FtEjnBPb1x6/h9s2WWfiWfI9WZ4kcyEX1OcQjW7
	 Iv6Yhs2SWd7S20D5nYrYWwf85y/QE1+Cm4A8hp8dz43K7+e76C6R1HnsIwSbffSpSu
	 vRbJhEkSMKnMg==
From: Tejun Heo <tj@kernel.org>
To: Matt Fleming <matt@readmodwrite.com>
Cc: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Edward Adam Davis <eadavis@qq.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	"ziwei . dai" <ziwei.dai@unisoc.com>,
	"ke . wang" <ke.wang@unisoc.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@cloudflare.com,
	Tejun Heo <tj@kernel.org>
Subject: [PATCHSET v2] sched/psi: Fix psimon fork deadlock and rtpoll_timer UAF
Date: Sun, 12 Jul 2026 07:46:17 -1000
Message-ID: <20260712174619.3553231-1-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

v2: - Retagged sched/psi (was cgroup) (patch 1).
    - Added a fix for a pre-existing rtpoll_timer use-after-free that the
      Sashiko AI review flagged on the previous posting (patch 2).

v1: https://lore.kernel.org/r/20260710134945-psimon-fix-tj@kernel.org

a5b98009f16d ("sched/psi: fix race between file release and pressure
write") made pressure_write() fork the psimon kthread while holding
cgroup_mutex, which deadlocks against the sched_ext enable path blocking
forks before grabbing cgroup_mutex. Patch 1 moves the fork outside
cgroup_mutex. Patch 2 fixes the use-after-free from a schedule attempt
re-arming group->rtpoll_timer behind psi_trigger_destroy() by shutting
down the timer when the group is freed.

Matt, patch 1 is unchanged from the previous posting except for the
subject prefix, so test results against that posting still apply.

Peter, once these are reviewed and tested, how do you want them routed?
I can take them through the cgroup tree if that works for you.

Patches:

  [PATCH 1/2] sched/psi: Create the psimon kthread outside of cgroup_mutex
  [PATCH 2/2] sched/psi: Shut down rtpoll_timer in psi_cgroup_free()

Based on cgroup/for-7.2-fixes (97fef6025844).

 include/linux/psi.h    |  4 ++-
 kernel/cgroup/cgroup.c | 23 +++++++++++++++-
 kernel/sched/psi.c     | 75 +++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 84 insertions(+), 18 deletions(-)

Thanks.

--
tejun
