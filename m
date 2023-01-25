From: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Wed, 25 Jan 2023 15:22:00 -0300
Message-ID: <Y9FzSBw10MGXm2TK@tpad>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674670944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TAHgioL+cbo0qEgcEaZEdMYDgI4uLoD69uULXZCMWk=;
        b=GiIH3wCAjUSKVpIdNPg9Vm0hAhs5WpCkx/XQVx4mx+QuTHj2ZGz/e5zCPZNffNQu34Hyqp
        fNl/kSvYjqPLVWZwdwNpw56+nFOykdmmIWb9RpMhwjgcHVf8r/YaYz4RTKeq97LInytD2x
        iD2cWdRXCzHcvXyOKR7moZ9K0xREjzM=
Content-Disposition: inline
In-Reply-To: <9e61ab53e1419a144f774b95230b789244895424.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 25, 2023 at 08:06:46AM -0300, Leonardo Br=E1s wrote:
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

Remote draining reduces interruptions whether CPU=20
is marked as isolated or not:

- Allows isolated CPUs from benefiting of pcp caching.
- Removes the interruption to non isolated CPUs. See for example=20

https://lkml.org/lkml/2022/6/13/2769

"Minchan Kim tested this independently and reported;

       My workload is not NOHZ CPUs but run apps under heavy memory
       pressure so they goes to direct reclaim and be stuck on
       drain_all_pages until work on workqueue run.

       unit: nanosecond
       max(dur)        avg(dur)                count(dur)
       166713013       487511.77786438033      1283

       From traces, system encountered the drain_all_pages 1283 times and
       worst case was 166ms and avg was 487us.

       The other problem was alloc_contig_range in CMA. The PCP draining
       takes several hundred millisecond sometimes though there is no
       memory pressure or a few of pages to be migrated out but CPU were
       fully booked.

       Your patch perfectly removed those wasted time."


> After I raised the data in the cover letter, I found that the performance=
 impact
> appears not be that big. So in order to try keeping the pcp cache on isol=
ated
> cpus active, I decided to focus effort on the locking scheme change.
>=20
> I mean, my rationale is: if is there a non-expensive way of keeping the f=
eature,
> why should we abandon it?
>=20
> Best regards,
> Leo
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20

