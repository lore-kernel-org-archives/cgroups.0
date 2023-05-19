From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Fri, 19 May 2023 12:47:47 -0300
Message-ID: <ZGeaI2jmItJj1twS@nvidia.com>
References: <ZFLdDyHoIdJSXJt+@google.com>
 <874josz4rd.fsf@nvidia.com>
 <ZFPP71czDDxMPLQK@google.com>
 <877ctm518f.fsf@nvidia.com>
 <ZFbZZPkSpsKMe8iR@google.com>
 <87ttwnkzap.fsf@nvidia.com>
 <ZFuvhP5qGPivokc0@google.com>
 <87jzxe9baj.fsf@nvidia.com>
 <ZF6rACJzilA06oe+@nvidia.com>
 <87y1lo8nwp.fsf@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6B3ZJNti/BIrnUQZgRjatFOd4YicJhlwK4Ri0TYZxeU=;
 b=bi4N+LhS5bzsDssw6Dr3JIhQkC9/b1ntzWuMOoTDBkuWGU+JEQpq6OLY88ujMwvQivJj9Ucst7GKAbRuaSgcntWCFipcm7jtOETE+OzMu3dAKHvV4F6slNTku7CWGwy1edoaR21227D5aX3T1mUtI7Ne/5w9nX6JyZGf8cwpfaZ5R0Qr7VRTF14CFNRBIE58l/UZ7n0B634QB6GlNxHpXlXNKdgl9u9eFDJ+9z0B4ISYCwq6KSHI400q1ZPotTgkLtfOYdSxC6SSHhUVtYfb/JPvot1vj1CZtM0Dx7zY1uoqgK4bY6IO/oERDLP9riT2CEgHf0hvFd+RMgk544JKmA==
Content-Disposition: inline
In-Reply-To: <87y1lo8nwp.fsf-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, May 16, 2023 at 10:21:10PM +1000, Alistair Popple wrote:
> 
> Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> writes:
> 
> > On Fri, May 12, 2023 at 06:45:13PM +1000, Alistair Popple wrote:
> >
> >> However review comments suggested it needed to be added as part of
> >> memcg. As soon as we do that we have to address how we deal with shared
> >> memory. If we stick with the original RLIMIT proposal this discussion
> >> goes away, but based on feedback I think I need to at least investigate
> >> integrating it into memcg to get anything merged.
> >
> > Personally I don't see how we can effectively solve the per-page
> > problem without also tracking all the owning memcgs for every
> > page. This means giving each struct page an array of memcgs
> >
> > I suspect this will be too expensive to be realistically
> > implementable.
> 
> Yep, agree with that. Tracking the list of memcgs was the main problem
> that prevented this.
> 
> > If it is done then we may not even need a pin controller on its own as
> > the main memcg should capture most of it. (althought it doesn't
> > distinguish between movable/swappable and non-swappable memory)
> >
> > But this is all being done for the libvirt people, so it would be good
> > to involve them
> 
> Do you know of anyone specifically there that is interested in this?
> I've rebased my series on latest upstream and am about to resend it so
> would be good to get some feedback from them.

"Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,

Are my usual gotos

Thanks,
Jason
