From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Fri, 11 Aug 2023 19:35:49 -0700
Message-ID: <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
References: <20230809045810.1659356-1-yosryahmed@google.com>
 <ZNNTgZVPZipTL/UM@dhcp22.suse.cz> <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA@mail.gmail.com>
 <ZNONgeoytpkchHga@dhcp22.suse.cz> <CAJD7tkb9C77UUxAykw_uMQvkzGyaZOZhM0nwWn_kcPjV0umyuA@mail.gmail.com>
 <ZNOVS0Smp2PHUIuq@dhcp22.suse.cz> <CAJD7tkZFxbjas=VfhYSGU84Y5vyjuqHqGsRjiDEOSDWh2BxNAg@mail.gmail.com>
 <ZNYnx9NqwSsXKhX3@dhcp22.suse.cz> <CAJD7tkbJ1fnMDudtsS2xubKn0RTWz7t0Hem=PSRQQp3sGf-iOw@mail.gmail.com>
 <ZNaLGVUtPu7Ua/jL@dhcp22.suse.cz> <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
 <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com> <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691807786; x=1692412586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xtg+keftJRj1GAGPnWqMjYAi2LDgfBuNTq5Si7vTecY=;
        b=EFOEq2BK/3AphDg71atGtLZ3JNf6pD/7iQNGpkLyIQvAGsS+4+4SDj5EXwfcZuKpN9
         A+kszuv1uvx3C1buqXecddsH+TNzr3nNv+/ciToEnvZYJMhXRN7Ig7OTiyTdiGQKjsz+
         PxH7SdFaIg8DGqgE0GVTY+L2ezzu7vbB4GCjgFqW5+jEJwgkGezz9nifLOg7fBEhg1tQ
         JVzQodQQ4p5Dk3pR5ARWlMWQ3Vp9/ZAJduQ+pZ++7N8u9oacbRZGmvI13+4QrcmPS3qk
         iEFNSRzrzGb3SDnZ6+WSWTeMLfKh8Nb4YBVqq28kkXxyqT1XDUOrMQd2rGJFcvD29Q1R
         yXIQ==
In-Reply-To: <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Aug 11, 2023 at 7:29=E2=80=AFPM Shakeel Butt <shakeelb@google.com> =
wrote:
>
> On Fri, Aug 11, 2023 at 7:12=E2=80=AFPM Yosry Ahmed <yosryahmed@google.co=
m> wrote:
> >
> [...]
> >
> > I am worried that writing to a stat for flushing then reading will
> > increase the staleness window which we are trying to reduce here.
> > Would it be acceptable to add a separate interface to explicitly read
> > flushed stats without having to write first? If the distinction
> > disappears in the future we can just short-circuit both interfaces.
>
> What is the acceptable staleness time window for your case? It is hard
> to imagine that a write+read will always be worse than just a read.
> Even the proposed patch can have an unintended and larger than
> expected staleness window due to some processing on
> return-to-userspace or some scheduling delay.

Maybe I am worrying too much, we can just go for writing to
memory.stat for explicit stats refresh.

Do we still want to go with the mutex approach Michal suggested for
do_flush_stats() to support either waiting for ongoing flushes
(mutex_lock) or skipping (mutex_trylock)?
