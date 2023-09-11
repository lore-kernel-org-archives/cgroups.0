From: "Yakunin, Dmitry (Nebius)" <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 1/3] cgroup: list all subsystem states in debugfs files
Date: Mon, 11 Sep 2023 07:55:15 +0000
Message-ID: <20230911075437.74027-2-zeil@nebius.com>
References: <20230911075437.74027-1-zeil@nebius.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nebius.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DKyGwIj4jv7VDoNrsbW4MCGeMC+A7Fjxr12aryd/0k=;
 b=LujzvkldKVdvzkRN2XebIglZAKv450VcgxhrdZKRo/lHjfcSjBuehaMQAFJFZ2LzKKiPtMvBIS+yXuzP4ERRek9DutT5TGoEtx1qp4NKyY2JTDlW3hEpb84/MdsfcrJG//G7jsINTQhbC8PEyEs2Nz+kS6RQuzx2xjloGmBAsJPoohzvhasnIjSTn6W8A69dAj0Ab31gsSxpFGemRW6igDJbanyfF0NkFJMLz7m8mo2veVn6ZMQplqSqiCCufQaDwZLnRI66FSxjNfj9bacRGfXdjcDKd5+HuUTb0iMvk39CGJxNLsT97OU7ncoBjr/9YAI2Sq7eSZgycySwjLEOkw==
In-Reply-To: <20230911075437.74027-1-zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: NB-Core Team <NB-CoreTeam-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Yakunin, Dmitry (Nebius)" <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>

After removing cgroup subsystem state could leak or live in background=0A=
forever because it is pinned by some reference. For example memory cgroup=
=0A=
could be pinned by pages in cache or tmpfs.=0A=
=0A=
This patch adds common debugfs interface for listing basic state for each=
=0A=
controller. Controller could define callback for dumping own attributes.=0A=
=0A=
In file /sys/kernel/debug/cgroup/<controller> each line shows state in=0A=
format: <common_attr>=3D<value>... [-- <controller_attr>=3D<value>... ]=0A=
=0A=
Common attributes:=0A=
=0A=
css - css pointer=0A=
cgroup - cgroup pointer=0A=
id - css id=0A=
ino - cgroup inode=0A=
flags - css flags=0A=
refcnt - css atomic refcount, for online shows huge bias=0A=
path - cgroup path=0A=
=0A=
This patch adds memcg attributes:=0A=
=0A=
mem_id - 16-bit memory cgroup id=0A=
memory - charged pages=0A=
memsw - charged memory+swap for v1 and swap for v2=0A=
kmem - charged kernel pages=0A=
tcpmem - charged tcp pages=0A=
shmem - shmem/tmpfs pages=0A=
=0A=
Link: https://lore.kernel.org/lkml/153414348591.737150.14229960913953276515=
.stgit@buzz=0A=
Suggested-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>=0A=
Reviewed-by: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>=0A=
Signed-off-by: Dmitry Yakunin <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>=0A=
---=0A=
 include/linux/cgroup-defs.h |   1 +=0A=
 kernel/cgroup/cgroup.c      | 101 ++++++++++++++++++++++++++++++++++++=0A=
 mm/memcontrol.c             |  14 +++++=0A=
 3 files changed, 116 insertions(+)=0A=
=0A=
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h=0A=
index 8a0d5466c7be..810bd300cbee 100644=0A=
--- a/include/linux/cgroup-defs.h=0A=
+++ b/include/linux/cgroup-defs.h=0A=
@@ -673,6 +673,7 @@ struct cgroup_subsys {=0A=
 	void (*exit)(struct task_struct *task);=0A=
 	void (*release)(struct task_struct *task);=0A=
 	void (*bind)(struct cgroup_subsys_state *root_css);=0A=
+	void (*css_dump)(struct cgroup_subsys_state *css, struct seq_file *m);=0A=
 =0A=
 	bool early_init:1;=0A=
 =0A=
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c=0A=
index 625d7483951c..fb9931ff7570 100644=0A=
--- a/kernel/cgroup/cgroup.c=0A=
+++ b/kernel/cgroup/cgroup.c=0A=
@@ -40,6 +40,7 @@=0A=
 #include <linux/mount.h>=0A=
 #include <linux/pagemap.h>=0A=
 #include <linux/proc_fs.h>=0A=
+#include <linux/debugfs.h>=0A=
 #include <linux/rcupdate.h>=0A=
 #include <linux/sched.h>=0A=
 #include <linux/sched/task.h>=0A=
@@ -7068,3 +7069,103 @@ static int __init cgroup_sysfs_init(void)=0A=
 subsys_initcall(cgroup_sysfs_init);=0A=
 =0A=
 #endif /* CONFIG_SYSFS */=0A=
+=0A=
+#ifdef CONFIG_DEBUG_FS=0A=
+void *css_debugfs_seqfile_start(struct seq_file *m, loff_t *pos)=0A=
+{=0A=
+	struct cgroup_subsys *ss =3D m->private;=0A=
+	struct cgroup_subsys_state *css;=0A=
+	int id =3D *pos;=0A=
+=0A=
+	rcu_read_lock();=0A=
+	css =3D idr_get_next(&ss->css_idr, &id);=0A=
+	*pos =3D id;=0A=
+	return css;=0A=
+}=0A=
+=0A=
+void *css_debugfs_seqfile_next(struct seq_file *m, void *v, loff_t *pos)=
=0A=
+{=0A=
+	struct cgroup_subsys *ss =3D m->private;=0A=
+	struct cgroup_subsys_state *css;=0A=
+	int id =3D *pos + 1;=0A=
+=0A=
+	css =3D idr_get_next(&ss->css_idr, &id);=0A=
+	*pos =3D id;=0A=
+	return css;=0A=
+}=0A=
+=0A=
+void css_debugfs_seqfile_stop(struct seq_file *m, void *v)=0A=
+{=0A=
+	rcu_read_unlock();=0A=
+}=0A=
+=0A=
+int css_debugfs_seqfile_show(struct seq_file *m, void *v)=0A=
+{=0A=
+	struct cgroup_subsys *ss =3D m->private;=0A=
+	struct cgroup_subsys_state *css =3D v;=0A=
+	/* data is NULL for root cgroup_subsys_state */=0A=
+	struct percpu_ref_data *data =3D css->refcnt.data;=0A=
+	size_t buflen;=0A=
+	char *buf;=0A=
+	int len;=0A=
+=0A=
+	seq_printf(m, "css=3D%pK cgroup=3D%pK id=3D%d ino=3D%lu flags=3D%#x refcn=
t=3D%lu path=3D",=0A=
+		   css, css->cgroup, css->id, cgroup_ino(css->cgroup),=0A=
+		   css->flags, data ? atomic_long_read(&data->count) : 0);=0A=
+=0A=
+	buflen =3D seq_get_buf(m, &buf);=0A=
+	if (buf) {=0A=
+		len =3D cgroup_path(css->cgroup, buf, buflen);=0A=
+		seq_commit(m, len < buflen ? len : -1);=0A=
+	}=0A=
+=0A=
+	if (ss->css_dump) {=0A=
+		seq_puts(m, " -- ");=0A=
+		ss->css_dump(css, m);=0A=
+	}=0A=
+=0A=
+	seq_putc(m, '\n');=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static const struct seq_operations css_debug_seq_ops =3D {=0A=
+	.start =3D css_debugfs_seqfile_start,=0A=
+	.next =3D css_debugfs_seqfile_next,=0A=
+	.stop =3D css_debugfs_seqfile_stop,=0A=
+	.show =3D css_debugfs_seqfile_show,=0A=
+};=0A=
+=0A=
+static int css_debugfs_open(struct inode *inode, struct file *file)=0A=
+{=0A=
+	int ret =3D seq_open(file, &css_debug_seq_ops);=0A=
+	struct seq_file *m =3D file->private_data;=0A=
+=0A=
+	if (!ret)=0A=
+		m->private =3D inode->i_private;=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static const struct file_operations css_debugfs_fops =3D {=0A=
+	.open =3D css_debugfs_open,=0A=
+	.read =3D seq_read,=0A=
+	.llseek =3D seq_lseek,=0A=
+	.release =3D seq_release,=0A=
+};=0A=
+=0A=
+static int __init css_debugfs_init(void)=0A=
+{=0A=
+	struct cgroup_subsys *ss;=0A=
+	struct dentry *dir;=0A=
+	int ssid;=0A=
+=0A=
+	dir =3D debugfs_create_dir("cgroup", NULL);=0A=
+	if (dir) {=0A=
+		for_each_subsys(ss, ssid)=0A=
+			debugfs_create_file(ss->name, 0644, dir, ss,=0A=
+					    &css_debugfs_fops);=0A=
+	}=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+late_initcall(css_debugfs_init);=0A=
+#endif /* CONFIG_DEBUG_FS */=0A=
diff --git a/mm/memcontrol.c b/mm/memcontrol.c=0A=
index 4b27e245a055..7b3d4a10ac63 100644=0A=
--- a/mm/memcontrol.c=0A=
+++ b/mm/memcontrol.c=0A=
@@ -5654,6 +5654,20 @@ static void mem_cgroup_css_rstat_flush(struct cgroup=
_subsys_state *css, int cpu)=0A=
 	}=0A=
 }=0A=
 =0A=
+static void mem_cgroup_css_dump(struct cgroup_subsys_state *css,=0A=
+				struct seq_file *m)=0A=
+{=0A=
+	struct mem_cgroup *memcg =3D mem_cgroup_from_css(css);=0A=
+=0A=
+	seq_printf(m, "mem_id=3D%u memory=3D%lu memsw=3D%lu kmem=3D%lu tcpmem=3D%=
lu shmem=3D%lu",=0A=
+		   mem_cgroup_id(memcg),=0A=
+		   page_counter_read(&memcg->memory),=0A=
+		   page_counter_read(&memcg->memsw),=0A=
+		   page_counter_read(&memcg->kmem),=0A=
+		   page_counter_read(&memcg->tcpmem),=0A=
+		   memcg_page_state(memcg, NR_SHMEM));=0A=
+}=0A=
+=0A=
 #ifdef CONFIG_MMU=0A=
 /* Handlers for move charge at task migration. */=0A=
 static int mem_cgroup_do_precharge(unsigned long count)=0A=
-- =0A=
2.25.1=0A=
=0A=
