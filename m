From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v6 0/4] memcg: Slow down swap allocation as the available space gets depleted
Date: Wed, 27 May 2020 12:58:42 -0700
Message-ID: <20200527195846.102707-1-kuba@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590609529;
        bh=cceq0nslNmPBHRGNvAoKjcHO4wn3WWeH8aZ2B6tbH7E=;
        h=From:To:Cc:Subject:Date:From;
        b=vsS3GJQY+3GrTaTAyo2NBKB3ea2HqlQR2dkWOfILWtaR4A+ZpBr3yneZCZEF9Hv2z
         sx4UHToiQuGHNRbjtIN2L6mteYz2c4iX5C3zYKGiE4pDoX4gJRdt13QfD9+GktJbsA
         OXmFO+iwSCBivypAZJPtHqhtl6PPsK8yVcKgvUVg=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Tejun describes the problem as follows:

When swap runs out, there's an abrupt change in system behavior -
the anonymous memory suddenly becomes unmanageable which readily
breaks any sort of memory isolation and can bring down the whole
system. To avoid that, oomd [1] monitors free swap space and triggers
kills when it drops below the specific threshold (e.g. 15%).

While this works, it's far from ideal:
 - Depending on IO performance and total swap size, a given
   headroom might not be enough or too much.
 - oomd has to monitor swap depletion in addition to the usual
   pressure metrics and it currently doesn't consider memory.swap.max.

Solve this by adapting parts of the approach that memory.high uses -
slow down allocation as the resource gets depleted turning the
depletion behavior from abrupt cliff one to gradual degradation
observable through memory pressure metric.

[1] https://github.com/facebookincubator/oomd

v5: https://lore.kernel.org/linux-mm/20200521002411.3963032-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
v4: https://lore.kernel.org/linux-mm/20200519171938.3569605-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
v3: https://lore.kernel.org/linux-mm/20200515202027.3217470-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
v2: https://lore.kernel.org/linux-mm/20200511225516.2431921-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
v1: https://lore.kernel.org/linux-mm/20200417010617.927266-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/

Jakub Kicinski (4):
  mm: prepare for swap over-high accounting and penalty calculation
  mm: move penalty delay clamping out of calculate_high_delay()
  mm: move cgroup high memory limit setting into struct page_counter
  mm: automatically penalize tasks with high swap use

 Documentation/admin-guide/cgroup-v2.rst |  20 +++
 include/linux/memcontrol.h              |   4 +-
 include/linux/page_counter.h            |   8 ++
 mm/memcontrol.c                         | 177 ++++++++++++++++++------
 4 files changed, 160 insertions(+), 49 deletions(-)

-- 
2.25.4

