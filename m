From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Use int for event/state parameter in
 several functions
Date: Fri, 28 Jul 2017 15:52:36 -0400
Message-ID: <20170728195236.GA22303@cmpxchg.org>
References: <20170727211004.34435-1-mka@chromium.org>
 <20170728182354.GC84665@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=llqJWG4kNBiP/ShMLw/YGBT5gBdivExWExHeC6GtuXg=; b=gRJ826ptJBX5QV+lCCWnMQI46T
        +/6aUjtJiEA11xjNH1K4XoETpZwhCpQjNTJ9QoCAi/wkE2eqefygGnA2lVXY1T3YTThAbB+N+WClA
        V91ZDvuol3R90Vm0kUj4Ayr5PEpQHMS+9pjNbkoAOmabiUuYRLBbQLB4P6fV25b6hl0Q=;
Content-Disposition: inline
In-Reply-To: <20170728182354.GC84665-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Fri, Jul 28, 2017 at 11:23:54AM -0700, Matthias Kaehlcke wrote:
> El Thu, Jul 27, 2017 at 02:10:04PM -0700 Matthias Kaehlcke ha dit:
> 
> > Several functions use an enum type as parameter for an event/state,
> > but are called in some locations with an argument of a different enum
> > type. Adjust the interface of these functions to reality by changing the
> > parameter to int.
> > 
> > This fixes a ton of enum-conversion warnings that are generated when
> > building the kernel with clang.

Thanks for fixing this, Matthias.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

> While building for another target with a different configuration I
> noticed that inc/dec/mod_memcg_page_state() are also called with a
> conflicting enum type. Changing the parameter type for these functions
> also would make the API more consistent, with the current patch there
> is a somewhat odd mix of related functions, with some receiving an
> enum and others an int.
> 
> Depending on your preference I can send a v3 of this patch or a
> separate patch to address the remaining functions (since this patch
> has already been added to -mm).

Since it's the exact same rationale for the other functions, it would
make sense to me to do a v3 that includes the remaining sites.
