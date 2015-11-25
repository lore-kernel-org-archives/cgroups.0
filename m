From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in handle_mm_fault
Date: Wed, 25 Nov 2015 18:21:02 +0100
Message-ID: <CACT4Y+ZdF09hOnb_bL4GNjytSMMGvNde8=9pdZt6gZQB1sp0hQ@mail.gmail.com>
References: <CACT4Y+ZCkv0BPOdo3aiheA5LXzXhcnuiw7kCoWL=b9FcC8-wqg@mail.gmail.com>
 <20151125084403.GA24703@dhcp22.suse.cz> <565592A1.50407@I-love.SAKURA.ne.jp>
 <CACT4Y+Zn+mK37-mvqDQTyt1Psp6HT2heT0e937SO24F7V1q7PA@mail.gmail.com> <201511260027.CCC26590.SOHFMQLVJOtFOF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=hb8WrAE04G2imlV2DpqeN6PSJXI/VUEObMaLprKzLoQ=;
        b=kXLSGcHDfQNCBE7wWG8dvVI2ui5G5+zVqPIApNnso/VH7cHL+/rgirSPi+zrW9Uajx
         hu2gbV4NgorRXb4SirbJc75K18g3B/2jCLuLiImPs91iDPHjcU7PMXT8t701lKL3cqUm
         YLkvMbU9T06xWNi9/tYJXhbcKW6yex6g7q0KCNysVu4cVl7RN0tvUNqv+fJ+clDaBZs3
         jZjSd7vWqEaC0IEDl0GbNIM0dwYEzR8Rye43+UB5XYzvjXbfWdD3i6qQF3zcE43XgY/5
         oTglCJK9Mb1MFMoB1ETDIYc+zaALaAxztNs1rY4yc+IS73ligzoXx1Vq1JTo7IlL2eUJ
         L8aA==
In-Reply-To: <201511260027.CCC26590.SOHFMQLVJOtFOF@I-love.SAKURA.ne.jp>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Sasha Levin <sasha.levin@oracle.com>, Eric Dumazet <edumazet@google.com>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>

On Wed, Nov 25, 2015 at 4:27 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Dmitry Vyukov wrote:
>> If the race described in
>> http://www.spinics.net/lists/cgroups/msg14078.html does actually
>> happen, then there is nothing to check.
>> https://gcc.gnu.org/ml/gcc/2012-02/msg00005.html talks about different
>> memory locations, if there is store-widening involving different
>> memory locations, then this is a compiler bug. But the race happens on
>> a single memory location, in such case the code is buggy.
>>
>
> All ->in_execve ->in_iowait ->sched_reset_on_fork ->sched_contributes_to_load
> ->sched_migrated ->memcg_may_oom ->memcg_kmem_skip_account ->brk_randomized
> shares the same byte.
>
> sched_fork(p) modifies p->sched_reset_on_fork but p is not yet visible.
> __sched_setscheduler(p) modifies p->sched_reset_on_fork.
> try_to_wake_up(p) modifies p->sched_contributes_to_load.
> perf_event_task_migrate(p) modifies p->sched_migrated.
>
> Trying to reproduce this problem with
>
>  static __always_inline bool
>  perf_sw_migrate_enabled(void)
>  {
> -       if (static_key_false(&perf_swevent_enabled[PERF_COUNT_SW_CPU_MIGRATIONS]))
> -               return true;
>         return false;
>  }
>
> would help testing ->sched_migrated case.








I have some progress.

With the following patch:

dvyukov@dvyukov-z840:~/src/linux-dvyukov$ git diff
include/linux/sched.h mm/memory.c
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2fae7d8..4c126a1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1455,6 +1455,8 @@ struct task_struct {
        /* Used for emulating ABI behavior of previous Linux versions */
        unsigned int personality;

+       union {
+       struct {
        unsigned in_execve:1;   /* Tell the LSMs that the process is doing an
                                 * execve */
        unsigned in_iowait:1;
@@ -1463,18 +1465,24 @@ struct task_struct {
        unsigned sched_reset_on_fork:1;
        unsigned sched_contributes_to_load:1;
        unsigned sched_migrated:1;
+       unsigned dummy_a:1;
 #ifdef CONFIG_MEMCG
        unsigned memcg_may_oom:1;
 #endif
+       unsigned dummy_b:1;
 #ifdef CONFIG_MEMCG_KMEM
        unsigned memcg_kmem_skip_account:1;
 #endif
 #ifdef CONFIG_COMPAT_BRK
        unsigned brk_randomized:1;
 #endif
+       };
+       unsigned nonatomic_flags;
+       };

        unsigned long atomic_flags; /* Flags needing atomic access. */

+
        struct restart_block restart_block;

        pid_t pid;
diff --git a/mm/memory.c b/mm/memory.c
index deb679c..6351dac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -62,6 +62,7 @@
 #include <linux/dma-debug.h>
 #include <linux/debugfs.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/kasan.h>

 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -3436,12 +3437,45 @@ int handle_mm_fault(struct mm_struct *mm,
struct vm_area_struct *vma,
         * Enable the memcg OOM handling for faults triggered in user
         * space.  Kernel faults are handled more gracefully.
         */
-       if (flags & FAULT_FLAG_USER)
+       if (flags & FAULT_FLAG_USER) {
+               volatile int x;
+               unsigned f0, f1;
+               f0 = READ_ONCE(current->nonatomic_flags);
+               for (x = 0; x < 1000; x++) {
+                       WRITE_ONCE(current->nonatomic_flags, 0xaeaeaeae);
+                       cpu_relax();
+                       WRITE_ONCE(current->nonatomic_flags, 0xaeaeaeab);
+                       cpu_relax();
+                       f1 = READ_ONCE(current->nonatomic_flags);
+                       if (f1 != 0xaeaeaeab) {
+                               pr_err("enable: flags 0x%x -> 0x%x\n", f0, f1);
+                               break;
+                       }
+               }
+               WRITE_ONCE(current->nonatomic_flags, f0);
+
                mem_cgroup_oom_enable();
+       }

        ret = __handle_mm_fault(mm, vma, address, flags);

        if (flags & FAULT_FLAG_USER) {
+               volatile int x;
+               unsigned f0, f1;
+               f0 = READ_ONCE(current->nonatomic_flags);
+               for (x = 0; x < 1000; x++) {
+                       WRITE_ONCE(current->nonatomic_flags, 0xaeaeaeae);
+                       cpu_relax();
+                       WRITE_ONCE(current->nonatomic_flags, 0xaeaeaeab);
+                       cpu_relax();
+                       f1 = READ_ONCE(current->nonatomic_flags);
+                       if (f1 != 0xaeaeaeab) {
+                               pr_err("enable: flags 0x%x -> 0x%x\n", f0, f1);
+                               break;
+                       }
+               }
+               WRITE_ONCE(current->nonatomic_flags, f0);
+
                mem_cgroup_oom_disable();
                 /*
                  * The task may have entered a memcg OOM situation but


I see:

[  153.484152] enable: flags 0x8 -> 0xaeaeaeaf
[  168.707786] enable: flags 0x8 -> 0xaeaeaeae
[  169.654966] enable: flags 0x40 -> 0xaeaeaeae
[  176.809080] enable: flags 0x48 -> 0xaeaeaeaa
[  177.496219] enable: flags 0x8 -> 0xaeaeaeaf
[  193.266703] enable: flags 0x0 -> 0xaeaeaeae
[  199.536435] enable: flags 0x8 -> 0xaeaeaeae
[  210.650809] enable: flags 0x48 -> 0xaeaeaeaf
[  210.869397] enable: flags 0x8 -> 0xaeaeaeaf
[  216.150804] enable: flags 0x8 -> 0xaeaeaeaa
[  231.607211] enable: flags 0x8 -> 0xaeaeaeaf
[  260.677408] enable: flags 0x48 -> 0xaeaeaeae
[  272.065364] enable: flags 0x40 -> 0xaeaeaeaf
[  281.594973] enable: flags 0x48 -> 0xaeaeaeaf
[  282.899860] enable: flags 0x8 -> 0xaeaeaeaf
[  286.472173] enable: flags 0x8 -> 0xaeaeaeae
[  286.763203] enable: flags 0x8 -> 0xaeaeaeaf
[  288.229107] enable: flags 0x0 -> 0xaeaeaeaf
[  291.336522] enable: flags 0x8 -> 0xaeaeaeae
[  310.082981] enable: flags 0x48 -> 0xaeaeaeaf
[  313.798935] enable: flags 0x8 -> 0xaeaeaeaf
[  343.340508] enable: flags 0x8 -> 0xaeaeaeaf
[  344.170635] enable: flags 0x48 -> 0xaeaeaeaf
[  357.568555] enable: flags 0x8 -> 0xaeaeaeaf
[  359.158179] enable: flags 0x48 -> 0xaeaeaeaf
[  361.188300] enable: flags 0x40 -> 0xaeaeaeaa
[  365.636639] enable: flags 0x8 -> 0xaeaeaeaf

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
