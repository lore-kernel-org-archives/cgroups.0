From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/8] cgroup: replace cftype->mode with CFTYPE_WORLD_WRITABLE
Date: Tue, 11 Aug 2015 13:58:03 -0400
Message-ID: <1439315889-3492-3-git-send-email-tj@kernel.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wXH/xk1G9HLNNgDrtjbiykEuG9WSXaIyrMEwoYbCUwE=;
        b=wG49czoC6/DU3AGXvAauEg1hmu6B+YxHk/wwAcaV5ITSd9geVHjaps3njijUyhtHCc
         8OZjbGxIZZ/csL/jp4IFoiothjqXaDtLka3LyzSWUOlM8wzCeOD6y3exiuSXq5mVZIEc
         wkUWLM7xJaLmd5BMX1HW1FgieGeRVAnqS9lGkSLpZNSq1cW2ldZjwmAod92cmeRJfJzr
         oH58++NyeiiDnvWZsrERfOt/YFXUUDt8cAGxHFmlMes/PkpnOT0iv7I31KNbEqAQZHqp
         ltxEzlWIoo/Pz4tZb9ne+xoUPmym7Vr4EvyO0O5enISJ8IYidUAEOWKF+oyTDBPejKL7
         yngw==
In-Reply-To: <1439315889-3492-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cftype->mode allows controllers to give arbitrary permissions to
interface knobs.  Except for "cgroup.event_control", the existing uses
are spurious.

* Some explicitly specify S_IRUGO | S_IWUSR even though that's the
  default.

* "cpuset.memory_pressure" specifies S_IRUGO while also setting a
  write callback which returns -EACCES.  All it needs to do is simply
  not setting a write callback.

"cgroup.event_control" uses cftype->mode to make the file
world-writable.  It's a misdesigned interface and we don't want
controllers to be tweaking interface file permissions in general.
This patch removes cftype->mode and all its spurious uses and
implements CFTYPE_WORLD_WRITABLE for "cgroup.event_control" which is
marked as compatibility-only.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/cgroup-defs.h |  6 +-----
 kernel/cgroup.c             | 19 +++++++------------
 kernel/cpuset.c             |  6 ------
 mm/memcontrol.c             |  3 +--
 4 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 74d241d..93f48ca 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -76,6 +76,7 @@ enum {
 	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cgrp */
 	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
 	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
+	CFTYPE_WORLD_WRITABLE	= (1 << 4),	/* (DON'T USE FOR NEW FILES) S_IWUGO */
 
 	/* internal flags, do not use outside cgroup core proper */
 	__CFTYPE_ONLY_ON_DFL	= (1 << 16),	/* only on default hierarchy */
@@ -324,11 +325,6 @@ struct cftype {
 	 */
 	char name[MAX_CFTYPE_NAME];
 	unsigned long private;
-	/*
-	 * If not 0, file mode is set to this value, otherwise it will
-	 * be figured out automatically
-	 */
-	umode_t mode;
 
 	/*
 	 * The maximum length of string, excluding trailing nul, that can
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 43535fc..a909e4d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1044,23 +1044,21 @@ static char *cgroup_file_name(struct cgroup *cgrp, const struct cftype *cft,
  * cgroup_file_mode - deduce file mode of a control file
  * @cft: the control file in question
  *
- * returns cft->mode if ->mode is not 0
- * returns S_IRUGO|S_IWUSR if it has both a read and a write handler
- * returns S_IRUGO if it has only a read handler
- * returns S_IWUSR if it has only a write hander
+ * S_IRUGO for read, S_IWUSR for write.
  */
 static umode_t cgroup_file_mode(const struct cftype *cft)
 {
 	umode_t mode = 0;
 
-	if (cft->mode)
-		return cft->mode;
-
 	if (cft->read_u64 || cft->read_s64 || cft->seq_show)
 		mode |= S_IRUGO;
 
-	if (cft->write_u64 || cft->write_s64 || cft->write)
-		mode |= S_IWUSR;
+	if (cft->write_u64 || cft->write_s64 || cft->write) {
+		if (cft->flags & CFTYPE_WORLD_WRITABLE)
+			mode |= S_IWUGO;
+		else
+			mode |= S_IWUSR;
+	}
 
 	return mode;
 }
@@ -4270,7 +4268,6 @@ static struct cftype cgroup_dfl_base_files[] = {
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_PROCS,
 		.write = cgroup_procs_write,
-		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
 		.name = "cgroup.controllers",
@@ -4305,7 +4302,6 @@ static struct cftype cgroup_legacy_base_files[] = {
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_PROCS,
 		.write = cgroup_procs_write,
-		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
 		.name = "cgroup.clone_children",
@@ -4325,7 +4321,6 @@ static struct cftype cgroup_legacy_base_files[] = {
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_TASKS,
 		.write = cgroup_tasks_write,
-		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
 		.name = "notify_on_release",
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ee14e3a..4da3f45 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1594,9 +1594,6 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	case FILE_MEMORY_PRESSURE_ENABLED:
 		cpuset_memory_pressure_enabled = !!val;
 		break;
-	case FILE_MEMORY_PRESSURE:
-		retval = -EACCES;
-		break;
 	case FILE_SPREAD_PAGE:
 		retval = update_flag(CS_SPREAD_PAGE, cs, val);
 		break;
@@ -1863,9 +1860,6 @@ static struct cftype files[] = {
 	{
 		.name = "memory_pressure",
 		.read_u64 = cpuset_read_u64,
-		.write_u64 = cpuset_write_u64,
-		.private = FILE_MEMORY_PRESSURE,
-		.mode = S_IRUGO,
 	},
 
 	{
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index acb93c5..78ba418 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4360,8 +4360,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
 	{
 		.name = "cgroup.event_control",		/* XXX: for compat */
 		.write = memcg_write_event_control,
-		.flags = CFTYPE_NO_PREFIX,
-		.mode = S_IWUGO,
+		.flags = CFTYPE_NO_PREFIX | CFTYPE_WORLD_WRITABLE,
 	},
 	{
 		.name = "swappiness",
-- 
2.4.3
