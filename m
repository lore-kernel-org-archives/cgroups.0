From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/4] mm/shmem: support deterministic charging of tmpfs
Date: Thu, 11 Nov 2021 15:42:00 -0800
Message-ID: <20211111234203.1824138-2-almasrymina@google.com>
References: <20211111234203.1824138-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=hhhBGiHo1owFEumWbv75KK8v4aTjrOx44gQLpz28MgY=;
        b=o27QKmXQPNCMqa688bbrGvW7CtGtFWwPMXw+RccYjhtzl2PwlMRHXHAniX3XlwYCDj
         kv8gAmHLgJbDlOKWBeqGUGX73BaFEuZjQBpNlg1QXtfFBQh1C2g7TjA5bN5hdDQhRx+8
         CjxPPNornrQYu6LnQG6I+LqkxRYKcXDJckrTQtK+wDopcS/IypADOOpeqvhzJoRsptan
         TUDJzjz3++Y2z2kc3uUaiKmUk3fQcxVzEWwWJeQ+lH6Q3SiwfyQDF9dB7CmL13RHAZaB
         N4roNRazhHVckPCyCIpa8zWWDeJ+RoizBsNqzzpIQm6dPtZwfTmfBPv6t/pHUmZNcmQ6
         gYxg==
In-Reply-To: <20211111234203.1824138-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Add memcg= option to shmem mount.

Users can specify this option at mount time and all data page charges
will be charged to the memcg supplied. Processes are only allowed to
direct tmpfs changes to a cgroup that they themselves can enter and
allocate memory in.

Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---

Changes in v3:
- Fixed build failures/warnings Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Changes in v2:
- Fixed Roman's email.
- Added a new wrapper around charge_memcg() instead of __mem_cgroup_charge()
- Merged the permission check into this patch as Roman suggested.
- Instead of checking for a s_memcg_to_charge off the superblock in the
filemap code, I set_active_memcg() before calling into the fs generic
code as Dave suggests.
- I have kept the s_memcg_to_charge in the superblock to keep the
struct address_space pointer small and preserve the remount use case..

---
 fs/super.c                 |   7 ++
 include/linux/fs.h         |   5 ++
 include/linux/memcontrol.h |  58 +++++++++++++++++
 mm/memcontrol.c            | 130 +++++++++++++++++++++++++++++++++++++
 mm/shmem.c                 |  73 ++++++++++++++++++++-
 5 files changed, 271 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 3bfc0f8fbd5bc..5484b08ba0025 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/memcontrol.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/writeback.h>		/* for the emergency remount stuff */
@@ -180,6 +181,9 @@ static void destroy_unused_super(struct super_block *s)
 	up_write(&s->s_umount);
 	list_lru_destroy(&s->s_dentry_lru);
 	list_lru_destroy(&s->s_inode_lru);
+#if CONFIG_MEMCG
+	mem_cgroup_set_charge_target(&s->s_memcg_to_charge, NULL);
+#endif
 	security_sb_free(s);
 	put_user_ns(s->s_user_ns);
 	kfree(s->s_subtype);
@@ -292,6 +296,9 @@ static void __put_super(struct super_block *s)
 		WARN_ON(s->s_dentry_lru.node);
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(!list_empty(&s->s_mounts));
+#if CONFIG_MEMCG
+		mem_cgroup_set_charge_target(&s->s_memcg_to_charge, NULL);
+#endif
 		security_sb_free(s);
 		fscrypt_sb_free(s);
 		put_user_ns(s->s_user_ns);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3afca821df32e..59407b3e7aee3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1567,6 +1567,11 @@ struct super_block {
 	struct workqueue_struct *s_dio_done_wq;
 	struct hlist_head s_pins;

+#ifdef CONFIG_MEMCG
+	/* memcg to charge for pages allocated to this filesystem */
+	struct mem_cgroup *s_memcg_to_charge;
+#endif
+
 	/*
 	 * Owning user namespace and default context in which to
 	 * interpret filesystem uids, gids, quotas, device nodes,
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0c5c403f4be6b..8583d37c05d9b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -27,6 +27,7 @@ struct obj_cgroup;
 struct page;
 struct mm_struct;
 struct kmem_cache;
+struct super_block;

 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
@@ -713,6 +714,9 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 	return __mem_cgroup_charge(folio, mm, gfp);
 }

+int mem_cgroup_charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
+			    gfp_t gfp);
+
 int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
@@ -923,6 +927,24 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 	return !!(memcg->css.flags & CSS_ONLINE);
 }

+struct mem_cgroup *
+mem_cgroup_mapping_get_charge_target(struct address_space *mapping);
+
+static inline void mem_cgroup_put_memcg(struct mem_cgroup *memcg)
+{
+	if (memcg)
+		css_put(&memcg->css);
+}
+
+void mem_cgroup_set_charge_target(struct mem_cgroup **target,
+				  struct mem_cgroup *memcg);
+struct mem_cgroup *mem_cgroup_get_from_path(const char *path);
+/**
+ * User is responsible for providing a buffer @buf of length @len and freeing
+ * it.
+ */
+int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf, size_t len);
+
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int zid, int nr_pages);

@@ -1223,6 +1245,42 @@ static inline int mem_cgroup_charge(struct folio *folio,
 	return 0;
 }

+static inline int mem_cgroup_charge_memcg(struct folio *folio,
+					  struct mem_cgroup *memcg,
+					  gfp_t gfp_mask)
+{
+	return 0;
+}
+
+static inline struct mem_cgroup *
+mem_cgroup_mapping_get_charge_target(struct address_space *mapping)
+{
+	return NULL;
+}
+
+static inline void mem_cgroup_put_memcg(struct mem_cgroup *memcg)
+{
+}
+
+static inline void mem_cgroup_set_charge_target(struct mem_cgroup **target,
+						struct mem_cgroup *memcg)
+{
+}
+
+static inline struct mem_cgroup *mem_cgroup_get_from_path(const char *path)
+{
+	return NULL;
+}
+
+static inline int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf,
+					      size_t len)
+{
+	if (len < 1)
+		return -EINVAL;
+	buf[0] = '\0';
+	return 0;
+}
+
 static inline int mem_cgroup_swapin_charge_page(struct page *page,
 			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 781605e920153..b3d8f52a63d17 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -62,6 +62,7 @@
 #include <linux/tracehook.h>
 #include <linux/psi.h>
 #include <linux/seq_buf.h>
+#include <linux/string.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -2580,6 +2581,126 @@ void mem_cgroup_handle_over_high(void)
 	css_put(&memcg->css);
 }

+/*
+ * Non error return value must eventually be released with css_put().
+ */
+struct mem_cgroup *mem_cgroup_get_from_path(const char *path)
+{
+	static const char procs_filename[] = "/cgroup.procs";
+	struct file *file, *procs;
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	char *procs_path =
+		kmalloc(strlen(path) + sizeof(procs_filename), GFP_KERNEL);
+
+	if (procs_path == NULL)
+		return ERR_PTR(-ENOMEM);
+	strcpy(procs_path, path);
+	strcat(procs_path, procs_filename);
+
+	procs = filp_open(procs_path, O_WRONLY, 0);
+	kfree(procs_path);
+
+	/*
+	 * Restrict the capability for tasks to mount with memcg charging to the
+	 * cgroup they could not join. For example, disallow:
+	 *
+	 * mount -t tmpfs -o memcg=root-cgroup nodev <MOUNT_DIR>
+	 *
+	 * if it is a non-root task.
+	 */
+	if (IS_ERR(procs))
+		return (struct mem_cgroup *)procs;
+	fput(procs);
+
+	file = filp_open(path, O_DIRECTORY | O_RDONLY, 0);
+	if (IS_ERR(file))
+		return (struct mem_cgroup *)file;
+
+	css = css_tryget_online_from_dir(file->f_path.dentry,
+					 &memory_cgrp_subsys);
+	if (IS_ERR(css))
+		memcg = (struct mem_cgroup *)css;
+	else
+		memcg = container_of(css, struct mem_cgroup, css);
+
+	fput(file);
+	return memcg;
+}
+
+/*
+ * Get the name of the optional charge target memcg associated with @sb.  This
+ * is the cgroup name, not the cgroup path.
+ */
+int mem_cgroup_get_name_from_sb(struct super_block *sb, char *buf, size_t len)
+{
+	struct mem_cgroup *memcg;
+	int ret = 0;
+
+	buf[0] = '\0';
+
+	rcu_read_lock();
+	memcg = rcu_dereference(sb->s_memcg_to_charge);
+	if (memcg && !css_tryget_online(&memcg->css))
+		memcg = NULL;
+	rcu_read_unlock();
+
+	if (!memcg)
+		return 0;
+
+	ret = cgroup_path(memcg->css.cgroup, buf + len / 2, len / 2);
+	if (ret >= len / 2)
+		strcpy(buf, "?");
+	else {
+		char *p = mangle_path(buf, buf + len / 2, " \t\n\\");
+
+		if (p)
+			*p = '\0';
+		else
+			strcpy(buf, "?");
+	}
+
+	css_put(&memcg->css);
+	return ret < 0 ? ret : 0;
+}
+
+/*
+ * Set or clear (if @memcg is NULL) charge association from file system to
+ * memcg.  If @memcg != NULL, then a css reference must be held by the caller to
+ * ensure that the cgroup is not deleted during this operation.
+ */
+void mem_cgroup_set_charge_target(struct mem_cgroup **target,
+				  struct mem_cgroup *memcg)
+{
+	if (memcg)
+		css_get(&memcg->css);
+	memcg = xchg(target, memcg);
+	if (memcg)
+		css_put(&memcg->css);
+}
+
+/*
+ * Returns the memcg to charge for inode pages.  If non-NULL is returned, caller
+ * must drop reference with css_put().  NULL indicates that the inode does not
+ * have a memcg to charge, so the default process based policy should be used.
+ */
+struct mem_cgroup *
+mem_cgroup_mapping_get_charge_target(struct address_space *mapping)
+{
+	struct mem_cgroup *memcg;
+
+	if (!mapping)
+		return NULL;
+
+	rcu_read_lock();
+	memcg = rcu_dereference(mapping->host->i_sb->s_memcg_to_charge);
+	if (memcg && !css_tryget_online(&memcg->css))
+		memcg = NULL;
+	rcu_read_unlock();
+
+	return memcg;
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			unsigned int nr_pages)
 {
@@ -6678,6 +6799,15 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 	return ret;
 }

+int mem_cgroup_charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
+			    gfp_t gfp)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+
+	return charge_memcg(folio, memcg, gfp);
+}
+
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/shmem.c b/mm/shmem.c
index 23c91a8beb781..8b623c49ee50d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -115,10 +115,14 @@ struct shmem_options {
 	bool full_inums;
 	int huge;
 	int seen;
+#if CONFIG_MEMCG
+	struct mem_cgroup *memcg;
+#endif
 #define SHMEM_SEEN_BLOCKS 1
 #define SHMEM_SEEN_INODES 2
 #define SHMEM_SEEN_HUGE 4
 #define SHMEM_SEEN_INUMS 8
+#define SHMEM_SEEN_MEMCG 16
 };

 #ifdef CONFIG_TMPFS
@@ -697,6 +701,7 @@ static int shmem_add_to_page_cache(struct page *page,
 	unsigned long i = 0;
 	unsigned long nr = compound_nr(page);
 	int error;
+	struct mem_cgroup *remote_memcg;

 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(index != round_down(index, nr), page);
@@ -709,7 +714,14 @@ static int shmem_add_to_page_cache(struct page *page,
 	page->index = index;

 	if (!PageSwapCache(page)) {
-		error = mem_cgroup_charge(page_folio(page), charge_mm, gfp);
+		remote_memcg = mem_cgroup_mapping_get_charge_target(mapping);
+		if (remote_memcg) {
+			error = mem_cgroup_charge_memcg(page_folio(page),
+							remote_memcg, gfp);
+			mem_cgroup_put_memcg(remote_memcg);
+		} else
+			error = mem_cgroup_charge(page_folio(page), charge_mm,
+						  gfp);
 		if (error) {
 			if (PageTransHuge(page)) {
 				count_vm_event(THP_FILE_FALLBACK);
@@ -1822,6 +1834,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	int error;
 	int once = 0;
 	int alloced = 0;
+	struct mem_cgroup *remote_memcg, *old_memcg;

 	if (index > (MAX_LFS_FILESIZE >> PAGE_SHIFT))
 		return -EFBIG;
@@ -1834,8 +1847,21 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	sbinfo = SHMEM_SB(inode->i_sb);
 	charge_mm = vma ? vma->vm_mm : NULL;

+	/*
+	 * If we're doing a remote charge here, set the active_memcg as the
+	 * remote memcg, so that eventually if pagecache_get_page() calls into
+	 * filemap_add_folio(), we charge the correct memcg.
+	 */
+	remote_memcg = mem_cgroup_mapping_get_charge_target(mapping);
+	if (remote_memcg)
+		old_memcg = set_active_memcg(remote_memcg);
+
 	page = pagecache_get_page(mapping, index,
 					FGP_ENTRY | FGP_HEAD | FGP_LOCK, 0);
+	if (remote_memcg) {
+		set_active_memcg(old_memcg);
+		mem_cgroup_put_memcg(remote_memcg);
+	}

 	if (page && vma && userfaultfd_minor(vma)) {
 		if (!xa_is_value(page)) {
@@ -3342,6 +3368,7 @@ static const struct export_operations shmem_export_ops = {
 enum shmem_param {
 	Opt_gid,
 	Opt_huge,
+	Opt_memcg,
 	Opt_mode,
 	Opt_mpol,
 	Opt_nr_blocks,
@@ -3363,6 +3390,7 @@ static const struct constant_table shmem_param_enums_huge[] = {
 const struct fs_parameter_spec shmem_fs_parameters[] = {
 	fsparam_u32   ("gid",		Opt_gid),
 	fsparam_enum  ("huge",		Opt_huge,  shmem_param_enums_huge),
+	fsparam_string("memcg",		Opt_memcg),
 	fsparam_u32oct("mode",		Opt_mode),
 	fsparam_string("mpol",		Opt_mpol),
 	fsparam_string("nr_blocks",	Opt_nr_blocks),
@@ -3379,6 +3407,9 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 	struct shmem_options *ctx = fc->fs_private;
 	struct fs_parse_result result;
 	unsigned long long size;
+#if CONFIG_MEMCG
+	struct mem_cgroup *memcg;
+#endif
 	char *rest;
 	int opt;

@@ -3412,6 +3443,17 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 			goto bad_value;
 		ctx->seen |= SHMEM_SEEN_INODES;
 		break;
+#if CONFIG_MEMCG
+	case Opt_memcg:
+		if (ctx->memcg)
+			css_put(&ctx->memcg->css);
+		memcg = mem_cgroup_get_from_path(param->string);
+		if (IS_ERR(memcg))
+			goto bad_value;
+		ctx->memcg = memcg;
+		ctx->seen |= SHMEM_SEEN_MEMCG;
+		break;
+#endif
 	case Opt_mode:
 		ctx->mode = result.uint_32 & 07777;
 		break;
@@ -3573,6 +3615,14 @@ static int shmem_reconfigure(struct fs_context *fc)
 	}
 	raw_spin_unlock(&sbinfo->stat_lock);
 	mpol_put(mpol);
+#if CONFIG_MEMCG
+	if (ctx->seen & SHMEM_SEEN_MEMCG && ctx->memcg) {
+		mem_cgroup_set_charge_target(&fc->root->d_sb->s_memcg_to_charge,
+					     ctx->memcg);
+		css_put(&ctx->memcg->css);
+		ctx->memcg = NULL;
+	}
+#endif
 	return 0;
 out:
 	raw_spin_unlock(&sbinfo->stat_lock);
@@ -3582,6 +3632,11 @@ static int shmem_reconfigure(struct fs_context *fc)
 static int shmem_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(root->d_sb);
+	int err;
+	char *buf = __getname();
+
+	if (!buf)
+		return -ENOMEM;

 	if (sbinfo->max_blocks != shmem_default_max_blocks())
 		seq_printf(seq, ",size=%luk",
@@ -3625,7 +3680,13 @@ static int shmem_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",huge=%s", shmem_format_huge(sbinfo->huge));
 #endif
 	shmem_show_mpol(seq, sbinfo->mpol);
-	return 0;
+	/* Memory cgroup binding: memcg=cgroup_name */
+	err = mem_cgroup_get_name_from_sb(root->d_sb, buf, PATH_MAX);
+	if (!err && buf[0] != '\0')
+		seq_printf(seq, ",memcg=%s", buf);
+
+	__putname(buf);
+	return err;
 }

 #endif /* CONFIG_TMPFS */
@@ -3710,6 +3771,14 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_flags |= SB_POSIXACL;
 #endif
 	uuid_gen(&sb->s_uuid);
+#if CONFIG_MEMCG
+	if (ctx->memcg) {
+		mem_cgroup_set_charge_target(&sb->s_memcg_to_charge,
+					     ctx->memcg);
+		css_put(&ctx->memcg->css);
+		ctx->memcg = NULL;
+	}
+#endif

 	inode = shmem_get_inode(sb, NULL, S_IFDIR | sbinfo->mode, 0, VM_NORESERVE);
 	if (!inode)
