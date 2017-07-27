From: Roman Gushchin <guro@fb.com>
Subject: [PATCH] cgroup: add cgroup.stat interface with basic hierarchy stats
Date: Thu, 27 Jul 2017 17:14:20 +0100
Message-ID: <20170727161420.2552-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=04V2EHctSKw/Wdcw/X7Ik52+hHtu2D83WS8Y4rhitvw=;
 b=BceppFwBptfv4mGv26BgstPYEhu03gpGTAictubvfqwiQ0reGuNY/WvhqaOvnr8h28lY
 O+7YTLzg9NNf4FbDk49Rp67wip8Mkf3N51FwzQEJoJZKxH/S9AV6D94fZnqvz+NT0BzQ
 26sY43N7+nGLprs6eLlyACEJxvP60jNO9oM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=04V2EHctSKw/Wdcw/X7Ik52+hHtu2D83WS8Y4rhitvw=;
 b=B0gsx2QKeb4YisbAKbgu6D9N4OC8WMCqCiOWAkkgQtOQ8LTjp08tPxlFJI1QLlq3A1dPGQakzFWsCbL8uaIVgKBwUaem9qAT72lag5UksAxvhc0NdiNhxn+xjcidQkoF4Klm41r9oQ4dciBvkBMec7RdVCecZWuxuzloa6Gclww=
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Add a cgroup.stat interface to the base cgroup control files
with the following metrics:

nr_descendants		total number of descendant cgroups
nr_dying_descendants	total number of dying descendant cgroups
max_descendant_depth	maximum descent depth below the current cgroup

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/cgroup-v2.txt | 12 ++++++++++++
 kernel/cgroup/cgroup.c      | 31 +++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index dec5afdaa36d..ae9cc0d917b3 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -854,6 +854,18 @@ All cgroup core files are prefixed with "cgroup."
 		1 if the cgroup or its descendants contains any live
 		processes; otherwise, 0.
 
+  cgroup.stat
+	A read-only flat-keyed file with the following entries:
+
+	  nr_descendants
+		Total number of descendant cgroups.
+
+	  nr_dying_descendants
+		Total number of dying descendant cgroups.
+
+	  max_descendant_depth
+		Maximum descent depth below the current cgroup.
+
 
 Controllers
 ===========
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 85f6a112344b..b7af1745d46c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3216,6 +3216,33 @@ static int cgroup_events_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static int cgroup_stats_show(struct seq_file *seq, void *v)
+{
+	struct cgroup_subsys_state *css;
+	unsigned long total = 0;
+	unsigned long offline = 0;
+	int max_level = 0;
+
+	rcu_read_lock();
+	css_for_each_descendant_pre(css, seq_css(seq)) {
+		if (css == seq_css(seq))
+			continue;
+		++total;
+		if (!(css->flags & CSS_ONLINE))
+			++offline;
+		if (css->cgroup->level > max_level)
+			max_level = css->cgroup->level;
+	}
+	rcu_read_unlock();
+
+	seq_printf(seq, "nr_descendants %lu\n", total);
+	seq_printf(seq, "nr_dying_descendants %lu\n", offline);
+	seq_printf(seq, "max_descendant_depth %d\n",
+		   max_level - seq_css(seq)->cgroup->level);
+
+	return 0;
+}
+
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
@@ -4309,6 +4336,10 @@ static struct cftype cgroup_base_files[] = {
 		.file_offset = offsetof(struct cgroup, events_file),
 		.seq_show = cgroup_events_show,
 	},
+	{
+		.name = "cgroup.stat",
+		.seq_show = cgroup_stats_show,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.13.3

