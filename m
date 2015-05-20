From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 0/2] Reduce overhead of memcg when unused
Date: Wed, 20 May 2015 13:50:43 +0100
Message-ID: <1432126245-10908-1-git-send-email-mgorman@suse.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-CGroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

These are two patches to reduce the overhead of memcg, particularly when
it's not used. The first is a simple reordering of when a barrier is applied
which memcg happens to get burned by.  I doubt it is controversial at all.

The second optionally disables memcg by default. This should have
been the default from the start and it matches what Debian already does
today. The difficulty is that existing installations may break if the new
kernel parameter is not applied so distributions need to be careful with
upgrades. The difference it makes is marginal and only visible in profiles,
not headline performance. It'd be understandable if memcg maintainers
rejected it but I'll leave it up to them.

 Documentation/kernel-parameters.txt |  4 ++++
 init/Kconfig                        | 15 +++++++++++++++
 kernel/cgroup.c                     | 20 ++++++++++++++++----
 mm/memcontrol.c                     |  3 +++
 mm/memory.c                         | 10 ++++++----
 5 files changed, 44 insertions(+), 8 deletions(-)

-- 
2.3.5
