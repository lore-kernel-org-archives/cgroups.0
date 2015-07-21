From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: Access rules for current->memcg
Date: Tue, 21 Jul 2015 05:24:11 -0400
Message-ID: <20150721092411.GA12570@cmpxchg.org>
References: <20150716145902.GA10758@dhcp22.suse.cz>
 <55A7C9B4.3010907@siteground.com>
 <20150716152239.GA22529@dhcp22.suse.cz>
 <CAJFSNy6sLX82+3ZW_COr__pDTd9aSGgL1bjryMKKcVPhEN0F9g@mail.gmail.com>
 <20150717071339.GA24787@dhcp22.suse.cz>
 <55A8ABC9.7090701@siteground.com>
 <20150720111707.GE1211@dhcp22.suse.cz>
 <55ACD9F8.2040802@siteground.com>
 <20150721074834.GF11967@dhcp22.suse.cz>
 <55AE0C18.5000304@siteground.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AE0C18.5000304-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 21, 2015 at 12:08:40PM +0300, Nikolay Borisov wrote:
> On 07/21/2015 10:48 AM, Michal Hocko wrote:
> > On Mon 20-07-15 14:22:32, Nikolay Borisov wrote:
> >> What about memsw.limit_in_bytes - memory.limit_in_bytes for the total swap
> > 
> > No this is not how the swap extension works. memsw counter covers
> > usage+swap. You can have up to memsw.limit_in_bytes swapped out. So
> 
> I think you are wrong with that assumption. According to the
> documentation here:
> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Resource_Management_Guide/sec-memory.html
> (the box titled "Setting the memory.memsw.limit_in_bytes and
> memory.limit_in_bytes parameters") it seems that the space that could be
> swapped is actually memsw.limit_in_bytes  - memory.limit_in_bytes.
> 
> The way I understand is you will only start swapping after the limit in
> memory.limit_in_bytes has been exhausted and you will be able to swap
> only until memsw.limit_in_bytes is exhausted (but since
> memory.usage_in_bytes is already calculated in, which would equal to
> memory.limit_in_bytes in a memory pressure situation) you effectively
> have memsw.limit_in_bytes - memory.limit_in_bytes, no?

No, the cgroup can also swap due to global/parental memory pressure,
not just due to memory.limit_in_bytes.  In that case, it can get its
pages swapped out until it reaches memsw.limit_in_bytes, with memory
consumption well below memory.limit or even 0.
