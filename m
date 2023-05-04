From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 35/40] lib: implement context capture support for tagged
 allocations
Date: Thu, 4 May 2023 10:09:57 +0200
Message-ID: <ZFNoVfb+1W4NAh74@dhcp22.suse.cz>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-36-surenb@google.com>
 <ZFIPmnrSIdJ5yusM@dhcp22.suse.cz>
 <CAJuCfpGsvWupMbasqvwcMYsOOPxTQqi1ed5+=vyu-yoPQwwybg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683187798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0f9aUoTiM+sJjdWNgkunI1DxI6aESt6W4qyqw6LAGM=;
        b=pWdGUIdHnc7pXvP6bdU3/IRv7Ifbi1CA0lQX+z9/n34tBigeeWwOZDECe8lz33AC0mNuHl
        AQdkuJamTlc3SfQd1m0hniHdcNs/5uk7Udyj1zoIuvzn0qfUFiaTx3hK+ZExAUDSxsNTzp
        xfg6Wx9ZGfIrh+ttMaaBChPygRSla+0=
Content-Disposition: inline
In-Reply-To: <CAJuCfpGsvWupMbasqvwcMYsOOPxTQqi1ed5+=vyu-yoPQwwybg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chr

On Wed 03-05-23 08:24:19, Suren Baghdasaryan wrote:
> On Wed, May 3, 2023 at 12:39=E2=80=AFAM Michal Hocko <mhocko@suse.com> wr=
ote:
> >
> > On Mon 01-05-23 09:54:45, Suren Baghdasaryan wrote:
> > [...]
> > > +struct codetag_ctx *alloc_tag_create_ctx(struct alloc_tag *tag, size=
_t size)
> > > +{
> > > +     struct alloc_call_ctx *ac_ctx;
> > > +
> > > +     /* TODO: use a dedicated kmem_cache */
> > > +     ac_ctx =3D kmalloc(sizeof(struct alloc_call_ctx), GFP_KERNEL);
> >
> > You cannot really use GFP_KERNEL here. This is post_alloc_hook path and
> > that has its own gfp context.
>=20
> I missed that. Would it be appropriate to use the gfp_flags parameter
> of post_alloc_hook() here?

No. the original allocation could have been GFP_USER based and you do
not want these allocations to pullute other zones potentially. You want
GFP_KERNEL compatible subset of that mask.

But even then I really detest an additional allocation from this context
for every single allocation request. There GFP_NOWAIT allocation for
steckdepot but that is at least cached and generally not allocating.
This will allocate for every single allocation. There must be a better
way.
--=20
Michal Hocko
SUSE Labs
