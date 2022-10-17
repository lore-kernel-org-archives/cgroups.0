From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] memcg rstat flushing optimization
Date: Mon, 17 Oct 2022 14:30:41 -0700
Message-ID: <CAJD7tkYkX7hetynuTYbpV50e1+dKgqWuGJ8d_VFSJPoF=k61NA@mail.gmail.com>
References: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
 <20221017185238.GA7699@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vc3li/tzR/oCCHp/uAgdn1p2dDfcQKGULLcU+GBdb+c=;
        b=RAhZtWKR/m4APOcLNaQu/IyieOIGeudNyluby/pCrVi2sFz2u1A0FSefKBAtiPDBf8
         seUBQVFcmsN0KKROH6v2fX9rYKR9yV3RxQEUg5HZJmPE4otB/k/wdZ3cXQnqp4gI2cfX
         +BsbrZ/E+jyA19LGwo0Xfj/sPwij+yDUr5znU9FgwCBQuY3ECDYxZIXkooVOZstOU5DW
         8kEpIXyAYuDCwvYA3IqHwv88jmBPBdiiuinwjffl8ccf0BCAMvS0uxjEmpOz576Fgi4u
         VQFx9bUPD3QtIf2eqt48BCliwgEEmZuBd7vQ9EcuUw28y1AQ5QNHJKrLI+9GcbuH4aKz
         KJJQ==
In-Reply-To: <20221017185238.GA7699-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Oct 17, 2022 at 11:52 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> Hello.
>
> On Tue, Oct 04, 2022 at 06:17:40PM -0700, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > Sorry for the long email :)
>
> (I'll get to other parts sometime in the future. Sorry for my latency :)
>
> > We have recently ran into a hard lockup on a machine with hundreds of
> > CPUs and thousands of memcgs during an rstat flush.
> > [...]
>
> I only respond with some remarks to this particular case.
>
>
> > As you can imagine, with a sufficiently large number of
> > memcgs and cpus, a call to mem_cgroup_flush_stats() might be slow, or
> > in an extreme case like the one we ran into, cause a hard lockup
> > (despite periodically flushing every 4 seconds).
>
> Is this your modification from the upstream value of FLUSH_TIME (that's
> every 2 s)?

It's actually once every 4s like upstream, I got confused by
flush_next_time multiplying the flush interval by 2.

>
> In the mailthread, you also mention >10s for hard-lockups. That sounds
> scary (even with the once per 4 seconds) since with large enough update
> tree (and update activity) periodic flush couldn't keep up.
> Also, it seems to be kind of bad feedback, the longer a (periodic) flush
> takes, the lower is the frequency of them and the more updates may
> accumulate. I.e. one spike in update activity can get the system into
> a spiral of long flushes that won't recover once the activity doesn't
> drop much more.

Yeah it is scary and shouldn't be likely to happen, but it did :(

We can keep coming up with mitigations to try and make it less likely,
but I was hoping we can find something more fundamental like keeping
track of what we really need to flush or avoiding all flushing in
non-sleepable contexts if possible.

>
> (2nd point should have been about some memcg_check_events() optimization
> or THRESHOLDS_EVENTS_TARGET justifying delayed flush but I've found none =
to be applicable.
> Just noting that v2 fortunetly doesn't have the threshold
> notifications.)

I think even without that, we can still run into the same problem in
other non-sleepable flushing contexts.

>
> Regards,
> Michal
