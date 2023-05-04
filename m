From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 16:25:30 -1000
Message-ID: <ZFMXmj9ZhSe5wyaS@slm.duckdns.org>
References: <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org>
 <ZFKqh5Dh93UULdse@slm.duckdns.org>
 <ZFKubD/lq7oB4svV@moria.home.lan>
 <ZFKu6zWA00AzArMF@slm.duckdns.org>
 <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
 <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
 <ZFK6pwOelIlhV8Bm@slm.duckdns.org>
 <ZFK9XMSzOBxIFOHm@slm.duckdns.org>
 <CAJuCfpE4YD_BumqFf2-NC8KS9D+kq0s_o4gRyWAH-WK4SgqUbA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683167134; x=1685759134;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X+UY7cUQaVo4x4W0WCSPsCuWeI5BUJEgh7i3Xst55/Y=;
        b=Rp/D+oug52h2Ti6mXmuImpIIDf60HeMLUvF0iIK2vttPwspm5hYlNosuEHVSrbtxTw
         U1aaOkS4o4kHX9lqnCC9bE9Qv4BkTepdXgX1eP7e7ih03h1Znb/fBHAFzIs3ZLAdzyf8
         Bdy+N5QGo07p0OmImH8mBW0eWTxAwcVTxazuYtPxC6BmtMp0/XcbyFMmmZorx8qew2E9
         Ccf9SafoTVOkRODhvQ6MQpCKPYkFE27/aFmb6+IC+s7J6n+xuSEgUyUsQVp7VEWj1Bkv
         v88EEfrZMkPXlnUNcgeQfwXyllZK7EU5nBpftptzpU3ovg2Ugby7Q+WZX0I3unGEo1Nj
         E0SQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJuCfpE4YD_BumqFf2-NC8KS9D+kq0s_o4gRyWAH-WK4SgqUbA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, vbabka@suse.cz, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

Hello,

On Wed, May 03, 2023 at 01:14:57PM -0700, Suren Baghdasaryan wrote:
> On Wed, May 3, 2023 at 1:00=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
> > Another related question. So, the reason for macro'ing stuff is needed =
is
> > because you want to print the line directly from kernel, right?
>=20
> The main reason is because we want to inject a code tag at the
> location of the call. If we have a code tag injected at every
> allocation call, then finding the allocation counter (code tag) to
> operate takes no time.
>
> > Is that
> > really necessary? Values from __builtin_return_address() can easily be
> > printed out as function+offset from kernel which already gives most of =
the
> > necessary information for triaging and mapping that back to source line=
 from
> > userspace isn't difficult. Wouldn't using __builtin_return_address() ma=
ke
> > the whole thing a lot simpler?
>=20
> If we do that we have to associate that address with the allocation
> counter at runtime on the first allocation and look it up on all
> following allocations. That introduces the overhead which we are
> trying to avoid by using macros.

I see. I'm a bit skeptical about the performance angle given that the hot
path can be probably made really cheap even with lookups. In most cases,
it's just gonna be an extra pointer deref and a few more arithmetics. That
can show up in microbenchmarks but it's not gonna be much. The benefit of
going that route would be the tracking thing being mostly self contained.

That said, it's nice to not have to worry about allocating tracking slots
and managing hash table, so no strong opinion.

Thanks.

--=20
tejun
