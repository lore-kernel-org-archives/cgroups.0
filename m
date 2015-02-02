From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: CGROUPS: HowTo: perform force_empty
Date: Mon, 2 Feb 2015 15:19:16 +0100
Message-ID: <20150202141916.GC4583@dhcp22.suse.cz>
References: <002d01d03ece$1971ae10$4c550a30$@samsung.com>
 <20150202121520.GB4583@dhcp22.suse.cz>
 <005f01d03ef1$e0242510$a06c6f30$@samsung.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qqNitnHGHyViLju8wlmhKdpMrFRvURMDroT7Z8vnFaM=;
        b=pRcN/v9oaZW5b5P+rfPULgqSSAEos2mXw/dBP9SvC3iMDhZaQi6dbqPd/k3zQjRp8A
         ncyq1Mc3gWl6vAp1ndUXo16xQDwq2AyIkCcXpE0UNiu90YfQRsAiLDuIKYle5hvJTHcv
         +dKi+EACBU2gUbtn1UQoXbvl28C4GkTh1JRr8HnJdrzxMc9nJvYRoOvJkHxFHkC2Jx8Y
         49ZZRYLMZRVDcm+aIT3cSM6hRC12qNR6maIQvgwIBODcKGyO8uLBwuzTtoFapkjYAYJU
         WMcP6W/L0Qes6W00LOiA6V/iylVllpHyQDTsCFnETnNqAZtL4FOIQ7eAZLl38t18wHwA
         9Inw==
Content-Disposition: inline
In-Reply-To: <005f01d03ef1$e0242510$a06c6f30$@samsung.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: PINTU KUMAR <pintu.k-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, rohit.kr-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, vishnu.ps-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, cpgs-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

On Mon 02-02-15 19:38:44, PINTU KUMAR wrote:
> Hi,
> 
> > -----Original Message-----
> > From: Michal Hocko [mailto:mstsxfx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of Michal Hocko
> > Sent: Monday, February 02, 2015 5:45 PM
> > To: PINTU KUMAR
> > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> > kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org; hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org; xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org;
> > cpgs-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
> > Subject: Re: CGROUPS: HowTo: perform force_empty
> > 
> > On Mon 02-02-15 15:23:22, PINTU KUMAR wrote:
> > > Hi,
> > >
> > > I have a question about memory cgroups under Linux kernel 3.10.
> > > Under: /sys/fs/cgroup/memory/:
> > >
> > > I found, memory.force_empty.
> > > But, when I try to do the following it says invalid argument:
> > > # echo 0 > memory.force_empty
> > > sh: echo: write error: Invalid argument
> > >
> > > It even fails with "echo 1"
> > 
> > It is not clear on which cgroup you are trying to invoke force_empty.
> > The knob is disabled for the root memcg so I suppose this is why you see the
> > failure.
>
> Ok, please let me know how to use it for specific group, and where to check the
> group info.

echo foo > $path_to_your_memcg/memory.force_empty

and you can get information about memory consumption for a particular
memcg in
cat $path_to_your_memcg/memory.stat

> Also, why we should not run it for: root_mem_cgroup

Because the primary motivation for force_empty knob was to free
reclaimable pages before the groups itself is removed. If this wasn't
done then the pages would stay on LRU and got reclaimed only under
memory pressure. The root memcg cannot be removed so it really didn't
make much sense to allow the know for it.

> > > I am using this command from the shell using the root login.
> > > Can you tell me how to execute the force_empty command.
> > 
> > You can echo anything to the knob to trigger the reclaim.
> > 
> > > Or, how to release all the memory under all cgroups and release it to
> > > the system?
> > 
> > Why would you use memcg API to release memory from the system as whole?
> > What are you trying to achieve?
> > 
> Actually, the problem is that, the system is running with low memory, after few
> application launch.
> When, I see the cgroup: memory.stat, lots are memory is available in cgroups.
> I also observed that system performs force_reclaim in background, to reclaim
> some memory from the background cgroup.

Once there is a memory pressure (global or triggered by hard limit on
memcg) there is a memory reclaim activated which scans and reclaims
memcgs proportionally.

> But, at some scenario, I wanted to clean-up entire cgroup and start from fresh,
> without killing the application, or without rebooting the system.
> This is only for some experiment purpose.

I am not sure I understand. How do you want to clean up the group when
there are still tasks running in them? What about memory consumed by
those tasks?

> > > Under, mm/memcontrol.c , if I use the function:
> > > mem_cgroup_force_empty(struct mem_cgroup *memcg), will it help to release
> > > all memory?
> > > But, then, how to initialize the memcg data structure?
> > > Can you provide some example to use this API, from some other kernel
> > > sub-system.
> > 
> > mem_cgroup_force_empty is an internal memory controller functionality which is
> > not supposed to be used from other kernel subsystems. Why would you want to
> > force reclaim on memcg level from the kernel in the first place?
> 
> I observe that force reclaim is already happening, during low memory condition.
> Similarly, I want to use force_empty option.
> But, I worry about, how to initialize the : struct mem_cgroup *memcg
> What field, and what value I should set in this structure, to pass to
> force_empty.

You definitely shouldn't abuse memcg internals to trigger memcg reclaim.
There is a good reason why that API is not exported for external use.

> This is only for some experiment purpose.
> 
> Otherwise, please let me know, how to use the:
> try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg, ....), which is found in
> mm/vmscan.c
> In any case, I need to know how to initialize the mem_cgroup structure.
> 
> Once the experiment results are successful, I will share the details back.
> Thank you for your reply.
-- 
Michal Hocko
SUSE Labs
