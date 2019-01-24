From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Thu, 24 Jan 2019 07:21:22 -0800
Message-ID: <20190124152122.GG50184@devbig004.ftw2.facebook.com>
References: <20190123223144.GA10798@chrisdown.name>
 <20190124082252.GD4087@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oHh6o8jn5g3tJ8EvMOq/zvMTuQRF5UWPWeqXachkSho=;
        b=ilOnDM8ll9pxsLgqR2XzLXRMetdJw86ka4AcMniC8p52iV6zbSbAPjjzUt9S1pFVxM
         RG54FaX6Fu0FURglgfSe5vsP+2EBeMksbHpMOYUz732zHg25PXAt/PsWsn5Tp37LZwSP
         GygS4W7IdvL0uwu19h43JDoQmrPdVwzxItlVmxORX6uR/t0soxTfgsHUDmBQbBpvQUjx
         fMZK77CA13TcCnwvKQ3vu5urs9np9Z1aavhPYgLNzJ/u5pcU40iw4/AxKqOTCinIBc5v
         z2q9JOfcI0TqKCNE2/BQCkV0eS5bEULEWI7DV0JMYu8oUwbg9e2xI9pT6ZO5LjgabUvI
         aoKg==
Content-Disposition: inline
In-Reply-To: <20190124082252.GD4087@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Hello, Michal.

On Thu, Jan 24, 2019 at 09:22:52AM +0100, Michal Hocko wrote:
> I do not think we can do that for two reasons. It breaks the existing
> semantic userspace might depend on and more importantly this is not a
> correct behavior IMO.

This is a valid concern but I'll come back to this later.

> You have to realize that stats are hierarchical because that is how we
> account. Events represent a way to inform that something has happened at
> the specific level of the tree though. If you do not setup low/high/max

This isn't true.  e.g. cgroup.events's populated event is
hierarchical.  Everything in cgroup should be hierarchical by default.

> limit then you simply cannot expect to be informed those get hit because
> they cannot by definition. Or put it other way, if you are waiting for
> those events you really want to know the (sub)tree they happened and if
> you propagate the event up the hierarchy you have hard time to tell that
> (you would basically have to exclude all but the lowest one and that is
> an awkward semantic at best.

I don't think it's a good idea to argue this for each piece of
information.  Again, everything should be hierarchical unless there
are clear and strong reasons against; otherwise, we end up with random
mix of hierarchical and flat behaviors, something that we want to
avoid the most - remember .use_hierarchy?.

> Maybe we want to document this better but I do not see we are going to
> change the behavior.

I beg you to reconsider.  This was a clear oversight and the cgroup2
usage is still relatively limited.  We sure can add local-specific
counters if needed but must not mix local and hierarchical counters
without a clear way to tell what's what.

Thanks.

-- 
tejun
