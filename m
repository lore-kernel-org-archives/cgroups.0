From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Mon, 28 Jan 2019 06:28:16 -0800
Message-ID: <20190128142816.GM50184@devbig004.ftw2.facebook.com>
References: <20190123223144.GA10798@chrisdown.name>
 <20190124082252.GD4087@dhcp22.suse.cz>
 <20190124160009.GA12436@cmpxchg.org>
 <20190124170117.GS4087@dhcp22.suse.cz>
 <20190124182328.GA10820@cmpxchg.org>
 <20190125074824.GD3560@dhcp22.suse.cz>
 <20190125165152.GK50184@devbig004.ftw2.facebook.com>
 <20190125173713.GD20411@dhcp22.suse.cz>
 <20190125182808.GL50184@devbig004.ftw2.facebook.com>
 <20190128125151.GI18811@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=16iA2KhpGFaktyfkAkUeDivlPZNfQCdHzHmJAlMfvm0=;
        b=OH9BmxAMpI2dn5E0OCOkDxyBFiuKIzG84TuAPLbsaHFD8Y4tP9t6UOgwYDLk0SqVJ+
         rzNq4skU4+AoEyiSlUqHzLlGst9c7xkw0Y0CmKGKRy/PDltLoNyyp6NP9H7DbLDIgLLl
         ooA2hHi2wDoPsq5RGy9/kHshGlGlPbFv7UC+4PgqPmcimos7sshWy5k7tzbolHoIbGWA
         OkirYa+jyvJNqEbA1TyZ0BdTZxyM0Tb4H0zH+RE6jiXiAOfiCAEfggYon3kBS4Rqm9gk
         uh7Ofnetke+CLAiD+Pi3juRT6eSFijXtCTiFKPwl2pFbgKwasbvGf2jX0YSyCZ7kXQ2Q
         YI5w==
Content-Disposition: inline
In-Reply-To: <20190128125151.GI18811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Hello, Michal.

On Mon, Jan 28, 2019 at 01:51:51PM +0100, Michal Hocko wrote:
> > For example, a workload manager watching over a subtree for a job with
> > nested memory limits set by the job itself.  It wants to take action
> > (reporting and possibly other remediative actions) when something goes
> > wrong in the delegated subtree but isn't involved in how the subtree
> > is configured inside.
> 
> Yes, I understand this part, but it is not clear to me, _how_ to report
> anything sensible without knowing _what_ has caused the event. You can
> walk the cgroup hierarchy and compare cached results with new ones but
> this is a) racy and b) clumsy.

All .events files generate aggregated stateful notifications.  For
anyone to do anything, they'd have to remember the previous state to
identify what actually happened.  Being hierarchical, it'd of course
need to walk down when an event triggers.

> > That sure is an option for use cases like above but it has the
> > downside of carrying over the confusing interface into the indefinite
> > future.
> 
> I actually believe that this is not such a big deal. For one thing the
> current events are actually helpful to watch the reclaim/setup behavior.

Sure, it isn't something critical.  It's just confusing and I think
it'd be better to improve.

> I do not really think you can go back. You cannot simply change semantic
> back and forth because you just break new users.
> 
> Really, I do not see the semantic changing after more than 3 years of
> production ready interface. If you really believe we need a hierarchical
> notification mechanism for the reclaim activity then add a new one.

I don't see it as black and white as you do.  Let's agree to disagree.
I'll ack the patch and note the disagreement.

Thanks.

-- 
tejun
