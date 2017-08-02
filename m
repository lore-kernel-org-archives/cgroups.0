From: Roman Gushchin <guro@fb.com>
Subject: [RFC 3/4] cgroup: add cgroup.stat interface with basic hierarchy stats
Date: Wed, 2 Aug 2017 17:55:31 +0100
Message-ID: <20170802165532.22277-4-guro@fb.com>
References: <20170802165532.22277-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=WLxPRuSMEvM/EDq/oTfzm+MI1nmr5B6mxp7VPZk/Rmg=;
 b=rMcHgWulsi3ZE6LdH+XknltiYf6SkvjYmbSyjGeD9VsAf2dKO4Dn8S4W5OsFixv/4UaP
 TMyK9ZSNIQlRw0gCTGfSsgCrV63X0j67h5iODtRMsKpOKNHsAkvQVvMKu9ZWgXLAIfbC
 9RXoidSm2p5ufAT4bKQ+CVCWMxJiv2ytGDM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WLxPRuSMEvM/EDq/oTfzm+MI1nmr5B6mxp7VPZk/Rmg=;
 b=XPdGfEk9f5Yn4enTZ+vNyonhTed7z6ruEgD5zpICxyUODMdEta45Rdbvzf5sRH5yl/1RLIqUDTjlpRuCa5f7FPqzB3tnFdfJDYPXcHMlVj7XRvi5xAlE/CN6p4JewgPF1sfHhmD2slFoCe5/U5Sve+xNokBguXudex5DQUTGlSo=
In-Reply-To: <20170802165532.22277-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

A cgroup can consume resources even after being deleted by a user.
For example, writing back dirty pages should be accounted and
limited, despite the corresponding cgroup might contain no processes
and being deleted by a user.

In the current implementation a cgroup can remain in such "dying" state
for an undefined amount of time. For instance, if a memory cgroup
contains a pge, mlocked by a process belonging to an other cgroup.

Although the lifecycle of a dying cgroup is out of user's control,
it's important to have some insight of what's going on under the hood.

In particular, it's handy to have a counter which will allow
to detect css leaks.

To solve this problem, add a cgroup.stat interface to
the base cgroup control files with the following metrics:

nr_descendants		total number of visible descendant cgroups
nr_dying_descendants	total number of dying descendant cgroups

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
 Documentation/cgroup-v2.txt | 18 ++++++++++++++++++
 kernel/cgroup/cgroup.c      | 16 ++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 46ec3f76211c..dc44785dc0fa 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -868,6 +868,24 @@ All cgroup core files are prefixed with "cgroup."
 	If the actual descent depth is equal or larger,
 	an attempt to create a new child cgroup will fail.
 
+  cgroup.stat
+	A read-only flat-keyed file with the following entries:
+
+	  nr_descendants
+		Total number of visible descendant cgroups.
+
+	  nr_dying_descendants
+		Total number of dying descendant cgroups. A cgroup becomes
+		dying after being deleted by a user. The cgroup will remain
+		in dying state for some time undefined time (which can depend
+		on system load) before being completely destroyed.
+
+		A process can't enter a dying cgroup under any circumstances,
+		a dying cgroup can't revive.
+
+		A dying cgroup can consume system resources not exceeding
+		limits, which were active at the moment of cgroup deletion.
+
 
 Controllers
 ===========
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9d53d69e44bb..f58e1fe8bebd 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3304,6 +3304,18 @@ static int cgroup_events_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static int cgroup_stats_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgroup = seq_css(seq)->cgroup;
+
+	seq_printf(seq, "nr_descendants %d\n",
+		   cgroup->nr_descendants);
+	seq_printf(seq, "nr_dying_descendants %d\n",
+		   cgroup->nr_dying_descendants);
+
+	return 0;
+}
+
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
@@ -4407,6 +4419,10 @@ static struct cftype cgroup_base_files[] = {
 		.seq_show = cgroup_max_depth_show,
 		.write = cgroup_max_depth_write,
 	},
+	{
+		.name = "cgroup.stat",
+		.seq_show = cgroup_stats_show,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.13.3

