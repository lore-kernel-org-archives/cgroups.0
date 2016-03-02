From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [cgroup/for-4.6 2/2] cgroup: suppress spurious de-populated events
Date: Wed, 2 Mar 2016 13:07:56 -0500
Message-ID: <20160302180756.GB11029@mtj.duckdns.org>
References: <20160302180712.GA11029@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YIou/jjTGmktcmJSs46WWadlAx4BtkzYu3QZXTroxW4=;
        b=XIgpqw7OI5nwBIeeZNJMJpRZklWwTAU2gtfKsnjDfPzQzRwVXdTDOlNpFALIk7kl+f
         CFut/QUBUgZQZI9Y40dWZvh6+7DugzFmktCIvCju4lpFDOLzYgL9NxXOjc3oTmv4lo9/
         WXhhjSQaG+lop9sERvJfwJhD2qlgvc0W4r7zSdJPYrwPCs6KFLNi8IAWbt8COCpXg6tr
         p69wbIoBzny7NwTIv33De3EUAHAJxd6oQFQyef7+EwZKctPzQTblIL7RWCIrxYKgDIma
         +zZzb0JG8Ck2itDlugRPU0vrPRa2LKTe/tc8iy0J8tj+361EaaSckcPBfeNPc0Lz9Lrq
         hnqg==
Content-Disposition: inline
In-Reply-To: <20160302180712.GA11029-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

During task migration, tasks may transfer between two css_sets which
are associated with the same cgroup.  If those tasks are the only
tasks in the cgroup, this currently triggers a spurious de-populated
event on the cgroup.

Fix it by bumping up populated count before bumping it down during
migration to ensure that it doesn't reach zero spuriously.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -678,6 +678,9 @@ static void css_set_move_task(struct tas
 {
 	lockdep_assert_held(&css_set_lock);
 
+	if (to_cset && !css_set_populated(to_cset))
+		css_set_update_populated(to_cset, true);
+
 	if (from_cset) {
 		struct css_task_iter *it, *pos;
 
@@ -711,8 +714,6 @@ static void css_set_move_task(struct tas
 		 */
 		WARN_ON_ONCE(task->flags & PF_EXITING);
 
-		if (!css_set_populated(to_cset))
-			css_set_update_populated(to_cset, true);
 		rcu_assign_pointer(task->cgroups, to_cset);
 		list_add_tail(&task->cg_list, use_mg_tasks ? &to_cset->mg_tasks :
 							     &to_cset->tasks);
