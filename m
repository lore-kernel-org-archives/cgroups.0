From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Date: Tue, 4 Nov 2014 08:48:41 -0500
Message-ID: <20141104134841.GB18441@phnom.home.cmpxchg.org>
References: <20141103210607.GA24091@node.dhcp.inet.fi>
 <20141103213628.GA11428@phnom.home.cmpxchg.org>
 <20141103215206.GB24091@node.dhcp.inet.fi>
 <20141103.165807.2039166055692354811.davem@davemloft.net>
 <20141103223626.GA12006@phnom.home.cmpxchg.org>
 <20141104130652.GC22207@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141104130652.GC22207@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: David Miller <davem@davemloft.net>, kirill@shutemov.name, akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 02:06:52PM +0100, Michal Hocko wrote:
> The code size grows (~1.5k) most probably due to struct page pointer
> arithmetic (but I haven't checked that) but the data section shrinks
> for SLAB. So we have additional 1.6k for SLUB. I guess this is
> acceptable.
> 
>    text    data     bss     dec     hex filename
> 8427489  887684 3186688 12501861         bec365 mmotm/vmlinux.slab
> 8429060  883588 3186688 12499336         beb988 page_cgroup/vmlinux.slab
> 
> 8438894  883428 3186688 12509010         bedf52 mmotm/vmlinux.slub
> 8440529  883428 3186688 12510645         bee5b5 page_cgroup/vmlinux.slub

That's unexpected.  It's not much, but how could the object size grow
at all when that much code is removed and we replace the lookups with
simple struct member accesses?  Are you positive these are the right
object files, in the right order?

> So to me it sounds like the savings for 64b are worth minor inconvenience
> for 32b which is clearly on decline and I would definitely not encourage
> people to use PAE kernels with a lot of memory where the difference
> might matter. For the most x86 32b deployments (laptops with 4G) the
> difference shouldn't be noticeable. I am not familiar with other archs
> so the situation might be different there.

On 32 bit, the overhead is 0.098% of memory, so 4MB on a 4G machine.
This should be acceptable, even for the three people that run on the
cutting edge of 3.18-based PAE distribution kernels. :-)

> This should probably go into the changelog, I guess.

Which part?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
