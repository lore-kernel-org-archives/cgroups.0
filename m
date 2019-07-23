From: Philipp Hahn <hahn@univention.de>
Subject: Bug#931111: linux-image-4.9.0-9: Memory "leak" caused by CGroup as used by pam_systemd
Date: Tue, 23 Jul 2019 15:56:59 +0200
Message-ID: <ad0222ca-5fb0-4177-dc82-ca63f079e942@univention.de>
References: <156154446841.16461.12659721223363969171.reportbug@fixa.knut.univention.de>
Reply-To: Philipp Hahn <hahn@univention.de>, 931111@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------96D375F0260231941D7A2A1D"
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist2=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.931111.B931111.156389072621176@bugs.debian.org>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-URL: <https://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: cgroups@vger.kernel.org, systemd-devel@lists.freedesktop.org
Cc: Roman Gushchin <guro@fb.com>, =?UTF-8?Q?=E6=AE=B5=E7=86=8A=E6=98=A5?= <duanxiongchun@bytedance.com>

This is a multi-part message in MIME format.
--------------96D375F0260231941D7A2A1D
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi,

I analyzed the issue and the problem seems to be CGroup related:

- we're using 'pam_systemd' in "/etc/pam.d/common-session"

- each cron-job / login then creates a new CGroup below
"/sys/fs/cgroup/systemd/user.slice/" while that job / session is running

- when the job / session terminates, the directory is deleted by
pam_systemd.

- but the Linux kernel still uses the CGroup to track kernel internal
memory (SLAB objects, pending cache pages, ...?)

- inside the kernel the CGroup is marked as "dying", but it is only
garbage collected very later on

- until then it adds to memory pressure and very slowly pushed the
system into swap.


I back-ported the patch
<https://www.spinics.net/lists/cgroups/msg20611.html> from Roman
Gushchin to add some extra debugging, which indeed shows a large number
of "dying" cgroups:

> # find /sys/fs/cgroup/memory -name cgroup.stat -exec grep '^nr_dying_descendants [^0]'  {} +
>   /sys/fs/cgroup/memory/cgroup.stat:nr_dying_descendants 360
>   /sys/fs/cgroup/memory/user.slice/cgroup.stat:nr_dying_descendants 320
>   /sys/fs/cgroup/memory/user.slice/user-0.slice/cgroup.stat:nr_dying_descendants 303
>   /sys/fs/cgroup/memory/system.slice/cgroup.stat:nr_dying_descendants 40
> # grep ^memory /proc/cgroups 
>   memory  10      452     1

Removing "pam_systemd" from PAM makes the problem go away.

Later Debain kernels are compiled with "CONFIG_MEMCG_KMEM=y", which
prompted me to add "cgroup.memory=nokmem" to the kernel command line.
This also seems to reduce the problem, but I'm not 100% convinced that
it really improves the situation.


I do not have a very good reproducer, but creating a cron-job with just
> * * *  * *  root  dd if=/dev/urandom of=/var/tmp/test-$$ count=1 >/dev/null

will most often increase the number of dying CGs every minute by one.


I do not know who is at fault here, if it is
- the Linux kernel for not freeing those resources earlier
- systemd for using CGs in a broken way
- someone others fault.

Clearly this is not good and I would like to receive some feedback on
what could be done top solve this issue, as running cron jobs is user
exploitable and can be used to DoS the system.
While looking for existing bug reports I stumbled over 912411 in Debian,
which also claims that there is a CG related leak - with Linux 4.19.x.

Should "pam_systemd" maybe do something like this before deleting the CG
directory:
> echo 0 >/sys/fs/cgroup/memory/.../memory.force_empty


Some more details are available at our bug-tracker at
<https://forge.univention.org/bugzilla/show_bug.cgi?id=49614#c5>.

Debian-Bugs:
* <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=931111>
* <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=912411>

Sincerely
Philipp
-- 
Philipp Hahn
Open Source Software Engineer

Univention GmbH
be open.
Mary-Somerville-Str. 1
D-28359 Bremen
Tel.: +49 421 22232-0
Fax : +49 421 22232-99
hahn@univention.de

https://www.univention.de/
Geschäftsführer: Peter H. Ganten
HRB 20755 Amtsgericht Bremen
Steuer-Nr.: 71-597-02876

--------------96D375F0260231941D7A2A1D
Content-Type: text/x-patch;
 name="49614_linux-cgroup-dying.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="49614_linux-cgroup-dying.diff"

=46rom 0679dee03c6d706d57145ea92c23d08fa10a1999 Mon Sep 17 00:00:00 2001
Message-Id: <0679dee03c6d706d57145ea92c23d08fa10a1999.1562083574.git.hahn=
@univention.de>
From: Roman Gushchin <guro@fb.com>
Date: Wed, 2 Aug 2017 17:55:29 +0100
Subject: [PATCH] cgroup: keep track of number of descent cgroups

Keep track of the number of online and dying descent cgroups.

This data will be used later to add an ability to control cgroup
hierarchy (limit the depth and the number of descent cgroups)
and display hierarchy stats.

Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <hahn@univention.de>
Url: https://www.spinics.net/lists/cgroups/msg20611.html
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4922,6 +4922,18 @@ static struct cftype cgroup_dfl_base_fil
 	{ }	/* terminate */
 };
=20
+static int cgroup_stat_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgroup =3D seq_css(seq)->cgroup;
+
+	seq_printf(seq, "nr_descendants %d\n",
+		   cgroup->nr_descendants);
+	seq_printf(seq, "nr_dying_descendants %d\n",
+		   cgroup->nr_dying_descendants);
+
+	return 0;
+}
+
 /* cgroup core interface files for the legacy hierarchies */
 static struct cftype cgroup_legacy_base_files[] =3D {
 	{
@@ -4964,6 +4976,10 @@ static struct cftype cgroup_legacy_base_
 		.write =3D cgroup_release_agent_write,
 		.max_write_len =3D PATH_MAX - 1,
 	},
+	{
+		.name =3D "cgroup.stat",
+		.seq_show =3D cgroup_stat_show,
+	},
 	{ }	/* terminate */
 };
=20
@@ -5063,9 +5079,15 @@ static void css_release_work_fn(struct w
 		if (ss->css_released)
 			ss->css_released(css);
 	} else {
+		struct cgroup *tcgrp;
+
 		/* cgroup release path */
 		trace_cgroup_release(cgrp);
=20
+		for (tcgrp =3D cgroup_parent(cgrp); tcgrp;
+		     tcgrp =3D cgroup_parent(tcgrp))
+			tcgrp->nr_dying_descendants--;
+
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 		cgrp->id =3D -1;
=20
@@ -5262,9 +5284,13 @@ static struct cgroup *cgroup_create(stru
 	cgrp->root =3D root;
 	cgrp->level =3D level;
=20
-	for (tcgrp =3D cgrp; tcgrp; tcgrp =3D cgroup_parent(tcgrp))
+	for (tcgrp =3D cgrp; tcgrp; tcgrp =3D cgroup_parent(tcgrp)) {
 		cgrp->ancestor_ids[tcgrp->level] =3D tcgrp->id;
=20
+		if (tcgrp !=3D cgrp)
+			tcgrp->nr_descendants++;
+	}
+
 	if (notify_on_release(parent))
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
=20
@@ -5468,6 +5494,7 @@ static void kill_css(struct cgroup_subsy
 static int cgroup_destroy_locked(struct cgroup *cgrp)
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
+	struct cgroup *tcgrp;
 	struct cgroup_subsys_state *css;
 	struct cgrp_cset_link *link;
 	int ssid;
@@ -5512,6 +5539,11 @@ static int cgroup_destroy_locked(struct
 	 */
 	kernfs_remove(cgrp->kn);
=20
+	for (tcgrp =3D cgroup_parent(cgrp); tcgrp; tcgrp =3D cgroup_parent(tcgr=
p)) {
+		tcgrp->nr_descendants--;
+		tcgrp->nr_dying_descendants++;
+	}
+
 	check_for_release(cgroup_parent(cgrp));
=20
 	/* put the base reference */
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -245,6 +245,14 @@ struct cgroup {
 	int level;
=20
 	/*
+	 * Keep track of total numbers of visible and dying descent cgroups.
+	 * Dying cgroups are cgroups which were deleted by a user,
+	 * but are still existing because someone else is holding a reference.
+	 */
+	int nr_descendants;
+	int nr_dying_descendants;
+
+	/*
 	 * Each non-empty css_set associated with this cgroup contributes
 	 * one to populated_cnt.  All children with non-zero popuplated_cnt
 	 * of their own contribute one.  The count is zero iff there's no

--------------96D375F0260231941D7A2A1D--

