From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 cgroup/for-3.15-fixes 1/2] cgroup: introduce
 task_css_is_root()
Date: Wed, 7 May 2014 09:06:27 -0400
Message-ID: <20140507130627.GA16702@htj.dyndns.org>
References: <20140505223557.GU11231@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=J8D21cc502noX3v1oBOne8A4ug8rnpXSBrokw968HTw=;
        b=XnsvarcTCt5IEi4WEmxVXi0J8QwtnDdNJgVLh9o1OClNALKbTfvuxpwP+NxhnnBKK0
         C46uQfiJmhWwK7QiV6MCzkBPB5ijxhOkZUF6GjDvmaVhqW4laVfp5h2MUT9lN698hzxH
         fGJivqJqnSJotXrmYGbjDM/7m/Caze37RLEM8PK+G4LknD7jjw8CTOyfcfXIhyQ7E3On
         mEvxiSpkhy4cIdIxLdBBZs2IKDk56BRzX20MoUBgbm8wj70eXiaIHDMmZev3oe+alUBm
         NIoTWzeyuzVwOgfVQ6JIpCDHq/1OY6FV18mQv7WccijoLXvc2RDc11qCYTwUqItBe0Vj
         x77g==
Content-Disposition: inline
In-Reply-To: <20140505223557.GU11231-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Determining the css of a task usually requires RCU read lock as that's
the only thing which keeps the returned css accessible till its
reference is acquired; however, testing whether a task belongs to the
root can be performed without dereferencing the returned css by
comparing the returned pointer against the root one in init_css_set[]
which never changes.

Implement task_css_is_root() which can be invoked in any context.
This will be used by the scheduled cgroup_freezer change.

v2: cgroup no longer supports modular controllers.  No need to export
    init_css_set.  Pointed out by Li.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h |   15 +++++++++++++++
 kernel/cgroup.c        |    2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -473,6 +473,7 @@ struct cftype {
 };
 
 extern struct cgroup_root cgrp_dfl_root;
+extern struct css_set init_css_set;
 
 static inline bool cgroup_on_dfl(const struct cgroup *cgrp)
 {
@@ -700,6 +701,20 @@ static inline struct cgroup_subsys_state
 	return task_css_check(task, subsys_id, false);
 }
 
+/**
+ * task_css_is_root - test whether a task belongs to the root css
+ * @task: the target task
+ * @subsys_id: the target subsystem ID
+ *
+ * Test whether @task belongs to the root css on the specified subsystem.
+ * May be invoked in any context.
+ */
+static inline bool task_css_is_root(struct task_struct *task, int subsys_id)
+{
+	return task_css_check(task, subsys_id, true) ==
+		init_css_set.subsys[subsys_id];
+}
+
 static inline struct cgroup *task_cgroup(struct task_struct *task,
 					 int subsys_id)
 {
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -348,7 +348,7 @@ struct cgrp_cset_link {
  * reference-counted, to improve performance when child cgroups
  * haven't been created.
  */
-static struct css_set init_css_set = {
+struct css_set init_css_set = {
 	.refcount		= ATOMIC_INIT(1),
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
 	.tasks			= LIST_HEAD_INIT(init_css_set.tasks),
