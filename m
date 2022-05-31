From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v5 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Mon, 30 May 2022 22:41:30 -0400
Message-ID: <1ecec7cb-035c-a4aa-3918-1a00ba48c6f9@redhat.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653964893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dqGPJPGu5WN/i1V+mwA4aFt/oqbHUtth4ZkdMSpoL5A=;
        b=FDiwaIDyEWxRWNxEOTvkJYB3DrWAEKpaDhMeWzxGDOtqi1jbSMQBcj2Qsgf+hIsR2Uq6xL
        FPBow4V0OphqVhDVk0oAQqY/6tU1jac87vt8Uqepfuz/w36WF22kaKuCHRL+12LUZC0U91
        fjk6G95/OSJpyZFKRlP9v9NPYJpeEi0=
Content-Language: en-US
In-Reply-To: <20220530074919.46352-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Muchun Song <songmuchun@bytedance.com>, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com

On 5/30/22 03:49, Muchun Song wrote:
> This version is rebased on v5.18.
>
> Since the following patchsets applied. All the kernel memory are charged
> with the new APIs of obj_cgroup.
>
> 	[v17,00/19] The new cgroup slab memory controller [1]
> 	[v5,0/7] Use obj_cgroup APIs to charge kmem pages [2]
>
> But user memory allocations (LRU pages) pinning memcgs for a long time -
> it exists at a larger scale and is causing recurring problems in the real
> world: page cache doesn't get reclaimed for a long time, or is used by the
> second, third, fourth, ... instance of the same job that was restarted into
> a new cgroup every time. Unreclaimable dying cgroups pile up, waste memory,
> and make page reclaim very inefficient.
>
> We can convert LRU pages and most other raw memcg pins to the objcg direction
> to fix this problem, and then the LRU pages will not pin the memcgs.
>
> This patchset aims to make the LRU pages to drop the reference to memory
> cgroup by using the APIs of obj_cgroup. Finally, we can see that the number
> of the dying cgroups will not increase if we run the following test script.
>
> ```bash
> #!/bin/bash
>
> dd if=/dev/zero of=temp bs=4096 count=1
> cat /proc/cgroups | grep memory
>
> for i in {0..2000}
> do
> 	mkdir /sys/fs/cgroup/memory/test$i
> 	echo $$ > /sys/fs/cgroup/memory/test$i/cgroup.procs
> 	cat temp >> log
> 	echo $$ > /sys/fs/cgroup/memory/cgroup.procs
> 	rmdir /sys/fs/cgroup/memory/test$i
> done
>
> cat /proc/cgroups | grep memory
>
> rm -f temp log
> ```
>
> [1] https://lore.kernel.org/linux-mm/20200623015846.1141975-1-guro@fb.com/
> [2] https://lore.kernel.org/linux-mm/20210319163821.20704-1-songmuchun@bytedance.com/
>
> v4: https://lore.kernel.org/all/20220524060551.80037-1-songmuchun@bytedance.com/
> v3: https://lore.kernel.org/all/20220216115132.52602-1-songmuchun@bytedance.com/
> v2: https://lore.kernel.org/all/20210916134748.67712-1-songmuchun@bytedance.com/
> v1: https://lore.kernel.org/all/20210814052519.86679-1-songmuchun@bytedance.com/
> RFC v4: https://lore.kernel.org/all/20210527093336.14895-1-songmuchun@bytedance.com/
> RFC v3: https://lore.kernel.org/all/20210421070059.69361-1-songmuchun@bytedance.com/
> RFC v2: https://lore.kernel.org/all/20210409122959.82264-1-songmuchun@bytedance.com/
> RFC v1: https://lore.kernel.org/all/20210330101531.82752-1-songmuchun@bytedance.com/
>
> v5:
>   - Lots of improvements from Johannes, Roman and Waiman.
>   - Fix lockdep warning reported by kernel test robot.
>   - Add two new patches to do code cleanup.
>   - Collect Acked-by and Reviewed-by from Johannes and Roman.
>   - I didn't replace local_irq_disable/enable() to local_lock/unlock_irq() since
>     local_lock/unlock_irq() takes an parameter, it needs more thinking to transform
>     it to local_lock.  It could be an improvement in the future.

My comment about local_lock/unlock is just a note that 
local_irq_disable/enable() have to be eventually replaced. However, we 
need to think carefully where to put the newly added local_lock. It is 
perfectly fine to keep it as is and leave the conversion as a future 
follow-up.

Thank you very much for your work on this patchset.

Cheers,
Longman


