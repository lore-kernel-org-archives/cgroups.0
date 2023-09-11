From: "Yakunin, Dmitry (Nebius)" <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 2/3] proc/kpagecgroup: report also inode numbers of
 offline cgroups
Date: Mon, 11 Sep 2023 07:55:20 +0000
Message-ID: <20230911075437.74027-3-zeil@nebius.com>
References: <20230911075437.74027-1-zeil@nebius.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nebius.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qs1ZCDDoENjULFOlfJgGzX2+wQ3stP8WoMAjcuMWdmo=;
 b=USF3bFUiw13spjOIDG+c2JYMAC+S4pDYVAOMPlwCFud4aMRd5+T4b8YZ51lULULY/SWEK2QFLLys+PNijhefOhx/fY2d6igsG8rLNolOi1bFbt1ianSqXiLS+1+STEU524YPtScyLuXNpWzfUvun104opKX4oSbs7dserEbyTIH3VcOIDzZ92TaueBHACeNveb0kqBvPGdthAXsGxGqSiNL2+RN/SsdNnlSWmoRIv0AaDJUnPr5DKZj9NFDThzPSs1hovPakrhE2QKE6t5xNXxdk6v9vEWwcj7gqRRkEzsX0lnvCPezUhQhabpylnHX8HLR1r00t/AsXioQVuoRG8g==
In-Reply-To: <20230911075437.74027-1-zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: NB-Core Team <NB-CoreTeam-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Yakunin, Dmitry (Nebius)" <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>

By default this interface reports inode number of closest online ancestor=
=0A=
if cgroups is offline (removed). Information about real owner is required=
=0A=
for detecting which pages keep removed cgroup.=0A=
=0A=
This patch adds per-file mode which is changed by writing 64-bit flags=0A=
into opened /proc/kpagecgroup. For now only first bit is used.=0A=
=0A=
Link: https://lore.kernel.org/lkml/153414348994.737150.10057219558779418929=
.stgit@buzz=0A=
Suggested-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>=0A=
Reviewed-by: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>=0A=
Signed-off-by: Dmitry Yakunin <zeil-2iiexdXeLXzQT0dZR+AlfA@public.gmane.org>=0A=
---=0A=
 fs/proc/page.c             | 24 ++++++++++++++++++++++--=0A=
 include/linux/memcontrol.h |  2 +-=0A=
 mm/memcontrol.c            |  5 +++--=0A=
 mm/memory-failure.c        |  2 +-=0A=
 4 files changed, 27 insertions(+), 6 deletions(-)=0A=
=0A=
diff --git a/fs/proc/page.c b/fs/proc/page.c=0A=
index 195b077c0fac..ae6feca2bbc7 100644=0A=
--- a/fs/proc/page.c=0A=
+++ b/fs/proc/page.c=0A=
@@ -278,6 +278,7 @@ static const struct proc_ops kpageflags_proc_ops =3D {=
=0A=
 static ssize_t kpagecgroup_read(struct file *file, char __user *buf,=0A=
 				size_t count, loff_t *ppos)=0A=
 {=0A=
+	unsigned long flags =3D (unsigned long)file->private_data;=0A=
 	const unsigned long max_dump_pfn =3D get_max_dump_pfn();=0A=
 	u64 __user *out =3D (u64 __user *)buf;=0A=
 	struct page *ppage;=0A=
@@ -301,7 +302,7 @@ static ssize_t kpagecgroup_read(struct file *file, char=
 __user *buf,=0A=
 		ppage =3D pfn_to_online_page(pfn);=0A=
 =0A=
 		if (ppage)=0A=
-			ino =3D page_cgroup_ino(ppage);=0A=
+			ino =3D page_cgroup_ino(ppage, !(flags & 1));=0A=
 		else=0A=
 			ino =3D 0;=0A=
 =0A=
@@ -323,10 +324,29 @@ static ssize_t kpagecgroup_read(struct file *file, ch=
ar __user *buf,=0A=
 	return ret;=0A=
 }=0A=
 =0A=
+static ssize_t kpagecgroup_write(struct file *file, const char __user *buf=
,=0A=
+				 size_t count, loff_t *ppos)=0A=
+{=0A=
+	u64 flags;=0A=
+=0A=
+	if (count !=3D 8)=0A=
+		return -EINVAL;=0A=
+=0A=
+	if (get_user(flags, buf))=0A=
+		return -EFAULT;=0A=
+=0A=
+	if (flags > 1)=0A=
+		return -EINVAL;=0A=
+=0A=
+	file->private_data =3D (void *)(unsigned long)flags;=0A=
+	return count;=0A=
+}=0A=
+=0A=
 static const struct proc_ops kpagecgroup_proc_ops =3D {=0A=
 	.proc_flags	=3D PROC_ENTRY_PERMANENT,=0A=
 	.proc_lseek	=3D mem_lseek,=0A=
 	.proc_read	=3D kpagecgroup_read,=0A=
+	.proc_write	=3D kpagecgroup_write,=0A=
 };=0A=
 #endif /* CONFIG_MEMCG */=0A=
 =0A=
@@ -335,7 +355,7 @@ static int __init proc_page_init(void)=0A=
 	proc_create("kpagecount", S_IRUSR, NULL, &kpagecount_proc_ops);=0A=
 	proc_create("kpageflags", S_IRUSR, NULL, &kpageflags_proc_ops);=0A=
 #ifdef CONFIG_MEMCG=0A=
-	proc_create("kpagecgroup", S_IRUSR, NULL, &kpagecgroup_proc_ops);=0A=
+	proc_create("kpagecgroup", 0600, NULL, &kpagecgroup_proc_ops);=0A=
 #endif=0A=
 	return 0;=0A=
 }=0A=
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h=0A=
index 222d7370134c..bbbddaa260d3 100644=0A=
--- a/include/linux/memcontrol.h=0A=
+++ b/include/linux/memcontrol.h=0A=
@@ -892,7 +892,7 @@ static inline bool mm_match_cgroup(struct mm_struct *mm=
,=0A=
 }=0A=
 =0A=
 struct cgroup_subsys_state *mem_cgroup_css_from_folio(struct folio *folio)=
;=0A=
-ino_t page_cgroup_ino(struct page *page);=0A=
+ino_t page_cgroup_ino(struct page *page, bool online);=0A=
 =0A=
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)=0A=
 {=0A=
diff --git a/mm/memcontrol.c b/mm/memcontrol.c=0A=
index 7b3d4a10ac63..48cfe3695e06 100644=0A=
--- a/mm/memcontrol.c=0A=
+++ b/mm/memcontrol.c=0A=
@@ -380,6 +380,7 @@ struct cgroup_subsys_state *mem_cgroup_css_from_folio(s=
truct folio *folio)=0A=
 /**=0A=
  * page_cgroup_ino - return inode number of the memcg a page is charged to=
=0A=
  * @page: the page=0A=
+ * @online: return closest online ancestor=0A=
  *=0A=
  * Look up the closest online ancestor of the memory cgroup @page is charg=
ed to=0A=
  * and return its inode number or 0 if @page is not charged to any cgroup.=
 It=0A=
@@ -390,7 +391,7 @@ struct cgroup_subsys_state *mem_cgroup_css_from_folio(s=
truct folio *folio)=0A=
  * after page_cgroup_ino() returns, so it only should be used by callers t=
hat=0A=
  * do not care (such as procfs interfaces).=0A=
  */=0A=
-ino_t page_cgroup_ino(struct page *page)=0A=
+ino_t page_cgroup_ino(struct page *page, bool online)=0A=
 {=0A=
 	struct mem_cgroup *memcg;=0A=
 	unsigned long ino =3D 0;=0A=
@@ -399,7 +400,7 @@ ino_t page_cgroup_ino(struct page *page)=0A=
 	/* page_folio() is racy here, but the entire function is racy anyway */=
=0A=
 	memcg =3D folio_memcg_check(page_folio(page));=0A=
 =0A=
-	while (memcg && !(memcg->css.flags & CSS_ONLINE))=0A=
+	while (memcg && online && !(memcg->css.flags & CSS_ONLINE))=0A=
 		memcg =3D parent_mem_cgroup(memcg);=0A=
 	if (memcg)=0A=
 		ino =3D cgroup_ino(memcg->css.cgroup);=0A=
diff --git a/mm/memory-failure.c b/mm/memory-failure.c=0A=
index 5b663eca1f29..6734489b2435 100644=0A=
--- a/mm/memory-failure.c=0A=
+++ b/mm/memory-failure.c=0A=
@@ -267,7 +267,7 @@ static int hwpoison_filter_task(struct page *p)=0A=
 	if (!hwpoison_filter_memcg)=0A=
 		return 0;=0A=
 =0A=
-	if (page_cgroup_ino(p) !=3D hwpoison_filter_memcg)=0A=
+	if (page_cgroup_ino(p, true) !=3D hwpoison_filter_memcg)=0A=
 		return -EINVAL;=0A=
 =0A=
 	return 0;=0A=
-- =0A=
2.25.1=0A=
=0A=
