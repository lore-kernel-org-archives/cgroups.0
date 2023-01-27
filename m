From: Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 27 Jan 2023 16:29:37 -0300
Message-ID: <029147be35b5173d5eb10c182e124ac9d2f1f0ba.camel@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
         <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
         <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
         <Y9FzSBw10MGXm2TK@tpad> <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
         <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
         <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
         <55ac6e3cbb97c7d13c49c3125c1455d8a2c785c3.camel@redhat.com>
         <Y9N7UMrLTyZT71uA@dhcp22.suse.cz>
         <15c605f27f87d732e80e294f13fd9513697b65e3.camel@redhat.com>
         <Y9OZezjUPITtEvTx@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674847784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUv5DFOx1orc2Szz1mjtgk5jcU9W4yiwziY2UuvBPys=;
        b=Y2PTWg68egXxUJjmq0soGogWzlHTh/J+kGegPkE9rwnLTQ37QJeSTN9W9lkt2nwMoCzMfj
        oRuTyixnmBjYwedNPYHGzazBbjjbHMBwH4LQpIxqihFEfIVvCkERZuM8cHCRwkLpLII/1Z
        Y4EPwMZWfyK8hRzFYz/pxUAs2o/h11w=
In-Reply-To: <Y9OZezjUPITtEvTx-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2023-01-27 at 10:29 +0100, Michal Hocko wrote:
> On Fri 27-01-23 04:35:22, Leonardo Br=C3=A1s wrote:
> > On Fri, 2023-01-27 at 08:20 +0100, Michal Hocko wrote:
> > > On Fri 27-01-23 04:14:19, Leonardo Br=C3=A1s wrote:
> > > > On Thu, 2023-01-26 at 15:12 -0800, Roman Gushchin wrote:
> > > [...]
> > > > > I'd rather opt out of stock draining for isolated cpus: it might =
slightly reduce
> > > > > the accuracy of memory limits and slightly increase the memory fo=
otprint (all
> > > > > those dying memcgs...), but the impact will be limited. Actually =
it is limited
> > > > > by the number of cpus.
> > > >=20
> > > > I was discussing this same idea with Marcelo yesterday morning.
> > > >=20
> > > > The questions had in the topic were:
> > > > a - About how many pages the pcp cache will hold before draining th=
em itself?=C2=A0
> > >=20
> > > MEMCG_CHARGE_BATCH (64 currently). And one more clarification. The ca=
che
> > > doesn't really hold any pages. It is a mere counter of how many charg=
es
> > > have been accounted for the memcg page counter. So it is not really
> > > consuming proportional amount of resources. It just pins the
> > > corresponding memcg. Have a look at consume_stock and refill_stock
> >=20
> > I see. Thanks for pointing that out!
> >=20
> > So in worst case scenario the memcg would have reserved 64 pages * (num=
cpus - 1)
>=20
> s@numcpus@num_isolated_cpus@

I was thinking worst case scenario being (ncpus - 1) being isolated.

>=20
> > that are not getting used, and may cause an 'earlier' OOM if this amoun=
t is
> > needed but can't be freed.
>=20
> s@OOM@memcg OOM@
=20
> > In the wave of worst case, supposing a big powerpc machine, 256 CPUs, e=
ach
> > holding 64k * 64 pages =3D> 1GB memory - 4MB (one cpu using resources).
> > It's starting to get too big, but still ok for a machine this size.
>=20
> It is more about the memcg limit rather than the size of the machine.
> Again, let's focus on actual usacase. What is the usual memcg setup with
> those isolcpus

I understand it's about the limit, not actually allocated memory. When I po=
int
the machine size, I mean what is expected to be acceptable from a user in t=
hat
machine.

>=20
> > The thing is that it can present an odd behavior:=20
> > You have a cgroup created before, now empty, and try to run given appli=
cation,
> > and hits OOM.
>=20
> The application would either consume those cached charges or flush them
> if it is running in a different memcg. Or what do you have in mind?

1 - Create a memcg with a VM inside, multiple vcpus pinned to isolated cpus=
.=20
2 - Run multi-cpu task inside the VM, it allocates memory for every CPU and=
 keep
    the pcp cache
3 - Try to run a single-cpu task (pinned?) inside the VM, which uses almost=
 all
    the available memory.
4 - memcg OOM.

Does it make sense?


>=20
> > You then restart the cgroup, run the same application without an issue.
> >=20
> > Even though it looks a good possibility, this can be perceived by user =
as
> > instability.
> >=20
> > >=20
> > > > b - Would it cache any kind of bigger page, or huge page in this sa=
me aspect?
> > >=20
> > > The above should answer this as well as those following up I hope. If
> > > not let me know.
> >=20
> > IIUC we are talking normal pages, is that it?
>=20
> We are talking about memcg charges and those have page granularity.
>=20

Thanks for the info!

Also, thanks for the feedback!
Leo

