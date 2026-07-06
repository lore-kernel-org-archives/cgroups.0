Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366253859E0;
	Mon,  6 Jul 2026 08:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783326043; cv=none; b=VO1ZE0TE9xLDpGVqYA1hMDhRDFE95kq7spWAnBfLQ2giV6OVY5ai1zWKoIUJCUaJTQ3Mkonc8Sz+oOZSfcd7K0mzIQ/SX2P93WQZ1ReycsUAEfcCu/TaLNX/tisxFFFvf4kLMny6rC+s6SFt8UN/Xqaw7BKTXf+SbhBAMOtQw48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783326043; c=relaxed/simple;
	bh=+ePsTDZ+8Ds8k2C9nCp58a2paqwfVPVBLJzKsNH7N+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b0CjfovgS9yVxabuM7yRSSSvxBj+PBie/nGaI7QfqfK4zBV2a5H2HOxv8/9OnH6sw+rFsr7505R0Mfck/KRXUx+4SRW7Q9jaH2bUrCxatxEUW8QIxJNIrL6zISGpO+JliCJRFBvH2IKrx3cLXYAGm9v0K6w2tzlx/M+CTOepwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVCzimyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVCzimyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D432F1F000E9;
	Mon,  6 Jul 2026 08:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783326032;
	bh=YnYW7gijRWIjSN0XiWehcJ0WWReETZpoC/sP90hYzHE=;
	h=From:To:Cc:Subject:Date;
	b=aVCzimyHl9Pf4Otyx+cVBSBvCfDVz5GEKxCv4yk2/DaL5sdCxQuUGd3nqsWBpVnBR
	 /Ae/h+1PmeH9AY3XWOMcW4VHEf0E5PaOjvW3XcK2a6F2TmJPOTI4VZCer0uuGTfqL2
	 gKe++kwH3eh81zgzhRS2gkJBQ/ltMTA19GyxeVllepgC/vgWb/2MvX2WyXpN22OpA7
	 TUY7Uc7SGDAWXr5jbnfOZrPZwx+1goV+dAWdS02vNjz+BRiB53n/P0jRbcD9jXMTye
	 8H0aIuntWklsEtmD4v+NVFJ29x5dSu7WyU7yjHzRtwl3CLfAejg2hsZefxKygm4n95
	 n0vegptLfPzeA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Gregory Price <gourry@gourry.net>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Zi Yan <ziy@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	stable@vger.kernel.org,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH v3] cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
Date: Mon,  6 Jul 2026 10:20:23 +0200
Message-ID: <20260706082023.60832-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Farhad Alemi <farhad.alemi@berkeley.edu>

Creating a child cpuset where cpuset.mems is never set leads to a div/0
when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
CPU hotplug event.

Reproduction steps:
 1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
 2) Move the task into the child cpuset
 3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
 4) unplug and hotplug a cpu
      echo 0 > /sys/devices/system/cpu/cpu1/online
      echo 1 > /sys/devices/system/cpu/cpu1/online
 5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
    call to __nodes_fold()

The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
nodes to the rebind routine.  Use cs->effective_mems instead, which is
guaranteed to have a non-empty nodemask once we reach that code path.

Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Closes: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: <stable@vger.kernel.org>
[ david: add a comment, slightly rephrase description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 kernel/cgroup/cpuset.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 591e3aa487fc1..45944b3e31ca4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2653,7 +2653,12 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
 
 		migrate = is_memory_migrate(cs);
 
-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		/*
+		 * For v1 we can have empty effective_mems, but we cannot
+		 * attach any tasks (see cpuset_can_attach_check()). For v2,
+		 * effective_mems is guaranteed to not be empty.
+		 */
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else

base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.43.0

