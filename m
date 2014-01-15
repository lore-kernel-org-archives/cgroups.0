From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Wed, 15 Jan 2014 15:34:49 +0100
Message-ID: <20140115143449.GN8782@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz>
 <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com>
 <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
 <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
 <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org>
 <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com>
 <20140110221432.GD6963@cmpxchg.org>
 <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Sun 12-01-14 14:10:49, David Rientjes wrote:
> On Fri, 10 Jan 2014, Johannes Weiner wrote:
> 
> > > > > It was acked-by Michal.
> > 
> > Michal acked it before we had most of the discussions and now he is
> > proposing an alternate version of yours, a patch that you are even
> > discussing with him concurrently in another thread.  To claim he is
> > still backing your patch because of that initial ack is disingenuous.
> > 
> 
> His patch depends on mine, Johannes.

Does it? Are we talking about the same patch here?
https://lkml.org/lkml/2013/12/12/174

Which depends on yours only to revert your part. I plan to repost it but
that still doesn't mean it will get merged because Johannes still has
some argumnets against. I would like to start the discussion again
because now we are so deep in circles that it is hard to come up with a
reasonable outcome. It is still hard to e.g. agree on an actual fix
for a real problem https://lkml.org/lkml/2013/12/12/129.

While notification might be an issue as well it is more of a corner case
than a regular one. So let's try to move on, agree on the "oom vs.
PF_EXITING) first and lay out discussion for the notification in a new
threa. Shall we?
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
