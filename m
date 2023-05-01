From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Mon, 1 May 2023 11:08:05 -0700
Message-ID: <CAJuCfpHU3ZMsNuqi1gSxzAWKr2D3VkiaTY0BEUQgM-QHNxRtSg@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <ZE/7FZbd31qIzrOc@P9FQF9L96D>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682964501; x=1685556501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+2lYHhqlJD16G2HYpsFMb3ZFL7Kq76WjunB2OGwz3cs=;
        b=InnNvCbyWRIxKxFGHEw18GDFvAR07SJg7UsaQSzayd856NvZvHy/7D82OiVunxTwOQ
         iI4bPEnaVC8DKfBD9q2mpFU/D2+4QZOsePkMvk/nKecGEkR7ieMp18RUohlow/ONsuPb
         fRpdmKiy/hCz/JHzVWz2n5Mg5OcWXlB55bYJJxXjQz7D5uG5SID6uaCO/Kks5xdfPjJJ
         it9fnMSSuNm2JWdg5Tcm2D1rTGbvS4aDpWOvTKMsD+KeIoUScC3se5ywU/XKx17SosJd
         CH4HSE+fdc45RYf+DKFB/2hLNASZoyYfq4ehjOUiQfqHoIRcizKtgl3mADdezSKqh+u9
         RU9w==
In-Reply-To: <ZE/7FZbd31qIzrOc@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

On Mon, May 1, 2023 at 10:47=E2=80=AFAM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> On Mon, May 01, 2023 at 09:54:10AM -0700, Suren Baghdasaryan wrote:
> > Performance overhead:
> > To evaluate performance we implemented an in-kernel test executing
> > multiple get_free_page/free_page and kmalloc/kfree calls with allocatio=
n
> > sizes growing from 8 to 240 bytes with CPU frequency set to max and CPU
> > affinity set to a specific CPU to minimize the noise. Below is performa=
nce
> > comparison between the baseline kernel, profiling when enabled, profili=
ng
> > when disabled (nomem_profiling=3Dy) and (for comparison purposes) basel=
ine
> > with CONFIG_MEMCG_KMEM enabled and allocations using __GFP_ACCOUNT:
> >
> >                       kmalloc                 pgalloc
> > Baseline (6.3-rc7)    9.200s                  31.050s
> > profiling disabled    9.800 (+6.52%)          32.600 (+4.99%)
> > profiling enabled     12.500 (+35.87%)        39.010 (+25.60%)
> > memcg_kmem enabled    41.400 (+350.00%)       70.600 (+127.38%)
>
> Hm, this makes me think we have a regression with memcg_kmem in one of
> the recent releases. When I measured it a couple of years ago, the overhe=
ad
> was definitely within 100%.
>
> Do you understand what makes the your profiling drastically faster than k=
mem?

I haven't profiled or looked into kmem overhead closely but I can do
that. I just wanted to see how the overhead compares with the existing
accounting mechanisms.

For kmalloc, the overhead is low because after we create the vector of
slab_ext objects (which is the same as what memcg_kmem does), memory
profiling just increments a lazy counter (which in many cases would be
a per-cpu counter). memcg_kmem operates on cgroup hierarchy with
additional overhead associated with that. I'm guessing that's the
reason for the big difference between these mechanisms but, I didn't
look into the details to understand memcg_kmem performance.

>
> Thanks!
