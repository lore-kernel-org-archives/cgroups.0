From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Access rules for current->memcg
Date: Mon, 20 Jul 2015 13:17:07 +0200
Message-ID: <20150720111707.GE1211@dhcp22.suse.cz>
References: <55A7B2D0.1030506@siteground.com>
 <20150716145902.GA10758@dhcp22.suse.cz>
 <55A7C9B4.3010907@siteground.com>
 <20150716152239.GA22529@dhcp22.suse.cz>
 <CAJFSNy6sLX82+3ZW_COr__pDTd9aSGgL1bjryMKKcVPhEN0F9g@mail.gmail.com>
 <20150717071339.GA24787@dhcp22.suse.cz>
 <55A8ABC9.7090701@siteground.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A8ABC9.7090701-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 17-07-15 10:16:25, Nikolay Borisov wrote:
> 
> 
> On 07/17/2015 10:13 AM, Michal Hocko wrote:
> > On Fri 17-07-15 00:21:51, Nikolay Borisov wrote:
[...]
> >> In my particular use case I have to query the memcg's various counters to expose
> >> them to the user in a different way than via the cgroup files
> >> (memory.limit_in_bytes etc).
> > 
> > Why is the regular interface not sufficient?
> 
> In my particular case I'm interested in playing with the contents of
> /proc/meminfo, so that processes running inside a cgroup only see the
> the system as defined by the memcg restrictions

I assume that this is an attempt to containerize /proc/meminfo. I am not
sure this is a great idea. There are counters which do not have memcg
specific counterpart or such a counterpart would be missleading (e.g.
slab, swap statistics).

Is this an out-of-tree project or you are trying to push your changes to
the Linus tree somewhere? I haven't noticed such patches.
-- 
Michal Hocko
SUSE Labs
