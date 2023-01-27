From: Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras@redhat.com>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 27 Jan 2023 04:35:22 -0300
Message-ID: <15c605f27f87d732e80e294f13fd9513697b65e3.camel@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
         <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
         <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
         <Y9FzSBw10MGXm2TK@tpad> <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
         <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
         <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
         <55ac6e3cbb97c7d13c49c3125c1455d8a2c785c3.camel@redhat.com>
         <Y9N7UMrLTyZT71uA@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674804930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AOQxAgAAK0FHDcI+jB5U3fyhR/dhMwJss/kdGg+mJds=;
        b=NhX5PZ7681qynWPUrWTadTCqSE00zaRsie31izol5b2ehfv0E8nfJIuC8SFw5fKsORzvmw
        pruJmdM3RbyXcHBe8+o7pd1uvsETF+rXVN7pCWYfB2lOXKVh95YYqH1XeoGKUXIEcG1G2y
        flSUkU1bqbjurbbFtL/zGbIVMcew/h4=
In-Reply-To: <Y9N7UMrLTyZT71uA@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Marcelo Tosatti <mtosatti@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, 2023-01-27 at 08:20 +0100, Michal Hocko wrote:
> On Fri 27-01-23 04:14:19, Leonardo Br=C3=A1s wrote:
> > On Thu, 2023-01-26 at 15:12 -0800, Roman Gushchin wrote:
> [...]
> > > I'd rather opt out of stock draining for isolated cpus: it might slig=
htly reduce
> > > the accuracy of memory limits and slightly increase the memory footpr=
int (all
> > > those dying memcgs...), but the impact will be limited. Actually it i=
s limited
> > > by the number of cpus.
> >=20
> > I was discussing this same idea with Marcelo yesterday morning.
> >=20
> > The questions had in the topic were:
> > a - About how many pages the pcp cache will hold before draining them i=
tself?=C2=A0
>=20
> MEMCG_CHARGE_BATCH (64 currently). And one more clarification. The cache
> doesn't really hold any pages. It is a mere counter of how many charges
> have been accounted for the memcg page counter. So it is not really
> consuming proportional amount of resources. It just pins the
> corresponding memcg. Have a look at consume_stock and refill_stock

I see. Thanks for pointing that out!

So in worst case scenario the memcg would have reserved 64 pages * (numcpus=
 - 1)
that are not getting used, and may cause an 'earlier' OOM if this amount is
needed but can't be freed.

In the wave of worst case, supposing a big powerpc machine, 256 CPUs, each
holding 64k * 64 pages =3D> 1GB memory - 4MB (one cpu using resources).
It's starting to get too big, but still ok for a machine this size.

The thing is that it can present an odd behavior:=20
You have a cgroup created before, now empty, and try to run given applicati=
on,
and hits OOM.
You then restart the cgroup, run the same application without an issue.

Even though it looks a good possibility, this can be perceived by user as
instability.

>=20
> > b - Would it cache any kind of bigger page, or huge page in this same a=
spect?
>=20
> The above should answer this as well as those following up I hope. If
> not let me know.

IIUC we are talking normal pages, is that it?

Best regards,
Leo

