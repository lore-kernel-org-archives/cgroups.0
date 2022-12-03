From: Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v3] mm: Add nodes= arg to memory.reclaim
Date: Sat, 3 Dec 2022 11:17:10 +0800
Message-ID: <EC963F6F-75C3-4168-97B3-544C36C2600A@linux.dev>
References: <20221202223533.1785418-1-almasrymina@google.com>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670037449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yB//b1EitRmLn+k+QyZlckrtyNyeyMWH9FzHsotPYVg=;
        b=ubL93lHJgSTgz+3zzH+QSRUgMV/lU7i9P2hA234RwUQaM5sly2K9vbBgeWb0vwoGJBxdx/
        glDZK10V70CZbf0v9q9CummWFes9OBw5TNB9xxhy8eM0hCnc5G10YopaPIL8WS7DzpnGzu
        9hsfB3qvJ5n8shNfCGlcwXzjKpvzL18=
In-Reply-To: <20221202223533.1785418-1-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Huang Ying <ying.huang@intel.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, fvdl@google.com, Michal Hocko <mhocko@suse.com>, bagasdotme@gmail.com, cgroups@vger.kernel.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>, linux-kernel@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>



> On Dec 3, 2022, at 06:35, Mina Almasry <almasrymina@google.com> wrote:
>=20
> The nodes=3D arg instructs the kernel to only scan the given nodes for
> proactive reclaim. For example use cases, consider a 2 tier memory =
system:
>=20
> nodes 0,1 -> top tier
> nodes 2,3 -> second tier
>=20
> $ echo "1m nodes=3D0" > memory.reclaim
>=20
> This instructs the kernel to attempt to reclaim 1m memory from node 0.
> Since node 0 is a top tier node, demotion will be attempted first. =
This
> is useful to direct proactive reclaim to specific nodes that are under
> pressure.
>=20
> $ echo "1m nodes=3D2,3" > memory.reclaim
>=20
> This instructs the kernel to attempt to reclaim 1m memory in the =
second tier,
> since this tier of memory has no demotion targets the memory will be
> reclaimed.
>=20
> $ echo "1m nodes=3D0,1" > memory.reclaim
>=20
> Instructs the kernel to reclaim memory from the top tier nodes, which =
can
> be desirable according to the userspace policy if there is pressure on
> the top tiers. Since these nodes have demotion targets, the kernel =
will
> attempt demotion first.
>=20
> Since commit 3f1509c57b1b ("Revert "mm/vmscan: never demote for memcg
> reclaim""), the proactive reclaim interface memory.reclaim does both
> reclaim and demotion. Reclaim and demotion incur different latency =
costs
> to the jobs in the cgroup. Demoted memory would still be addressable
> by the userspace at a higher latency, but reclaimed memory would need =
to
> incur a pagefault.
>=20
> The 'nodes' arg is useful to allow the userspace to control demotion
> and reclaim independently according to its policy: if the =
memory.reclaim
> is called on a node with demotion targets, it will attempt demotion =
first;
> if it is called on a node without demotion targets, it will only =
attempt
> reclaim.
>=20
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Acked-by: Muchun Song <songmuchun@bytedance.com>

Thanks.=
