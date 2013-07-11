From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5.5/9] cgroup: use for_each_subsys() instead of
 for_each_root_subsys() in cgroup_populate/clear_dir()
Date: Thu, 11 Jul 2013 10:19:27 -0700
Message-ID: <20130711171927.GE10195@mtj.dyndns.org>
References: <1372463145-4245-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eTR3oh8Xdw5OzP4eha8vB7suClJdlBdygUZxIyOOdp8=;
        b=OXHVKNiupXcqHy/QSCdqOksH9/vmTjhHzF+lmUjydA5BeaO3C5eGI17QwAt5DHpCYV
         NR7DYHiIjmOxLHRgxkYHASEpo758DYqcMwibhQvLHupAUuUVbKxTjeIUG4dj7e9waXCX
         XlhJqMWtbETZ+Ds30QquGw2uhv8fCsDHXcWFUi7h9cpkIeQRoRYG6Do13/slS34MdFIj
         WfBYeZyK1x50os21jANQRGxKt7Beid9OBCb/9A2XAhryqfc39us8z/JQs5Uu+vQkv3J8
         tT00av5cXDxm+kWpKf6U1t6h5aF+MaPExclL06xYF/DRkbJoyF7gSgkdljGEMPeJbSUi
         dJcg==
Content-Disposition: inline
In-Reply-To: <1372463145-4245-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

rebind_subsystems() will be updated to handle file creations and
removals with proper error handling and to do that will need to
perform file operations before actually adding the subsystem to the
hierarchy.

To enable such usage, update cgroup_populate/clear_dir() to use
for_each_subsys() instead of for_each_root_subsys() so that they
operate on all subsystems specified by @subsys_mask whether that
subsystem is currently bound to the hierarchy or not.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
for_each_subsys() conversions separated out.  Doesn't change the end
result from the original posting.

Thanks.

 kernel/cgroup.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -965,10 +965,12 @@ static void cgroup_rm_file(struct cgroup
 static void cgroup_clear_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 {
 	struct cgroup_subsys *ss;
+	int i;
 
-	for_each_root_subsys(cgrp->root, ss) {
+	for_each_subsys(ss, i) {
 		struct cftype_set *set;
-		if (!test_bit(ss->subsys_id, &subsys_mask))
+
+		if (!test_bit(i, &subsys_mask))
 			continue;
 		list_for_each_entry(set, &ss->cftsets, node)
 			cgroup_addrm_files(cgrp, NULL, set->cfts, false);
@@ -4177,12 +4179,13 @@ static struct cftype cgroup_base_files[]
 static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 {
 	struct cgroup_subsys *ss;
-	int ret = 0;
+	int i, ret = 0;
 
 	/* process cftsets of each subsystem */
-	for_each_root_subsys(cgrp->root, ss) {
+	for_each_subsys(ss, i) {
 		struct cftype_set *set;
-		if (!test_bit(ss->subsys_id, &subsys_mask))
+
+		if (!test_bit(i, &subsys_mask))
 			continue;
 
 		list_for_each_entry(set, &ss->cftsets, node) {
