From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 27 Jan 2023 15:50:31 -0800
Message-ID: <Y9RjRxe5Ao2/u+1Y@P9FQF9L96D.corp.robot.car>
References: <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
 <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
 <55ac6e3cbb97c7d13c49c3125c1455d8a2c785c3.camel@redhat.com>
 <Y9N7UMrLTyZT71uA@dhcp22.suse.cz>
 <15c605f27f87d732e80e294f13fd9513697b65e3.camel@redhat.com>
 <Y9OZezjUPITtEvTx@dhcp22.suse.cz>
 <029147be35b5173d5eb10c182e124ac9d2f1f0ba.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674863436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/s356kjQjTo/NKt8pwAEyADOkBLZ0BqETecZLsYgjM=;
        b=Oje197PRQ2GU1rKiuR/Hn8mnMhKtnmSzuaghr6jKx8M84GPls+gqP225AjheHQL1QVvC0C
        MUgefT43v07E2KVZUjbAEqfrnW86BJk9+nzjXNDGp5WNLYqVWXGVcFb8lsLUfUjo1tT1lG
        TIDxvvbRZ89OPikOzZ+OIsGWdiodBLo=
Content-Disposition: inline
In-Reply-To: <029147be35b5173d5eb10c182e124ac9d2f1f0ba.camel@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, Marcelo Tosatti <mtosatti@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Jan 27, 2023 at 04:29:37PM -0300, Leonardo Br=E1s wrote:
> On Fri, 2023-01-27 at 10:29 +0100, Michal Hocko wrote:
> > On Fri 27-01-23 04:35:22, Leonardo Br=E1s wrote:
> > > On Fri, 2023-01-27 at 08:20 +0100, Michal Hocko wrote:
> > > > On Fri 27-01-23 04:14:19, Leonardo Br=E1s wrote:
> > > > > On Thu, 2023-01-26 at 15:12 -0800, Roman Gushchin wrote:
> > > > [...]
> > > > > > I'd rather opt out of stock draining for isolated cpus: it migh=
t slightly reduce
> > > > > > the accuracy of memory limits and slightly increase the memory =
footprint (all
> > > > > > those dying memcgs...), but the impact will be limited. Actuall=
y it is limited
> > > > > > by the number of cpus.
> > > > >=20
> > > > > I was discussing this same idea with Marcelo yesterday morning.
> > > > >=20
> > > > > The questions had in the topic were:
> > > > > a - About how many pages the pcp cache will hold before draining =
them itself?=A0
> > > >=20
> > > > MEMCG_CHARGE_BATCH (64 currently). And one more clarification. The =
cache
> > > > doesn't really hold any pages. It is a mere counter of how many cha=
rges
> > > > have been accounted for the memcg page counter. So it is not really
> > > > consuming proportional amount of resources. It just pins the
> > > > corresponding memcg. Have a look at consume_stock and refill_stock
> > >=20
> > > I see. Thanks for pointing that out!
> > >=20
> > > So in worst case scenario the memcg would have reserved 64 pages * (n=
umcpus - 1)
> >=20
> > s@numcpus@num_isolated_cpus@
>=20
> I was thinking worst case scenario being (ncpus - 1) being isolated.
>=20
> >=20
> > > that are not getting used, and may cause an 'earlier' OOM if this amo=
unt is
> > > needed but can't be freed.
> >=20
> > s@OOM@memcg OOM@
> =20
> > > In the wave of worst case, supposing a big powerpc machine, 256 CPUs,=
 each
> > > holding 64k * 64 pages =3D> 1GB memory - 4MB (one cpu using resources=
).
> > > It's starting to get too big, but still ok for a machine this size.
> >=20
> > It is more about the memcg limit rather than the size of the machine.
> > Again, let's focus on actual usacase. What is the usual memcg setup with
> > those isolcpus
>=20
> I understand it's about the limit, not actually allocated memory. When I =
point
> the machine size, I mean what is expected to be acceptable from a user in=
 that
> machine.
>=20
> >=20
> > > The thing is that it can present an odd behavior:=20
> > > You have a cgroup created before, now empty, and try to run given app=
lication,
> > > and hits OOM.
> >=20
> > The application would either consume those cached charges or flush them
> > if it is running in a different memcg. Or what do you have in mind?
>=20
> 1 - Create a memcg with a VM inside, multiple vcpus pinned to isolated cp=
us.=20
> 2 - Run multi-cpu task inside the VM, it allocates memory for every CPU a=
nd keep
>     the pcp cache
> 3 - Try to run a single-cpu task (pinned?) inside the VM, which uses almo=
st all
>     the available memory.
> 4 - memcg OOM.
>=20
> Does it make sense?

It can happen now as well, you just need a competing drain request.

Honestly, I feel the probability of this scenario to be a real problem is f=
airly low.
I don't recall any complains on spurious OOMs because of races in the drain=
ing code.
Usually machines which are tight on memory are rarely have so many idle cpu=
s.

Thanks!
