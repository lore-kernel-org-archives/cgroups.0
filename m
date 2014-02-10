From: Michal Hocko <mhocko@suse.cz>
Subject: Re: mm: memcg: A infinite loop in __handle_mm_fault()
Date: Mon, 10 Feb 2014 12:19:28 +0100
Message-ID: <20140210111928.GA7117@dhcp22.suse.cz>
References: <52F81C5D.6010601@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yc70pmNY7dVZUJH0RYZIMghg84JlMnc297nBxJOwdVA=;
        b=QgzQPJerbf6Co9Lk3kzKHoOwwmujXKKnJbhnbgcT4CnIRaQL+ozOvxI0XG2hHtySun
         EGURwV7uyyaODMhdhr+QwJivDuyZJp5Q2BPdUprt4ha+i77BCSo6bFbUM//zamLaPw3w
         nyucamhZqw05ZvdSNzZY/FQwYHFmCA08dqwyCo6QEUQbY+Eog4+mppj2j8ycp6EmxH8m
         7bV9odeeJoI4itnT7hI0mllVk8+WgZrMDGPtT6Q1C/b60NaFk8aXCB+jUIOP8m9Eu+Ez
         nWTk0HutNP0ccS/7IDmcUVyAvjHgUdqeKzKS9KskoHDaN5W25zBS5UqgXnZqax/1N6TC
         gBUQ==
Content-Disposition: inline
In-Reply-To: <52F81C5D.6010601@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

[CCing Kirill]

On Mon 10-02-14 09:25:01, Mizuma, Masayoshi wrote:
> Hi,

Hi,

> This is a bug report for memory cgroup hang up.
> I reproduced this using 3.14-rc1 but I couldn't in 3.7.
> 
> When I ran a program (see below) under a limit of memcg, the process hanged up.
> Using kprobe trace, I detected the hangup in __handle_mm_fault().
> do_huge_pmd_wp_page(), which is called by __handle_mm_fault(), always returns
> VM_FAULT_OOM, so it repeats goto retry and the task can't be killed.

Thanks a lot for this very good report. I would bet the issue is related
to the THP zero page.

__handle_mm_fault retry loop for VM_FAULT_OOM from do_huge_pmd_wp_page
expects that the pmd is marked for splitting so that it can break out
and retry the fault. This is not the case for THP zero page though.
do_huge_pmd_wp_page checks is_huge_zero_pmd and goes to allocate a new
huge page which will succeed in your case because you are hitting memcg
limit not the global memory pressure. But then a new page is charged by
mem_cgroup_newpage_charge which fails. An existing page is then split
and we are returning VM_FAULT_OOM. But we do not have page initialized
in that path because page = pmd_page(orig_pmd) is called after
is_huge_zero_pmd check.

I am not familiar with THP zero page code much but I guess splitting
such a zero page is not a way to go. Instead we should simply drop the
zero page and retry the fault. I would assume that one of
do_huge_pmd_wp_zero_page_fallback or do_huge_pmd_wp_page_fallback should
do the trick but both of them try to charge new page(s) before the
current zero page is uncharged. That makes it prone to the same issue
AFAICS.

But may be Kirill has a better idea.

> --------------------------------------------------
> static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>                              unsigned long address, unsigned int flags)
> {Hi all,
> 
> This is a bug report for memory cgroup hang up.
> I reproduced this using 3.14-rc1 but I couldn't in 3.7.
> 
> When I ran a program (see below) under a limit of memcg, the process hangs up.
> Using kprobe trace, I detected the hangup in __handle_mm_fault().
> do_huge_pmd_wp_page(), which is called by __handle_mm_fault(), always returns
> VM_FAULT_OOM but the task can't be killed.
> It seems to be in infinite loop and the process is never killed.
> 
> --------------------------------------------------
> static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>                              unsigned long address, unsigned int flags)
> {
> ...
> retry:
>         pgd = pgd_offset(mm, address);
> ...
>                         if (dirty && !pmd_write(orig_pmd)) {
>                                 ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
>                                                           orig_pmd);
>                                 /*
>                                  * If COW results in an oom, the huge pmd will
>                                  * have been split, so retry the fault on the
>                                  * pte for a smaller charge.
>                                  */
>                                 if (unlikely(ret & VM_FAULT_OOM))
>                                         goto retry;
> --------------------------------------------------
> 
> [Step to reproduce]
> 
> 1. Set memory cgroup as follows:
> 
> --------------------------------------------------
> # mkdir /sys/fs/cgroup/memory/test
> # echo "6M" > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> # echo "6M" > /sys/fs/cgroup/memory/test/memory.memsw.limit_in_bytes 
> --------------------------------------------------
> 
> 2. Ran the following process (test.c).
> 
> test.c:
> --------------------------------------------------
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #define SIZE 4*1024*1024
> #define HUGE 2*1024*1024
> #define PAGESIZE 4096
> #define NUM SIZE/PAGESIZE
> 
> int main(void)
> {
> 	char *a;
> 	char *c;
> 	int i;
> 
> 	/* wait until set cgroup limits */
> 	sleep(1);
> 
> 	posix_memalign((void **)&a, HUGE, SIZE);
> 	posix_memalign((void **)&c, HUGE, SIZE);
> 
> 	for (i = 0; i<NUM; i++) {
> 		*(a + i * PAGESIZE) = *(c + i * PAGESIZE);
> 	}
> 
> 	for (i = 0; i<NUM; i++) {
> 		*(c + i * PAGESIZE) = *(a + i * PAGESIZE);
> 	}
> 
> 	free(a);
> 	free(c);
> 	return 0;
> }
> --------------------------------------------------
> 
> 3. Add it to memory cgroup.
> --------------------------------------------------
> # ./test &
> # echo $! > /sys/fs/cgroup/memory/test/tasks
> --------------------------------------------------
> 
> Then, the process will hangup.
> I checked the infinit loop by using kprobetrace.
> 
> Setting of kprobetrace:
> --------------------------------------------------
> # echo 'p:do_huge_pmd_wp_page do_huge_pmd_wp_page address=%dx' > /sys/kernel/debug/tracing/kprobe_events
> # echo 'r:do_huge_pmd_wp_page_r do_huge_pmd_wp_page ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
> # echo 'r:mem_cgroup_newpage_charge mem_cgroup_newpage_charge ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
> # echo 'r:mem_cgroup_charge_common mem_cgroup_charge_common ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
> # echo 'r:__mem_cgroup_try_charge __mem_cgroup_try_charge ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/do_huge_pmd_wp_page/enable
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/do_huge_pmd_wp_page_r/enable
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/mem_cgroup_newpage_charge/enable
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/mem_cgroup_charge_common/enable
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/__mem_cgroup_try_charge/enable
> --------------------------------------------------
> 
> The result:
> --------------------------------------------------
> test-2721  [001] dN..  2530.635679: do_huge_pmd_wp_page: (do_huge_pmd_wp_page+0x0/0xa90) address=0x7f55a4400000
> test-2721  [001] dN..  2530.635723: __mem_cgroup_try_charge: (mem_cgroup_charge_common+0x4a/0xa0 <- __mem_cgroup_try_charge) ret=0xfffffff4
> test-2721  [001] dN..  2530.635724: mem_cgroup_charge_common: (mem_cgroup_newpage_charge+0x26/0x30 <- mem_cgroup_charge_common) ret=0xfffffff4
> test-2721  [001] dN..  2530.635725: mem_cgroup_newpage_charge: (do_huge_pmd_wp_page+0x125/0xa90 <- mem_cgroup_newpage_charge) ret=0xfffffff4
> test-2721  [001] dN..  2530.635733: do_huge_pmd_wp_page_r: (handle_mm_fault+0x19e/0x4b0 <- do_huge_pmd_wp_page) ret=0x1
> test-2721  [001] dN..  2530.635735: do_huge_pmd_wp_page: (do_huge_pmd_wp_page+0x0/0xa90) address=0x7f55a4400000
> test-2721  [001] dN..  2530.635761: __mem_cgroup_try_charge: (mem_cgroup_charge_common+0x4a/0xa0 <- __mem_cgroup_try_charge) ret=0xfffffff4
> test-2721  [001] dN..  2530.635761: mem_cgroup_charge_common: (mem_cgroup_newpage_charge+0x26/0x30 <- mem_cgroup_charge_common) ret=0xfffffff4
> test-2721  [001] dN..  2530.635762: mem_cgroup_newpage_charge: (do_huge_pmd_wp_page+0x125/0xa90 <- mem_cgroup_newpage_charge) ret=0xfffffff4
> test-2721  [001] dN..  2530.635768: do_huge_pmd_wp_page_r: (handle_mm_fault+0x19e/0x4b0 <- do_huge_pmd_wp_page) ret=0x1
> (...repeat...)
> --------------------------------------------------
> 
> Regards,
> Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ...
> retry:
>         pgd = pgd_offset(mm, address);
> ...
>                         if (dirty && !pmd_write(orig_pmd)) {
>                                 ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
>                                                           orig_pmd);
>                                 /*
>                                  * If COW results in an oom, the huge pmd will
>                                  * have been split, so retry the fault on the
>                                  * pte for a smaller charge.
>                                  */
>                                 if (unlikely(ret & VM_FAULT_OOM))
>                                         goto retry;
> --------------------------------------------------
> 
> [Step to reproduce]
> 
> 1. Set memory cgroup as follows:
> 
> --------------------------------------------------
> # mkdir /sys/fs/cgroup/memory/test
> # echo "6M" > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> # echo "6M" > /sys/fs/cgroup/memory/test/memory.memsw.limit_in_bytes 
> --------------------------------------------------
> 
> 2. Ran the following process (test.c).
> 
> test.c:
> --------------------------------------------------
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #define SIZE 4*1024*1024
> #define HUGE 2*1024*1024
> #define PAGESIZE 4096
> #define NUM SIZE/PAGESIZE
> 
> int main(void)
> {
> 	char *a;
> 	char *c;
> 	int i;
> 
> 	/* wait until set cgroup limits */
> 	sleep(1);
> 
> 	posix_memalign((void **)&a, HUGE, SIZE);
> 	posix_memalign((void **)&c, HUGE, SIZE);
> 
> 	for (i = 0; i<NUM; i++) {
> 		*(a + i * PAGESIZE) = *(c + i * PAGESIZE);
> 	}
> 
> 	for (i = 0; i<NUM; i++) {
> 		*(c + i * PAGESIZE) = *(a + i * PAGESIZE);
> 	}
> 
> 	free(a);
> 	free(c);
> 	return 0;
> }
> --------------------------------------------------
> 
> 3. Add it to memory cgroup.
> --------------------------------------------------
> # ./test &
> # echo $! > /sys/fs/cgroup/memory/test/tasks
> --------------------------------------------------
> 
> Then, the process will hangup.
> I checked the infinit loop by using kprobetrace.
> 
> Setting of kprobetrace:
> --------------------------------------------------
> # echo 'p:do_huge_pmd_wp_page do_huge_pmd_wp_page address=%dx' > /sys/kernel/debug/tracing/kprobe_events
> # echo 'r:do_huge_pmd_wp_page_r do_huge_pmd_wp_page ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
> # echo 'r:mem_cgroup_newpage_charge mem_cgroup_newpage_charge ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
> # echo 'r:mem_cgroup_charge_common mem_cgroup_charge_common ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
> # echo 'r:__mem_cgroup_try_charge __mem_cgroup_try_charge ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/do_huge_pmd_wp_page/enable
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/do_huge_pmd_wp_page_r/enable
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/mem_cgroup_newpage_charge/enable
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/mem_cgroup_charge_common/enable
> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/__mem_cgroup_try_charge/enable
> --------------------------------------------------
> 
> The result:
> --------------------------------------------------
> test-2721  [001] dN..  2530.635679: do_huge_pmd_wp_page: (do_huge_pmd_wp_page+0x0/0xa90) address=0x7f55a4400000
> test-2721  [001] dN..  2530.635723: __mem_cgroup_try_charge: (mem_cgroup_charge_common+0x4a/0xa0 <- __mem_cgroup_try_charge) ret=0xfffffff4
> test-2721  [001] dN..  2530.635724: mem_cgroup_charge_common: (mem_cgroup_newpage_charge+0x26/0x30 <- mem_cgroup_charge_common) ret=0xfffffff4
> test-2721  [001] dN..  2530.635725: mem_cgroup_newpage_charge: (do_huge_pmd_wp_page+0x125/0xa90 <- mem_cgroup_newpage_charge) ret=0xfffffff4
> test-2721  [001] dN..  2530.635733: do_huge_pmd_wp_page_r: (handle_mm_fault+0x19e/0x4b0 <- do_huge_pmd_wp_page) ret=0x1
> test-2721  [001] dN..  2530.635735: do_huge_pmd_wp_page: (do_huge_pmd_wp_page+0x0/0xa90) address=0x7f55a4400000
> test-2721  [001] dN..  2530.635761: __mem_cgroup_try_charge: (mem_cgroup_charge_common+0x4a/0xa0 <- __mem_cgroup_try_charge) ret=0xfffffff4
> test-2721  [001] dN..  2530.635761: mem_cgroup_charge_common: (mem_cgroup_newpage_charge+0x26/0x30 <- mem_cgroup_charge_common) ret=0xfffffff4
> test-2721  [001] dN..  2530.635762: mem_cgroup_newpage_charge: (do_huge_pmd_wp_page+0x125/0xa90 <- mem_cgroup_newpage_charge) ret=0xfffffff4
> test-2721  [001] dN..  2530.635768: do_huge_pmd_wp_page_r: (handle_mm_fault+0x19e/0x4b0 <- do_huge_pmd_wp_page) ret=0x1
> (...repeat...)
> --------------------------------------------------
> 
> Regards,
> Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
