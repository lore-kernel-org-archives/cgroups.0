From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] device_cgroup: fix the comment format for recently added
 functions
Date: Thu, 24 Apr 2014 15:33:21 -0400
Message-ID: <20140424193321.GS29214@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Moving more extensive explanations to the end of the comment.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 security/device_cgroup.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index abbe0b2..dbd2489 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -306,17 +306,17 @@ static int devcgroup_seq_show(struct seq_file *m, void *v)
 }
 
 /**
- * match_exception	- iterates the exception list trying to match a rule
- * 			  based on type, major, minor and access type. It is
- * 			  considered a match if an exception is found that
- * 			  will contain the entire range of provided parameters.
+ * match_exception	- iterates the exception list trying to find a complete match
  * @exceptions: list of exceptions
  * @type: device type (DEV_BLOCK or DEV_CHAR)
  * @major: device file major number, ~0 to match all
  * @minor: device file minor number, ~0 to match all
  * @access: permission mask (ACC_READ, ACC_WRITE, ACC_MKNOD)
  *
- * returns: true in case it matches an exception completely
+ * It is considered a complete match if an exception is found that will
+ * contain the entire range of provided parameters.
+ *
+ * Return: true in case it matches an exception completely
  */
 static bool match_exception(struct list_head *exceptions, short type,
 			    u32 major, u32 minor, short access)
@@ -341,20 +341,19 @@ static bool match_exception(struct list_head *exceptions, short type,
 }
 
 /**
- * match_exception_partial - iterates the exception list trying to match a rule
- * 			     based on type, major, minor and access type. It is
- * 			     considered a match if an exception's range is
- * 			     found to contain *any* of the devices specified by
- * 			     provided parameters. This is used to make sure no
- * 			     extra access is being granted that is forbidden by
- * 			     any of the exception list.
+ * match_exception_partial - iterates the exception list trying to find a partial match
  * @exceptions: list of exceptions
  * @type: device type (DEV_BLOCK or DEV_CHAR)
  * @major: device file major number, ~0 to match all
  * @minor: device file minor number, ~0 to match all
  * @access: permission mask (ACC_READ, ACC_WRITE, ACC_MKNOD)
  *
- * returns: true in case the provided range mat matches an exception completely
+ * It is considered a partial match if an exception's range is found to
+ * contain *any* of the devices specified by provided parameters. This is
+ * used to make sure no extra access is being granted that is forbidden by
+ * any of the exception list.
+ *
+ * Return: true in case the provided range mat matches an exception completely
  */
 static bool match_exception_partial(struct list_head *exceptions, short type,
 				    u32 major, u32 minor, short access)
@@ -387,13 +386,13 @@ static bool match_exception_partial(struct list_head *exceptions, short type,
 }
 
 /**
- * verify_new_ex - verifies if a new exception is part of what is allowed
- *		   by a dev cgroup based on the default policy +
- *		   exceptions. This is used to make sure a child cgroup
- *		   won't have more privileges than its parent
+ * verify_new_ex - verifies if a new exception is allowed by parent cgroup's permissions
  * @dev_cgroup: dev cgroup to be tested against
  * @refex: new exception
  * @behavior: behavior of the exception's dev_cgroup
+ *
+ * This is used to make sure a child cgroup won't have more privileges
+ * than its parent
  */
 static bool verify_new_ex(struct dev_cgroup *dev_cgroup,
 		          struct dev_exception_item *refex,
-- 
1.7.1
