From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Wed, 2 Feb 2022 11:29:36 -0500
Message-ID: <cfde9038-8887-ea8b-b0f8-f950e85a54af@redhat.com>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-4-longman@redhat.com>
 <YfeuK5j7cbgM+Oo+@dhcp22.suse.cz> <YfgT/9tEREQNiiAN@cmpxchg.org>
 <YfgnUZQBRkqhrEIb@carbon.dhcp.thefacebook.com>
 <Yfgpknwr1tMnPkqh@dhcp22.suse.cz>
 <12686956-612d-d89b-5641-470d5e913090@redhat.com>
 <YfkQJ4QhfY0dICB9@dhcp22.suse.cz>
 <268a8bdf-4c70-b967-f34c-2293b54186f0@redhat.com>
 <YfpHbtffFi2x1L4p@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643819382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f0ow7OhvPHO62CtY/qyYiL8XWSa1Avspao6Gho1V2I8=;
        b=Jaa8LDqcfUs/kitD42arp04Mo5j9ccJ8wGFMTD3Ds2FGssn6fUVWV5voAMNB6ZZVj1+VvE
        g8rmZXRESVvMi/R+gq3IBFFlEDoJYMtmo+uzqhB4rEtIq4YeGA3VReDWENlw9gjrHSs6nn
        eOTOsd5i7t7oDd44zb5KWoSfjMQFMlk=
Content-Language: en-US
In-Reply-To: <YfpHbtffFi2x1L4p-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2/2/22 03:57, Michal Hocko wrote:
> On Tue 01-02-22 11:41:19, Waiman Long wrote:
>> On 2/1/22 05:49, Michal Hocko wrote:
> [...]
>>> Could you be more specific? Offlined memcgs are still part of the
>>> hierarchy IIRC. So it shouldn't be much more than iterating the whole
>>> cgroup tree and collect interesting data about dead cgroups.
>> What I mean is that without piggybacking on top of page_owner, we will to
>> add a lot more code to collect and display those information which may have
>> some overhead of its own.
> Yes, there is nothing like a free lunch. Page owner is certainly a tool
> that can be used. My main concern is that this tool doesn't really
> scale on large machines with a lots of memory. It will provide a very
> detailed information but I am not sure this is particularly helpful to
> most admins (why should people process tons of allocation backtraces in
> the first place). Wouldn't it be sufficient to have per dead memcg stats
> to see where the memory sits?
>
> Accumulated offline memcgs is something that bothers more people and I
> am really wondering whether we can do more for those people to evaluate
> the current state.

You won't get the stack backtrace information without page_owner 
enabled. I believe that is a helpful piece of information. I don't 
expect page_owner to be enabled by default on production system because 
of its memory overhead.

I believe you can actually see the number of memory cgroups present by 
looking at the /proc/cgroups file. Though, you don't know how many of 
them are offline memcgs. So if one suspect that there are a large number 
of offline memcgs, one can set up a test environment with page_owner 
enabled for further analysis.

Cheers,
Longman

