From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 14:21:52 -0700
Message-ID: <243A0156-D26A-47C9-982A-C8B0CDD69DA2@linux.dev>
References: <YkdrEG5FlL7Gq2Vi@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648848115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RheG54Ou/GCQ9HYC/0tkyW4FKtlSnlhACvpquuW6JiY=;
        b=C9f2RCuoO8F6qaHAYQpqz7jL5PucFQfwU/3ammN/mL2rYcntPCt7BTtkpbezWZSwxFr7A6
        mf+PgUfJRw4OntsGYKHLRPjtjRq0oX8YZ4BQ/GmKn5N5YMAho3xAZY/Ols+1fVA3dou8ph
        O01NqbVchl5UCEMLOAf4yCTprThcg/Q=
In-Reply-To: <YkdrEG5FlL7Gq2Vi@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

> On Apr 1, 2022, at 2:13 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>=20
> =EF=BB=BFOn Fri, Apr 01, 2022 at 11:39:30AM -0700, Roman Gushchin wrote:
>> The interface you're proposing is not really extensible, so we'll likely n=
eed to
>> introduce a new interface like memory.reclaim_ext very soon. Why not crea=
te
>> an extensible API from scratch?
>>=20
>> I'm looking at cgroup v2 documentation which describes various interface f=
iles
>> formats and it seems like given the number of potential optional argument=
s
>> the best option is nested keyed (please, refer to the Interface Files sec=
tion).
>>=20
>> E.g. the format can be:
>> echo "1G type=3Dfile nodemask=3D1-2 timeout=3D30s" > memory.reclaim
>=20
> Yeah, that syntax looks perfect.
>=20
> But why do you think it's not extensible from the current patch? We
> can add those arguments one by one as we agree on them, and return
> -EINVAL if somebody passes an unknown parameter.
>=20
> It seems to me the current proposal is forward-compatible that way
> (with the current set of keyword pararms being the empty set :-))

It wasn=E2=80=99t obvious to me. We spoke about positional arguments and the=
n it wasn=E2=80=99t clear how to add them in a backward-compatible way. The l=
ast thing we want is a bunch of memory.reclaim* interfaces :)

So yeah, let=E2=80=99s just describe it properly in the documentation, no co=
de changes are needed.=
