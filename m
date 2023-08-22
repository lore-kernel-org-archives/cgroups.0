From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: non-unified flushing for userspace stats
Date: Tue, 22 Aug 2023 08:43:13 -0700
Message-ID: <CAJD7tkYrbs8Eqb-AbTmb5JeQb+KeLZrU4C2kJk8pjva-6p6bHQ@mail.gmail.com>
References: <20230821205458.1764662-1-yosryahmed@google.com> <a4opjlmm5it3ujoypcgjfljfamjvr7gu34sc7lrjldfbqzz4lj@6w4lqdcfd3zu>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692719030; x=1693323830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aHPwQRfzvw0kSRyeNQxBzdbaew4IqY6cIfInQbasrDQ=;
        b=sEQshxKo1c53nQhGLbHCCdc+S2tBe70IsqZWr7uYwwq9MoMEMzlTYnO6hFGblId8HR
         DzzXIr0Ng5kZ8/r2nmhyqI70Cd91DmIvGtUBCxTGKWkDWaAHPTwgsIY9Q8aM7BIQoe1N
         AFJXDgT/DK9PdVByD6peAL9817rZ2/DecmzYDeKW4k8VYQFxiZvcB1tNj6kVv7l55IG/
         R2ZX4wdjG0RXpwDlzSlIiiT17KUinChOvJXjhixzKBGtmb4QrfWMjNdC8QhiwnuOOQ5t
         vhTR2MV2OtnpVDusGoen77jQIoKs6WbqROpZbkfQGnaroO2feltIB5XZ+bsfnT0OjlyD
         MueQ==
In-Reply-To: <a4opjlmm5it3ujoypcgjfljfamjvr7gu34sc7lrjldfbqzz4lj@6w4lqdcfd3zu>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 22, 2023 at 6:01=E2=80=AFAM Michal Koutn=C3=BD <mkoutny-WDPRK7U/wSs@public.gmane.org=
m> wrote:
>
> Hello.
>
> On Mon, Aug 21, 2023 at 08:54:55PM +0000, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > For userspace reads, unified flushing leads to non-deterministic stats
> > staleness and reading cost.
>
> I only skimed previous threads but I don't remember if it was resolved:
> a) periodic flushing was too much spaced for user space readers (i.e. 2s
>    delay is too much [1]),
> b) periodic flushing didn't catch up (i.e. full tree flush can
>    occassionaly take more than 2s) leading to extra staleness?

The idea is that having stats anywhere between 0-2 seconds stale is
inconsistent, especially when compared to other values (such as
memory.usage_in_bytes), which can give an inconsistent and stale view
of the system. For some readers, 2s is too spaced (we have readers
that read every second). A time-only bound is scary because on large
systems a lot can happen in a second. There will always be a delay
anyway, but ideally we want to minimize it.

I think 2s is also not a strict bound (e.g. flushing is taking a lot
of time, a flush started but the cgroup you care about hasn't been
flushed yet, etc).

There is also the problem of variable cost of reading.

>
> [1] Assuming that nr_cpus*MEMCG_CHARGE_BATCH error bound is also too
>     much for userspace readers, correct?

I can't tell for sure to be honest, but given the continuously
increased number of cpus on modern systems, and the fact that
nr_cpus*MEMCG_CHARGE_BATCH can be localized in one cgroup or spread
across the hierarchy, I think it's better if we drop it for userspace
reads if possible.

>
> > The cost of userspace reads are now determinstic, and depend on the
> > size of the subtree being read. This should fix both the *sometimes*
> > expensive reads (due to flushing the entire tree) and occasional
> > staless (due to skipping flushing).
>
> This is nice, thanks to the atomic removal in the commit 0a2dc6ac3329
> ("cgroup: remove cgroup_rstat_flush_atomic()"). I think the smaller
> chunks with yielding could be universally better (last words :-).

I was hoping we can remove unified flushing completely, but stress
testing with hundreds of concurrent reclaimers shows a lot of
regression. Maybe it doesn't matter in practice, but I don't want to
pull that trigger :)

FWIW, with unified flushing we are getting great concurrency for
in-kernel flushers like reclaim or refault, but at the expense of
stats staleness. I really wonder what hidden cost we are paying due to
the stale stats. I would imagine any problems that manifest from this
would be difficult to tie back to the stale stats.

>
> Thanks,
> Michal
>
