From: Aristeu Rozanski <aris-moeOTchvdi7YtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/4] device_cgroup: convert device_cgroup internally to policy + exceptions
Date: Tue, 24 Jul 2012 18:03:36 -0400
Message-ID: <20120724220334.761027749@muttley.lan.cathedral>
References: <20120724220333.966415895@muttley.lan.cathedral>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=handle_whitelist_as_exceptions.patch
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="utf-8"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

The original model of device_cgroup is having a whitelist where all the
allowed devices are listed. The problem with this approach is that is
impossible to have the case of allowing everything but few devices.

The reason for that lies in the way the whitelist is handled internally=
:
since there's only a whitelist, the "all devices" entry would have to b=
e
removed and replaced by the entire list of possible devices but the one=
s
that are being denied.  Since dev_t is 32 bits long, representing the a=
llowed
devices as a bitfield is not memory efficient.

This patch replaces the "whitelist" by a "exceptions" list and the defa=
ult
policy is kept as "deny_all" variable in dev_cgroup structure.

The current interface determines that whenever "a" is written to device=
s.allow
or devices.deny, the entry masking all devices will be added or removed=
,
respectively. This behavior is kept and it's what will determine the de=
fault
policy:

	# cat devices.list=20
	a *:* rwm
	# echo a >devices.deny
	# cat devices.list=20
	# echo a >devices.allow
	# cat devices.list=20
	a *:* rwm

The interface is also preserved. For example, if one wants to block onl=
y access
to /dev/null:
	# ls -l /dev/null
	crw-rw-rw- 1 root root 1, 3 Jul 24 16:17 /dev/null
	# echo a >devices.allow
	# echo "c 1:3 rwm" >devices.deny
	# cat /dev/null
	cat: /dev/null: Operation not permitted
	# echo >/dev/null
	bash: /dev/null: Operation not permitted
	mknod /tmp/null c 1 3
	mknod: =E2=80=98/tmp/null=E2=80=99: Operation not permitted
	# echo "c 1:3 r" >devices.allow
	# cat /dev/null
	# echo >/dev/null
	bash: /dev/null: Operation not permitted
	mknod /tmp/null c 1 3
	mknod: =E2=80=98/tmp/null=E2=80=99: Operation not permitted
	# echo "c 1:3 rw" >devices.allow
	# echo >/dev/null
	# cat /dev/null
	# mknod /tmp/null c 1 3
	mknod: =E2=80=98/tmp/null=E2=80=99: Operation not permitted
	# echo "c 1:3 rwm" >devices.allow
	# echo >/dev/null
	# cat /dev/null
	# mknod /tmp/null c 1 3
	#

Note that I didn't rename the functions/variables in this patch, but in=
 the
next one to make reviewing easier.

Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 security/device_cgroup.c |  228 +++++++++++++++++++++++++++-----------=
---------
 1 file changed, 132 insertions(+), 96 deletions(-)

Index: github/security/device_cgroup.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- github.orig/security/device_cgroup.c	2012-07-24 17:58:42.984081909 =
-0400
+++ github/security/device_cgroup.c	2012-07-24 17:59:11.324823460 -0400
@@ -96,7 +96,6 @@
 	return -ENOMEM;
 }
=20
-/* Stupid prototype - don't bother combining existing entries */
 /*
  * called under devcgroup_mutex
  */
@@ -136,16 +135,13 @@
 	struct dev_whitelist_item *walk, *tmp;
=20
 	list_for_each_entry_safe(walk, tmp, &dev_cgroup->whitelist, list) {
-		if (walk->type =3D=3D DEV_ALL)
-			goto remove;
 		if (walk->type !=3D wh->type)
 			continue;
-		if (walk->major !=3D ~0 && walk->major !=3D wh->major)
+		if (walk->major !=3D wh->major)
 			continue;
-		if (walk->minor !=3D ~0 && walk->minor !=3D wh->minor)
+		if (walk->minor !=3D wh->minor)
 			continue;
=20
-remove:
 		walk->access &=3D ~wh->access;
 		if (!walk->access) {
 			list_del_rcu(&walk->list);
@@ -185,19 +181,9 @@
 	INIT_LIST_HEAD(&dev_cgroup->whitelist);
 	parent_cgroup =3D cgroup->parent;
=20
-	if (parent_cgroup =3D=3D NULL) {
-		struct dev_whitelist_item *wh;
-		wh =3D kmalloc(sizeof(*wh), GFP_KERNEL);
-		if (!wh) {
-			kfree(dev_cgroup);
-			return ERR_PTR(-ENOMEM);
-		}
-		wh->minor =3D wh->major =3D ~0;
-		wh->type =3D DEV_ALL;
-		wh->access =3D ACC_MASK;
+	if (parent_cgroup =3D=3D NULL)
 		dev_cgroup->deny_all =3D false;
-		list_add(&wh->list, &dev_cgroup->whitelist);
-	} else {
+	else {
 		parent_dev_cgroup =3D cgroup_to_devcgroup(parent_cgroup);
 		mutex_lock(&devcgroup_mutex);
 		ret =3D dev_whitelist_copy(&dev_cgroup->whitelist,
@@ -268,33 +254,48 @@
 	char maj[MAJMINLEN], min[MAJMINLEN], acc[ACCLEN];
=20
 	rcu_read_lock();
-	list_for_each_entry_rcu(wh, &devcgroup->whitelist, list) {
-		set_access(acc, wh->access);
-		set_majmin(maj, wh->major);
-		set_majmin(min, wh->minor);
-		seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
+	/*
+	 * To preserve the compatibility:
+	 * - Only show the "all devices" when the default policy is to allow
+	 * - List the exceptions in case the default policy is to deny
+	 * This way, the file remains as a "whitelist of devices"
+	 */
+	if (devcgroup->deny_all =3D=3D false) {
+		set_access(acc, ACC_MASK);
+		set_majmin(maj, ~0);
+		set_majmin(min, ~0);
+		seq_printf(m, "%c %s:%s %s\n", type_to_char(DEV_ALL),
 			   maj, min, acc);
+	} else {
+		list_for_each_entry_rcu(wh, &devcgroup->whitelist, list) {
+			set_access(acc, wh->access);
+			set_majmin(maj, wh->major);
+			set_majmin(min, wh->minor);
+			seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
+				   maj, min, acc);
+		}
 	}
 	rcu_read_unlock();
=20
 	return 0;
 }
=20
-/*
- * may_access_whitelist:
- * does the access granted to dev_cgroup c contain the access
- * requested in whitelist item refwh.
- * return 1 if yes, 0 if no.
- * call with devcgroup_mutex held
+/**
+ * may_access_whitelist - verifies if a new rule is part of what is al=
lowed
+ *			  by a dev cgroup based on the default policy +
+ *			  exceptions. This is used to make sure a child cgroup
+ *			  won't have more privileges than its parent or to
+ *			  verify if a certain access is allowed.
+ * @dev_cgroup: dev cgroup to be tested against
+ * @refwh: new rule
  */
-static int may_access_whitelist(struct dev_cgroup *c,
-				       struct dev_whitelist_item *refwh)
+static int may_access_whitelist(struct dev_cgroup *dev_cgroup,
+			        struct dev_whitelist_item *refwh)
 {
 	struct dev_whitelist_item *whitem;
+	bool match =3D false;
=20
-	list_for_each_entry(whitem, &c->whitelist, list) {
-		if (whitem->type & DEV_ALL)
-			return 1;
+	list_for_each_entry(whitem, &dev_cgroup->whitelist, list) {
 		if ((refwh->type & DEV_BLOCK) && !(whitem->type & DEV_BLOCK))
 			continue;
 		if ((refwh->type & DEV_CHAR) && !(whitem->type & DEV_CHAR))
@@ -305,8 +306,21 @@
 			continue;
 		if (refwh->access & (~whitem->access))
 			continue;
-		return 1;
+		match =3D true;
+		break;
 	}
+
+	/*
+	 * In two cases we'll consider this new rule valid:
+	 * - the dev cgroup has its default policy to allow + exception list:
+	 *   the new rule should *not* match any of the exceptions
+	 *   (!deny_all, !match)
+	 * - the dev cgroup has its default policy to deny + exception list:
+	 *   the new rule *should* match the exceptions
+	 *   (deny_all, match)
+	 */
+	if (dev_cgroup->deny_all =3D=3D match)
+		return 1;
 	return 0;
 }
=20
@@ -356,11 +370,21 @@
=20
 	switch (*b) {
 	case 'a':
-		wh.type =3D DEV_ALL;
-		wh.access =3D ACC_MASK;
-		wh.major =3D ~0;
-		wh.minor =3D ~0;
-		goto handle;
+		switch (filetype) {
+		case DEVCG_ALLOW:
+			if (!parent_has_perm(devcgroup, &wh))
+				return -EPERM;
+			dev_whitelist_clean(devcgroup);
+			devcgroup->deny_all =3D false;
+			break;
+		case DEVCG_DENY:
+			dev_whitelist_clean(devcgroup);
+			devcgroup->deny_all =3D true;
+			break;
+		default:
+			return -EINVAL;
+		}
+		return 0;
 	case 'b':
 		wh.type =3D DEV_BLOCK;
 		break;
@@ -419,17 +443,31 @@
 		}
 	}
=20
-handle:
 	switch (filetype) {
 	case DEVCG_ALLOW:
 		if (!parent_has_perm(devcgroup, &wh))
 			return -EPERM;
-		devcgroup->deny_all =3D false;
+		/*
+		 * If the default policy is to allow by default, try to remove
+		 * an matching exception instead. And be silent about it: we
+		 * don't want to break compatibility
+		 */
+		if (devcgroup->deny_all =3D=3D false) {
+			dev_whitelist_rm(devcgroup, &wh);
+			return 0;
+		}
 		return dev_whitelist_add(devcgroup, &wh);
 	case DEVCG_DENY:
-		dev_whitelist_rm(devcgroup, &wh);
-		devcgroup->deny_all =3D true;
-		break;
+		/*
+		 * If the default policy is to deny by default, try to remove
+		 * an matching exception instead. And be silent about it: we
+		 * don't want to break compatibility
+		 */
+		if (devcgroup->deny_all =3D=3D true) {
+			dev_whitelist_rm(devcgroup, &wh);
+			return 0;
+		}
+		return dev_whitelist_add(devcgroup, &wh);
 	default:
 		return -EINVAL;
 	}
@@ -476,73 +514,71 @@
 	.base_cftypes =3D dev_cgroup_files,
 };
=20
-int __devcgroup_inode_permission(struct inode *inode, int mask)
+/**
+ * __devcgroup_check_permission - checks if an inode operation is perm=
itted
+ * @dev_cgroup: the dev cgroup to be tested against
+ * @type: device type
+ * @major: device major number
+ * @minor: device minor number
+ * @access: combination of ACC_WRITE, ACC_READ and ACC_MKNOD
+ *
+ * returns 0 on success, -EPERM case the operation is not permitted
+ */
+static int __devcgroup_check_permission(struct dev_cgroup *dev_cgroup,
+					short type, u32 major, u32 minor,
+				        short access)
 {
-	struct dev_cgroup *dev_cgroup;
-	struct dev_whitelist_item *wh;
+	struct dev_whitelist_item wh;
+	int rc;
+
+	memset(&wh, 0, sizeof(wh));
+	wh.type =3D type;
+	wh.major =3D major;
+	wh.minor =3D minor;
+	wh.access =3D access;
=20
 	rcu_read_lock();
+	rc =3D may_access_whitelist(dev_cgroup, &wh);
+	rcu_read_unlock();
=20
-	dev_cgroup =3D task_devcgroup(current);
+	if (!rc)
+		return -EPERM;
=20
-	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
-		if (wh->type & DEV_ALL)
-			goto found;
-		if ((wh->type & DEV_BLOCK) && !S_ISBLK(inode->i_mode))
-			continue;
-		if ((wh->type & DEV_CHAR) && !S_ISCHR(inode->i_mode))
-			continue;
-		if (wh->major !=3D ~0 && wh->major !=3D imajor(inode))
-			continue;
-		if (wh->minor !=3D ~0 && wh->minor !=3D iminor(inode))
-			continue;
+	return 0;
+}
=20
-		if ((mask & MAY_WRITE) && !(wh->access & ACC_WRITE))
-			continue;
-		if ((mask & MAY_READ) && !(wh->access & ACC_READ))
-			continue;
-found:
-		rcu_read_unlock();
-		return 0;
-	}
+int __devcgroup_inode_permission(struct inode *inode, int mask)
+{
+	struct dev_cgroup *dev_cgroup =3D task_devcgroup(current);
+	short type, access =3D 0;
=20
-	rcu_read_unlock();
+	if (S_ISBLK(inode->i_mode))
+		type =3D DEV_BLOCK;
+	if (S_ISCHR(inode->i_mode))
+		type =3D DEV_CHAR;
+	if (mask & MAY_WRITE)
+		access |=3D ACC_WRITE;
+	if (mask & MAY_READ)
+		access |=3D ACC_READ;
=20
-	return -EPERM;
+	return __devcgroup_check_permission(dev_cgroup, type, imajor(inode),
+					    iminor(inode), access);
 }
=20
 int devcgroup_inode_mknod(int mode, dev_t dev)
 {
-	struct dev_cgroup *dev_cgroup;
-	struct dev_whitelist_item *wh;
+	struct dev_cgroup *dev_cgroup =3D task_devcgroup(current);
+	short type;
=20
 	if (!S_ISBLK(mode) && !S_ISCHR(mode))
 		return 0;
=20
-	rcu_read_lock();
-
-	dev_cgroup =3D task_devcgroup(current);
-
-	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
-		if (wh->type & DEV_ALL)
-			goto found;
-		if ((wh->type & DEV_BLOCK) && !S_ISBLK(mode))
-			continue;
-		if ((wh->type & DEV_CHAR) && !S_ISCHR(mode))
-			continue;
-		if (wh->major !=3D ~0 && wh->major !=3D MAJOR(dev))
-			continue;
-		if (wh->minor !=3D ~0 && wh->minor !=3D MINOR(dev))
-			continue;
-
-		if (!(wh->access & ACC_MKNOD))
-			continue;
-found:
-		rcu_read_unlock();
-		return 0;
-	}
+	if (S_ISBLK(mode))
+		type =3D DEV_BLOCK;
+	else
+		type =3D DEV_CHAR;
=20
-	rcu_read_unlock();
+	return __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
+					    MINOR(dev), ACC_MKNOD);
=20
-	return -EPERM;
 }
