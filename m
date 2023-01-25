From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Wed, 25 Jan 2023 12:39:25 +0100
Message-ID: <Y9EU7awmpZaqbFtP@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674646766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oqqka9Owzafd2X56BISD/lkkMSHTDdTB9S6csfU4aLY=;
        b=KYsnXNxxrnUiZeznqoi+EbhT2L0rtf5QYqic6aQTX5P5VQ1STxtKjbDnMPgtlg7/Y1p61L
        KvRwG/pY12Ow/MVHYy249SOWJfTwl35GWdrSy9yvyhUV3hBWnCJBOumPvpNF2+dJ1WFAWP
        qn7IAe/rCU0k7ivrlr77GeNUyPbpS2M=
Content-Disposition: inline
In-Reply-To: <9e61ab53e1419a144f774b95230b789244895424.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 25-01-23 08:06:46, Leonardo Br=E1s wrote:
> On Wed, 2023-01-25 at 09:33 +0100, Michal Hocko wrote:
> > On Wed 25-01-23 04:34:57, Leonardo Bras wrote:
> > > Disclaimer:
> > > a - The cover letter got bigger than expected, so I had to split it in
> > >     sections to better organize myself. I am not very confortable wit=
h it.
> > > b - Performance numbers below did not include patch 5/5 (Remove flags
> > >     from memcg_stock_pcp), which could further improve performance for
> > >     drain_all_stock(), but I could only notice the optimization at the
> > >     last minute.
> > >=20
> > >=20
> > > 0 - Motivation:
> > > On current codebase, when drain_all_stock() is ran, it will schedule a
> > > drain_local_stock() for each cpu that has a percpu stock associated w=
ith a
> > > descendant of a given root_memcg.
> > >=20
> > > This happens even on 'isolated cpus', a feature commonly used on work=
loads that
> > > are sensitive to interruption and context switching such as vRAN and =
Industrial
> > > Control Systems.
> > >=20
> > > Since this scheduling behavior is a problem to those workloads, the p=
roposal is
> > > to replace the current local_lock + schedule_work_on() solution with =
a per-cpu
> > > spinlock.
> >=20
> > If IIRC we have also discussed that isolated CPUs can simply opt out
> > from the pcp caching and therefore the problem would be avoided
> > altogether without changes to the locking scheme. I do not see anything
> > regarding that in this submission. Could you elaborate why you have
> > abandoned this option?
>=20
> Hello Michal,
>=20
> I understand pcp caching is a nice to have.
> So while I kept the idea of disabling pcp caching in mind as an option, I=
 first
> tried to understand what kind of impacts we would be seeing when trying to
> change the locking scheme.
>=20
> After I raised the data in the cover letter, I found that the performance=
 impact
> appears not be that big. So in order to try keeping the pcp cache on isol=
ated
> cpus active, I decided to focus effort on the locking scheme change.
>=20
> I mean, my rationale is: if is there a non-expensive way of keeping the f=
eature,
> why should we abandon it?

Because any locking to pcp adds a potential contention. You haven't been
able to trigger that contention by your testing but that doesn't really
mean it is non-existent.

Besided that opt-out for isolated cpus should be a much smaller change
with a much more predictable behavior. The overall performance for
charging on isolated cpus will be slightly worse but it hasn't been seen
this is anything really noticeable. Most workloads which do care about
isolcpus tend to not enter kernel much AFAIK so this should have
relatively small impact.

All that being said I would prefer a simpler solution which seems to be
to simply opt out from pcp caching and if the performance for real
world workloads shows regressions then we can start thinking about a
more complex solution.
--=20
Michal Hocko
SUSE Labs
