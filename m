From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Using cgroup membership for resource access control?
Date: Mon, 6 Feb 2023 11:42:12 -1000
Message-ID: <Y+F0NA9iI0zlONz7@slm.duckdns.org>
References: <Y+FvQbfTdcTe9GVu@agluck-desk3.sc.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RM0dHQibFaaOeas3cj3XA1NvkGxIpzMBa9fsiolqgCo=;
        b=RvOFv3Z31Yj5mmSTDwcykYqpK+nXUuKDHwTIRjp7IlTJ49/4jCZPgRtgPHfcF5QfcI
         rxlVQ8AP6+WBj28k4Mv1D4kChHfjw+mulKOnfkWe0+iCfeb/Pkv7m8/XJxV1VKT6yj6b
         ebi3BnWJhBWgQNCmRmJgpYKlaDFQqVo6KLyp0FVnBO9utT1McPcXlu5LI0mK5ca9zYQN
         xuxvMVycIxexW3iDVbESeTs4nQKBV+vyZGCJAdDPnJJs+owngKh3K+WL7coj3sWZ+UTN
         ngLxlh2RIgPVxtj05gKjqH6JU5hmhJV3Li1Djo/eL8ygqZUWOffb17T9TfYl1BHBWhlo
         e/sA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y+FvQbfTdcTe9GVu-E6Nu+q68HHQWLgLFz2vlpa2pdiUAq4bhAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ramesh Thomas <ramesh.thomas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello,

On Mon, Feb 06, 2023 at 01:21:05PM -0800, Tony Luck wrote:
...
> I'm thinking along these lines:
> 
> 1) Sysadmin creates a cgroup for a "job". Initializes the limits on
> how many of these virtual windows can be used (h/w has a fixed number).
> Assigns tasks in the job to this cgroup.
> 
> 2) Tasks in the job that want to offer virtual windows call into the
> driver to allocate and partially set up windows tagged with "available
> to any other process in my cgroup".
> 
> 3) Other tasks in the group ask the driver to complete the h/w
> initialization by adding them (their PASID) to the access list
> for each window.
> 
> My questions:
> 
> 1) Is this horrible - have I misunderstood cgroups?
> 	1a) If this is horrible, can it be rescued?

I'm not sure whether I fully understand what the virtual windows are but
assuming that it's a hardware resource that's limited in number and if
you're okay with tying it to cgroup hierarchy, I think it can just be one of
the resources that are managed by the misc controller.

The tying access domain to the cgroup part is likely the challenging part.
cgroup hierarchy is primarily composed according to the innate usage
hierarchy of the system and this might not match what you need. I can't
tell.

> 2) Will it work - is "membership in a cgroup" a valid security mechanism?

Again, I can't tell without knowing about the specifics but it gets used
that way in some cases - e.g. devcg in cgroup1 or the BPF counterpart in
ecgroup2 are used to enforce raw device access restrictions based on cgroup
membership.

> 3) Has someone done something similar before (so I can learn from their code)?

For limiting the number available to a part of a system, the misc controller
- kernel/cgroup/misc.c.

> 4) Is there an existing exported API to help. I see task_cgroup_path()
> which looks generally helpful (though I'd prefer a task_cgroup() that
> just takes a task and gives me the cgroup to which it belongs.)

task_dfl_cgroup(). However, please note that everything in cgroup is
supposed to be hierarchical, so that's something to keep on mind when
defining an external security mechanism based on cgroup membership.

The flip side is that on vast majority of configurations, cgroup hierarchy
more or less coincides with process tree which has the benefit of being
available regardless of cgroups, so in a lot of cases, it can be better to
just go the traditional way and tie these things to the process tree.

Thanks.

-- 
tejun
