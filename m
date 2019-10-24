From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol: fix network errors from failing
 __GFP_ATOMIC charges
Date: Thu, 24 Oct 2019 10:14:45 +0200
Message-ID: <20191024081445.GR17610@dhcp22.suse.cz>
References: <20191022233708.365764-1-hannes@cmpxchg.org>
 <20191023064012.GB754@dhcp22.suse.cz>
 <20191023154618.GA366316@cmpxchg.org>
 <CALvZod6fDEqDrYmmVC42552Ej4Y47FVZUj_irSZNxKWRF4vPYw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALvZod6fDEqDrYmmVC42552Ej4Y47FVZUj_irSZNxKWRF4vPYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, netdev@vger.kernel.org, Kernel Team <kernel-team@fb.com>

On Wed 23-10-19 10:38:36, Shakeel Butt wrote:
> On Wed, Oct 23, 2019 at 8:46 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Wed, Oct 23, 2019 at 08:40:12AM +0200, Michal Hocko wrote:
[...]
> > > On the other hand this would allow to break the isolation by an
> > > unpredictable amount. Should we put a simple cap on how much we can go
> > > over the limit. If the memcg limit reclaim is not able to keep up with
> > > those overflows then even __GFP_ATOMIC allocations have to fail. What do
> > > you think?
> >
> > I don't expect a big overrun in practice, and it appears that Google
> > has been letting even NOWAIT allocations pass through without
> > isolation issues.
> 
> We have been overcharging for __GFP_HIGH allocations for couple of
> years and see no isolation issues in the production.
> 
> > Likewise, we have been force-charging the skmem for
> > a while now and it hasn't been an issue for reclaim to keep up.
> >
> > My experience from production is that it's a whole lot easier to debug
> > something like a memory.max overrun than it is to debug a machine that
> > won't respond to networking. So that's the side I would err on.

It is definitely good to hear that your production systems are working well.
I was not really worried about normal workloads but rather malicious
kind of (work)loads where memcg is used to contain a potentially untrusted
entities. That's where an unbounded atomic charges escapes would be a
much bigger deal. Maybe this is not the case now because we do not
have that many accounted __GFP_ATOMIC requests (I have tried to audit
but gave up very shortly afterwards because there are not that many
using __GFP_ACCOUNT directly so they are likely hidden behind
SLAB_ACCOUNT). But I do not really like that uncertainty.

If you have a really strong opinion on an explicit limit then I
would like to see at least some warning to the kernel log so that we
learn when some workloads hit a pathological paths that and act upon
that. Does that sound like something you would agree to?

E.g. something like

diff --git a/mm/page_counter.c b/mm/page_counter.c
index de31470655f6..e6999f6cf79e 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -62,6 +62,8 @@ void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
 	WARN_ON_ONCE(new < 0);
 }
 
+#define SAFE_OVERFLOW	1024
+
 /**
  * page_counter_charge - hierarchically charge pages
  * @counter: counter
@@ -82,8 +84,14 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 		 * This is indeed racy, but we can live with some
 		 * inaccuracy in the watermark.
 		 */
-		if (new > c->watermark)
+		if (new > c->watermark) {
 			c->watermark = new;
+			if (new > c->max + SAFE_OVERFLOW) {
+				pr_warn("Max limit %lu breached, usage:%lu. Please report.\n",
+						c->max, atomic_long_read(&c->usage);
+				dump_stack();
+			}
+		}
 	}
 }
 
-- 
Michal Hocko
SUSE Labs
