From: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Wed, 3 May 2023 15:15:43 -0700
Message-ID: <ZFLdDyHoIdJSXJt+@google.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683152145;
        bh=+ocrPAkOdQyItdTxvvDTbqSS5GMs2VRphMsyKFbsZMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M3duYVZPAF/mrKdE8OyWA9MtJurowlEptwZBbkzO1iXsIfpGROqYKbwRviOgeNhui
         ZQ1inuPL+Ub6XYeT596m6Y+o4ok0jIFutl791I/9eg71Zeq+gW/UCiN8NyoJFuib8F
         gyAPFXtRd6dJ3Gayl3HET/k8/x9kfHDAwH694ypfoT+MoGVVZ3BibDVMtbyORtRl5J
         gOPRl8F2pB4npD5dBtb5/frwPTnt8aZeKhMYfq2/2CtxTj2xBYBpcZmZ3689XXztUD
         ZRsQNikB13XNml3M40l2GSFvelBi9ODM+WY6e5896VnGsEC+GtwvuqNrCQOfYGZJiB
         v6Wr0M5kTiK+A==
Content-Disposition: inline
In-Reply-To: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi T.J.,

On Tue, Apr 11, 2023 at 04:36:37PM -0700, T.J. Mercier wrote:
> When a memcg is removed by userspace it gets offlined by the kernel.
> Offline memcgs are hidden from user space, but they still live in the
> kernel until their reference count drops to 0. New allocations cannot
> be charged to offline memcgs, but existing allocations charged to
> offline memcgs remain charged, and hold a reference to the memcg.
> 
> As such, an offline memcg can remain in the kernel indefinitely,
> becoming a zombie memcg. The accumulation of a large number of zombie
> memcgs lead to increased system overhead (mainly percpu data in struct
> mem_cgroup). It also causes some kernel operations that scale with the
> number of memcgs to become less efficient (e.g. reclaim).
> 
> There are currently out-of-tree solutions which attempt to
> periodically clean up zombie memcgs by reclaiming from them. However
> that is not effective for non-reclaimable memory, which it would be
> better to reparent or recharge to an online cgroup. There are also
> proposed changes that would benefit from recharging for shared
> resources like pinned pages, or DMA buffer pages.

I am also interested in this topic. T.J. and I have some offline
discussion about this. We have some proposals to solve this
problem.

I will share the write up here for the up coming LSF/MM discussion.


Shared Memory Cgroup Controllers

= Introduction

The current memory cgroup controller does not support shared memory objects. For the memory that is shared between different processes, it is not obvious which process should get charged. Google has some internal tmpfs “memcg=” mount option to charge tmpfs data to  a specific memcg that’s often different from where charging processes run. However it faces some difficulties when the charged memcg exits and the charged memcg becomes a zombie memcg.
Other approaches include “re-parenting” the memcg charge to the parent memcg. Which has its own problem. If the charge is huge, iteration of the reparenting can be costly.

= Proposed Solution

The proposed solution is to add a new type of memory controller for shared memory usage. E.g. tmpfs, hugetlb, file system mmap and dma_buf. This shared memory cgroup controller object will have the same life cycle of the underlying  shared memory.

Processes can not be added to the shared memory cgroup. Instead the shared memory cgroup can be added to the memcg using a “smemcg” API file, similar to adding a process into the “tasks” API file.
When a smemcg is added to the memcg, the amount of memory that has been shared in the memcg process will be accounted for as the part of the memcg “memory.current”.The memory.current of the memcg is make up of two parts, 1) the processes anonymous memory and 2) the memory shared from smemcg.

When the memcg “memory.current” is raised to the limit. The kernel will active try to reclaim for the memcg to make “smemcg memory + process anonymous memory” within the limit. Further memory allocation within those memcg processes will fail if the limit can not be followed. If many reclaim attempts fail to bring the memcg “memory.current” within the limit, the process in this memcg will get OOM killed.

= Benefits

The benefits of this solution include:
* No zombie memcg. The life cycle of the smemcg match the share memory file system or dma_buf.
* No reparenting. The shared memory only charge once to the smemcg object. A memcg can include a smemcg to as part of the memcg memory usage. When process exit and memcg get deleted, the charge remain to the smemcg object.
* Much cleaner mental model of the smemcg, each share memory page is charge to one smemcg only once.
* Notice the same smemcg can add to more than one memcg. It can better describe the shared memory relation.

Chris



> Suggested attendees:
> Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
