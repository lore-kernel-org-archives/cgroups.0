From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 0/4] mm: memcontrol: populate unified hierarchy interface
Date: Mon,  4 Aug 2014 17:14:53 -0400
Message-ID: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=Message-Id:Date:Subject:Cc:To:From; bh=duQWQ+xHE3uvmTxU2znFwmRz67dBlJHQs8VCTL1cnFg=;
	b=TpkEhI0BB0n254UY67rRlxBIpuPPkBYlXTkW1g6aZbSHtKIwCzKFnfS9tuWozksTYMvzV15jjGLg6qYJksRtZ3vdGEis1G5Qt99hu+0/twgWABYt0XrU85j+ZSjilIG1II/xPsRsOG0uz8Z9Z5cebMsal5sUXQ3GnQCG2JnLg2c=;
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

the ongoing versioning of the cgroup user interface gives us a chance
to clean up the memcg control interface and fix a lot of
inconsistencies and ugliness that crept in over time.

This series adds a minimal set of control files to the new memcg
interface to get basic memcg functionality going in unified hierarchy:

- memory.current: a read-only file that shows current memory usage.

- memory.high: a file that allows setting a high limit on the memory
  usage.  This is an elastic limit, which is enforced via direct
  reclaim, so allocators are throttled once it's reached, but it can
  be exceeded and does not trigger OOM kills.  This should be a much
  more suitable default upper boundary for the majority of use cases
  that are better off with some elasticity than with sudden OOM kills.

- memory.max: a file that allows setting a maximum limit on memory
  usage which is ultimately enforced by OOM killing tasks in the
  group.  This is for setups that want strict isolation at the cost of
  task death above a certain point.  However, even those can still
  combine the max limit with the high limit to approach OOM situations
  gracefully and with time to intervene.

- memory.vmstat: vmstat-style per-memcg statistics.  Very minimal for
  now (lru stats, allocations and frees, faults), but fixing
  fundamental issues of the old memory.stat file, including gross
  misnomers like pgpgin/pgpgout for pages charged/uncharged etc.

 Documentation/cgroups/unified-hierarchy.txt |  18 +++
 include/linux/res_counter.h                 |  29 +++++
 include/linux/swap.h                        |   3 +-
 kernel/res_counter.c                        |   3 +
 mm/memcontrol.c                             | 177 +++++++++++++++++++++++++---
 mm/vmscan.c                                 |   3 +-
 6 files changed, 216 insertions(+), 17 deletions(-)
