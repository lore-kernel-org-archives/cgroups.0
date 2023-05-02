From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in string_get_size's output
Date: Tue, 2 May 2023 18:19:27 +0300
Message-ID: <CAHp75VdvRshCthpFOjtmajVgCS_8YoJBGbLVukPwU+t79Jgmww@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan> <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
 <ZFCA2FF+9MI8LI5i@moria.home.lan> <CAHp75VdK2bgU8P+-np7ScVWTEpLrz+muG-R15SXm=ETXnjaiZg@mail.gmail.com>
 <ZFCsAZFMhPWIQIpk@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683040803; x=1685632803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2UFtU6oUaOr0vAs1hqgYmpK0GvH9Lqd4XIp3l76+ytw=;
        b=fQDTcAPBcFMm48S9mQhBubJHQt6Rf9v6Z4dCuVwj56NHh0dP3ICDHdXuGTZQ7fhY6f
         NVwsf2cgqzJ2oTH5E3+K89qprKrCbOGTByhEvyoyI4jzL38CLohj4Pemx6+zekp7fjIC
         C0wfN5ZD3wmwhLkep7s0ZqbRXr8rVSrCyB0q6Z4CQD4ucuL/biAEe5lz0MuYDAeeY6uB
         gtH3nfcpQt9FqSzoPBxOU/XU4QDMDDdYIjdcF09D6jE8LNvs6UBNJcq1K4MKCbG+pFI5
         zN03kdFjS2HNT9cI3ETBPM+TTHt6uAO2dPGj9O13t7gNwcK/SiD5lyjyY8em9DO5HFop
         7wkA==
In-Reply-To: <ZFCsAZFMhPWIQIpk@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowe

On Tue, May 2, 2023 at 9:22=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Tue, May 02, 2023 at 08:33:57AM +0300, Andy Shevchenko wrote:
> > Actually instead of producing zillions of variants, do a %p extension
> > to the printf() and that's it. We have, for example, %pt with T and
> > with space to follow users that want one or the other variant. Same
> > can be done with string_get_size().
>
> God no.

Any elaboration what's wrong with that?

God no for zillion APIs for almost the same. Today you want space,
tomorrow some other (special) delimiter.

--=20
With Best Regards,
Andy Shevchenko
