From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v5 16/16] memcg: enable accounting for ldt_struct objects
Date: Mon, 19 Jul 2021 13:46:08 +0300
Message-ID: <abca5516-e4fd-241b-d7ba-b63b1cc4ad32@virtuozzo.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=QOm/SWMV/Asmk/Sj3wEkt1IsJkdhz+j421ZJ6yW2Ajw=; b=kh1Qd1RE1pR9jrM/w8w
        qxPxAOTVJv3sd9PzBZE+KYHSBYIWCGnf9JnAOEGp2M7bH74AlmKK0Pff70hUPNcblLwOiU8lkG0qk
        ykM0GR8bWCONZKN7qnpx1eF6xvx9w4CAQZgTqnTBIzZJcBbk0FrdyYnh+HMpJLOu7LmI40QeTa8=;
In-Reply-To: <cover.1626688654.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Each task can request own LDT and force the kernel to allocate up to
64Kb memory per-mm.

There are legitimate workloads with hundreds of processes and there
can be hundreds of workloads running on large machines.
The unaccounted memory can cause isolation issues between the workloads
particularly on highly utilized machines.

It makes sense to account for this objects to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/kernel/ldt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index aa15132..525876e 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -154,7 +154,7 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
 	if (num_entries > LDT_ENTRIES)
 		return NULL;
 
-	new_ldt = kmalloc(sizeof(struct ldt_struct), GFP_KERNEL);
+	new_ldt = kmalloc(sizeof(struct ldt_struct), GFP_KERNEL_ACCOUNT);
 	if (!new_ldt)
 		return NULL;
 
@@ -168,9 +168,9 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
 	 * than PAGE_SIZE.
 	 */
 	if (alloc_size > PAGE_SIZE)
-		new_ldt->entries = vzalloc(alloc_size);
+		new_ldt->entries = __vmalloc(alloc_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	else
-		new_ldt->entries = (void *)get_zeroed_page(GFP_KERNEL);
+		new_ldt->entries = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 
 	if (!new_ldt->entries) {
 		kfree(new_ldt);
-- 
1.8.3.1

