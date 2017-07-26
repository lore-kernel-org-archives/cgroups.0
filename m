From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] mm: memcontrol: Cast mismatched enum types passed to
 memcg state and event functions
Date: Wed, 26 Jul 2017 14:49:14 -0700
Message-ID: <20170726214914.GA84665@google.com>
References: <20170726192356.18420-1-mka@chromium.org>
 <20170726142309.ac40faf5eb99568e6edb064c@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7NhNkWGcWAqn28wYUp7MIYXYXThyaObAuJxnZxDZa54=;
        b=ilLv7rHrUESJ2GARFPi4382WoWKKHRBP1osZbKQvfmrs+RrMzbEDVLRgpHIOIL27qw
         4prZpH01VCvW8RAumpJckfZKqUvnjpVwArdwfToood4crL04TXLSHBvitWrtYI4Op4vp
         UR17pUv0oAO+X7A/n7bZUcL3lWIALkX0HmdB4=
Content-Disposition: inline
In-Reply-To: <20170726142309.ac40faf5eb99568e6edb064c@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Doug Anderson <dianders@chromium.org>

El Wed, Jul 26, 2017 at 02:23:09PM -0700 Andrew Morton ha dit:

> On Wed, 26 Jul 2017 12:23:56 -0700 Matthias Kaehlcke <mka@chromium.org> wrote:
> 
> > In multiple instances enum values of an incorrect type are passed to
> > mod_memcg_state() and other memcg functions. Apparently this is
> > intentional, however clang rightfully generates tons of warnings about
> > the mismatched types. Cast the offending values to the type expected
> > by the called function. The casts add noise, but this seems preferable
> > over losing the typesafe interface or/and disabling the warning.
> > 
> > ...
> >
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -576,7 +576,7 @@ static inline void __mod_lruvec_state(struct lruvec *lruvec,
> >  	if (mem_cgroup_disabled())
> >  		return;
> >  	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> > -	__mod_memcg_state(pn->memcg, idx, val);
> > +	__mod_memcg_state(pn->memcg, (enum memcg_stat_item)idx, val);
> >  	__this_cpu_add(pn->lruvec_stat->count[idx], val);
> >  }
> 
> __mod_memcg_state()'s `idx' arg can be either enum memcg_stat_item or
> enum memcg_stat_item.  I think it would be better to just admit to
> ourselves that __mod_memcg_state() is more general than it appears, and
> change it to take `int idx'.  I assume that this implicit cast of an
> enum to an int will not trigger a clang warning?

Sure, no warnings are raised for implicit casts from enum to
int.

__mod_memcg_state() is not the only function though, all these
functions are called with conflicting types:

memcg_page_state()
__mod_memcg_state()
mod_memcg_state()
count_memcg_events()
count_memcg_page_event()
memcg_sum_events()

Should we change all of them to reveice an int instead of an enum?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
