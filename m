From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] jump_label: make static_key_enabled() work on static_key_true/false types too
Date: Tue, 15 Sep 2015 21:51:22 -0400
Message-ID: <1442368285-16306-2-git-send-email-tj@kernel.org>
References: <1442368285-16306-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=loQrAAdUdcMa38DBYmaMTaj0x0bKhrf4jVKkwQUVrBA=;
        b=QqpxTbdExYCX9JdIBoHBiSPIYTRN0twXNLFcDKdsTnhyfOhhmtGX47B0610RY+UbTU
         NkYgMsgyTasURf88VxMWbqQxRerDQ7yM94J81D+wfam+LT1bzfDu8Cg7/vvEuJx1/et6
         3TZ8q7LaowOKISSWBrtY/+I9tqIhYLlm+ri3ofmVcK8g/EcHJriA0Nje8khdzA1LvLtn
         Kk5AMl/BxtU4l0EOwS4BtHkjBhQeP4dvWTRjz8wVZYQMXUvNLCYtywlufU8awfpWeGY/
         uM1qZR5ueU9LB1bb/RBSOU96AcMYry755frlYXNapeeMLA1Y8A+CRZqrV0pmRkCaOjUJ
         mxQg==
In-Reply-To: <1442368285-16306-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>

static_key_enabled() can be used on struct static_key but not on its
wrapper types static_key_true and static_key_false.  The function is
useful for debugging and management of static keys.  Update it so that
it can be used for the wrapper types too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Hello,

If this patch is acceptable, please let me know how it should be
routed.

Thanks.

 include/linux/jump_label.h | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 7f653e8..c9ca050 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -216,11 +216,6 @@ static inline int jump_label_apply_nops(struct module *mod)
 #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
 #define jump_label_enabled static_key_enabled
 
-static inline bool static_key_enabled(struct static_key *key)
-{
-	return static_key_count(key) > 0;
-}
-
 static inline void static_key_enable(struct static_key *key)
 {
 	int count = static_key_count(key);
@@ -267,6 +262,17 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_FALSE(name)	\
 	struct static_key_false name = STATIC_KEY_FALSE_INIT
 
+extern bool ____wrong_branch_error(void);
+
+#define static_key_enabled(x)							\
+({										\
+	if (!__builtin_types_compatible_p(typeof(*x), struct static_key) &&	\
+	    !__builtin_types_compatible_p(typeof(*x), struct static_key_true) &&\
+	    !__builtin_types_compatible_p(typeof(*x), struct static_key_false))	\
+		____wrong_branch_error();					\
+	static_key_count((struct static_key *)x) > 0;				\
+})
+
 #ifdef HAVE_JUMP_LABEL
 
 /*
@@ -325,8 +331,6 @@ struct static_key_false {
  * See jump_label_type() / jump_label_init_type().
  */
 
-extern bool ____wrong_branch_error(void);
-
 #define static_branch_likely(x)							\
 ({										\
 	bool branch;								\
-- 
2.4.3
