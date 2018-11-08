From: Tejun Heo <tj@kernel.org>
Subject: [PATCH for-4.20-fixes] cgroup: fix CSS_TASK_ITER_PROCS
Date: Thu, 8 Nov 2018 12:15:15 -0800
Message-ID: <20181108201515.GC2509588@devbig004.ftw2.facebook.com>
References: <fdb057a2-342a-d49e-587a-f1ca8680033e@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BxbFJOzRVuNYYE5nClkVAe8F5JFbtv/j1hv7sF2oke4=;
        b=sHVViSG38AH29tX4KYViKHyE5I0BS8AxKoHFzPXi9B1F5NSPn2W/o+307GGO5968Oi
         0ey++lvswOOWgEctbhBXCNTrlDgaztC7HVXUUejF3yEEeeLMzPC5pENVpw103gcRZUps
         Yti1YtoCZFmihDrzIm9YWCBnRIfl3GGGRV5/oz6wLt0NrmuWtYJL957ui1qVOIIg6Iwd
         QdBfcr4crf/RVck6eYfcgahkbwa5ZgEGc2fbBIF/p1+K5fP+mUJaoeAPVCK3WbKOnF3D
         KPYJRGyffsyiPt4lg+2aucEjzxmUflGpcWItxqkYY/MZ0njVxSFww6ofeInLlB34Typi
         N4fg==
Content-Disposition: inline
In-Reply-To: <fdb057a2-342a-d49e-587a-f1ca8680033e@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, kernel-team@fb.com

CSS_TASK_ITER_PROCS implements process-only iteration by making
css_task_iter_advance() skip tasks which aren't threadgroup leaders;
however, when an iteration is started css_task_iter_start() calls the
inner helper function css_task_iter_advance_css_set() instead of
css_task_iter_advance().  As the helper doesn't have the skip logic,
when the first task to visit is a non-leader thread, it doesn't get
skipped correctly as shown in the following example.

  # ps -L 2030
    PID   LWP TTY      STAT   TIME COMMAND
   2030  2030 pts/0    Sl+    0:00 ./test-thread
   2030  2031 pts/0    Sl+    0:00 ./test-thread
  # mkdir -p /sys/fs/cgroup/x/a/b
  # echo threaded > /sys/fs/cgroup/x/a/cgroup.type
  # echo threaded > /sys/fs/cgroup/x/a/b/cgroup.type
  # echo 2030 > /sys/fs/cgroup/x/a/cgroup.procs
  # cat /sys/fs/cgroup/x/a/cgroup.threads
  2030
  2031
  # cat /sys/fs/cgroup/x/cgroup.procs
  2030
  # echo 2030 > /sys/fs/cgroup/x/a/b/cgroup.threads
  # cat /sys/fs/cgroup/x/cgroup.procs
  2031
  2030

The last read of cgroup.procs is incorrectly showing non-leader 2031
in cgroup.procs output.

This can be fixed by updating css_task_iter_advance() to handle the
first advance and css_task_iters_tart() to call
css_task_iter_advance() instead of the inner helper.  After the fix,
the same commands result in the following (correct) result:

  # ps -L 2062
    PID   LWP TTY      STAT   TIME COMMAND
   2062  2062 pts/0    Sl+    0:00 ./test-thread
   2062  2063 pts/0    Sl+    0:00 ./test-thread
  # mkdir -p /sys/fs/cgroup/x/a/b
  # echo threaded > /sys/fs/cgroup/x/a/cgroup.type
  # echo threaded > /sys/fs/cgroup/x/a/b/cgroup.type
  # echo 2062 > /sys/fs/cgroup/x/a/cgroup.procs
  # cat /sys/fs/cgroup/x/a/cgroup.threads
  2062
  2063
  # cat /sys/fs/cgroup/x/cgroup.procs
  2062
  # echo 2062 > /sys/fs/cgroup/x/a/b/cgroup.threads
  # cat /sys/fs/cgroup/x/cgroup.procs
  2062

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Fixes: 8cfd8147df67 ("cgroup: implement cgroup v2 thread support")
Cc: stable@vger.kernel.org # v4.14+
---
 kernel/cgroup/cgroup.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6aaf5dd5383b..1f84977fab47 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4202,20 +4202,25 @@ static void css_task_iter_advance(struct css_task_iter *it)
 
 	lockdep_assert_held(&css_set_lock);
 repeat:
-	/*
-	 * Advance iterator to find next entry.  cset->tasks is consumed
-	 * first and then ->mg_tasks.  After ->mg_tasks, we move onto the
-	 * next cset.
-	 */
-	next = it->task_pos->next;
+	if (it->task_pos) {
+		/*
+		 * Advance iterator to find next entry.  cset->tasks is
+		 * consumed first and then ->mg_tasks.  After ->mg_tasks,
+		 * we move onto the next cset.
+		 */
+		next = it->task_pos->next;
 
-	if (next == it->tasks_head)
-		next = it->mg_tasks_head->next;
+		if (next == it->tasks_head)
+			next = it->mg_tasks_head->next;
 
-	if (next == it->mg_tasks_head)
+		if (next == it->mg_tasks_head)
+			css_task_iter_advance_css_set(it);
+		else
+			it->task_pos = next;
+	} else {
+		/* called from start, proceed to the first cset */
 		css_task_iter_advance_css_set(it);
-	else
-		it->task_pos = next;
+	}
 
 	/* if PROCS, skip over tasks which aren't group leaders */
 	if ((it->flags & CSS_TASK_ITER_PROCS) && it->task_pos &&
@@ -4255,7 +4260,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css, unsigned int flags,
 
 	it->cset_head = it->cset_pos;
 
-	css_task_iter_advance_css_set(it);
+	css_task_iter_advance(it);
 
 	spin_unlock_irq(&css_set_lock);
 }
