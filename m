From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Date: Mon, 3 Nov 2014 23:52:06 +0200
Message-ID: <20141103215206.GB24091@node.dhcp.inet.fi>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
 <20141103210607.GA24091@node.dhcp.inet.fi>
 <20141103213628.GA11428@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=shutemov.name;
	s=default; t=1415051526;
	bh=DZGMjFgRXEzqhtrNnptcfq4KgjNiNz+KPf4yFjnK7o4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P/IVB2Vv7S+WfOHgGnyZcJ8nWISNdKbl8A2n9EUhZrY+v3vtN3+Vf5OsgnZ9wyfAh
	 tIgvPJ5zU67DplmpawMi0+a2qqLcgo0GIiWUOxNMeVBBgvmr4omDwPiboACSJE58g9
	 OuuF4t1vlKLzHOrEDNVnxUryeqvU1yMfp8YsaJNs=
Content-Disposition: inline
In-Reply-To: <20141103213628.GA11428@phnom.home.cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>, David Miller <davem@davemloft.net>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:36:28PM -0500, Johannes Weiner wrote:
> On Mon, Nov 03, 2014 at 11:06:07PM +0200, Kirill A. Shutemov wrote:
> > On Sat, Nov 01, 2014 at 11:15:54PM -0400, Johannes Weiner wrote:
> > > Memory cgroups used to have 5 per-page pointers.  To allow users to
> > > disable that amount of overhead during runtime, those pointers were
> > > allocated in a separate array, with a translation layer between them
> > > and struct page.
> > > 
> > > There is now only one page pointer remaining: the memcg pointer, that
> > > indicates which cgroup the page is associated with when charged.  The
> > > complexity of runtime allocation and the runtime translation overhead
> > > is no longer justified to save that *potential* 0.19% of memory.
> > 
> > How much do you win by the change?
> 
> Heh, that would have followed right after where you cut the quote:
> with CONFIG_SLUB, that pointer actually sits in already existing
> struct page padding, which means that I'm saving one pointer per page
> (8 bytes per 4096 byte page, 0.19% of memory), plus the pointer and
> padding in each memory section.  I also save the (minor) translation
> overhead going from page to page_cgroup and the maintenance burden
> that stems from having these auxiliary arrays (see deleted code).

I read the description. I want to know if runtime win (any benchmark data?)
from moving mem_cgroup back to the struct page is measurable.

If the win is not significant, I would prefer to not occupy the padding:
I'm sure we will be able to find a better use for the space in struct page
in the future.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
