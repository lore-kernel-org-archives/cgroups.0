From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 0/3] Soft limit memory management bug fixes
Date: Wed, 17 Feb 2021 12:41:33 -0800
Message-ID: <cover.1613584277.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

During testing of tiered memory management based on memory soft limit,
I found three issues with memory management using cgroup based soft
limit in the mainline code.  Fix the issues with the three patches in
this series.  Also updated patch 3 per Johannes' comments on the first
version of this patch.

Thanks.

Tim

Changelog:
v2
1. Do soft limit tree uncharge update in batch of the same node only
for v1 cgroups that have a soft limit.  Batching in nodes is only
relevant for cgroup v1 that has per node soft limit tree. 

Tim Chen (3):
  mm: Fix dropped memcg from mem cgroup soft limit tree
  mm: Force update of mem cgroup soft limit tree on usage excess
  mm: Fix missing mem cgroup soft limit tree updates

 mm/memcontrol.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

-- 
2.20.1

