From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered
 memory
Date: Thu, 15 Apr 2021 15:31:46 -0700
Message-ID: <4a864946-a316-3d9c-8780-64c6281276d1@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
 <CALvZod7StYJCPnWRNLnYQV8S5CBLtE0w4r2rH-wZzNs9jGJSRg@mail.gmail.com>
 <CAHbLzkrPD6s9vRy89cgQ36e+1cs6JbLqV84se7nnvP9MByizXA@mail.gmail.com>
 <CALvZod69-GcS2W57hAUvjbWBCD6B2dTeVsFbtpQuZOM2DphwCQ@mail.gmail.com>
 <YHABLBYU0UgzwOZi@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YHABLBYU0UgzwOZi-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



On 4/9/21 12:24 AM, Michal Hocko wrote:
> On Thu 08-04-21 13:29:08, Shakeel Butt wrote:
>> On Thu, Apr 8, 2021 at 11:01 AM Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> [...]
>>> The low priority jobs should be able to be restricted by cpuset, for
>>> example, just keep them on second tier memory nodes. Then all the
>>> above problems are gone.
> 
> Yes, if the aim is to isolate some users from certain numa node then
> cpuset is a good fit but as Shakeel says this is very likely not what
> this work is aiming for.
> 
>> Yes that's an extreme way to overcome the issue but we can do less
>> extreme by just (hard) limiting the top tier usage of low priority
>> jobs.
> 
> Per numa node high/hard limit would help with a more fine grained control.
> The configuration would be tricky though. All low priority memcgs would
> have to be carefully configured to leave enough for your important
> processes. That includes also memory which is not accounted to any
> memcg. 
> The behavior of those limits would be quite tricky for OOM situations
> as well due to a lack of NUMA aware oom killer.
> 

Another downside of putting limits on individual NUMA
node is it would limit flexibility.  For example two memory nodes are
similar enough in performance, that you really only care about a cgroup
not using more than a threshold of the combined capacity from the two
memory nodes.  But when you put a hard limit on NUMA node, then you are
tied down to a fix allocation partition for each node.  Perhaps there are
some kernel resources that are pre-allocated primarily from one node. A
cgroup may bump into the limit on the node and failed the allocation,
even when it has a lot of slack in the other node.  This makes getting
the configuration right trickier.

There are some differences in opinion currently
on whether grouping memory nodes into tiers, and putting limit on
using them by cgroup is a desirable.  Many people want the 
management constraint placed at individual NUMA node for each cgroup, instead
of at the tier level.  Will appreciate feedbacks from folks who have
insights on how such NUMA based control interface will work, so we
at least agree here in order to move forward.

Tim

