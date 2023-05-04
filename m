From: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Thu, 4 May 2023 10:36:46 -0700
Message-ID: <ZFPtLjiSQxRw+isR@google.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
 <ZFLdDyHoIdJSXJt+@google.com>
 <CALvZod4=+ANT6UR5h7Cp+0hKkVx6tPAaRa5iqBF=L2VBdMKERQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683221808;
        bh=7m9mx37F+1kk4z6LzQyOim8wIxzOUZ4IAmcYza3FjjE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PWfegElRN1ziVqNk0605RFihboAZqs05zLQVo8zo4UsAlE6X7XldLxz2R0jRorZo1
         pr6+LUKPpJEfNfPXK3a1DPvKsrB07uUStDjsOvGpvKLP851QN72yyfkdCF3Bmj2GUe
         0LIUfFYEQAMEinLOtHfsApU7rNRZbtSDYyB2Ehb1kkXhQSRO3oS3LF2tLGmxeubzE7
         xTC3PwklYdL0HLFvVAxLgTLWUY7JrOzfg2NZvoGJ/8D3ePKF/WfjBolBORaU4KqN/R
         S8cF51Ghj7k2TZRANxUaL5G5E22rjcAOTxzA5esU46q254z2zpcBSZ6kOOEHEFlrnm
         27HvIxM2VQjGQ==
Content-Disposition: inline
In-Reply-To: <CALvZod4=+ANT6UR5h7Cp+0hKkVx6tPAaRa5iqBF=L2VBdMKERQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, May 04, 2023 at 10:02:38AM -0700, Shakeel Butt wrote:
> On Wed, May 3, 2023 at 3:15 PM Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> [...]
> > I am also interested in this topic. T.J. and I have some offline
> > discussion about this. We have some proposals to solve this
> > problem.
> >
> > I will share the write up here for the up coming LSF/MM discussion.
> >
> >
> > Shared Memory Cgroup Controllers
> >
> > = Introduction
> >
> > The current memory cgroup controller does not support shared memory objects. For the memory that is shared between different processes, it is not obvious which process should get charged. Google has some internal tmpfs “memcg=” mount option to charge tmpfs data to  a specific memcg that’s often different from where charging processes run. However it faces some difficulties when the charged memcg exits and the charged memcg becomes a zombie memcg.
> 
> What is the exact problem this proposal is solving? Is it the zombie
> memcgs? To me that is just a side effect of memory shared between
> different memcgs.

I am trying to get rid of zombie memcgs by using shared memory controllers.
That means also finding alternattive solution for "memcg=" usage.
> 
> > Other approaches include “re-parenting” the memcg charge to the parent memcg. Which has its own problem. If the charge is huge, iteration of the reparenting can be costly.
> 
> What is the iteration of the reparenting? Are you referring to
> reparenting the LRUs or something else?

Yes, reparenting the LRU. As Yu point out to me offlined. That LRU
iteration is on an offline memcg so it shouldn't block any thing
major.

Still, I think the smemcg offer more than recharging regarding
modeling the share relationship.

> >
> > = Proposed Solution
> >
> > The proposed solution is to add a new type of memory controller for shared memory usage. E.g. tmpfs, hugetlb, file system mmap and dma_buf. This shared memory cgroup controller object will have the same life cycle of the underlying  shared memory.
> 
> I am confused by the relationship between shared memory controller and
> the underlying shared memory. What does the same life cycle mean? Are

Same life cycle means, if the smemcg comes from a tmpfs, the smemcg have
the same life cycle of the tmpfs.

> the users expected to register the shared memory objects with the
> smemcg? What about unnamed shared memory objects like MAP_SHARED or


The user doesn't need to register shared memory objects. However the file
system code might need to. But I count that as the kernel not the user.

The cgroup admin adds the smemcg into the memcg that shares it. We can
also make an policy option for kernel auto add by smemcg to memcg that
share from it.

> memfds?

Each file system mount will have their own smemcg.

> 
> How does the charging work for smemcg? Is this new controller hierarchical?

Charge only happen once on the smemcg.

Please see this thread for the distinguishing between charge counter and borrow counter.
https://lore.kernel.org/linux-mm/CALvZod4=+ANT6UR5h7Cp+0hKkVx6tPAaRa5iqBF=L2VBdMKERQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/T/#m955cab80f70097d7c9a5be21c19c4851170fa052

I haven't give too much thought of the hierarchical issue.
My initial thought are on the smemcg side, those are not hierarchical.
On the memcg side, they are.

Do you have specific examples where we can discuss hierarchical usage?

> > Processes can not be added to the shared memory cgroup. Instead the shared memory cgroup can be added to the memcg using a “smemcg” API file, similar to adding a process into the “tasks” API file.
> 
> Is the charge of the underlying shared memory live with smemcg or the
> memcg where smemcg is attached? Can a smemcg detach and reattach to a

Charge live with smemcg.

> different memcg?

Smemcg can add to more than one memcg without detached.
Please see the above email regarding borrow vs charge.

> 
> > When a smemcg is added to the memcg, the amount of memory that has been shared in the memcg process will be accounted for as the part of the memcg “memory.current”.The memory.current of the memcg is make up of two parts, 1) the processes anonymous memory and 2) the memory shared from smemcg.
> 
> The above is somewhat giving the impression that the charge of shared
> memory lives with smemcg. This can mess up or complicate the
> hierarchical property of the original memcg.


I haven't given a lot of thought to that. Can you share with me an example
how things can mess up? I will see if I can use the smemcg model to
address it.

> > When the memcg “memory.current” is raised to the limit. The kernel will active try to reclaim for the memcg to make “smemcg memory + process anonymous memory” within the limit. Further memory allocation within those memcg processes will fail if the limit can not be followed. If many reclaim attempts fail to bring the memcg “memory.current” within the limit, the process in this memcg will get OOM killed.
> 
> The OOM killing for remote charging needs much more thought. Please
> see https://lwn.net/Articles/787626/ for previous discussion on
> related topic.

Yes, just take a look. I think the new idea is borrow vs charged.

Let's come up with some detail example try to break the smemcg borrow model.

Chris
