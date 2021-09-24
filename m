From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] mem_cgroup: introduce foreign_writeback_in_process() function
Date: Fri, 24 Sep 2021 14:46:23 +0800
Message-ID: <1632465983-30525-2-git-send-email-brookxu.cn@gmail.com>
References: <1632465983-30525-1-git-send-email-brookxu.cn@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f0GxVaNbVW0DvbjS40nByrp5JbLVkqcqCJ/2Z3nsHrQ=;
        b=KumeSPyep1PPko2skk0eqpAVVSFetiWqeAAclpxM6br9aBNY8UZ8HoRNhWJt6dq4l7
         DRGK4F0m1dv7vyCNkpWdtUDJyDW+hkyAAlj3zMFof7bL81tqd8GDGjD90+ALVa+4UYUf
         6FMs2h5X4jYNZ3iPHrGfooduiRDtrbu/taZ/wFQWushFmSxXf0ZsHKUup+5eZnOsl0KB
         1VSbhX833c7Iy64o+my5fT3ImlXC9hJ88ZWfrLkL0CEcTzp2SMYINwUi4srGg4hk6KZ9
         kfjY4T8MD/aNuc51L+/6neQbOOfxq9CcLzOxvs1HIpwVUOJ2DKNRd40CaSm1ws8GpnJw
         Euew==
In-Reply-To: <1632465983-30525-1-git-send-email-brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Directly use atomic_read(&frn->done.cnt) == 1 to check whether frn
is issued, which makes the code a bit obscure. Maybe we should
replace it with a more understandable function.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 mm/memcontrol.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3e1384a6..464745b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4542,6 +4542,12 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
  * As being wrong occasionally doesn't matter, updates and accesses to the
  * records are lockless and racy.
  */
+
+static inline bool foreign_writeback_in_process(struct memcg_cgwb_frn *frn)
+{
+	return atomic_read(&frn->done.cnt) != 1;
+}
+
 void mem_cgroup_track_foreign_dirty_slowpath(struct page *page,
 					     struct bdi_writeback *wb)
 {
@@ -4565,7 +4571,7 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct page *page,
 		    frn->memcg_id == wb->memcg_css->id)
 			break;
 		if (time_before64(frn->at, oldest_at) &&
-		    atomic_read(&frn->done.cnt) == 1) {
+		    !foreign_writeback_in_process(frn)) {
 			oldest = i;
 			oldest_at = frn->at;
 		}
@@ -4612,7 +4618,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		 * already one in flight.
 		 */
 		if (time_after64(frn->at, now - intv) &&
-		    atomic_read(&frn->done.cnt) == 1) {
+		    !foreign_writeback_in_process(frn)) {
 			frn->at = 0;
 			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id);
 			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
-- 
1.8.3.1

