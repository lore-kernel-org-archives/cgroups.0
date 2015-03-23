From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 14/18] writeback: update wb_over_bg_thresh() to use wb_domain aware operations
Date: Mon, 23 Mar 2015 01:07:43 -0400
Message-ID: <1427087267-16592-15-git-send-email-tj@kernel.org>
References: <1427087267-16592-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dN+YGrQVQ8zQLMqig1sx5UAfaBb/ExcbLsxG1+S9G/w=;
        b=y839ZHeFsY1Y6lNtPISRIBk6J/4W35abWTJJODixb0zbEJW/xwRhJFIZ/skcwdrzby
         rIjvANWglRhoZcHgF5Ul6277enxFsVZQv6rWSw0RZnsNhTtcCPJiUeTiLt1/DJaACU+i
         bfVQfNZUcYRXDMB1c4F8dPx/KI7xSomxHK406u/uAp5Wj0HUtz52l+Al1APC/3r6dGJ2
         bQOwd1j2JkT4PkNuf2WyxIskftnTcmLDwEplDMPV1k7q4iudO+Z3JU9votilKq4oIusM
         V1N16BI8SJsQoIdzbm7xsRDDbzcF0syYszhs+rcreEhJq3WFaYtrikbilmX+9AgmswNS
         qw8g==
In-Reply-To: <1427087267-16592-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

wb_over_bg_thresh() currently uses global_dirty_limits() and
wb_dirty_limit() both of which are wrappers around operations which
take dirty_throttle_control.  For cgroup writeback support, the
function will be updated to also consider memcg wb_domains which
requires the context information carried in dirty_throttle_control.

This patch updates wb_over_bg_thresh() so that it uses the underlying
wb_domain aware operations directly and builds the global
dirty_throttle_control in the process.

This patch doesn't introduce any behavioral changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/page-writeback.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 99f8d02..2626e6c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1749,15 +1749,22 @@ EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
  */
 bool wb_over_bg_thresh(struct bdi_writeback *wb)
 {
-	unsigned long background_thresh, dirty_thresh;
+	struct dirty_throttle_control gdtc_stor = { GDTC_INIT(wb) };
+	struct dirty_throttle_control * const gdtc = &gdtc_stor;
 
-	global_dirty_limits(&background_thresh, &dirty_thresh);
+	/*
+	 * Similar to balance_dirty_pages() but ignores pages being written
+	 * as we're trying to decide whether to put more under writeback.
+	 */
+	gdtc->avail = global_dirtyable_memory();
+	gdtc->dirty = global_page_state(NR_FILE_DIRTY) +
+		      global_page_state(NR_UNSTABLE_NFS);
+	domain_dirty_limits(gdtc);
 
-	if (global_page_state(NR_FILE_DIRTY) +
-	    global_page_state(NR_UNSTABLE_NFS) > background_thresh)
+	if (gdtc->dirty > gdtc->bg_thresh)
 		return true;
 
-	if (wb_stat(wb, WB_RECLAIMABLE) > wb_dirty_limit(wb, background_thresh))
+	if (wb_stat(wb, WB_RECLAIMABLE) > __wb_dirty_limit(gdtc))
 		return true;
 
 	return false;
-- 
2.1.0
