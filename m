From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.11] cgroup: update sane_behavior documentation
Date: Thu, 13 Jun 2013 20:07:53 -0700
Message-ID: <20130614030753.GC7846@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
	:content-disposition:user-agent;
	bh=X0cLGZq4nqiHGj7t7VLwynK9F4hGULSuU0Fg8velWuI=;
	b=WLaTrvPspnPJXt+YtYjScaOf8sm6VsVzIjhCdl32Aa5lnF9WEKdjb2F6ZLMMZz/KvG
	U0QxtG/o2HLOw8ebHWbOVn5FyeuHL8mAOhYn7XT92tMBuG1CVLXadp88b41NI1ORJ5CJ
	4yTv1JqY441Q03BYyvHEceD1n5hmtB8IwNi2+N9ocRWgqCw5Fa/Zhes/hq+SdORvrTSn
	FlcgTpnCH7kuaj+pjiK9KIir1DeF/guVHoxBcRx7D7tUJWqHMCmvUx3rwN6c7vHUyArn
	xDo9h+IjtzESQuFM9fwcFkS6t0RstiVxXorkti83kXRHDmFLCux9bnrHTw7U4WKRETqA
	ekRQ==
Content-Disposition: inline
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
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

From f63674fd0d6afa1ba24309aee1f8c60195d39041 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 13 Jun 2013 19:58:38 -0700

f12dc02014 ("cgroup: mark "tasks" cgroup file as insane") and
cc5943a781 ("cgroup: mark "notify_on_release" and "release_agent"
cgroup files insane") forgot to update the changed behavior
documentation in cgroup.h.  Update it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Forgot to update sane_behavior comment.  Applied this patch to
cgroup/for-3.11.  Thanks.

 include/linux/cgroup.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b7bd4be..1760476 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -264,13 +264,14 @@ enum {
 	 *
 	 * - Remount is disallowed.
 	 *
-	 * - memcg: use_hierarchy is on by default and the cgroup file for
-	 *   the flag is not created.
+	 * - "tasks" is removed.  Everything should be at process
+	 *   granularity.  Use "cgroup.procs" instead.
 	 *
-	 * The followings are planned changes.
+	 * - "release_agent" and "notify_on_release" are removed.
+	 *   Replacement notification mechanism will be implemented.
 	 *
-	 * - release_agent will be disallowed once replacement notification
-	 *   mechanism is implemented.
+	 * - memcg: use_hierarchy is on by default and the cgroup file for
+	 *   the flag is not created.
 	 */
 	CGRP_ROOT_SANE_BEHAVIOR	= (1 << 0),
 
-- 
1.8.2.1
