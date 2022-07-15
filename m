From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3 cgroup/for-5.20] cgroup: Elide write-locking
 threadgroup_rwsem when updating csses on an empty subtree
Date: Thu, 14 Jul 2022 18:38:15 -1000
Message-ID: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=kUYCCkCp2sZaFmaobvAgo9eIoVvtPeHxItnEuLVK4Pw=;
        b=pvgxeU3HgvzlG1Ih8myLZ5v7kjtFLSKMmhkrsYSOL06XJOSBeokm6WYkCPBF/VJvn+
         C3fnZnZgBPiA6Jwqi74UoFqyQkXq7b2Vdmi2//HmEGDrkbKH8+cBhFCG2NQqus+foDOw
         MyUCZ51bODeq7F0bkhYdjvzu0jQn8QeHJ58mRkZmWh6dD5D3DXlvmyTgtaJbbHyg57Ns
         qDstWAtJfgEzCEhmK8gCY7i2J1KoHycaQoU+7mBmb8LIePeSjKDOXRdeNOIknMtGn81y
         RBtQrdOdqqSr2ZaTmv71trPPP7o7EPBTkg5SX6UaEMwuF4TYc48OXftNZ2duZVaJHa+i
         hA0Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Christian Brauner <brauner@kernel.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>, John Stultz <john.stultz@linaro.org>, Dmitry Shmidt <dimitrysh@google.com>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

cgroup_update_dfl_csses() write-lock the threadgroup_rwsem as updating the
csses can trigger process migrations. However, if the subtree doesn't
contain any tasks, there aren't gonna be any cgroup migrations. This
condition can be trivially detected by testing whether
mgctx.preloaded_src_csets is empty. Elide write-locking threadgroup_rwsem if
the subtree is empty.

After this optimization, the usage pattern of creating a cgroup, enabling
the necessary controllers, and then seeding it with CLONE_INTO_CGROUP and
then removing the cgroup after it becomes empty doesn't need to write-lock
threadgroup_rwsem at all.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Michal Koutn=FD <mkoutny@suse.com>
---
 kernel/cgroup/cgroup.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2933,12 +2933,11 @@ static int cgroup_update_dfl_csses(struc
 	struct cgroup_subsys_state *d_css;
 	struct cgroup *dsct;
 	struct css_set *src_cset;
+	bool has_tasks;
 	int ret;
=20
 	lockdep_assert_held(&cgroup_mutex);
=20
-	percpu_down_write(&cgroup_threadgroup_rwsem);
-
 	/* look up all csses currently attached to @cgrp's subtree */
 	spin_lock_irq(&css_set_lock);
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
@@ -2949,6 +2948,16 @@ static int cgroup_update_dfl_csses(struc
 	}
 	spin_unlock_irq(&css_set_lock);
=20
+	/*
+	 * We need to write-lock threadgroup_rwsem while migrating tasks.
+	 * However, if there are no source csets for @cgrp, changing its
+	 * controllers isn't gonna produce any task migrations and the
+	 * write-locking can be skipped safely.
+	 */
+	has_tasks =3D !list_empty(&mgctx.preloaded_src_csets);
+	if (has_tasks)
+		percpu_down_write(&cgroup_threadgroup_rwsem);
+
 	/* NULL dst indicates self on default hierarchy */
 	ret =3D cgroup_migrate_prepare_dst(&mgctx);
 	if (ret)
@@ -2967,7 +2976,8 @@ static int cgroup_update_dfl_csses(struc
 	ret =3D cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	if (has_tasks)
+		percpu_up_write(&cgroup_threadgroup_rwsem);
 	return ret;
 }
=20
