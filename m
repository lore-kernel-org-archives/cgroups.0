From: Roman Gushchin <guro@fb.com>
Subject: Re: [RFC 2/4] cgroup: implement hierarchy limits
Date: Wed, 2 Aug 2017 19:55:05 +0100
Message-ID: <20170802185505.GA7939@castle.dhcp.TheFacebook.com>
References: <20170802165532.22277-1-guro@fb.com>
 <20170802165532.22277-3-guro@fb.com>
 <20170802184416.GK2311718@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=ZDOz4B9ycB/5MJGkn/il5tBlKf+SNwcFhkjXX5bakjY=;
 b=EUytPXsDqPomvHVTIUqQ5lxtAgZ4z5zVy3YUiVXMIeJlrEYw6zLFiuEjra7WQ3mG+lcY
 +ztv6y91CA86MxC0ULmR9JFNKcbDrG8ouCoJteFoqJVTgSCaiFYduUlstgEzghIMM6Oj
 RQYp11trelcOxpbIFZuzur7ah9hX9vT6FgU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZDOz4B9ycB/5MJGkn/il5tBlKf+SNwcFhkjXX5bakjY=;
 b=Se+xHDrcKfJ2mjXsw4bpOUwm4KAUvmacbg+P0oAR9yJ/8MMPJhKnGzeenh/klRAcB1muSYDco/94Wubq/vs6W+PorAckG16MQjUS+W43gZN2q1I6Mr0LwbqF1PW/7FiSw6J9V3u0MK+84FuwQs15aBD2tQ462Iw0WkPqcjgU7a4=
Content-Disposition: inline
In-Reply-To: <20170802184416.GK2311718@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, Zefan Li <lizefan@huawei.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Aug 02, 2017 at 11:44:17AM -0700, Tejun Heo wrote:
> Hello, Roman.
> 
> Generally looks good to me.  One minor nit.
> 
> On Wed, Aug 02, 2017 at 05:55:30PM +0100, Roman Gushchin wrote:
> > +static ssize_t cgroup_max_descendants_write(struct kernfs_open_file *of,
> > +					   char *buf, size_t nbytes, loff_t off)
> > +{
> > +	struct cgroup *cgrp;
> > +	int descendants;
> > +	ssize_t ret;
> > +
> > +	buf = strstrip(buf);
> > +	if (!strcmp(buf, "max")) {
> > +		descendants = INT_MAX;
> > +	} else {
> > +		ret = kstrtouint(buf, 0, &descendants);
>                      ^^^^^^^^^^^
> 		     shouldn't this be kstrtoint?

Hi, Tejun!

Of course, it should.
Please, find an updated version below.

Thank you!

Roman

--

From c6492640f7a70b88e4b573c6f04081e3c82ce8fa Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Fri, 28 Jul 2017 18:28:44 +0100
Subject: [PATCH 2/4] cgroup: implement hierarchy limits

Creating cgroup hierearchies of unreasonable size can affect
overall system performance. A user might want to limit the
size of cgroup hierarchy. This is especially important if a user
is delegating some cgroup sub-tree.

To address this issue, introduce an ability to control
the size of cgroup hierarchy.

The cgroup.max.descendants control file allows to set the maximum
allowed number of descendant cgroups.
The cgroup.max.depth file controls the maximum depth of the cgroup
tree. Both are single value r/w files, with "max" default value.

The control files exist on each hierarchy level (including root).
When a new cgroup is created, we check the total descendants
and depth limits on each level, and if none of them are exceeded,
a new cgroup is created.

Only alive cgroups are counted, removed (dying) cgroups are
ignored.

Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/cgroup-v2.txt |  14 +++++
 include/linux/cgroup-defs.h |   5 ++
 kernel/cgroup/cgroup.c      | 126 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index dec5afdaa36d..46ec3f76211c 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -854,6 +854,20 @@ All cgroup core files are prefixed with "cgroup."
 		1 if the cgroup or its descendants contains any live
 		processes; otherwise, 0.
 
+  cgroup.max.descendants
+	A read-write single value files.  The default is "max".
+
+	Maximum allowed number of descent cgroups.
+	If the actual number of descendants is equal or larger,
+	an attempt to create a new cgroup in the hierarchy will fail.
+
+  cgroup.max.depth
+	A read-write single value files.  The default is "max".
+
+	Maximum allowed descent depth below the current cgroup.
+	If the actual descent depth is equal or larger,
+	an attempt to create a new child cgroup will fail.
+
 
 Controllers
 ===========
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 58b4c425a155..59e4ad9e7bac 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -273,13 +273,18 @@ struct cgroup {
 	 */
 	int level;
 
+	/* Maximum allowed descent tree depth */
+	int max_depth;
+
 	/*
 	 * Keep track of total numbers of visible and dying descent cgroups.
 	 * Dying cgroups are cgroups which were deleted by a user,
 	 * but are still existing because someone else is holding a reference.
+	 * max_descendants is a maximum allowed number of descent cgroups.
 	 */
 	int nr_descendants;
 	int nr_dying_descendants;
+	int max_descendants;
 
 	/*
 	 * Each non-empty css_set associated with this cgroup contributes
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index cfdbb1e780de..0fd9134e1720 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1827,6 +1827,8 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	cgrp->self.cgroup = cgrp;
 	cgrp->self.flags |= CSS_ONLINE;
 	cgrp->dom_cgrp = cgrp;
+	cgrp->max_descendants = INT_MAX;
+	cgrp->max_depth = INT_MAX;
 
 	for_each_subsys(ss, ssid)
 		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
@@ -3209,6 +3211,92 @@ static ssize_t cgroup_type_write(struct kernfs_open_file *of, char *buf,
 	return ret ?: nbytes;
 }
 
+static int cgroup_max_descendants_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	int descendants = READ_ONCE(cgrp->max_descendants);
+
+	if (descendants == INT_MAX)
+		seq_puts(seq, "max\n");
+	else
+		seq_printf(seq, "%d\n", descendants);
+
+	return 0;
+}
+
+static ssize_t cgroup_max_descendants_write(struct kernfs_open_file *of,
+					   char *buf, size_t nbytes, loff_t off)
+{
+	struct cgroup *cgrp;
+	int descendants;
+	ssize_t ret;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, "max")) {
+		descendants = INT_MAX;
+	} else {
+		ret = kstrtoint(buf, 0, &descendants);
+		if (ret)
+			return ret;
+	}
+
+	if (descendants < 0 || descendants > INT_MAX)
+		return -ERANGE;
+
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENOENT;
+
+	cgrp->max_descendants = descendants;
+
+	cgroup_kn_unlock(of->kn);
+
+	return nbytes;
+}
+
+static int cgroup_max_depth_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	int depth = READ_ONCE(cgrp->max_depth);
+
+	if (depth == INT_MAX)
+		seq_puts(seq, "max\n");
+	else
+		seq_printf(seq, "%d\n", depth);
+
+	return 0;
+}
+
+static ssize_t cgroup_max_depth_write(struct kernfs_open_file *of,
+				      char *buf, size_t nbytes, loff_t off)
+{
+	struct cgroup *cgrp;
+	ssize_t ret;
+	int depth;
+
+	buf = strstrip(buf);
+	if (!strcmp(buf, "max")) {
+		depth = INT_MAX;
+	} else {
+		ret = kstrtoint(buf, 0, &depth);
+		if (ret)
+			return ret;
+	}
+
+	if (depth < 0 || depth > INT_MAX)
+		return -ERANGE;
+
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENOENT;
+
+	cgrp->max_depth = depth;
+
+	cgroup_kn_unlock(of->kn);
+
+	return nbytes;
+}
+
 static int cgroup_events_show(struct seq_file *seq, void *v)
 {
 	seq_printf(seq, "populated %d\n",
@@ -4309,6 +4397,16 @@ static struct cftype cgroup_base_files[] = {
 		.file_offset = offsetof(struct cgroup, events_file),
 		.seq_show = cgroup_events_show,
 	},
+	{
+		.name = "cgroup.max.descendants",
+		.seq_show = cgroup_max_descendants_show,
+		.write = cgroup_max_descendants_write,
+	},
+	{
+		.name = "cgroup.max.depth",
+		.seq_show = cgroup_max_depth_show,
+		.write = cgroup_max_depth_write,
+	},
 	{ }	/* terminate */
 };
 
@@ -4662,6 +4760,29 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	return ERR_PTR(ret);
 }
 
+static bool cgroup_check_hierarchy_limits(struct cgroup *parent)
+{
+	struct cgroup *cgroup;
+	int ret = false;
+	int level = 1;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	for (cgroup = parent; cgroup; cgroup = cgroup_parent(cgroup)) {
+		if (cgroup->nr_descendants >= cgroup->max_descendants)
+			goto fail;
+
+		if (level > cgroup->max_depth)
+			goto fail;
+
+		level++;
+	}
+
+	ret = true;
+fail:
+	return ret;
+}
+
 int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 {
 	struct cgroup *parent, *cgrp;
@@ -4676,6 +4797,11 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 	if (!parent)
 		return -ENODEV;
 
+	if (!cgroup_check_hierarchy_limits(parent)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
 	cgrp = cgroup_create(parent);
 	if (IS_ERR(cgrp)) {
 		ret = PTR_ERR(cgrp);
-- 
2.13.3

