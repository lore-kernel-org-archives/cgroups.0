From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 5/5] kernel/cpuset.c: Mark cpuset_init_current_mems_allowed as __init
Date: Tue,  3 Feb 2015 00:50:16 +0100
Message-ID: <1422921016-27618-6-git-send-email-linux@rasmusvillemoes.dk>
References: <1422921016-27618-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1b+GuOwrSyQSp6PcBuaa9sD9pESWFOpfxLRt+8b+C/g=;
        b=I4kSHW8vpW4m5kUUJPvj+N0QqunjUmL+gM0GQsOEx5R0qVPH2+UGZk3UsSQAnnbRyX
         VAak83TdLTvAdz9qv3kkjJffixrlrKtQLLiqb3RLnz+TCUq/O8iuSAjzkqYDCR4IKdlY
         3C5o00cGy7ed4lNFw1m55XO5QYJXvE8PgmhmU=
In-Reply-To: <1422921016-27618-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

The only caller of cpuset_init_current_mems_allowed is the __init
annotated build_all_zonelists_init, so we can also make the former
__init.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 64b257f6bca2..c54a1dae6c11 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2400,7 +2400,7 @@ void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 	 */
 }
 
-void cpuset_init_current_mems_allowed(void)
+void __init cpuset_init_current_mems_allowed(void)
 {
 	nodes_setall(current->mems_allowed);
 }
-- 
2.1.3
