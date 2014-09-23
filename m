From: Zefan Li <lizefan@huawei.com>
Subject: [PATCH v3 2/3] sched: add macros to define bitops for task atomic
 flags
Date: Tue, 23 Sep 2014 15:44:59 +0800
Message-ID: <542124FB.4030109@huawei.com>
References: <542124D3.9000007@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <542124D3.9000007@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Miao Xie <miaox@cn.fujitsu.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

This will simplify code when we add new flags.

v3:
- Kees pointed out that no_new_privs should never be cleared, so we
shouldn't define task_clear_no_new_privs(). we define 3 macros instead
of a single one.

v2:
- updated scripts/tags.sh, suggested by Peter.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/sched.h | 21 ++++++++++++---------
 scripts/tags.sh       |  6 ++++++
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4557765..5630763 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1959,15 +1959,18 @@ static inline void memalloc_noio_restore(unsigned int flags)
 /* Per-process atomic flags. */
 #define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
 
-static inline bool task_no_new_privs(struct task_struct *p)
-{
-	return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
-}
-
-static inline void task_set_no_new_privs(struct task_struct *p)
-{
-	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
-}
+#define TASK_PFA_TEST(name, func)					\
+	static inline bool task_##func(struct task_struct *p)		\
+	{ return test_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_SET(name, func)					\
+	static inline void task_set_##func(struct task_struct *p)	\
+	{ set_bit(PFA_##name, &p->atomic_flags); }
+#define TASK_PFA_CLEAR(name, func)					\
+	static inline void task_clear_##func(struct task_struct *p)	\
+	{ clear_bit(PFA_##name, &p->atomic_flags); }
+
+TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
+TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
 
 /*
  * task->jobctl flags
diff --git a/scripts/tags.sh b/scripts/tags.sh
index cbfd269..293828b 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -197,6 +197,9 @@ exuberant()
 	--regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'		\
 	--regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 	--regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
+	--regex-c++='/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'	\
+	--regex-c++='/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+	--regex-c++='/TASK_PFA_CLEAR\([^,]*,\s*([^)]*)\)/task_clear_\1/'\
 	--regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
 	--regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
 	--regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
@@ -260,6 +263,9 @@ emacs()
 	--regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
 	--regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
 	--regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
+	--regex='/TASK_PFA_TEST\([^,]*,\s*([^)]*)\)/task_\1/'		\
+	--regex='/TASK_PFA_SET\([^,]*,\s*([^)]*)\)/task_set_\1/'	\
+	--regex='/TASK_PFA_CLEAR\([^,]*,\s*([^)]*)\)/task_clear_\1/'	\
 	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
 	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
 	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'\
-- 
1.8.0.2
