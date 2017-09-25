From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.15] sched/cputime: Add dummy cputime_adjust()
 implementation for CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
Date: Mon, 25 Sep 2017 14:34:21 -0700
Message-ID: <20170925213421.GC560070@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=B4ivb9fec7rziO1bViWiE12GvgDQUU1bF6+qUawa6J0=;
        b=fEOCWSTA1n19CKdvj+AHYKrZB3mgKhHKgnmATPQmWmk0ylJ6X0rcUxw6eoyYQuvEjK
         n80QFC2TroRJEx8Q5EzC66nNkdKotazLdv1YkEbLgyXWkeWfyM4R+xuQz9rSiNut1kLJ
         2teC+wuROPrQkZH3n2uXnxsiEPKnO+3ClY473SWOilPHTTJl/C4eAKRSL9DZNQQHeXMI
         6DPLje6CYr7qxMK8Qhyu7h5wTWfOJP9w9MbIfz1d1gNpsyp8FG339VOl9SMMJD1BbDfy
         LpjSBE9uN5Vow4R5bk6bCM+dv2KCfnUmsjPhVzgwI4u5ammBlUf7yUl3QmK9E7RxDbMa
         FEcg==
Content-Disposition: inline
In-Reply-To: <20170811163754.3939102-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

Hello,

Another follow-up fix.  I missed a dummy implementation leading to
bulid failure on s390.  Because the bug and fix are trivial, I
directly applied the patch to cgroup/for-4.15.  Please let me know if
it should be routed differently.

Thanks.
------ 8< ------
From 8157a7faf94135386bf04b1cf94e6efd3fb94702 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 25 Sep 2017 14:27:54 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

cfb766da54d9 ("sched/cputime: Expose cputime_adjust()") made
cputime_adjust() public for cgroup basic cpu stat support; however,
the commit forgot to add a dummy implementaiton for
CONFIG_VIRT_CPU_ACCOUNTING_NATIVE leading to compiler errors on some
s390 configurations.

Fix it by adding the missing dummy implementation.

Reported-by: “kbuild-all@01.org” <kbuild-all@01.org>
Fixes: cfb766da54d9 ("sched/cputime: Expose cputime_adjust()")
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/cputime.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e01b699..5498f20 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -447,6 +447,13 @@ void vtime_account_irq_enter(struct task_struct *tsk)
 EXPORT_SYMBOL_GPL(vtime_account_irq_enter);
 #endif /* __ARCH_HAS_VTIME_ACCOUNT */
 
+void cputime_adjust(struct task_cputime *curr, struct prev_cputime *prev,
+		    u64 *ut, u64 *st)
+{
+	*ut = curr->utime;
+	*st = curr->stime;
+}
+
 void task_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 {
 	*ut = p->utime;
-- 
2.9.5

