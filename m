From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
Date: Wed, 22 Jan 2020 09:14:06 +0100
Message-ID: <20200122081406.GO29276@dhcp22.suse.cz>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
 <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
 <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
 <20200120072237.GA18451@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001201307520.259466@chino.kir.corp.google.com>
 <20200120212726.GB29276@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001211500250.157547@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001211500250.157547@chino.kir.corp.google.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, ktkhai@virtuozzo.com, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, stable@vger.kernel.org

On Tue 21-01-20 15:08:39, David Rientjes wrote:
> On Mon, 20 Jan 2020, Michal Hocko wrote:
> 
> > > > > When migrating memcg charges of thp memory, there are two possibilities:
> > > > > 
> > > > >  (1) The underlying compound page is mapped by a pmd and thus does is not 
> > > > >      on a deferred split queue (it's mapped), or
> > > > > 
> > > > >  (2) The compound page is not mapped by a pmd and is awaiting split on a
> > > > >      deferred split queue.
> > > > > 
> > > > > The current charge migration implementation does *not* migrate charges for 
> > > > > thp memory on the deferred split queue, it only migrates charges for pages 
> > > > > that are mapped by a pmd.
> > > > > 
> > > > > Thus, to migrate charges, the underlying compound page cannot be on a 
> > > > > deferred split queue; no list manipulation needs to be done in 
> > > > > mem_cgroup_move_account().
> > > > > 
> > > > > With the current code, the underlying compound page is moved to the 
> > > > > deferred split queue of the memcg its memory is not charged to, so 
> > > > > susbequent reclaim will consider these pages for the wrong memcg.  Remove 
> > > > > the deferred split queue handling in mem_cgroup_move_account() entirely.
> > > > 
> > > > I believe this still doesn't describe the underlying problem to the full
> > > > extent. What happens with the page on the deferred list when it
> > > > shouldn't be there in fact? Unless I am missing something deferred_split_scan
> > > > will simply split that huge page. Which is a bit unfortunate but nothing
> > > > really critical. This should be mentioned in the changelog.
> > > > 
> > > 
> > > Are you referring to a compound page on the deferred split queue before a 
> > > task is moved?  I'm not sure this is within the scope of Wei's patch.. 
> > > this is simply preventing a page from being moved to the deferred split
> > > queue of a memcg that it is not charged to.  Is there a concern about why 
> > > this code can be removed or a suggestion on something else it should be 
> > > doing instead?
> > 
> > No, I do not have any concern about the patch itslef. It is that the
> > changelog doesn't decribe the user visible effect. All I am saying is
> > that the current code splits THPs of moved pages under memory pressure
> > even if that is not needed. And that is a clear bug.
> 
> Ah, gotcha.  I tried to do this in the final paragraph of my amedment to 
> Wei's patch and why it's important that this is marked as stable.

I considered "susbequent reclaim will consider these pages for the wrong
memcg." quite unclear TBH.
 
> The current code in 5.4 from commit 87eaceb3faa59 places any migrated 
> compound page onto the deferred split queue of the destination memcg 
> regardless of whether it has a mapping pmd 
> (list_empty(page_deferred_list()) was already false) or it does not have a 
> mapping pmd (but is now on the wrong queue).  For the latter, 
> can_split_huge_page() can help for the actual split but not for the 
> removal of the page that is now erroneously on the queue.

Does that mean that those fully mapped THPs are not going to be split?

> For the former, 
> memcg reclaim would not see the pages that it should split under memcg 
> pressure so we'll see the same memcg oom conditions we saw before the 
> deferred split shrinker became SHRINKER_MEMCG_AWARE: unnecessary ooms.

OK, this is yet another user visibile effect and it would be better to
mention it explicitly in the changelog. 

-- 
Michal Hocko
SUSE Labs
