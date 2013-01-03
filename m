From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 02/13] cpuset: remove fast exit path from
	remove_tasks_in_empty_cpuset()
Date: Thu,  3 Jan 2013 13:35:56 -0800
Message-ID: <1357248967-24959-3-git-send-email-tj@kernel.org>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
	:in-reply-to:references;
	bh=4TxXbIZkyK65jMBemQl2d2ZZLgXA3Kb3/M9dSS4gCOQ=;
	b=HuhNw9IQCiKuGF7zehvRT41Z9sZwUjTnHMgzonQoeyaipiV8umWdAcI8yj5/1TYFNL
	21ipEKLPvuAsfnQc5x8GzJzHW8+MRBr6QudzZMgCqm0wfjM6or+/tOXvwMy8bnw5i1yw
	11LUrmBDmEm6OYLnpi1v1EvNauGsiPLYVjLlOVlM2+oETpUX5uVztLWQZGcDSSePSEn4
	u934dZ74IKOrFv2A0MWuEsIO/D7OKYcQPPkaZKiKOxIkIt3YuEBnE60BLVK6V/+O8C78
	TCCZrjlPhk/osFTed8sQ10KdB5Cw4fD6lWuKlqcuOv9oXecVDFnZdMuiWv3kDXIbk2Iz
	cRGg==
In-Reply-To: <1357248967-24959-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The function isn't that hot, the overhead of missing the fast exit is
low, the test itself depends heavily on cgroup internals, and it's
gonna be a hindrance when trying to decouple cpuset locking from
cgroup core.  Remove the fast exit path.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cpuset.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 854b8bf..5372b6f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1968,14 +1968,6 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	struct cpuset *parent;
 
 	/*
-	 * The cgroup's css_sets list is in use if there are tasks
-	 * in the cpuset; the list is empty if there are none;
-	 * the cs->css.refcnt seems always 0.
-	 */
-	if (list_empty(&cs->css.cgroup->css_sets))
-		return;
-
-	/*
 	 * Find its next-highest non-empty parent, (top cpuset
 	 * has online cpus, so can't be empty).
 	 */
-- 
1.8.0.2
