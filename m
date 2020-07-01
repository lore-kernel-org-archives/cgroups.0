From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: [PATCH 0/2] arm64/kdump: Fix OOPS and OOM issues in kdump kernel
Date: Thu,  2 Jul 2020 03:44:18 +0530
Message-ID: <1593641660-13254-1-git-send-email-bhsharma@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593641692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=glPotn+K1T613CjdKByq3iS5Ne25OlUyrCXDnz2IEJI=;
        b=GIwxPYMxTKcoydC9vFpVsjxxv0acSNTJSi55AWiU+JwiCfEvWkpHfS86QIkLPkl4OJ9+H0
        3lkeF4f4dlIG/lqA8GK6Lz/z7P5Gw9kOeBngP7IkqYkzrNJD/3m8xJcUd8tZ73v/gG24uK
        LNI+/OUZLlmCMZlxNBVwbnwpqSSTHwY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org
Cc: bhsharma@redhat.com, bhupesh.linux@gmail.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, James Morse <james.morse@arm.com>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org

Prabhakar recently reported a kdump kernel boot failure on ThunderX2
arm64 plaforms (which I was able to reproduce on ampere arm64 machines
as well), (see [1]), which is seen when a corner case is hit on some
arm64 boards when kdump kernel runs with "cgroup_disable=memory" passed
to the kdump kernel (via bootargs) and the crashkernel was originally
allocated from either a ZONE_DMA32 memory or mixture of memory chunks
belonging to both ZONE_DMA and ZONE_DMA32 regions.

While [PATCH 1/2] fixes the OOPS inside mem_cgroup_get_nr_swap_pages()
function, [PATCH 2/2] fixes the OOM seen inside the kdump kernel by
allocating the crashkernel inside ZONE_DMA region only.

[1]. https://marc.info/?l=kexec&m=158954035710703&w=4

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kexec@lists.infradead.org
Reported-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>

Bhupesh Sharma (2):
  mm/memcontrol: Fix OOPS inside mem_cgroup_get_nr_swap_pages()
  arm64: Allocate crashkernel always in ZONE_DMA

 arch/arm64/mm/init.c | 16 ++++++++++++++--
 mm/memcontrol.c      |  9 ++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

-- 
2.7.4

