From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.10] devcg: remove broken_hierarchy tag
Date: Sun, 7 Apr 2013 10:28:18 -0700
Message-ID: <20130407172818.GD12038@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:mime-version
	:content-type:content-disposition:user-agent;
	bh=UgKI00qFga8q4u3irPoWRUGG5v92tqeYLl2sG249clo=;
	b=mGjsEwIeW9l+YN4UWKWw5+AtTUApW6XwnPeKdtGsW9s96LxHgWLhuJAXbNjhwEa5dk
	3EiH7xeTtXxzqgXipMQRgcAMjZ7QnMDVTml/Gqqqv9OivBODHEjEv3kgIoSLlNomijmi
	DJaytlcwRPgG1LyyqSQ+Hz5dMP3qCiGk5WSVNu26yX8PDT2j0uSBcJgM2KpyMrmRvhr6
	/DNjt3+Bdscpkf5dIedivMANzk1edZKneVOlwuI+U+DzvQ8ZMq+b6NbpdQ0YMaF9noNE
	tjH3gZ7+n3pdjtfkRyZ+q2nHUAKt8JMJvU+DRxwwHLOB0a5IrDYmbfoFmknU0K5o/XNL
	vQFg==
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
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From f913fbedbdfc08eeff742c4b3077e267d8fc867f Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Sun, 7 Apr 2013 10:25:39 -0700

bd2953ebbb ("devcg: propagate local changes down the hierarchy")
implemented proper hierarchy support.  Remove the broken tag.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
Applying to cgroup/for-3.10.

Thanks.

 security/device_cgroup.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 221967d..994aecc 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -739,15 +739,6 @@ struct cgroup_subsys devices_subsys = {
 	.css_offline = devcgroup_offline,
 	.subsys_id = devices_subsys_id,
 	.base_cftypes = dev_cgroup_files,
-
-	/*
-	 * While devices cgroup has the rudimentary hierarchy support which
-	 * checks the parent's restriction, it doesn't properly propagates
-	 * config changes in ancestors to their descendents.  A child
-	 * should only be allowed to add more restrictions to the parent's
-	 * configuration.  Fix it and remove the following.
-	 */
-	.broken_hierarchy = true,
 };
 
 /**
-- 
1.8.1.4
