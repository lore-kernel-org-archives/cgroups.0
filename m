From: "Mizuma, Masayoshi" <m.mizuma-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: mm: memcg: A infinite loop in __handle_mm_fault()
Date: Mon, 10 Feb 2014 20:51:00 +0900
Message-ID: <52F8BD24.8020009@jp.fujitsu.com>
References: <52F81C5D.6010601@jp.fujitsu.com> <20140210111928.GA7117@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140210111928.GA7117-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>



(2014/02/10 20:19), Michal Hocko wrote:
> [CCing Kirill]
>
> On Mon 10-02-14 09:25:01, Mizuma, Masayoshi wrote:
>> Hi,
>
> Hi,

Thank you for response and sorry for my broken mail text (I mistook copy and paste...).

>
>> This is a bug report for memory cgroup hang up.
>> I reproduced this using 3.14-rc1 but I couldn't in 3.7.
>>
>> When I ran a program (see below) under a limit of memcg, the process hanged up.
>> Using kprobe trace, I detected the hangup in __handle_mm_fault().
>> do_huge_pmd_wp_page(), which is called by __handle_mm_fault(), always returns
>> VM_FAULT_OOM, so it repeats goto retry and the task can't be killed.
>
> Thanks a lot for this very good report. I would bet the issue is related
> to the THP zero page.
>
> __handle_mm_fault retry loop for VM_FAULT_OOM from do_huge_pmd_wp_page
> expects that the pmd is marked for splitting so that it can break out
> and retry the fault. This is not the case for THP zero page though.
> do_huge_pmd_wp_page checks is_huge_zero_pmd and goes to allocate a new
> huge page which will succeed in your case because you are hitting memcg
> limit not the global memory pressure. But then a new page is charged by
> mem_cgroup_newpage_charge which fails. An existing page is then split
> and we are returning VM_FAULT_OOM. But we do not have page initialized
> in that path because page = pmd_page(orig_pmd) is called after
> is_huge_zero_pmd check.
>
> I am not familiar with THP zero page code much but I guess splitting
> such a zero page is not a way to go. Instead we should simply drop the
> zero page and retry the fault. I would assume that one of
> do_huge_pmd_wp_zero_page_fallback or do_huge_pmd_wp_page_fallback should
> do the trick but both of them try to charge new page(s) before the
> current zero page is uncharged. That makes it prone to the same issue
> AFAICS.
>
> But may be Kirill has a better idea.

I think this issue is related to THP, too. Because, it is not reproduced when
THP is disabled as following.

# echo never > /sys/kernel/mm/transparent_hugepage/enabled

Regards,
Masayoshi Mizuma

>
> But may be Kirill has a better idea.
>
>> --------------------------------------------------
>> static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>>                               unsigned long address, unsigned int flags)
>> {Hi all,
>>
>> This is a bug report for memory cgroup hang up.
>> I reproduced this using 3.14-rc1 but I couldn't in 3.7.
>>
>> When I ran a program (see below) under a limit of memcg, the process hangs up.
>> Using kprobe trace, I detected the hangup in __handle_mm_fault().
>> do_huge_pmd_wp_page(), which is called by __handle_mm_fault(), always returns
>> VM_FAULT_OOM but the task can't be killed.
>> It seems to be in infinite loop and the process is never killed.
>>
>> --------------------------------------------------
>> static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>>                               unsigned long address, unsigned int flags)
>> {
>> ...
>> retry:
>>          pgd = pgd_offset(mm, address);
>> ...
>>                          if (dirty && !pmd_write(orig_pmd)) {
>>                                  ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
>>                                                            orig_pmd);
>>                                  /*
>>                                   * If COW results in an oom, the huge pmd will
>>                                   * have been split, so retry the fault on the
>>                                   * pte for a smaller charge.
>>                                   */
>>                                  if (unlikely(ret & VM_FAULT_OOM))
>>                                          goto retry;
>> --------------------------------------------------
>>
>> [Step to reproduce]
>>
>> 1. Set memory cgroup as follows:
>>
>> --------------------------------------------------
>> # mkdir /sys/fs/cgroup/memory/test
>> # echo "6M" > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>> # echo "6M" > /sys/fs/cgroup/memory/test/memory.memsw.limit_in_bytes
>> --------------------------------------------------
>>
>> 2. Ran the following process (test.c).
>>
>> test.c:
>> --------------------------------------------------
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <unistd.h>
>> #define SIZE 4*1024*1024
>> #define HUGE 2*1024*1024
>> #define PAGESIZE 4096
>> #define NUM SIZE/PAGESIZE
>>
>> int main(void)
>> {
>> 	char *a;
>> 	char *c;
>> 	int i;
>>
>> 	/* wait until set cgroup limits */
>> 	sleep(1);
>>
>> 	posix_memalign((void **)&a, HUGE, SIZE);
>> 	posix_memalign((void **)&c, HUGE, SIZE);
>>
>> 	for (i = 0; i<NUM; i++) {
>> 		*(a + i * PAGESIZE) = *(c + i * PAGESIZE);
>> 	}
>>
>> 	for (i = 0; i<NUM; i++) {
>> 		*(c + i * PAGESIZE) = *(a + i * PAGESIZE);
>> 	}
>>
>> 	free(a);
>> 	free(c);
>> 	return 0;
>> }
>> --------------------------------------------------
>>
>> 3. Add it to memory cgroup.
>> --------------------------------------------------
>> # ./test &
>> # echo $! > /sys/fs/cgroup/memory/test/tasks
>> --------------------------------------------------
>>
>> Then, the process will hangup.
>> I checked the infinit loop by using kprobetrace.
>>
>> Setting of kprobetrace:
>> --------------------------------------------------
>> # echo 'p:do_huge_pmd_wp_page do_huge_pmd_wp_page address=%dx' > /sys/kernel/debug/tracing/kprobe_events
>> # echo 'r:do_huge_pmd_wp_page_r do_huge_pmd_wp_page ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
>> # echo 'r:mem_cgroup_newpage_charge mem_cgroup_newpage_charge ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
>> # echo 'r:mem_cgroup_charge_common mem_cgroup_charge_common ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
>> # echo 'r:__mem_cgroup_try_charge __mem_cgroup_try_charge ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/do_huge_pmd_wp_page/enable
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/do_huge_pmd_wp_page_r/enable
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/mem_cgroup_newpage_charge/enable
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/mem_cgroup_charge_common/enable
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/__mem_cgroup_try_charge/enable
>> --------------------------------------------------
>>
>> The result:
>> --------------------------------------------------
>> test-2721  [001] dN..  2530.635679: do_huge_pmd_wp_page: (do_huge_pmd_wp_page+0x0/0xa90) address=0x7f55a4400000
>> test-2721  [001] dN..  2530.635723: __mem_cgroup_try_charge: (mem_cgroup_charge_common+0x4a/0xa0 <- __mem_cgroup_try_charge) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635724: mem_cgroup_charge_common: (mem_cgroup_newpage_charge+0x26/0x30 <- mem_cgroup_charge_common) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635725: mem_cgroup_newpage_charge: (do_huge_pmd_wp_page+0x125/0xa90 <- mem_cgroup_newpage_charge) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635733: do_huge_pmd_wp_page_r: (handle_mm_fault+0x19e/0x4b0 <- do_huge_pmd_wp_page) ret=0x1
>> test-2721  [001] dN..  2530.635735: do_huge_pmd_wp_page: (do_huge_pmd_wp_page+0x0/0xa90) address=0x7f55a4400000
>> test-2721  [001] dN..  2530.635761: __mem_cgroup_try_charge: (mem_cgroup_charge_common+0x4a/0xa0 <- __mem_cgroup_try_charge) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635761: mem_cgroup_charge_common: (mem_cgroup_newpage_charge+0x26/0x30 <- mem_cgroup_charge_common) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635762: mem_cgroup_newpage_charge: (do_huge_pmd_wp_page+0x125/0xa90 <- mem_cgroup_newpage_charge) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635768: do_huge_pmd_wp_page_r: (handle_mm_fault+0x19e/0x4b0 <- do_huge_pmd_wp_page) ret=0x1
>> (...repeat...)
>> --------------------------------------------------
>>
>> Regards,
>> Masayoshi Mizuma <m.mizuma-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> ...
>> retry:
>>          pgd = pgd_offset(mm, address);
>> ...
>>                          if (dirty && !pmd_write(orig_pmd)) {
>>                                  ret = do_huge_pmd_wp_page(mm, vma, address, pmd,
>>                                                            orig_pmd);
>>                                  /*
>>                                   * If COW results in an oom, the huge pmd will
>>                                   * have been split, so retry the fault on the
>>                                   * pte for a smaller charge.
>>                                   */
>>                                  if (unlikely(ret & VM_FAULT_OOM))
>>                                          goto retry;
>> --------------------------------------------------
>>
>> [Step to reproduce]
>>
>> 1. Set memory cgroup as follows:
>>
>> --------------------------------------------------
>> # mkdir /sys/fs/cgroup/memory/test
>> # echo "6M" > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>> # echo "6M" > /sys/fs/cgroup/memory/test/memory.memsw.limit_in_bytes
>> --------------------------------------------------
>>
>> 2. Ran the following process (test.c).
>>
>> test.c:
>> --------------------------------------------------
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <unistd.h>
>> #define SIZE 4*1024*1024
>> #define HUGE 2*1024*1024
>> #define PAGESIZE 4096
>> #define NUM SIZE/PAGESIZE
>>
>> int main(void)
>> {
>> 	char *a;
>> 	char *c;
>> 	int i;
>>
>> 	/* wait until set cgroup limits */
>> 	sleep(1);
>>
>> 	posix_memalign((void **)&a, HUGE, SIZE);
>> 	posix_memalign((void **)&c, HUGE, SIZE);
>>
>> 	for (i = 0; i<NUM; i++) {
>> 		*(a + i * PAGESIZE) = *(c + i * PAGESIZE);
>> 	}
>>
>> 	for (i = 0; i<NUM; i++) {
>> 		*(c + i * PAGESIZE) = *(a + i * PAGESIZE);
>> 	}
>>
>> 	free(a);
>> 	free(c);
>> 	return 0;
>> }
>> --------------------------------------------------
>>
>> 3. Add it to memory cgroup.
>> --------------------------------------------------
>> # ./test &
>> # echo $! > /sys/fs/cgroup/memory/test/tasks
>> --------------------------------------------------
>>
>> Then, the process will hangup.
>> I checked the infinit loop by using kprobetrace.
>>
>> Setting of kprobetrace:
>> --------------------------------------------------
>> # echo 'p:do_huge_pmd_wp_page do_huge_pmd_wp_page address=%dx' > /sys/kernel/debug/tracing/kprobe_events
>> # echo 'r:do_huge_pmd_wp_page_r do_huge_pmd_wp_page ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
>> # echo 'r:mem_cgroup_newpage_charge mem_cgroup_newpage_charge ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
>> # echo 'r:mem_cgroup_charge_common mem_cgroup_charge_common ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
>> # echo 'r:__mem_cgroup_try_charge __mem_cgroup_try_charge ret=$retval' >> /sys/kernel/debug/tracing/kprobe_events
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/do_huge_pmd_wp_page/enable
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/do_huge_pmd_wp_page_r/enable
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/mem_cgroup_newpage_charge/enable
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/mem_cgroup_charge_common/enable
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobes/__mem_cgroup_try_charge/enable
>> --------------------------------------------------
>>
>> The result:
>> --------------------------------------------------
>> test-2721  [001] dN..  2530.635679: do_huge_pmd_wp_page: (do_huge_pmd_wp_page+0x0/0xa90) address=0x7f55a4400000
>> test-2721  [001] dN..  2530.635723: __mem_cgroup_try_charge: (mem_cgroup_charge_common+0x4a/0xa0 <- __mem_cgroup_try_charge) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635724: mem_cgroup_charge_common: (mem_cgroup_newpage_charge+0x26/0x30 <- mem_cgroup_charge_common) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635725: mem_cgroup_newpage_charge: (do_huge_pmd_wp_page+0x125/0xa90 <- mem_cgroup_newpage_charge) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635733: do_huge_pmd_wp_page_r: (handle_mm_fault+0x19e/0x4b0 <- do_huge_pmd_wp_page) ret=0x1
>> test-2721  [001] dN..  2530.635735: do_huge_pmd_wp_page: (do_huge_pmd_wp_page+0x0/0xa90) address=0x7f55a4400000
>> test-2721  [001] dN..  2530.635761: __mem_cgroup_try_charge: (mem_cgroup_charge_common+0x4a/0xa0 <- __mem_cgroup_try_charge) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635761: mem_cgroup_charge_common: (mem_cgroup_newpage_charge+0x26/0x30 <- mem_cgroup_charge_common) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635762: mem_cgroup_newpage_charge: (do_huge_pmd_wp_page+0x125/0xa90 <- mem_cgroup_newpage_charge) ret=0xfffffff4
>> test-2721  [001] dN..  2530.635768: do_huge_pmd_wp_page_r: (handle_mm_fault+0x19e/0x4b0 <- do_huge_pmd_wp_page) ret=0x1
>> (...repeat...)
>> --------------------------------------------------
>>
>> Regards,
>> Masayoshi Mizuma <m.mizuma-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
