From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Date: Mon, 11 Jun 2012 12:55:05 +0900
Message-ID: <4FD56C19.4060307@jp.fujitsu.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com> <20120527202848.GC7631@skywalker.linux.vnet.ibm.com> <87lik920h8.fsf@skywalker.in.ibm.com> <20120608160612.dea6d1ce.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120608160612.dea6d1ce.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

(2012/06/09 8:06), Andrew Morton wrote:
> On Wed, 30 May 2012 20:13:31 +0530
> "Aneesh Kumar K.V"<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>  wrote:
>
>>>>
>>>>   - code: seperating hugetlb bits out from memcg bits to avoid growing
>>>>     mm/memcontrol.c beyond its current 5650 lines, and
>>>>
>>>
>>> I can definitely look at spliting mm/memcontrol.c
>>>
>>>
>>>>   - performance: not incurring any overhead of enabling memcg for per-
>>>>     page tracking that is unnecessary if users only want to limit hugetlb
>>>>     pages.
>>>>
>>
>> Since Andrew didn't sent the patchset to Linus because of this
>> discussion, I looked at reworking the patchset as a seperate
>> controller. The patchset I sent here
>>
>> http://thread.gmane.org/gmane.linux.kernel.mm/79230
>>
>> have seen minimal testing. I also folded the fixup patches
>> Andrew had in -mm to original patchset.
>>
>> Let me know if the changes looks good.
>
> This is starting to be a problem.  I'm still sitting on the old version
> of this patchset and it will start to get in the way of other work.
>
> We now have this new version of the patchset which implements a
> separate controller but it is unclear to me which way we want to go.
>
> Can the memcg developers please drop everything else and make a
> decision here?

Following is a summary in my point of view.
I think there are several topics.

  - overheads.
   (A) IMHO, runtime overhead will be negligible because...
      - if hugetlb is used, anonymous memory accouning doesn't add much overheads
        because they're not used.
      - when it comes to file-cache accounting, I/O dominates performance rather
        than memcg..
      - but you may see some overheads with 100+ cpu system...I'm not sure.

   (B) memory space overhead will not be negligible.
      - now, memcg uses 16bytes per page....4GB/1TB.
        This may be an obvious overhead to the system if working set size are
        quite big and the apps want to use huge size memory.

   (C) what hugetlbfs is.
    - hugetlb is statically allocated. So, they're not usual memory.
      Then, hugetlb cgroup is better.

    - IMHO, hugetlb is memory. And I thought memory.limit_in_bytes should
      take it into account....

   (D) code duplication
    - memory cgroup and hugetlb cgroup will have similar hooks,codes,UIs.
    - we need some #ifdef if we have consolidated memory/hugetlb cgroup.

   (E) user experience
    - with independent hugetlb cgroup, users can disable memory cgroup.
    - with consolidated memcg+hugetlb cgroup, we'll be able to limit
      usual page + hugetlb usage by a limit.


Now, I think...

   1. I need to agree that overhead is _not_ negligible.

   2. THP should be the way rather than hugetlb for my main target platform.
      (shmem/tmpfs should support THP. we need study.)
      user-experience should be fixed by THP+tmpfs+memcg.

   3. It seems Aneesh decided to have independent hugetlb cgroup.

So, now, I admit to have independent hugetlb cgroup.
Other opinions ?

Thanks,
-Kame











