From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Access rules for current->memcg
Date: Tue, 21 Jul 2015 14:25:48 +0200
Message-ID: <20150721122548.GK11967@dhcp22.suse.cz>
References: <20150716152239.GA22529@dhcp22.suse.cz>
 <CAJFSNy6sLX82+3ZW_COr__pDTd9aSGgL1bjryMKKcVPhEN0F9g@mail.gmail.com>
 <20150717071339.GA24787@dhcp22.suse.cz>
 <55A8ABC9.7090701@siteground.com>
 <20150720111707.GE1211@dhcp22.suse.cz>
 <55ACD9F8.2040802@siteground.com>
 <20150721074834.GF11967@dhcp22.suse.cz>
 <55AE0C18.5000304@siteground.com>
 <20150721094832.GI11967@dhcp22.suse.cz>
 <55AE1FB7.8050107@siteground.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AE1FB7.8050107-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 21-07-15 13:32:23, Nikolay Borisov wrote:
> 
> 
> On 07/21/2015 12:48 PM, Michal Hocko wrote:
> > On Tue 21-07-15 12:08:40, Nikolay Borisov wrote:
[...]
> >> I looked more carefully into the code and saw that the page_counters
> >> (which back memory/memsw.limit/usage_in_bytes) are charged during the
> >> try_charge whereas the per-cpu statistics (which back the info in
> >> memory.stats) are updated after committing the charge. I assume in the
> >> case where charges are not canceled the data in memory.stats and
> >> memory.memsw.max_usage_in_bytes - memory.usage_in_bytes should be identical?
> > 
> > I am not sure what you mean here. max_usage_in_bytes is a historical
> > value which was the maximum charge used at some point in time.
> > usage_in_bytes is always the _current_ value of the charge counter.
> > max_usage_in_bytes-usage_in_bytes doesn't tell you much really.
> > 
> 
> I have misunderstood me I have never, ever referred to max_usage. What I
> meant was that the information that memory.stat file provides is
> acquired by reading the memcg->stat->count[counter] and those values are
> updated when mem_cgroup_commit_charge() is invoked.

True

> And
> mem_cgroup_commit_charge is invoked AFTER mem_cgroup_try_charge, which
> updates the charge counters.

Still true and you should realize that the commit is called very shortly
after the charge. The race window is not really interesting for anything
practical.

> So my point was that whether I read the
> swap value (for example) from the memory.stats file or whether I
> manually do the maths with subtraction  as previously shown the 2 values
> should match.

Your subtraction simply doesn't work and doesn't tell you how much
memory is swapped out from the memcg as explained in other email.

> Essentially whether information should be queried form the charge
> counter or from the mem_cgroup_stat_cpu struct. Does that make sense?

memory.stat will tell you the information you are looking for. You
simply cannot calculate those numbers from the counters.
-- 
Michal Hocko
SUSE Labs
