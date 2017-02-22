From: Laurent Dufour <ldufour-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 0/2] mm/cgroup soft limit data allocation
Date: Wed, 22 Feb 2017 16:58:09 +0100
Message-ID: <1487779091-31381-1-git-send-email-ldufour@linux.vnet.ibm.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The first patch of this series is fixing a panic occurring when soft
limit data allocation is using soft limit data.

The second patch, as suggested by Michal Hocko, is pushing forward by
delaying the soft limit data allocation when a soft limit is set.

Laurent Dufour (2):
  mm/cgroup: avoid panic when init with low memory
  mm/cgroup: delay soft limit data allocation

 mm/memcontrol.c | 54 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 14 deletions(-)

-- 
2.7.4
