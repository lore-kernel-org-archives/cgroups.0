From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Wed, 16 Aug 2023 15:35:26 -0700
Message-ID: <CAJD7tkYSk-73c1=5vmuRdykAQO=pJSkQFgRqkpdfnh7f-Zufkw@mail.gmail.com>
References: <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org> <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg@mail.gmail.com>
 <ZNrLO5PAEZw4yjI9@slm.duckdns.org> <CAJD7tkYgCySTX28zK9GZiWwsabR4nv7M2hQ57y12si-fqtv7zg@mail.gmail.com>
 <CALvZod6KRxiDzrppCgx+=SHg2+96nFE5crwXCKwe9PZbWM_6cQ@mail.gmail.com>
 <CAJD7tkaUzhvZPohpo1F8TUKRPuXH7bjDeg9VCzN2CbywQbRutQ@mail.gmail.com>
 <CALvZod6HUtYhDaXiwXSrcwfxLSrZ37sZhKY1Mg4kmpDFk13aYw@mail.gmail.com>
 <CAJD7tkYzr2cg-aQ899vfqB4jR7iP83t8f-Z4AH8d9iW-yw-nnQ@mail.gmail.com>
 <CALvZod441xBoXzhqLWTZ+xnqDOFkHmvrzspr9NAr+nybqXgS-A@mail.gmail.com> <ZN0eqq4hLRYQPHCI@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692225363; x=1692830163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQmT7Uh6sWQfVX+jY524yxLYNHKGsl2fBek6097smRE=;
        b=HE9ACyuPPztqNyPxMJQxaWvmISJrT2O9wxlj6I3goqtgzDkkUS1kgXt+rhwzwpNVau
         vgAcjEFeg8oZ2Y7Qn54zx6x10dTczteNXnJCK8dJiC8IdA1AnK98T4udBeNNZDHmCxT8
         TesHS7tlAyWIfqrRXQ5Bq0wKxcgC92lmxlUCOADGVHL1AYWe9PWf+1vxj7oSPUonsg4N
         8bexPQjNfdrbICA/7tpvLEd7RzKCdazkK1XZJ5tw9Iull4sR7NqpzIELjVlqslZvIoz+
         FNMUm9u69u6T8dHHa6ghSukbVowSf6hc6Z+mTkLJdHWWEHWESEj5KRZkM2SrzOr7eUp8
         wLnw==
In-Reply-To: <ZN0eqq4hLRYQPHCI-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Wed, Aug 16, 2023 at 12:08=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Wed, Aug 16, 2023 at 10:11:20AM -0700, Shakeel Butt wrote:
> > These options are not white and black and there can be something in
> > between but let me be very clear on what I don't want and would NACK.
>
> I'm not a big fan of interfaces with hidden states. What you're proposing
> isn't strictly that but it's still a bit nasty. So, if we can get by with=
out
> doing that, that'd be great.

Agreed. I will try to send patches soon implementing option (2) above,
basically removing unified flushing. I will try to document any
potential regressions that may happen and how we may fix them. Ideally
we see no regressions.

>
> > I don't want a global sleepable lock which can be taken by potentially
> > any application running on the system. We have seen similar global
> > locks causing isolation and priority inversion issues in production.
> > So, not another lock which needs to be taken under extreme condition
> > (reading stats under OOM) by a high priority task (node controller)
> > and might be held by a low priority task.
>
> Yeah, this is a real concern. Those priority inversions do occur and can =
be
> serious but causing serious problems under memory pressure usually requir=
es
> involving memory allocations and IOs. Here, it's just all CPU. So, at lea=
st
> in OOM conditions, this shouldn't be in the way (the system wouldn't have
> anything else to do anyway).
>
> It is true that this still can lead to priority through CPU competition t=
ho.
> However, that problem isn't necessarily solved by what you're suggesting
> either unless you want to restrict explicit flushing based on permissions
> which is another can of worms.

Right. Also in the case of a mutex, if we disable preemption while
holding the mutex, this makes sure that whoever holding the mutex does
not starve waiters. Essentially the difference would be that waiters
will sleep with the mutex instead of spinning, but the mutex holder
itself wouldn't sleep.

I will make this a separate patch, just in case it's too
controversial. Switching the spinlock to a mutex should not block
removing unified flushing.

>
> My preference is not exposing this in user interface. This is mostly aris=
ing
> from internal implementation details and isn't what users necessarily car=
e
> about. There are many things we can do on the kernel side to make trade-o=
ffs
> among overhead, staleness and priority inversions. If we make this an
> explicit userland interface behavior, we get locked into that semantics
> which we'll likely regret in some future.
>

Yeah that's what I am trying to do here as well.  I will try to follow
up on this discussion with patches soon.

Thanks everyone!
