From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 7/9] mm: Mark functions as static in page_cgroup.c
Date: Fri, 7 Feb 2014 17:41:34 +0530
Message-ID: <6054d570fc83c3d4f3de240d6da488f876e21450.1391167128.git.rashika.kheria@gmail.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=xzp6FNWdLh7Y7qgTZ/lshXsjCw1DPn0P6VF+xt0gsYw=;
        b=QF7tLGS5H3AyKcFxQu5WnteZAA5Oh33RduatHgpJadaExvMU/qDuEg3GNWNUZcK/AH
         oPUnsBTDi19155d1uFLN6CYX3MbcxRS08waoDG+FzhoBZ4Z3EqHxHCW2/EK5v44FV/2j
         tgy8vmvKuKc/DSrvG5e++WS0IH6Wb46vyaji0ORZOP9P0neYWJ3DSyUBcBwHiLaYVaUH
         JkRn+LBJ1CCD7AsaA/fxTHdPcDzkkcLSOy3jDo2JF09TcTFl6GgIXa+1cIN+eESuaskS
         L7zE2TC7WIiPaHOwZJFy/+USnJRFKm7u4a2gyDLyIoDh/kIZso7zQF32k2VUcfAReOhw
         N3Tg==
Content-Disposition: inline
In-Reply-To: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, containers@lists.linux-foundation.org, josh@joshtriplett.org

Mark functions as static in page_cgroup.c because they are not used
outside this file.

This eliminates the following warning in mm/page_cgroup.c:
mm/page_cgroup.c:177:6: warning: no previous prototype for =E2=80=98__fre=
e_page_cgroup=E2=80=99 [-Wmissing-prototypes]
mm/page_cgroup.c:190:15: warning: no previous prototype for =E2=80=98onli=
ne_page_cgroup=E2=80=99 [-Wmissing-prototypes]
mm/page_cgroup.c:225:15: warning: no previous prototype for =E2=80=98offl=
ine_page_cgroup=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/page_cgroup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 6d757e3a..6ec349c 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -174,7 +174,7 @@ static void free_page_cgroup(void *addr)
 	}
 }
=20
-void __free_page_cgroup(unsigned long pfn)
+static void __free_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *ms;
 	struct page_cgroup *base;
@@ -187,9 +187,9 @@ void __free_page_cgroup(unsigned long pfn)
 	ms->page_cgroup =3D NULL;
 }
=20
-int __meminit online_page_cgroup(unsigned long start_pfn,
-			unsigned long nr_pages,
-			int nid)
+static int __meminit online_page_cgroup(unsigned long start_pfn,
+				unsigned long nr_pages,
+				int nid)
 {
 	unsigned long start, end, pfn;
 	int fail =3D 0;
@@ -222,8 +222,8 @@ int __meminit online_page_cgroup(unsigned long start_=
pfn,
 	return -ENOMEM;
 }
=20
-int __meminit offline_page_cgroup(unsigned long start_pfn,
-		unsigned long nr_pages, int nid)
+static int __meminit offline_page_cgroup(unsigned long start_pfn,
+				unsigned long nr_pages, int nid)
 {
 	unsigned long start, end, pfn;
=20
--=20
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
