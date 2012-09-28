From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v3 07/13] mm: Allocate kernel pages to the right memcg
Date: Fri, 28 Sep 2012 14:28:39 +0100
Message-ID: <20120928132839.GG29125@suse.de>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-8-git-send-email-glommer@parallels.com>
 <20120927135053.GF3429@suse.de>
 <50657153.8010101@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <50657153.8010101@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

On Fri, Sep 28, 2012 at 01:43:47PM +0400, Glauber Costa wrote:
> On 09/27/2012 05:50 PM, Mel Gorman wrote:
> >> +void __free_accounted_pages(struct page *page, unsigned int order)
> >> > +{
> >> > +	memcg_kmem_uncharge_page(page, order);
> >> > +	__free_pages(page, order);
> >> > +}
> >> > +
> >> > +void free_accounted_pages(unsigned long addr, unsigned int order)
> >> > +{
> >> > +	if (addr != 0) {
> >> > +		VM_BUG_ON(!virt_addr_valid((void *)addr));
> > This is probably overkill. If it's invalid, the next line is likely to
> > blow up anyway. It's no biggie.
> > 
> 
> So this is here because it is in free_pages() as well. If it blows, at
> least we know precisely why (if debugging), and VM_BUG_ON() is only
> compiled in when CONFIG_DEBUG_VM.
> 

Ah, I see.

> But I'm fine with either.
> Should it stay or should it go ?
> 

It can stay. It makes sense that it look similar to free_pages() and as
you say, it makes debugging marginally easier.


-- 
Mel Gorman
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
