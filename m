From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Fri, 28 Oct 2022 07:22:27 +0800
Message-ID: <87bkpwkg24.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
        <Y1jpDfwBQId3GkJC@feng-clx> <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
        <Y1kl8VbPE0RYdyEB@feng-clx> <Y1lZV6qHp3gIINGc@dhcp22.suse.cz>
        <87wn8lkbk5.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <Y1ou5DGHrEsKnhri@dhcp22.suse.cz>
        <87o7txk963.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <Y1o63SWD2KmQkT3v@dhcp22.suse.cz>
        <87fsf9k3yg.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <Y1p5vaN1AWhpNWZx@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666912996; x=1698448996;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=qctRSNSWHaYKZhhzWADPStHUQ6ZRSzyF7S51wP2f2Yw=;
  b=FxoZ08b6wdLmyocQYaFuKieP0dbrFofime6cfFZ8rOOWqb285fDo9NU3
   /IMQZJqotWMEkCu7ubaDHJ+8Z+KwxZ8JspjFU3aOJG5XyqlI7/PThbmjZ
   CbZkRWD+Jxt9IYS2yZHbbJuPpthaPAE2rYnSTlZvLLjx+hfhrZkrgSluy
   LKW53Giipd0HE9oirJCETDWmm7b+0Lo+8CdGbCj0dmekTcEmqFHrBya/S
   k0U+TNfDok5T+kOyNWielUFrcaBHu57CVyAq9VdvRmAT1avXDV2NJkTuU
   zJEuQ3g5VcsvWaN8DQATqA9FR9qZdMuNGk6ctAuRg0SdZj+djf5eHPbmp
   Q==;
In-Reply-To: <Y1p5vaN1AWhpNWZx-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org> (Michal Hocko's message of
        "Thu, 27 Oct 2022 14:29:49 +0200")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:

> On Thu 27-10-22 17:31:35, Huang, Ying wrote:
>> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
>> 
>> > On Thu 27-10-22 15:39:00, Huang, Ying wrote:
>> >> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
>> >> 
>> >> > On Thu 27-10-22 14:47:22, Huang, Ying wrote:
>> >> >> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:
>> >> > [...]
>> >> >> > I can imagine workloads which wouldn't like to get their memory demoted
>> >> >> > for some reason but wouldn't it be more practical to tell that
>> >> >> > explicitly (e.g. via prctl) rather than configuring cpusets/memory
>> >> >> > policies explicitly?
>> >> >> 
>> >> >> If my understanding were correct, prctl() configures the process or
>> >> >> thread.
>> >> >
>> >> > Not necessarily. There are properties which are per adddress space like
>> >> > PR_[GS]ET_THP_DISABLE. This could be very similar.
>> >> >
>> >> >> How can we get process/thread configuration at demotion time?
>> >> >
>> >> > As already pointed out in previous emails. You could hook into
>> >> > folio_check_references path, more specifically folio_referenced_one
>> >> > where you have all that you need already - all vmas mapping the page and
>> >> > then it is trivial to get the corresponding vm_mm. If at least one of
>> >> > them has the flag set then the demotion is not allowed (essentially the
>> >> > same model as VM_LOCKED).
>> >> 
>> >> Got it!  Thanks for detailed explanation.
>> >> 
>> >> One bit may be not sufficient.  For example, if we want to avoid or
>> >> control cross-socket demotion and still allow demoting to slow memory
>> >> nodes in local socket, we need to specify a node mask to exclude some
>> >> NUMA nodes from demotion targets.
>> >
>> > Isn't this something to be configured on the demotion topology side? Or
>> > do you expect there will be per process/address space usecases? I mean
>> > different processes running on the same topology, one requesting local
>> > demotion while other ok with the whole demotion topology?
>> 
>> I think that it's possible for different processes have different
>> requirements.
>> 
>> - Some processes don't care about where the memory is placed, prefer
>>   local, then fall back to remote if no free space.
>> 
>> - Some processes want to avoid cross-socket traffic, bind to nodes of
>>   local socket.
>> 
>> - Some processes want to avoid to use slow memory, bind to fast memory
>>   node only.
>
> Yes, I do understand that. Do you have any specific examples in mind?
> [...]

Sorry, I don't have specific examples.

>> > If we really need/want to give a fine grained control over demotion
>> > nodemask then we would have to go with vma->mempolicy interface. In
>> > any case a per process on/off knob sounds like a reasonable first step
>> > before we learn more about real usecases.
>> 
>> Yes.  Per-mm or per-vma property is much better than per-task property.
>> Another possibility, how about add a new flag to set_mempolicy() system
>> call to set the per-mm mempolicy?  `numactl` can use that by default.
>
> Do you mean a flag to control whether the given policy is applied to a
> task or mm?

Yes.  That is the idea.

Best Regards,
Huang, Ying
