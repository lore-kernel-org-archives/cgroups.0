From: zhong jiang <zhongjiang@huawei.com>
Subject: Re: KASAN: use-after-free Read in get_mem_cgroup_from_mm
Date: Sat, 16 Mar 2019 17:38:54 +0800
Message-ID: <5C8CC42E.1090208@huawei.com>
References: <00000000000006457e057c341ff8@google.com> <5C7BFE94.6070500@huawei.com> <CACT4Y+Z+CH0UTdSz-w_woMPrBwg-GuobV1Su4qd9ReffTkyfVg@mail.gmail.com> <5C7D2F82.40907@huawei.com> <CACT4Y+agwaszODNGJHCqn4fSk4Le9exn3Cau0nornJ0RaTpDJw@mail.gmail.com> <5C7D4500.3070607@huawei.com> <CACT4Y+b6y_3gTpR8LvNREHOV0TP7jB=Zp1L03dzpaz_SaeESng@mail.gmail.com> <5C7E1A38.2060906@huawei.com> <20190306020540.GA23850@redhat.com> <5C821550.50506@huawei.com> <20190315213944.GD9967@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190315213944.GD9967@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, syzbot <syzbot+cbb52e396df3e565ab02@syzkaller.appspotmail.com>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>

On 2019/3/16 5:39, Andrea Arcangeli wrote:
> On Fri, Mar 08, 2019 at 03:10:08PM +0800, zhong jiang wrote:
>> I can reproduce the issue in arm64 qemu machine.  The issue will leave after applying the
>> patch.
>>
>> Tested-by: zhong jiang <zhongjiang@huawei.com>
> Thanks a lot for the quick testing!
>
>> Meanwhile,  I just has a little doubt whether it is necessary to use RCU to free the task struct or not.
>> I think that mm->owner alway be NULL after failing to create to process. Because we call mm_clear_owner.
> I wish it was enough, but the problem is that the other CPU may be in
> the middle of get_mem_cgroup_from_mm() while this runs, and it would
> dereference mm->owner while it is been freed without the call_rcu
> affter we clear mm->owner. What prevents this race is the
As you had said, It would dereference mm->owner after we clear mm->owner.

But after we clear mm->owner,  mm->owner should be NULL.  Is it right?

And mem_cgroup_from_task will check the parameter. 
you mean that it is possible after checking the parameter to  clear the owner .
and the NULL pointer will trigger. :-(

Thanks,
zhong jiang
> rcu_read_lock() in get_mem_cgroup_from_mm() and the corresponding
> call_rcu to free the task struct in the fork failure path (again only
> if CONFIG_MEMCG=y is defined). Considering you can reproduce this tiny
> race on arm64 qemu (perhaps tcg JIT timing variantions helps?), you
> might also in theory be able to still reproduce the race condition if
> you remove the call_rcu from delayed_free_task and you replace it with
> free_task.
>
> .
>


