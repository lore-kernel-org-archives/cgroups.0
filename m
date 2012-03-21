From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: memcg-devel updated for v3.3
Date: Wed, 21 Mar 2012 10:45:45 +0100
Message-ID: <20120321094545.GA10450@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

[sorry for few days delay]

Hi,
The memcg-devel tree hosted at github[*] has been updated to 3.3. Like
with the previous releases the current patch queue is sitting in the
since-3.3 branch based on v3.3 linus tree.

We are currently at 37 patches comparing to 74 in the previous cycle
which looks like a quite nice reduction.

Andrew Morton (7):
      memcg-clear-pc-mem_cgorup-if-necessary-fix
      memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix
      memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes
      memcg-simplify-move_account-check-fix
      memcg-use-new-logic-for-page-stat-accounting-fix
      memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix
      mm/memcontrol.c: s/stealed/stolen/

Anton Vorontsov (1):
      mm/memcontrol.c: remove redundant BUG_ON() in mem_cgroup_usage_unregister_event()

Hugh Dickins (15):
      memcg-clear-pc-mem_cgorup-if-necessary-fix-2
      memcg-clear-pc-mem_cgorup-if-necessary fix 3
      memcg: fix page migration to reset_owner
      memcg: replace MEM_CONT by MEM_RES_CTLR
      memcg: replace mem and mem_cont stragglers
      memcg: lru_size instead of MEM_CGROUP_ZSTAT
      memcg: enum lru_list lru
      memcg: remove redundant returns
      idr: make idr_get_next() good for rcu_read_lock()
      cgroup: revert ss_id_lock to spinlock
      memcg: let css_get_next() rely upon rcu_read_lock()
      memcg: remove PCG_CACHE page_cgroup flag fix
      memcg: remove PCG_CACHE page_cgroup flag fix2
      memcg: remove PCG_FILE_MAPPED fix cosmetic fix
      memcg: fix GPF when cgroup removal races with last exit

Jeff Liu (1):
      mm/memcontrol.c: remove unnecessary 'break' in mem_cgroup_read()

Johannes Weiner (1):
      memcg-clear-pc-mem_cgorup-if-necessary-comments

KAMEZAWA Hiroyuki (10):
      memcg: clear pc->mem_cgorup if necessary.
      memcg: remove unnecessary thp check in page stat accounting
      memcg: remove PCG_CACHE page_cgroup flag
      memcg: remove EXPORT_SYMBOL(mem_cgroup_update_page_stat)
      memcg: simplify move_account() check
      memcg: remove PCG_MOVE_LOCK flag from page_cgroup
      memcg: use new logic for page stat accounting
      memcg: remove PCG_FILE_MAPPED
      memcg-remove-pcg_file_mapped-fix
      memcg: fix performance of mem_cgroup_begin_update_page_stat()

Konstantin Khlebnikov (1):
      memcg: kill dead prev_priority stubs

Li Zefan (1):
      cgroup: remove cgroup_subsys argument from callbacks


Happy hacking and have a lot of fun.

Let me know if I missed any patches.

---
[*] git://github.com/mstsxfx/memcg-devel.git
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
