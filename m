From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] memcg: remove PCG_ACCT_LRU.
Date: Tue, 6 Dec 2011 09:58:25 +0900
Message-ID: <20111206095825.69426eb2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111202190622.8e0488d6.kamezawa.hiroyu@jp.fujitsu.com>
	<20111202120849.GA1295@cmpxchg.org>
	<20111205095009.b82a9bdf.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1112051552210.3938@sister.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.LSU.2.00.1112051552210.3938@sister.anvils>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org

On Mon, 5 Dec 2011 16:13:06 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Mon, 5 Dec 2011, KAMEZAWA Hiroyuki wrote:
> > On Fri, 2 Dec 2011 13:08:49 +0100
> > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > On Fri, Dec 02, 2011 at 07:06:22PM +0900, KAMEZAWA Hiroyuki wrote:

> > Hmm. IMHO, we have 2 easy ways.
> > 
> >  - Ignore PCG_USED bit at LRU handling.
> >    2 problems.
> >    1. memory.stat may show very wrong statistics if swapin is too often.
> >    2. need careful use of mem_cgroup_charge_lrucare().
> > 
> >  - Clear pc->mem_cgroup at swapin-readahead.
> >    A problem.
> >    1. we need a new hook.
> > 
> > I'll try to clear pc->mem_cgroup at swapin. 
> > 
> > Thank you for pointing out.
> 
> Ying and I found PageCgroupAcctLRU very hard to grasp, even despite
> the comments Hannes added to explain it.  

Now, I don't think it's difficult. It seems no file system codes
add pages to LRU before add_to_page_cache() (I checked.)
So, what we need to care is only swap-cache. In swap-cache path,
we can do slow work.

> In moving the LRU locking
> from zone to memcg, we needed to depend upon pc->mem_cgroup: that
> was difficult while the interpretation of pc->mem_cgroup depended
> upon two flags also; and very tricky when pages were liable to shift
> underneath you from one LRU to another, as flags came and went.
> So we already eliminated PageCgroupAcctLRU here.
> 

Okay, Hm, do you see performance improvement by moving locks ?


> I'm fairly happy with what we have now, and have ported it forward
> to 3.2.0-rc3-next-20111202: with a few improvements on top of what
> we've got internally - Hannes's remark above about "amortizing the
> winnings" in the page freeing hotpath has prompted me to improve
> on what we had there, needs more testing but seems good so far.
> 
> However, I've hardly begun splitting the changes up into a series:
> had intended to do so last week, but day followed day...  If you'd
> like to see the unpolished uncommented rollup, I can post that.
> 

please.
Anyway, I'll post my own again as output even if I stop my work there.

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
