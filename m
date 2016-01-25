From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] mm/memcontrol: avoid a spurious gcc warning
Date: Mon, 25 Jan 2016 16:45:50 +0100
Message-ID: <1453736756-1959377-3-git-send-email-arnd@arndb.de>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

When CONFIG_DEBUG_VM is set, the various VM_BUG_ON() confuse gcc to
the point where it cannot remember that 'memcg' is known to be initialized:

mm/memcontrol.c: In function 'mem_cgroup_can_attach':
mm/memcontrol.c:4791:9: warning: 'memcg' may be used uninitialized in this function [-Wmaybe-uninitialized]

On ARM gcc-5.1, the above happens when any two or more of the VM_BUG_ON()
are active, but not when I remove most or all of them. This is clearly
random behavior and the only way I've found to shut up the warning is
to add an explicit initialization.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d06cae2de783..9340eb981653 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4762,6 +4762,7 @@ static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
 	 * multiple.
 	 */
 	p = NULL;
+	memcg = NULL;
 	cgroup_taskset_for_each_leader(leader, css, tset) {
 		WARN_ON_ONCE(p);
 		p = leader;
-- 
2.7.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
