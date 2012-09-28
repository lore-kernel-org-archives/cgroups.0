From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 07/13] mm: Allocate kernel pages to the right memcg
Date: Fri, 28 Sep 2012 13:43:47 +0400
Message-ID: <50657153.8010101@parallels.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-8-git-send-email-glommer@parallels.com> <20120927135053.GF3429@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120927135053.GF3429-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 09/27/2012 05:50 PM, Mel Gorman wrote:
>> +void __free_accounted_pages(struct page *page, unsigned int order)
>> > +{
>> > +	memcg_kmem_uncharge_page(page, order);
>> > +	__free_pages(page, order);
>> > +}
>> > +
>> > +void free_accounted_pages(unsigned long addr, unsigned int order)
>> > +{
>> > +	if (addr != 0) {
>> > +		VM_BUG_ON(!virt_addr_valid((void *)addr));
> This is probably overkill. If it's invalid, the next line is likely to
> blow up anyway. It's no biggie.
> 

So this is here because it is in free_pages() as well. If it blows, at
least we know precisely why (if debugging), and VM_BUG_ON() is only
compiled in when CONFIG_DEBUG_VM.

But I'm fine with either.
Should it stay or should it go ?

