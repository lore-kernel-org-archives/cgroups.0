Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E304A5EB7
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 22:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016705; cv=none; b=rwLtSV5g4bcCDiUMnV/w3X6fVY0A/XIOT+Gq7tqYKBCNjyH4FzvkDKG82Wzwu0uWoSICsXiJCmNhHlnr26eKfebdwG2/SRpyLib/+4YknMRh/DStHdVZr36MJOvSlKyGkjzdXgSciwSTtx3G+N1Q6TkCf2DKTuCHdpcCXzraStA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016705; c=relaxed/simple;
	bh=hRA0QmNCDYX9+z5uFKoRcS834j3w2oQc0PNKxc0kF08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K3flK2pZlD48ksCMcoMnqGsngqD8hyhjKsfiu12DEViOm4Osk9WP9fF4gwgOMa/bJSi8rhEh7FsNGleVax87OWYewnO7tbCh6dpi7gz2pjj0udycdIgEBv8SfUO6K2FLl0809V1NIcrv+jSpHkbmgWYRtKtzWywgGTRqUAgxjwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Ww1AdFpO; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Ww1AdFpO"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-53505bc6524so16777541cf.0
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 15:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792016701; x=1792621501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q7Ub4KDl09XJRSF6d4W+ZBSqnX35V2vs0yWYMavxzk8=;
        b=Ww1AdFpOxjAWwEd2TVi61o3OrrUwFU8pqTD9JM9iey9NzPFUOW18CuB6Q7nuT4ksY7
         hKM22/jJsJvPWS907Y9nQb/2At2OHHDS41d0ztzOPbushpR4sIQH+Z/N6PFDof4ZD2Mx
         DzWSy0hQu+dWVAMSz4VU2lXw+O2umonDtXlqIyYrJUyxtawvcU4GXOou+oCyag6kKqHA
         d+h7rHZwbvPZoQJIBsRyj/FlRb3BuD+XmNPdWaLdsTZ4cOyiP5iSeLTW8uNEjzQsRsXr
         ugwiW7kquJ7sMiHfCqBrVte5kzJcg2pWHTAdVE42jy/NXedk26eWMo0MKXX19UCfr1uU
         dS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792016701; x=1792621501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q7Ub4KDl09XJRSF6d4W+ZBSqnX35V2vs0yWYMavxzk8=;
        b=y4NI7i+4tTWxbL7r+1AaxmkjGvauktpaJ+lsuIBvuWMgW8sTB0pe9uHx7SjOlZi+3M
         8Ass4tOvTUv0LSllhZrZSZq4ws+hX/ZbMSSpRoyE7lqZhE/HaEQz0EkNtz5ZbEhEpaf3
         Q7lI+hEzWHhQx740QR1pN4n3yNSvNrQFjQ/1wsDZHw8hNb2vDDjxcUXL47BZj9b5B+AE
         ZCLaof/2vs+Zhl/e3aFzjQvpVrs44gp41BWKDToWXzWU40CDKUdJZR2BVJStvkjRCO6D
         6fSNArQPCcDEekWvg1v/k5aB/Q/4nCnLl4fcL9zoABc3Xm1m7rgk6Kki85FusEYNnGFq
         oAbQ==
X-Forwarded-Encrypted: i=1; AKwUvByAa4ptcvGzWVg7OpoTi1NmNf8srgObvYnnt+Hgq3xHeMdu/ARnrAgb2AU6asz5nrn/dpfaxyI8@vger.kernel.org
X-Gm-Message-State: AFq9FYJpeokPGcN9IHnsttMKHb79dkY68OaYArYgG6Nivh/iNsDbw0wq
	1Hu3hMMWclriZzZgTeiOMw40AH5/rKr5lKZ2/Gd6yPYHnLGQmpY9pGeaCUDwUOgQn+0=
X-Gm-Gg: AYBFou2+dpuYrTz4FzHWah6tKQT384aWged9EDDRaiQFn3mjIZ2BaRkypiZlg8Jl8oD
	swoMCcXBuEg8Kqy4d9de8VffE+rgNEDFv77iw262ZwPeO12lasOCOFQ5UI9wscLUW01qfKhBaD2
	76T8nn6gN563F+gvAFsRi5/zg1hAnYGVBnMYMWc1XPph9AVXhnakrojub64b5gpYPLI1qhM/E0t
	fe6BncUa36JE2jHCemWWm3ntT0SGUMiI1uc8IwRCIVo3RFuTH4BLLZPrOtOknT48zVHMkliGNS4
	g5Rvzbnde3kLiDGZ7w+SR1WR11jIBp+lARjpT6BeiWnR1ZhEyS+echMXowZqHdmwGCaT1KGd5z1
	LpyRPEpjDAlB8m+IxZ42FutrbRdMIgW1l7kLn4GnFC0qz+h0UJ98Gfhdy89H5PQWOG4gUbOExbC
	4EW6QKN7TBBVrPLyAdMTrfgSPeZdPf4ntug06+uusYDqUUG5LGqpSqB5CQxQinzmsKjir6+gJ8Q
	B8UG2xdehV46FFGF3dj2H3W6EJupMK9qpbKkJF7U48SqiUfvpSf9nWXQ35v
X-Received: by 2002:a05:622a:551b:b0:535:70b3:fa09 with SMTP id d75a77b69052e-535a628f4bfmr260621911cf.37.1792016701507;
        Wed, 14 Oct 2026 15:25:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536128418b2sm8652601cf.30.2026.10.14.15.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 15:25:00 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	david@kernel.org,
	mgorman@techsingularity.net
Subject: [PATCH 0/2] mm: fix two allocator races with zonelist and cpuset updates
Date: Wed, 14 Oct 2026 18:24:54 -0400
Message-ID: <20261014222456.2318284-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two small fixes for lockless allocator checks that can act on an
inconsistent view of state another CPU is updating.

Neither of these are stable-worthy.

Patch 1: the zonelist_update_seq retry is compiled out without
CONFIG_MEMORY_HOTREMOVE, but memory hot-add can also cause the race.
A __GFP_THISNODE allocation can observe this and fail to allocate.

Patch 2: cpuset_nodemask_valid_mems_allowed() compares a mempolicy
nodemask with mems_allowed without mems_allowed_seq. A concurrent
cpuset update can cause a spurious empty intersection and end up
relaxing an MPOL_BIND needlessly. This only covers task policies.

Reproducers
===========

Both races were reproduced on an unmodified kernel in a QEMU guest with
three NUMA nodes:
   node 0: 3G, CPUs 0-1
   node 1: 1G ZONE_NORMAL, CPU 2
   node 2: 1G ZONE_NORMAL, CPU 3

And a 512M pc-dimm cold-plugged on node 1, left offline at boot
(CONFIG_ACPI_HOTPLUG_MEMORY=y, CONFIG_MEMORY_HOTREMOVE=n).

The windows are a few instructions wide, so I used a test module to
widens them with a kprobe placed on a single instruction inside the
window.  This basically emulates an interrupt or vCPU preemption.

Patch 1 (zonelist):

  Online node 1's first memory block as ZONE_MOVABLE, which rebuilds
  node 1's zonelists.

  Stall the rebuild after it writes ZONE_MOVABLE into the first entry
  but before it writes ZONE_NORMAL into the second.

  On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1.

  Before: the allocation fails, 3/3 runs.
  After:  the allocation waits for the rebuild and succeeds, 3/3 runs.

Patch 2 (cpuset):

  Put a task in a cpuset with mems={0}
  set_mempolicy(2) the task to MPOL_BIND={0}
  Run the task on node2 (yes this is a little flagrant).
  
  Fill node 0 with HugeTLB pages to make allocations fail.
  Stall between the two loads in cpuset_nodemask_valid_mems_allowed().

  While stalled, change cpuset.mems={1,2}, this rebinds the task
  mempolicy to MPOL_BIND={1}.

  The check compares the old mems_allowed (0) with the new policy (1),
  finds no overlap, and drops the nodemask.

  Before: the allocation lands on node 2, 3/3 runs.
  After:  the allocation lands on node 1, 3/3 runs.

Gregory Price (Meta) (2):
  mm/page_alloc: detect zonelist rebuilds from memory hot-add
  cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask

 kernel/cgroup/cpuset.c | 13 ++++++++++++-
 mm/page_alloc.c        |  4 ++--
 2 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.53.0-Meta

