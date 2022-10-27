From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/vmscan: respect cpuset policy during page demotion
Date: Thu, 27 Oct 2022 14:47:22 +0800
Message-ID: <87wn8lkbk5.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20221026074343.6517-1-feng.tang@intel.com>
        <dc453287-015d-fd1c-fe7f-6ee45772d6aa@linux.ibm.com>
        <Y1jpDfwBQId3GkJC@feng-clx> <Y1j7tsj5M0Md/+Er@dhcp22.suse.cz>
        <Y1kl8VbPE0RYdyEB@feng-clx> <Y1lZV6qHp3gIINGc@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666853289; x=1698389289;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=bNTVcZUk3EGA9xSMZhWo1dSEwPloZHZhSf6kjCFBv2U=;
  b=c3yTwbuvKl22m9bW7iJtZFwb45N45ynGrPEBCqBpuh3qN9KQdPrsHrlu
   1v2NL59UVftOYu7aCRex4SS3DPdw1M+D50ikHo2/Bpmf61eVaOFxNhdWG
   fx1wktEP6B/X+Lt/h4V0+BF8wdz3Sf395MCgVJZYWARFh5s5Fibvv36Qq
   O3wJicFQxu/RCpvzeLWqMdVDvHOyeS2hcNoqg0UtwGDoOWKPnjwK7OGg1
   YgVciiD/O1H1llNugNQvaxwjWfGy+00FCQzA7o25g/ljHiobHVH3xhu/V
   BSzu+XbHHnWXesunjlF5YpKM0868xwnwQBd0Fv8dju+T0Y1nGMlvui521
   w==;
In-Reply-To: <Y1lZV6qHp3gIINGc-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org> (Michal Hocko's message of
        "Wed, 26 Oct 2022 17:59:19 +0200")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aneesh Kumar K V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> writes:

> On Wed 26-10-22 20:20:01, Feng Tang wrote:
>> On Wed, Oct 26, 2022 at 05:19:50PM +0800, Michal Hocko wrote:
>> > On Wed 26-10-22 16:00:13, Feng Tang wrote:
>> > > On Wed, Oct 26, 2022 at 03:49:48PM +0800, Aneesh Kumar K V wrote:
>> > > > On 10/26/22 1:13 PM, Feng Tang wrote:
>> > > > > In page reclaim path, memory could be demoted from faster memory tier
>> > > > > to slower memory tier. Currently, there is no check about cpuset's
>> > > > > memory policy, that even if the target demotion node is not allowd
>> > > > > by cpuset, the demotion will still happen, which breaks the cpuset
>> > > > > semantics.
>> > > > > 
>> > > > > So add cpuset policy check in the demotion path and skip demotion
>> > > > > if the demotion targets are not allowed by cpuset.
>> > > > > 
>> > > > 
>> > > > What about the vma policy or the task memory policy? Shouldn't we respect
>> > > > those memory policy restrictions while demoting the page? 
>> > >  
>> > > Good question! We have some basic patches to consider memory policy
>> > > in demotion path too, which are still under test, and will be posted
>> > > soon. And the basic idea is similar to this patch.
>> > 
>> > For that you need to consult each vma and it's owning task(s) and that
>> > to me sounds like something to be done in folio_check_references.
>> > Relying on memcg to get a cpuset cgroup is really ugly and not really
>> > 100% correct. Memory controller might be disabled and then you do not
>> > have your association anymore.
>>  
>> You are right, for cpuset case, the solution depends on 'CONFIG_MEMCG=y',
>> and the bright side is most of distribution have it on.
>
> CONFIG_MEMCG=y is not sufficient. You would need to enable memcg
> controller during the runtime as well.
>  
>> > This all can get quite expensive so the primary question is, does the
>> > existing behavior generates any real issues or is this more of an
>> > correctness exercise? I mean it certainly is not great to demote to an
>> > incompatible numa node but are there any reasonable configurations when
>> > the demotion target node is explicitly excluded from memory
>> > policy/cpuset?
>> 
>> We haven't got customer report on this, but there are quite some customers
>> use cpuset to bind some specific memory nodes to a docker (You've helped
>> us solve a OOM issue in such cases), so I think it's practical to respect
>> the cpuset semantics as much as we can.
>
> Yes, it is definitely better to respect cpusets and all local memory
> policies. There is no dispute there. The thing is whether this is really
> worth it. How often would cpusets (or policies in general) go actively
> against demotion nodes (i.e. exclude those nodes from their allowes node
> mask)?
>
> I can imagine workloads which wouldn't like to get their memory demoted
> for some reason but wouldn't it be more practical to tell that
> explicitly (e.g. via prctl) rather than configuring cpusets/memory
> policies explicitly?

If my understanding were correct, prctl() configures the process or
thread.  How can we get process/thread configuration at demotion time?

Best Regards,
Huang, Ying
