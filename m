From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - "none"
Date: Tue, 27 Jan 2015 17:27:05 +0100
Message-ID: <20150127162705.GE19880@dhcp22.suse.cz>
References: <1421508107-29377-1-git-send-email-hannes@cmpxchg.org>
 <20150120133711.GI25342@dhcp22.suse.cz>
 <20150120143002.GB11181@phnom.home.cmpxchg.org>
 <20150120143644.GL25342@dhcp22.suse.cz>
 <CAOS58YNZFuSP6cKLAkYKkK+QUDxwngnKE5UGHmAL7n3PygraaQ@mail.gmail.com>
 <20150123170353.GA12036@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150123170353.GA12036@phnom.home.cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, Greg Thelen <gthelen@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>

On Fri 23-01-15 12:03:53, Johannes Weiner wrote:
> On Tue, Jan 20, 2015 at 12:00:11PM -0500, Tejun Heo wrote:
> > Hello,
> > 
> > On Tue, Jan 20, 2015 at 9:36 AM, Michal Hocko <mhocko@suse.cz> wrote:
> > > On Tue 20-01-15 09:30:02, Johannes Weiner wrote:
> > > [...]
> > >> Another possibility would be "infinity",
> > >
> > > yes infinity definitely sounds much better to me.
> > 
> > FWIW, I prefer "max". It's shorter and clear enough. I don't think
> > there's anything ambiguous about "the memory max limit is at its
> > maximum". No need to introduce a different term.
> 
> While I don't feel too strongly, I do agree with this.  I don't see
> much potential for confusion, and "max" is much shorter and sweeter.
> 
> Michal?

I dunno. Infinity is unambiguous and still not_too_long_to_write which
is why I like it more. Max might evoke impression that this is a
symbolic name for memory.max value. Which would work for both
memory.high and memory.low because the meaning would be the same. But
who knows what the future has to tell about that...

I definitely do not want to bikeshed about this because both names are
acceptable.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
