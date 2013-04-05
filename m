From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 0/2] page_cgroup cleanups
Date: Fri,  5 Apr 2013 14:01:10 +0400
Message-ID: <1365156072-24100-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Hi,

Last time I sent the mem cgroup bypass patches, Kame and Michal pointed out
that some of it was a bit of cleanup, specifically at the page_cgroup side.
I've decided to separate those patches and send them separately. After these
patches are applied, page_cgroup will be initialized together with the root
cgroup, instead of init/main.c

When we move cgroup initialization to the first non-root cgroup created, all
we'll have to do from the page_cgroup side would be to move the initialization
that now happens at root, to the first child.

Glauber Costa (2):
  memcg: consistently use vmalloc for page_cgroup allocations
  memcg: defer page_cgroup initialization

 include/linux/page_cgroup.h | 21 +------------------
 init/main.c                 |  2 --
 mm/memcontrol.c             |  2 ++
 mm/page_cgroup.c            | 51 +++++++++++++++------------------------------
 4 files changed, 20 insertions(+), 56 deletions(-)

-- 
1.8.1.4
