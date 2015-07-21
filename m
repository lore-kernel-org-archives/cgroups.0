From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Access rules for current->memcg
Date: Tue, 21 Jul 2015 09:48:34 +0200
Message-ID: <20150721074834.GF11967@dhcp22.suse.cz>
References: <55A7B2D0.1030506@siteground.com>
 <20150716145902.GA10758@dhcp22.suse.cz>
 <55A7C9B4.3010907@siteground.com>
 <20150716152239.GA22529@dhcp22.suse.cz>
 <CAJFSNy6sLX82+3ZW_COr__pDTd9aSGgL1bjryMKKcVPhEN0F9g@mail.gmail.com>
 <20150717071339.GA24787@dhcp22.suse.cz>
 <55A8ABC9.7090701@siteground.com>
 <20150720111707.GE1211@dhcp22.suse.cz>
 <55ACD9F8.2040802@siteground.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55ACD9F8.2040802-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 20-07-15 14:22:32, Nikolay Borisov wrote:
> 
> 
> On 07/20/2015 02:17 PM, Michal Hocko wrote:
> > On Fri 17-07-15 10:16:25, Nikolay Borisov wrote:
> >>
> >>
> >> On 07/17/2015 10:13 AM, Michal Hocko wrote:
> >>> On Fri 17-07-15 00:21:51, Nikolay Borisov wrote:
> > [...]
> >>>> In my particular use case I have to query the memcg's various counters to expose
> >>>> them to the user in a different way than via the cgroup files
> >>>> (memory.limit_in_bytes etc).
> >>>
> >>> Why is the regular interface not sufficient?
> >>
> >> In my particular case I'm interested in playing with the contents of
> >> /proc/meminfo, so that processes running inside a cgroup only see the
> >> the system as defined by the memcg restrictions
> > 
> > I assume that this is an attempt to containerize /proc/meminfo. I am not
> > sure this is a great idea. There are counters which do not have memcg
> > specific counterpart or such a counterpart would be missleading (e.g.
> > slab, swap statistics).
> 
> Why would swap be misleading?

Because the swap space is inherently a shared resource.

> What about memsw.limit_in_bytes - memory.limit_in_bytes for the total swap

No this is not how the swap extension works. memsw counter covers
usage+swap. You can have up to memsw.limit_in_bytes swapped out. So
you would have to do min(memsw.limit_in_bytes, TotalSwap) but even then
it wouldn't tell you much because that would be the case for other
memory cgroups as well. I would be quite hard to distribute the
TotalSwap for all the cgroups.

> and calculating the swap usage
> based on memory.memsw.max_usage_in_bytes - memory.usage_in_bytes ?

This doesn't make much sense to me. Swap usage per memcg is exported by
memory.stat file. But this is not what you want to export. meminfo
exports SwapFree which would tell you how much memory could be swapped
out before the anonymous memory is not reclaimable anymore. This is
impossible to find out in general - especially when the system is
allowed to be overcommit.
-- 
Michal Hocko
SUSE Labs
