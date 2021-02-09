From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 0/3] Soft limit memory management bug fixes
Date: Tue,  9 Feb 2021 12:29:44 -0800
Message-ID: <cover.1612902157.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

During testing of tiered memory management based on memory soft limit, I found three 
issues with memory management using cgroup based soft limit in the mainline code.
Fix the issues with the three patches in this series.

Tim Chen (3):
  mm: Fix dropped memcg from mem cgroup soft limit tree
  mm: Force update of mem cgroup soft limit tree on usage excess
  mm: Fix missing mem cgroup soft limit tree updates

 mm/memcontrol.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

-- 
2.20.1

