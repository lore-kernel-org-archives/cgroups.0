From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: vmscan: fix IO/refault regression in cache
 workingset transition
Date: Thu, 6 Apr 2017 10:49:22 -0400
Message-ID: <20170406144922.GA32364@cmpxchg.org>
References: <20170404220052.27593-1-hannes@cmpxchg.org>
 <1491430264.16856.43.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XQ6MqRwuxQOpRMRS/hs3AHE8vrkMq9RK/PfowVIfgoU=; b=27P2dmqaqNK9xCh2QMmDKLrME7
        8JcB7hPm/j6MS1WxA5jqVz988hVrRAA3ym1rZ7c61g6uWZaxfrk1RDrjpdQESHloQgZRtW4XYbE8J
        A3Sn2d5NdtiDjxB82R9rwW+PPqj1jQ0E/7j8TW8SA0+jo7cgtLx/yqI6XM+1wKHACAoQ=;
Content-Disposition: inline
In-Reply-To: <1491430264.16856.43.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Apr 05, 2017 at 06:11:04PM -0400, Rik van Riel wrote:
> On Tue, 2017-04-04 at 18:00 -0400, Johannes Weiner wrote:
>=20
> > +
> > +	/*
> > +	=A0* When refaults are being observed, it means a new
> > workingset
> > +	=A0* is being established. Disable active list protection to
> > get
> > +	=A0* rid of the stale workingset quickly.
> > +	=A0*/
>=20
> This looks a little aggressive. What is this
> expected to do when you have multiple workloads
> sharing the same LRU, and one of the workloads
> is doing refaults, while the other workload is
> continuing to use the same working set as before?

It is aggressive, but it seems to be a trade-off between three things:
maximizing workingset protection during stable periods; minimizing
repeat refaults during workingset transitions; both of those when the
LRU is shared.

The data point we would need to balance optimally between these cases
is whether the active list is hot or stale, but we only have that once
we disable active list protection and challenge those pages.

The more conservative we go about this, the more IO cost to establish
the incoming workingset pages.

I actually did experiment with this. Instead of disabling active list
protection entirely, I reverted to the more conservative 50/50 ratio
during refaults. The 50/50 split addressed the regression, but the
aggressive behavior fared measurably better across three different
services I tested this on (one of them *is* multi-workingset, but the
jobs are cgrouped so they don't *really* share LRUs).

That win was intriguing, but it would be bad if it came out of the
budget of truly shared LRUs (for which I have no quantification).

Since this is a regression fix, it would be fair to be conservative
and use the 50/50 split for transitions here; keep the more adaptive
behavior for a future optimization.

What do you think?
