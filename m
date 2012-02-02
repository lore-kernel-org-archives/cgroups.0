From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH] memcg: make threshold index in the right position
Date: Thu,  2 Feb 2012 17:45:19 +0800
Message-ID: <1328175919-11209-1-git-send-email-handai.szj@taobao.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=hlTjLcQ9C1VpUkY479+wWPqH5wFCZJotcwZE7/Jf7zA=;
        b=C7DsKESlsZCTLL+AuUee/IQJazILM8LQGdAnYg535fi5md2z3BkFPcGcd101fY6Gev
         n0j43hvPcd+Ye0lCyb2kvXgzj59cR08zPUqfRCW8d3M3BlJkB1kTg7Fe9xGXAcjzZ+Jw
         sPxUQdbfOkx6T4CaIhnjiypuUtiq88/89Sw08=
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: Sha Zhengju <handai.szj@taobao.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, "Kirill A. Shutemov" <kirill@shutemov.name>

From: Sha Zhengju <handai.szj@taobao.com>

Index current_threshold may point to threshold that just equal to
usage after __mem_cgroup_threshold is triggerd. But after registering
a new event, it will change (pointing to threshold just below usage).
So make it consistent here.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 mm/memcontrol.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22d94f5..79f4a58 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -183,7 +183,7 @@ struct mem_cgroup_threshold {
 
 /* For threshold */
 struct mem_cgroup_threshold_ary {
-	/* An array index points to threshold just below usage. */
+	/* An array index points to threshold just below or equal to usage. */
 	int current_threshold;
 	/* Size of entries[] */
 	unsigned int size;
@@ -4319,14 +4319,15 @@ static int mem_cgroup_usage_register_event(struct cgroup *cgrp,
 	/* Find current threshold */
 	new->current_threshold = -1;
 	for (i = 0; i < size; i++) {
-		if (new->entries[i].threshold < usage) {
+		if (new->entries[i].threshold <= usage) {
 			/*
 			 * new->current_threshold will not be used until
 			 * rcu_assign_pointer(), so it's safe to increment
 			 * it here.
 			 */
 			++new->current_threshold;
-		}
+		} else
+			break;
 	}
 
 	/* Free old spare buffer and save old primary buffer as spare */
-- 
1.7.4.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
