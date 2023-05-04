From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 35/40] lib: implement context capture support for tagged allocations
Date: Thu, 4 May 2023 09:22:07 -0700
Message-ID: <CAJuCfpGUtw6cbjLsksGJKATZfTV0FEYRXwXT0pZV83XqQydBgg@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-36-surenb@google.com>
 <ZFIPmnrSIdJ5yusM@dhcp22.suse.cz> <CAJuCfpGsvWupMbasqvwcMYsOOPxTQqi1ed5+=vyu-yoPQwwybg@mail.gmail.com>
 <ZFNoVfb+1W4NAh74@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683217340; x=1685809340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gsk62XwjD8JjQowiDifvFLPW2uokrx3QTotNr7V9c/A=;
        b=6NGLeWA30bcHwOn4ghW5tWONP3tIeVXLoIAwGSOlF40SYraEbii/SQhzrJIho8Ivb6
         Hpkk6vNh9E5t/cw05230dMqe0m+/H6ie+h8h31p+GrZCCgkTxJbXyMjFGjZkhz3bV6dG
         vSjHZI0HIdPfHSmqobGMchd9amOB1v/ceZjRFhmXUrjm4M4cWFnS99GIAMxh/gj5liXv
         4tj0lHTy81/1Wbpb012EhMfXD9LTcX1fI/Tm4TbQO8kVMc6YZQrPrde4R4+RJt2s2OWX
         VOgAgJHhDqiDK83jUMMdRLdqlv9RhFWhmjzvFXehDDJFCUBnHdRe0JsvmE5LyyU2xx97
         symQ==
In-Reply-To: <ZFNoVfb+1W4NAh74@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chr

On Thu, May 4, 2023 at 1:09=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Wed 03-05-23 08:24:19, Suren Baghdasaryan wrote:
> > On Wed, May 3, 2023 at 12:39=E2=80=AFAM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Mon 01-05-23 09:54:45, Suren Baghdasaryan wrote:
> > > [...]
> > > > +struct codetag_ctx *alloc_tag_create_ctx(struct alloc_tag *tag, si=
ze_t size)
> > > > +{
> > > > +     struct alloc_call_ctx *ac_ctx;
> > > > +
> > > > +     /* TODO: use a dedicated kmem_cache */
> > > > +     ac_ctx =3D kmalloc(sizeof(struct alloc_call_ctx), GFP_KERNEL)=
;
> > >
> > > You cannot really use GFP_KERNEL here. This is post_alloc_hook path a=
nd
> > > that has its own gfp context.
> >
> > I missed that. Would it be appropriate to use the gfp_flags parameter
> > of post_alloc_hook() here?
>
> No. the original allocation could have been GFP_USER based and you do
> not want these allocations to pullute other zones potentially. You want
> GFP_KERNEL compatible subset of that mask.

Ack.

>
> But even then I really detest an additional allocation from this context
> for every single allocation request. There GFP_NOWAIT allocation for
> steckdepot but that is at least cached and generally not allocating.
> This will allocate for every single allocation.

A small correction here. alloc_tag_create_ctx() is used only for
allocations which we requested to capture the context. So, this last
sentence is true for allocations we specifically marked to capture the
context, not in general.

> There must be a better way.

Yeah, agree, it would be good to avoid allocations in this path. Any
specific ideas on how to improve this? Pooling/caching perhaps? I
think kmem_cache does some of that already but maybe something else?
Thanks,
Suren.

> --
> Michal Hocko
> SUSE Labs
