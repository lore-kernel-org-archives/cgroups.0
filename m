From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered
 memory
Date: Fri, 9 Apr 2021 09:24:28 +0200
Message-ID: <YHABLBYU0UgzwOZi@dhcp22.suse.cz>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
 <CALvZod7StYJCPnWRNLnYQV8S5CBLtE0w4r2rH-wZzNs9jGJSRg@mail.gmail.com>
 <CAHbLzkrPD6s9vRy89cgQ36e+1cs6JbLqV84se7nnvP9MByizXA@mail.gmail.com>
 <CALvZod69-GcS2W57hAUvjbWBCD6B2dTeVsFbtpQuZOM2DphwCQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617953070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3CuiOk6cqvEWVs8EpFm1ZB/VV5Oybfre6iEM0gujwYY=;
        b=H4OWQuY93sOd2wKm3WVHcYphE9zQySsHIQ3lLQnHVXjXiTp5Z2tGAgTERRG5jUPKPJz+WD
        aeAYiSW0cSqzDTTLy2KbJpJgWv7DhS+age8yXFSPvW0YTZsIDaZ7PgOaFd1yMcKNYaXUvZ
        kMvpiEldYW/V/6JgPafaL4NeJ4VBUV0=
Content-Disposition: inline
In-Reply-To: <CALvZod69-GcS2W57hAUvjbWBCD6B2dTeVsFbtpQuZOM2DphwCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu 08-04-21 13:29:08, Shakeel Butt wrote:
> On Thu, Apr 8, 2021 at 11:01 AM Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
[...]
> > The low priority jobs should be able to be restricted by cpuset, for
> > example, just keep them on second tier memory nodes. Then all the
> > above problems are gone.

Yes, if the aim is to isolate some users from certain numa node then
cpuset is a good fit but as Shakeel says this is very likely not what
this work is aiming for.

> Yes that's an extreme way to overcome the issue but we can do less
> extreme by just (hard) limiting the top tier usage of low priority
> jobs.

Per numa node high/hard limit would help with a more fine grained control.
The configuration would be tricky though. All low priority memcgs would
have to be carefully configured to leave enough for your important
processes. That includes also memory which is not accounted to any
memcg. 
The behavior of those limits would be quite tricky for OOM situations
as well due to a lack of NUMA aware oom killer.
-- 
Michal Hocko
SUSE Labs
