From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 9/9] memcg: accounting for ldt_struct objects
Date: Tue, 9 Mar 2021 11:04:56 +0300
Message-ID: <05c448c7-d992-8d80-b423-b80bf5446d7c@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DETAgUIoY/Yh+88xtrJ0p4ub3J39q3mROrB0pV7+7iY=;
 b=s1VeK+kL/60lgVPBobVfRF82ESE/ZrQt6G7tL6f0LBe3D+HFVMTQU6ILix5Gf/uZWUi+lQDaluVNyWxT2qFCLctf8EqjgL47nG/6eBAOi58InqTwljsuG4JiZBg4eLf5OvcLW7HzQ6NtliUXsI1QlCTcq/Yf50HgWzw+AdY/cNY=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Objects can be created from memcg-limited tasks
but its misuse may lead to host OOM.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 arch/x86/kernel/ldt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index aa15132..a1889a0 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -154,7 +154,7 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
 	if (num_entries > LDT_ENTRIES)
 		return NULL;
 
-	new_ldt = kmalloc(sizeof(struct ldt_struct), GFP_KERNEL);
+	new_ldt = kmalloc(sizeof(struct ldt_struct), GFP_KERNEL_ACCOUNT);
 	if (!new_ldt)
 		return NULL;
 
@@ -168,9 +168,10 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
 	 * than PAGE_SIZE.
 	 */
 	if (alloc_size > PAGE_SIZE)
-		new_ldt->entries = vzalloc(alloc_size);
+		new_ldt->entries = __vmalloc(alloc_size,
+					     GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	else
-		new_ldt->entries = (void *)get_zeroed_page(GFP_KERNEL);
+		new_ldt->entries = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 
 	if (!new_ldt->entries) {
 		kfree(new_ldt);
-- 
1.8.3.1

