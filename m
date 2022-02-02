From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 3/3] mm/page_owner: Dump memcg information
Date: Wed, 2 Feb 2022 17:38:07 +0100
Message-ID: <YfqzbwAPKpshXSLK@dhcp22.suse.cz>
References: <20220129205315.478628-4-longman@redhat.com>
 <YfeuK5j7cbgM+Oo+@dhcp22.suse.cz>
 <YfgT/9tEREQNiiAN@cmpxchg.org>
 <YfgnUZQBRkqhrEIb@carbon.dhcp.thefacebook.com>
 <Yfgpknwr1tMnPkqh@dhcp22.suse.cz>
 <12686956-612d-d89b-5641-470d5e913090@redhat.com>
 <YfkQJ4QhfY0dICB9@dhcp22.suse.cz>
 <268a8bdf-4c70-b967-f34c-2293b54186f0@redhat.com>
 <YfpHbtffFi2x1L4p@dhcp22.suse.cz>
 <YfqpSPLC+LAdqbJX@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643819888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ovtEFN3zyuhZ84VATTXxeaX4XxbwY8ky/fQzl6DC/1E=;
        b=VbieOmiRhqEU6RioiXSYtTXq1pkpEM59XXP4jKGogGC6DPO62BFtWfjW0oxah/XnG4ZUpr
        fVcilnkkpeLfnCDqL24v6MCv/f+OzRTkaH1XJ7IPGKFxSvII98y0Pztp7ZHSXVDOgIndiB
        B908vNICOfe2bWd7yPqAP6oCJuqr0bA=
Content-Disposition: inline
In-Reply-To: <YfqpSPLC+LAdqbJX@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Rafael Aquini <aquini@redhat.com>

On Wed 02-02-22 07:54:48, Roman Gushchin wrote:
> On Wed, Feb 02, 2022 at 09:57:18AM +0100, Michal Hocko wrote:
> > On Tue 01-02-22 11:41:19, Waiman Long wrote:
> > > 
> > > On 2/1/22 05:49, Michal Hocko wrote:
> > [...]
> > > > Could you be more specific? Offlined memcgs are still part of the
> > > > hierarchy IIRC. So it shouldn't be much more than iterating the whole
> > > > cgroup tree and collect interesting data about dead cgroups.
> > > 
> > > What I mean is that without piggybacking on top of page_owner, we will to
> > > add a lot more code to collect and display those information which may have
> > > some overhead of its own.
> > 
> > Yes, there is nothing like a free lunch. Page owner is certainly a tool
> > that can be used. My main concern is that this tool doesn't really
> > scale on large machines with a lots of memory. It will provide a very
> > detailed information but I am not sure this is particularly helpful to
> > most admins (why should people process tons of allocation backtraces in
> > the first place). Wouldn't it be sufficient to have per dead memcg stats
> > to see where the memory sits?
> > 
> > Accumulated offline memcgs is something that bothers more people and I
> > am really wondering whether we can do more for those people to evaluate
> > the current state.
> 
> Cgroup v2 has corresponding counters for years. Or do you mean something different?

Do we have anything more specific than nr_dying_descendants? I was
thinking about an interface which would provide paths and stats for dead
memcgs. But I have to confess I haven't really spent much time thinking
about how much work that would be. I am by no means against adding memcg
information to the page owner. I just think there must be a better way
to present resource consumption by dead memcgs.

-- 
Michal Hocko
SUSE Labs
