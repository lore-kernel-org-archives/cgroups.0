From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Wed, 16 Aug 2023 10:11:20 -0700
Message-ID: <CALvZod441xBoXzhqLWTZ+xnqDOFkHmvrzspr9NAr+nybqXgS-A@mail.gmail.com>
References: <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz> <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
 <ZNrDWqfjXtAYhnvT@slm.duckdns.org> <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org> <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg@mail.gmail.com>
 <ZNrLO5PAEZw4yjI9@slm.duckdns.org> <CAJD7tkYgCySTX28zK9GZiWwsabR4nv7M2hQ57y12si-fqtv7zg@mail.gmail.com>
 <CALvZod6KRxiDzrppCgx+=SHg2+96nFE5crwXCKwe9PZbWM_6cQ@mail.gmail.com>
 <CAJD7tkaUzhvZPohpo1F8TUKRPuXH7bjDeg9VCzN2CbywQbRutQ@mail.gmail.com>
 <CALvZod6HUtYhDaXiwXSrcwfxLSrZ37sZhKY1Mg4kmpDFk13aYw@mail.gmail.com> <CAJD7tkYzr2cg-aQ899vfqB4jR7iP83t8f-Z4AH8d9iW-yw-nnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692205893; x=1692810693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mihDJW+Sury5wgYKSVJ4wMxtsiublP7tmkDuALLcHY8=;
        b=rV1Ty5Qw3EKhiG5czbzW/vE1BSLiUs9zUNJcjf+75M5FK0vpYpqr7JxcSnbPjCRksH
         JDYTQwxkpjoZNv/FpeeH5CDlqg97AYMA3Uy0Y1Ja7RVxqKn03yZKibU88sWBt2MJWhX1
         6pa36ry2L9+ntsrjBi2HhHLxzZtZYzQVmb5Ia2NQND5p/l4gd3XUH/8EpN6CMgeaEv/w
         ks+iUH9vv+yHXWBqWDjFMFYo5h+Y3BZ31ynhfIDwOs7X7VwcN3j+94Z7jxPv7TFK2OKF
         GsQGnCvb/Aq3Hd50Nn6+7VHy97QXR0nLGjHiXlAzLOMiZjLu2Sekg/DnlLL4slsuAh9f
         YoSA==
In-Reply-To: <CAJD7tkYzr2cg-aQ899vfqB4jR7iP83t8f-Z4AH8d9iW-yw-nnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Tue, Aug 15, 2023 at 7:20=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
[...]
>
> The problem in (1) is that first of all it's a behavioral change, we
> start having explicit staleness in the stats, and userspace needs to
> adapt by explicitly requesting a flush. A node controller can be
> enlightened to do so, but on a system with a lot of cgroups, if you
> flush once explicitly and iterate through all cgroups, the flush will
> be stale by the time you reach the last cgroup. Keep in mind there are
> also users that read their own stats, figuring out which users need to
> flush explicitly vs. read cached stats is a problem.

I thought we covered the invalidity of the staleness argument. Similar
staleness can happen today, so not strictly a behavioral change. We
can change the time window and condition of the periodic flush to
reduce the chance of staleness. Option 2 can also face staleness as
well.

>
> Taking a step back, the total work that needs to be done does not
> change with (2). A node controller iterating cgroups and reading their
> stats will do the same amount of flushing, it will just be distributed
> across multiple read syscalls, so shorter intervals in kernel space.

You seem to be worried about the very fine grained staleness of the
stats. So, for scenarios where stats of multi-level cgroups need to be
read and the workload is continuously updating the stats, the total
work can be much more. For example if we are reading stats of root and
top level memcgs then potentially option 2 can flush the stats for the
whole tree twice.

>
> There are also in-kernel flushers (e.g. reclaim and dirty throttling)
> that will benefit from (2) by reading more accurate stats without
> having to flush the entire tree. The behavior is currently
> indeterministic, you may get fresh or stale stats, you may flush one
> cgroup or 100 cgroups.
>
> I think with (2) we make less compromises in terms of accuracy and
> determinism, and it's a less disruptive change to userspace.

These options are not white and black and there can be something in
between but let me be very clear on what I don't want and would NACK.
I don't want a global sleepable lock which can be taken by potentially
any application running on the system. We have seen similar global
locks causing isolation and priority inversion issues in production.
So, not another lock which needs to be taken under extreme condition
(reading stats under OOM) by a high priority task (node controller)
and might be held by a low priority task.
