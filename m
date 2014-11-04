From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Date: Tue, 4 Nov 2014 09:40:45 +0900
Message-ID: <20141104004045.GC8412@js1304-P5Q-DELUXE>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
 <20141103080208.GA7052@js1304-P5Q-DELUXE>
 <20141103150942.GA32052@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141103150942.GA32052@phnom.home.cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>, David Miller <davem@davemloft.net>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:09:42AM -0500, Johannes Weiner wrote:
> Hi Joonsoo,
> 
> On Mon, Nov 03, 2014 at 05:02:08PM +0900, Joonsoo Kim wrote:
> > On Sat, Nov 01, 2014 at 11:15:54PM -0400, Johannes Weiner wrote:
> > > Memory cgroups used to have 5 per-page pointers.  To allow users to
> > > disable that amount of overhead during runtime, those pointers were
> > > allocated in a separate array, with a translation layer between them
> > > and struct page.
> > 
> > Hello, Johannes.
> > 
> > I'd like to leave this translation layer.
> > Could you just disable that code with #ifdef until next user comes?
> > 
> > In our company, we uses PAGE_OWNER on mm tree which is the feature
> > saying who allocates the page. To use PAGE_OWNER needs modifying
> > struct page and then needs re-compile. This re-compile makes us difficult
> > to use this feature. So, we decide to implement run-time configurable
> > PAGE_OWNER through page_cgroup's translation layer code. Moreover, with
> > this infrastructure, I plan to implement some other debugging feature.
> > 
> > Because of my laziness, it didn't submitted to LKML. But, I will
> > submit it as soon as possible. If the code is removed, I would
> > copy-and-paste the code, but, it would cause lose of the history on
> > that code. So if possible, I'd like to leave that code now.
> 
> Please re-introduce this code when your new usecase is ready to be
> upstreamed.  There is little reason to burden an unrelated feature
> with a sizable chunk of dead code for a vague future user.

Okay.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
