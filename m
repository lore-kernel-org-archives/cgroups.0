From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: provide shmem statistics
Date: Wed, 22 Feb 2017 14:24:44 +0100
Message-ID: <20170222132444.GK5753@dhcp22.suse.cz>
References: <20170221164343.32252-1-hannes@cmpxchg.org>
 <20170222081230.GC5753@dhcp22.suse.cz>
 <20170222124501.GA9184@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170222124501.GA9184-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <cdown-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed 22-02-17 07:45:01, Johannes Weiner wrote:
> On Wed, Feb 22, 2017 at 09:12:31AM +0100, Michal Hocko wrote:
> > On Tue 21-02-17 11:43:43, Johannes Weiner wrote:
> > > Cgroups currently don't report how much shmem they use, which can be
> > > useful data to have, in particular since shmem is included in the
> > > cache/file item while being reclaimed like anonymous memory.
> > > 
> > > Add a counter to track shmem pages during charging and uncharging.
> > 
> > Yes this is indeed useful. Accounting shmem to the page cache was a
> > mistake because this is more than confusing. Sad we cannot fix that.
> 
> Agreed, this continues to cause confusion with many Linux users :(
> 
> > I would have just one concern with this patch. You are relying on
> > PageSwapBacked check but it looks like we are going to implement
> > MADV_FREE by dropping this flag. I know we do not support MADV_FREE
> > on shared mappings but if we ever do then the accounting will become
> > subtly broken. Can/Should we rely on shmem_mapping() check instead?
> 
> Yes, right now we do MADV_FREE only on private pages, so this patch is
> safe with Shaohua's changes to how we use PG_swapbacked.
> 
> Should we support MADV_FREE on shared mappings in the future, using
> shmem_mapping() for memcg accounting won't work unfortunately, because
> shared pages are truncated from the page cache before uncharging, and
> that clears the page->mapping pointer.

You are right!

> However, in that case we could
> probably unaccount the pages from shmem at the time of MADV_FREE, when
> we clear the PG_swapbacked bit.

Or we can just keep the code as is and add a comment to
madvise_free_single_vma to remind that memcg charging would have to be
handled properly if we want to drop vma_is_anonymous check there. It is
really hard to tell whether we ever get a support for MADV_FREE for
shared pages.

> > Other than that the patch looks good to me.
> 
> Thanks!

-- 
Michal Hocko
SUSE Labs
