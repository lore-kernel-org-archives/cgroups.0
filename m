From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 11:07:43 -0700
Message-ID: <CAJuCfpFZsPibxrj163ypZQFOMmRTQe+=qJbZ8=o2kd1g0p=QQw@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
 <20230503122839.0d9934c5@gandalf.local.home> <CAJuCfpFYq7CZS4y2ZiF+AJHRKwnyhmZCk_uuTwFse26DxGh-qQ@mail.gmail.com>
 <20230503140337.0f7127b2@gandalf.local.home>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683137275; x=1685729275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYpn5fAZ9k+tc7itapEv1evmei0G939nEHfVs4IvTnU=;
        b=CiPRLrpSjqW+fOh4MZzhage7DRZ0A4p0DiZA5jkP6SoRdijKTb12IH8HPYoav3LVEG
         UxuWUsJ8XzpNsPDm/IXDURhwANLIszVcD7BHVZWpxKR8Cw0scnMG0+3659JdLK1Cnzbt
         gTx327NEx/KsnLGXWD2bm6c3nHMqUhK1ehp/AZAyLh+gV85XesNeu4FfbGmllcRcS3lj
         8b1rxia0KH86OKF4Rdr+PF90kA/tWE7FmwRSBvJAJbjNt9nt9Qc9maZ0a63/0iDWxZfb
         BP/YCRNb1VC6qYWZToRLJOzAfLm4sCL3eqAVGEOxe8HA1U7xEqqPmLc8gyCiBCpRmk5A
         q7WQ==
In-Reply-To: <20230503140337.0f7127b2@gandalf.local.home>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, an

On Wed, May 3, 2023 at 11:03=E2=80=AFAM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Wed, 3 May 2023 10:40:42 -0700
> Suren Baghdasaryan <surenb@google.com> wrote:
>
> > > This approach is actually quite common, especially since tagging ever=
y
> > > instance is usually overkill, as if you trace function calls in a run=
ning
> > > kernel, you will find that only a small percentage of the kernel ever
> > > executes. It's possible that you will be allocating a lot of tags tha=
t will
> > > never be used. If run time allocation is possible, that is usually th=
e
> > > better approach.
> >
> > True but the memory overhead should not be prohibitive here. As a
> > ballpark number, on my machine I see there are 4838 individual
> > allocation locations and each codetag structure is 32 bytes, so that's
> > 152KB.
>
> If it's not that big, then allocating at runtime should not be an issue
> either. If runtime allocation can make it less intrusive to the code, tha=
t
> would be more rationale to do so.

As I noted, this issue is minor since we can be smart about how we
allocate these entries. The main issue is the performance overhead.
The kmalloc path is extremely fast and very hot. Even adding a per-cpu
increment in our patchset has a 35% overhead. Adding an additional
lookup here would prevent us from having it enabled all the time in
production.

>
> -- Steve
