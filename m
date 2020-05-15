From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v3 0/3] memcg: Slow down swap allocation as the available space gets depleted
Date: Fri, 15 May 2020 13:20:24 -0700
Message-ID: <20200515202027.3217470-1-kuba@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589574035;
        bh=P7ylBbnDPkXrGHK/uAPdYjg2MLbnpTgJJ00qvZ3qp38=;
        h=From:To:Cc:Subject:Date:From;
        b=x6QV70KfTY4U7aFjmudNZZrx1neH0SRoq5E45i9eURCIxREum4/9C9i1Aseq2AJe5
         Rcnfsi8kUH40ncqWae+1ASsjMjW3Cw2/bSRwtXnULOD+2QM65mvT8BaPJbno8ZyKAI
         KFPK0FxiLJ71kuacaMmLLrtrwTfLjT3DG7hZwn24=
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

v2: https://lore.kernel.org/linux-mm/20200511225516.2431921-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
v1: https://lore.kernel.org/linux-mm/20200417010617.927266-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/

Jakub Kicinski (3):
  mm: prepare for swap over-high accounting and penalty calculation
  mm: move penalty delay clamping out of calculate_high_delay()
  mm: automatically penalize tasks with high swap use

 Documentation/admin-guide/cgroup-v2.rst |  20 +++
 include/linux/memcontrol.h              |   4 +
 mm/memcontrol.c                         | 159 ++++++++++++++++++------
 3 files changed, 143 insertions(+), 40 deletions(-)

-- 
2.25.4

