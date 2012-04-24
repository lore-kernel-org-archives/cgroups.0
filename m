From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch] Documentation: memcg: future proof hierarchical statistics documentation
Date: Tue, 24 Apr 2012 21:33:58 +0200
Message-ID: <1335296038-29297-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The hierarchical versions of per-memcg counters in memory.stat are all
calculated the same way and are all named total_<counter>.

Documenting the pattern is easier for maintenance than listing each
counter twice.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Acked-by: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/memory.txt |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index ab34ae5..6a066a2 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -432,17 +432,10 @@ hierarchical_memory_limit - # of bytes of memory limit with regard to hierarchy
 hierarchical_memsw_limit - # of bytes of memory+swap limit with regard to
 			hierarchy under which memory cgroup is.
 
-total_cache		- sum of all children's "cache"
-total_rss		- sum of all children's "rss"
-total_mapped_file	- sum of all children's "cache"
-total_pgpgin		- sum of all children's "pgpgin"
-total_pgpgout		- sum of all children's "pgpgout"
-total_swap		- sum of all children's "swap"
-total_inactive_anon	- sum of all children's "inactive_anon"
-total_active_anon	- sum of all children's "active_anon"
-total_inactive_file	- sum of all children's "inactive_file"
-total_active_file	- sum of all children's "active_file"
-total_unevictable	- sum of all children's "unevictable"
+total_<counter>		- # hierarchical version of <counter>, which in
+			addition to the cgroup's own value includes the
+			sum of all hierarchical children's values of
+			<counter>, i.e. total_cache
 
 # The following additional stats are dependent on CONFIG_DEBUG_VM.
 
-- 
1.7.7.6
