From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5.5/6] cgroup: move init_css_set initialization inside
	cgroup_mutex
Date: Mon, 24 Jun 2013 17:34:34 -0700
Message-ID: <20130625003434.GV1918@mtj.dyndns.org>
References: <1371864854-28364-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=cYb1q5gv5SadeuzJEt+wJ5vPmhxQkFOHhYgtxGKPuI8=;
	b=twLizLf1V8wGS3NRSE6yMMp2693ix0r/mBskQC11on9X0G7R2ap34W62OCTNVRV41K
	7xXQhOMUygPmhmtidr6n0utWNUP0ucXC4QOe/l6UZ2SYeVFjM3ACa2sz6jp544Idr/SR
	0NcYzwwGuskmziEuBj3eWn28+Q2z4cjH7fI1ysp/fw6WHSX2uzkgkSOMKRwbY8xE8QDZ
	VI8YLeQJYc0dydsRo4kJyFzqrUVaI10MXaji0semGa5SjspMwvVA5XZciZobX5Mfra/w
	fFZzgkQvKYeuwIpTqyvpuXYS7SH8Ui6acS6V01pfqEJajcQ8IBr6nb3RBhBLsliJO0JX
	vq5w==
Content-Disposition: inline
In-Reply-To: <1371864854-28364-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

cgroup_init() was doing init_css_set initialization outside
cgroup_mutex, which is fine but we want to add lockdep annotation on
subsystem iterations and cgroup_init() will trigger it spuriously.
Move init_css_set initialization inside cgroup_mutex.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4888,14 +4888,14 @@ int __init cgroup_init(void)
 			cgroup_init_idr(ss, init_css_set.subsys[ss->subsys_id]);
 	}
 
-	/* Add init_css_set to the hash table */
-	key = css_set_hash(init_css_set.subsys);
-	hash_add(css_set_table, &init_css_set.hlist, key);
-
 	/* allocate id for the dummy hierarchy */
 	mutex_lock(&cgroup_mutex);
 	mutex_lock(&cgroup_root_mutex);
 
+	/* Add init_css_set to the hash table */
+	key = css_set_hash(init_css_set.subsys);
+	hash_add(css_set_table, &init_css_set.hlist, key);
+
 	BUG_ON(cgroup_init_root_id(&cgroup_dummy_root));
 
 	mutex_unlock(&cgroup_root_mutex);
