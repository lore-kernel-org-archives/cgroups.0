From: Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH 2/3] cgroup/cpuset: introduce cpuset.mems.migration
Date: Mon, 26 Apr 2021 14:59:45 +0800
Message-ID: <20210426065946.40491-3-wuyun.abel@bytedance.com>
References: <20210426065946.40491-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4BNCpox+Q4e8hYikN+nhg8PF+MLOBfs4k+9TqIvGhtE=;
        b=QJxuoyQiUxZTDa/Le6Tgnac3owBGJVVO9dqLiEHwLd3gf9+w4zWj31kOFUN2EMPsiI
         iQlM05cgeuslqVIo9GDiJ+/BcodPYvU0paW2f/QlxkP6JYz8Ln3koJ4LZWw6MxcOsY00
         ygieNfzfUoM4PVeIm9jrlxnkBSJ0w80zsslt6LHVsuiN1UFUhPbEdbQIreAXugqhYTMk
         0R/p1B84nLxQf05CDejIb7NW20n5L1Azdn07BR2ps4yZH79PpH23EP827vM9ztjMsqG8
         z8yZAEcUBpspayVJkctv70+BVIznjIRqgWn1vEpXc+hE1Lb66ZcJctatvPGRiPISL9zN
         +L3g==
In-Reply-To: <20210426065946.40491-1-wuyun.abel@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: akpm@linux-foundation.org, lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, corbet@lwn.net
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Abel Wu <wuyun.abel@bytedance.com>

Some of our services are quite performance sensitive and
actually NUMA-aware designed, aka numa-services. The SLOs
can be easily violated when co-locate these services with
other workloads. Thus they are granted to occupy the whole
one or several NUMA nodes according to their quota.

When a NUMA node is assigned to numa-service, the workload
on that node needs to be moved away fast and complete. The
main aspects we cared about on the eviction are as follows:

a) it should complete soon enough so that numa-services
   won=E2=80=99t wait too long to hurt user experience
b) the workloads to be evicted could have massive usage on
   memory, and migrating such amount of memory may lead to
   a sudden severe performance drop lasting tens of seconds
   that some certain workloads may not afford
c) the impact of the eviction should be limited within the
   source and destination nodes
d) cgroup interface is preferred

So we come to a thought that:

1) fire up numa-services without waiting for memory migration
2) memory migration can be done asynchronously by using spare
   memory bandwidth

AutoNUMA seems to be a solution, but its scope is global which
violates c&d. And cpuset.memory_migrate performs in a synchronous
fashion which breaks a&b. So a mixture of them, the new cgroup2
interface cpuset.mems.migration, is introduced.

The new cpuset.mems.migration supports three modes:

 - "none" mode, meaning migration disabled
 - "sync" mode, which is exactly the same as the cgroup v1
   interface cpuset.memory_migrate
 - "lazy" mode, when walking through all the pages, unlike
   cpuset.memory_migrate, it only sets pages to protnone,
   and numa faults triggered by later touch will handle the
   movement.

See next patch for detailed information.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 kernel/cgroup/cpuset.c | 104 ++++++++++++++++++++++++++++++++---------
 mm/mempolicy.c         |   2 +-
 2 files changed, 84 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a945504c0ae7..ee84f168eea8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -212,6 +212,7 @@ typedef enum {
 	CS_MEM_EXCLUSIVE,
 	CS_MEM_HARDWALL,
 	CS_MEMORY_MIGRATE,
+	CS_MEMORY_MIGRATE_LAZY,
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
@@ -248,6 +249,11 @@ static inline int is_memory_migrate(const struct cpuse=
t *cs)
 	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
 }
=20
+static inline int is_memory_migrate_lazy(const struct cpuset *cs)
+{
+	return test_bit(CS_MEMORY_MIGRATE_LAZY, &cs->flags);
+}
+
 static inline int is_spread_page(const struct cpuset *cs)
 {
 	return test_bit(CS_SPREAD_PAGE, &cs->flags);
@@ -1594,6 +1600,7 @@ struct cpuset_migrate_mm_work {
 	struct mm_struct	*mm;
 	nodemask_t		from;
 	nodemask_t		to;
+	int			flags;
 };
=20
 static void cpuset_migrate_mm_workfn(struct work_struct *work)
@@ -1602,21 +1609,29 @@ static void cpuset_migrate_mm_workfn(struct work_st=
ruct *work)
 		container_of(work, struct cpuset_migrate_mm_work, work);
=20
 	/* on a wq worker, no need to worry about %current's mems_allowed */
-	do_migrate_pages(mwork->mm, &mwork->from, &mwork->to, MPOL_MF_MOVE_ALL);
+	do_migrate_pages(mwork->mm, &mwork->from, &mwork->to, mwork->flags);
 	mmput(mwork->mm);
 	kfree(mwork);
 }
=20
-static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
-							const nodemask_t *to)
+static void cpuset_migrate_mm(struct cpuset *cs, struct mm_struct *mm,
+			      const nodemask_t *from, const nodemask_t *to)
 {
-	struct cpuset_migrate_mm_work *mwork;
+	struct cpuset_migrate_mm_work *mwork =3D NULL;
+	int flags =3D 0;
=20
-	mwork =3D kzalloc(sizeof(*mwork), GFP_KERNEL);
+	if (is_memory_migrate_lazy(cs))
+		flags =3D MPOL_MF_LAZY;
+	else if (is_memory_migrate(cs))
+		flags =3D MPOL_MF_MOVE_ALL;
+
+	if (flags)
+		mwork =3D kzalloc(sizeof(*mwork), GFP_KERNEL);
 	if (mwork) {
 		mwork->mm =3D mm;
 		mwork->from =3D *from;
 		mwork->to =3D *to;
+		mwork->flags =3D flags;
 		INIT_WORK(&mwork->work, cpuset_migrate_mm_workfn);
 		queue_work(cpuset_migrate_mm_wq, &mwork->work);
 	} else {
@@ -1690,7 +1705,6 @@ static void update_tasks_nodemask(struct cpuset *cs)
 	css_task_iter_start(&cs->css, 0, &it);
 	while ((task =3D css_task_iter_next(&it))) {
 		struct mm_struct *mm;
-		bool migrate;
=20
 		cpuset_change_task_nodemask(task, &newmems);
=20
@@ -1698,13 +1712,8 @@ static void update_tasks_nodemask(struct cpuset *cs)
 		if (!mm)
 			continue;
=20
-		migrate =3D is_memory_migrate(cs);
-
 		mpol_rebind_mm(mm, &cs->mems_allowed);
-		if (migrate)
-			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
-		else
-			mmput(mm);
+		cpuset_migrate_mm(cs, mm, &cs->old_mems_allowed, &newmems);
 	}
 	css_task_iter_end(&it);
=20
@@ -1911,6 +1920,11 @@ static int update_flag(cpuset_flagbits_t bit, struct=
 cpuset *cs,
 	else
 		clear_bit(bit, &trialcs->flags);
=20
+	if (bit =3D=3D CS_MEMORY_MIGRATE)
+		clear_bit(CS_MEMORY_MIGRATE_LAZY, &trialcs->flags);
+	if (bit =3D=3D CS_MEMORY_MIGRATE_LAZY)
+		clear_bit(CS_MEMORY_MIGRATE, &trialcs->flags);
+
 	err =3D validate_change(cs, trialcs);
 	if (err < 0)
 		goto out;
@@ -2237,11 +2251,8 @@ static void cpuset_attach(struct cgroup_taskset *tse=
t)
 			 * @old_mems_allowed is the right nodesets that we
 			 * migrate mm from.
 			 */
-			if (is_memory_migrate(cs))
-				cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
-						  &cpuset_attach_nodemask_to);
-			else
-				mmput(mm);
+			cpuset_migrate_mm(cs, mm, &oldcs->old_mems_allowed,
+					  &cpuset_attach_nodemask_to);
 		}
 	}
=20
@@ -2258,6 +2269,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
=20
 typedef enum {
 	FILE_MEMORY_MIGRATE,
+	FILE_MEMORY_MIGRATE_LAZY,
 	FILE_CPULIST,
 	FILE_MEMLIST,
 	FILE_EFFECTIVE_CPULIST,
@@ -2275,11 +2287,8 @@ typedef enum {
 	FILE_SPREAD_SLAB,
 } cpuset_filetype_t;
=20
-static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype=
 *cft,
-			    u64 val)
+static int __cpuset_write_u64(struct cpuset *cs, cpuset_filetype_t type, u=
64 val)
 {
-	struct cpuset *cs =3D css_cs(css);
-	cpuset_filetype_t type =3D cft->private;
 	int retval =3D 0;
=20
 	get_online_cpus();
@@ -2305,6 +2314,9 @@ static int cpuset_write_u64(struct cgroup_subsys_stat=
e *css, struct cftype *cft,
 	case FILE_MEMORY_MIGRATE:
 		retval =3D update_flag(CS_MEMORY_MIGRATE, cs, val);
 		break;
+	case FILE_MEMORY_MIGRATE_LAZY:
+		retval =3D update_flag(CS_MEMORY_MIGRATE_LAZY, cs, val);
+		break;
 	case FILE_MEMORY_PRESSURE_ENABLED:
 		cpuset_memory_pressure_enabled =3D !!val;
 		break;
@@ -2324,6 +2336,12 @@ static int cpuset_write_u64(struct cgroup_subsys_sta=
te *css, struct cftype *cft,
 	return retval;
 }
=20
+static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype=
 *cft,
+			    u64 val)
+{
+	return __cpuset_write_u64(css_cs(css), cft->private, val);
+}
+
 static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype=
 *cft,
 			    s64 val)
 {
@@ -2473,6 +2491,8 @@ static u64 cpuset_read_u64(struct cgroup_subsys_state=
 *css, struct cftype *cft)
 		return is_sched_load_balance(cs);
 	case FILE_MEMORY_MIGRATE:
 		return is_memory_migrate(cs);
+	case FILE_MEMORY_MIGRATE_LAZY:
+		return is_memory_migrate_lazy(cs);
 	case FILE_MEMORY_PRESSURE_ENABLED:
 		return cpuset_memory_pressure_enabled;
 	case FILE_MEMORY_PRESSURE:
@@ -2555,6 +2575,40 @@ static ssize_t sched_partition_write(struct kernfs_o=
pen_file *of, char *buf,
 	return retval ?: nbytes;
 }
=20
+static int cpuset_mm_migration_show(struct seq_file *seq, void *v)
+{
+	struct cpuset *cs =3D css_cs(seq_css(seq));
+
+	if (is_memory_migrate_lazy(cs))
+		seq_puts(seq, "lazy\n");
+	else if (is_memory_migrate(cs))
+		seq_puts(seq, "sync\n");
+	else
+		seq_puts(seq, "none\n");
+	return 0;
+}
+
+static ssize_t cpuset_mm_migration_write(struct kernfs_open_file *of,
+					 char *buf, size_t nbytes, loff_t off)
+{
+	struct cpuset *cs =3D css_cs(of_css(of));
+	cpuset_filetype_t type =3D FILE_MEMORY_MIGRATE;
+	int turning_on =3D 1;
+	int retval;
+
+	buf =3D strstrip(buf);
+
+	if (!strcmp(buf, "none"))
+		turning_on =3D 0;
+	else if (!strcmp(buf, "lazy"))
+		type =3D FILE_MEMORY_MIGRATE_LAZY;
+	else if (strcmp(buf, "sync"))
+		return -EINVAL;
+
+	retval =3D __cpuset_write_u64(cs, type, turning_on);
+	return retval ?: nbytes;
+}
+
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -2711,6 +2765,14 @@ static struct cftype dfl_files[] =3D {
 		.flags =3D CFTYPE_DEBUG,
 	},
=20
+	{
+		.name =3D "mems.migration",
+		.seq_show =3D cpuset_mm_migration_show,
+		.write =3D cpuset_mm_migration_write,
+		.private =3D FILE_MEMORY_MIGRATE,
+		.flags =3D CFTYPE_NOT_ON_ROOT,
+	},
+
 	{ }	/* terminate */
 };
=20
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e0ae6997bbfb..f816b2ac5f52 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1097,7 +1097,7 @@ static int migrate_to_node(struct mm_struct *mm, int =
source, int dest,
 	 * need migration.  Between passing in the full user address
 	 * space range and MPOL_MF_DISCONTIG_OK, this call can not fail.
 	 */
-	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
+	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL | MPOL_MF_LAZY)));
 	queue_pages_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
=20
--=20
2.31.1

