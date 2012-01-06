From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [RESEND, PATCH 2/6] memcg: remove unused variable
Date: Fri,  6 Jan 2012 22:57:48 +0200
Message-ID: <1325883472-5614-2-git-send-email-kirill@shutemov.name>
References: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, "Kirill A. Shutemov" <kirill@shutemov.name>

From: "Kirill A. Shutemov" <kirill@shutemov.name>

mm/memcontrol.c: In function =E2=80=98mc_handle_file_pte=E2=80=99:
mm/memcontrol.c:5206:16: warning: variable =E2=80=98inode=E2=80=99 set bu=
t not used [-Wunused-but-set-variable]

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 73f0c3e..39c3d60 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5121,7 +5121,6 @@ static struct page *mc_handle_file_pte(struct vm_ar=
ea_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
 	struct page *page =3D NULL;
-	struct inode *inode;
 	struct address_space *mapping;
 	pgoff_t pgoff;
=20
@@ -5130,7 +5129,6 @@ static struct page *mc_handle_file_pte(struct vm_ar=
ea_struct *vma,
 	if (!move_file())
 		return NULL;
=20
-	inode =3D vma->vm_file->f_path.dentry->d_inode;
 	mapping =3D vma->vm_file->f_mapping;
 	if (pte_none(ptent))
 		pgoff =3D linear_page_index(vma, addr);
--=20
1.7.8.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter=
.ca/
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
