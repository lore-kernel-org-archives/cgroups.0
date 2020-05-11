From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v2 0/3] memcg: Slow down swap allocation as the available space gets depleted
Date: Mon, 11 May 2020 15:55:13 -0700
Message-ID: <20200511225516.2431921-1-kuba@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589237730;
        bh=pxjZnopLEhvVuE+hwn+nFyI+Zvw/0BY6mIaM+QZzV7A=;
        h=From:To:Cc:Subject:Date:From;
        b=DBRJCAly+tHOgZNaQm1yXJo14p3rpfNMkFGOf/JTiwFC8KbCSIDuK+9NMQxg1l1db
         4n9EbIX9vjTGND0oaWj7Dv3rRevFAGRUoKVbP/3+fdsPCYOT3Qpf+I4c6kW1Zw3wYi
         3uWV3g5tnzxSHDPldQgRgoZeKEb2DI88HJJ0u/kk=
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

v1: https://lore.kernel.org/linux-mm/20200417010617.927266-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/

Jakub Kicinski (3):
  mm: prepare for swap over-high accounting and penalty calculation
  mm: move penalty delay clamping out of calculate_high_delay()
  mm: automatically penalize tasks with high swap use

 Documentation/admin-guide/cgroup-v2.rst |  16 +++
 include/linux/memcontrol.h              |   4 +
 mm/memcontrol.c                         | 166 ++++++++++++++++++------
 3 files changed, 147 insertions(+), 39 deletions(-)

-- 
2.25.4

