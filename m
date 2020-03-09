From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: linux-next test error: BUG: using __this_cpu_read() in
 preemptible code in __mod_memcg_state
Date: Mon, 9 Mar 2020 17:56:04 +0800
Message-ID: <5b1196be-09ce-51f7-f5e7-63f2e597f91e@linux.alibaba.com>
References: <00000000000022640205a04a20d8@google.com>
 <20200309092423.2ww3aw6yfyce7yty@box>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200309092423.2ww3aw6yfyce7yty@box>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, syzbot <syzbot+826543256ed3b8c37f62-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/3/9 =CF=C2=CE=E75:24, Kirill A. Shutemov =D0=B4=B5=C0:
>> check_preemption_disabled: 3 callbacks suppressed
>> BUG: using __this_cpu_read() in preemptible [00000000] code: syz-fuzzer/=
9432
>> caller is __mod_memcg_state+0x27/0x1a0 mm/memcontrol.c:689
>> CPU: 1 PID: 9432 Comm: syz-fuzzer Not tainted 5.6.0-rc4-next-20200306-sy=
zkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>>  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
>>  __this_cpu_preempt_check.cold+0x84/0x90 lib/smp_processor_id.c:64
>>  __mod_memcg_state+0x27/0x1a0 mm/memcontrol.c:689
>>  __split_huge_page mm/huge_memory.c:2575 [inline]
>>  split_huge_page_to_list+0x124b/0x3380 mm/huge_memory.c:2862
>>  split_huge_page include/linux/huge_mm.h:167 [inline]
> It looks like a regression due to c8cba0cc2a80 ("mm/thp: narrow lru
> locking").

yes, I guess so.

In this patch, I am very bold to move the lru unlock from before=20
'remap_page(head);' up to before 'ClearPageCompound(head);' which is
often checked in lrulock. I want to know which part that real should
stay in lru_lock.=20

So revert this patch or move it back or move after ClearPageCompound
should fix this problem.=20

In the weekend and today, I tried a lot to reproduce this bug on my 2
machines, but still can't. :~(

Many thanks to give a try!

Thank
Alex=20

line 2605 mm/huge_memory.c:
        spin_unlock_irqrestore(&pgdat->lru_lock, flags);

        ClearPageCompound(head);

        split_page_owner(head, HPAGE_PMD_ORDER);

        /* See comment in __split_huge_page_tail() */
        if (PageAnon(head)) {
                /* Additional pin to swap cache */
                if (PageSwapCache(head)) {
                        page_ref_add(head, 2);
                        xa_unlock(&swap_cache->i_pages);
                } else {
                        page_ref_inc(head);
                }
        } else {
                /* Additional pin to page cache */
                page_ref_add(head, 2);
                xa_unlock(&head->mapping->i_pages);
        }

        remap_page(head);

