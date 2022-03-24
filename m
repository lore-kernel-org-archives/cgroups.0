From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce proportional protection on memcg
Date: Thu, 24 Mar 2022 09:23:44 -0700
Message-ID: <FE4CCCF9-CF08-424B-85D0-B5C1BA63329D@linux.dev>
References: <Yjx/3yi7BfH7wLPz@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648139027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jlU6JpVYC93QtZ6D2/Ze8QjTZ71IF09IQ/nMKJqg8hc=;
        b=Dz+/nGu1/jm2+vB4zQIBb+nXE2hZlNTrO17gf+Lf9ZPWIfmxoX4vihNvVMbGxXdtPDE4E7
        lYaSsRYI4FwNYMrnKL0Q9AnJhmAisTnqXmAn/ACjniKDXU20eF4DP71R5eHHuWmzE924jp
        4njvGX3E9hG2vnT2mEOR5vDAcrZBfhU=
In-Reply-To: <Yjx/3yi7BfH7wLPz-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It seems like what=E2=80=99s being proposed is an ability to express the pro=
tection in % of the current usage rather than an absolute number.
It=E2=80=99s an equivalent for something like a memory (reclaim) priority: e=
.g. a cgroup with 80% protection is _always_ reclaimed less aggressively tha=
n one with a 20% protection.

That said, I=E2=80=99m not a fan of this idea.
It might make sense in some reasonable range of usages, but if your workload=
 is simply leaking memory and growing indefinitely, protecting it seems like=
 a bad idea. And the first part can be easily achieved using an userspace to=
ol.

Thanks!

> On Mar 24, 2022, at 7:33 AM, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>=20
> =EF=BB=BFI'm confused by the aims of this patch. We already have proportio=
nal reclaim for memory.min and memory.low, and memory.high is already "propo=
rtional" by its nature to drive memory back down behind the configured thres=
hold.
>=20
> Could you please be more clear about what you're trying to achieve and in w=
hat way the existing proportional reclaim mechanisms are insufficient for yo=
u?
>=20
