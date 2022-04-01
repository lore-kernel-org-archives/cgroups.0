From: Wei Xu <weixugc@google.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 14:38:53 -0700
Message-ID: <CAAPL-u_UiJQetHJbMXb6CbgzjLOUUFGcLnLn0MDGTN=LWpcgqQ@mail.gmail.com>
References: <YkdrEG5FlL7Gq2Vi@cmpxchg.org> <243A0156-D26A-47C9-982A-C8B0CDD69DA2@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HQybvipiwCmhDTMI61RMqSUH6YQ4cHyMt2incAt7F0M=;
        b=d7qruhihQmBK9XRXFDTh/OTFwOPUebBbBRONhopS4Kl3YS6Bi5NMrVsCYDEno0qUE2
         PHL/op/2RZN53g+F8PqMf+RGpmtoRceNQ2hJQe23qD8n2Z4tyFOh09yDWN3y7im+ON6H
         FNml4umZ981FkpwzHWjVwer70e8OrdQSzD5wysr24DFRYLuYiltD712vAQUAUj9KU72T
         K1WC4mgeJ7ck53xxur7kZFSCvvaEcDUFNfFtSXMonZAqw0muNFIglXH5OFJJ+4Hpe5uI
         3QccBy7LUbIaoHsAaeYwwpcyr9H8zr5KqFxkFNYMXVUztyCEVKP9JS40ggeGGkCpyAwk
         uMPw==
In-Reply-To: <243A0156-D26A-47C9-982A-C8B0CDD69DA2@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Greg Thelen <gthelen@google.com>

On Fri, Apr 1, 2022 at 2:21 PM Roman Gushchin <roman.gushchin@linux.dev> wr=
ote:
>
> > On Apr 1, 2022, at 2:13 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > =EF=BB=BFOn Fri, Apr 01, 2022 at 11:39:30AM -0700, Roman Gushchin wrote=
:
> >> The interface you're proposing is not really extensible, so we'll like=
ly need to
> >> introduce a new interface like memory.reclaim_ext very soon. Why not c=
reate
> >> an extensible API from scratch?
> >>
> >> I'm looking at cgroup v2 documentation which describes various interfa=
ce files
> >> formats and it seems like given the number of potential optional argum=
ents
> >> the best option is nested keyed (please, refer to the Interface Files =
section).
> >>
> >> E.g. the format can be:
> >> echo "1G type=3Dfile nodemask=3D1-2 timeout=3D30s" > memory.reclaim
> >
> > Yeah, that syntax looks perfect.
> >

I agree this is a better syntax than positional arguments. The latter
would require a default value be specified for each earlier argument
if we just want to provide a custom value for a later argument.

> > But why do you think it's not extensible from the current patch? We
> > can add those arguments one by one as we agree on them, and return
> > -EINVAL if somebody passes an unknown parameter.
> >
> > It seems to me the current proposal is forward-compatible that way
> > (with the current set of keyword pararms being the empty set :-))
>
> It wasn=E2=80=99t obvious to me. We spoke about positional arguments and =
then it wasn=E2=80=99t clear how to add them in a backward-compatible way. =
The last thing we want is a bunch of memory.reclaim* interfaces :)
> So yeah, let=E2=80=99s just describe it properly in the documentation, no=
 code changes are needed.
