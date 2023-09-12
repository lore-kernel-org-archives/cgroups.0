From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 4/4] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Tue, 12 Sep 2023 04:09:28 -0700
Message-ID: <CAJD7tka4zEcu-jMycMo0=xB7PP1j7P0gu_weGJSLQvbhYMzv9Q@mail.gmail.com>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-5-yosryahmed@google.com> <ZPX0kCKd4TaVLJY7@dhcp22.suse.cz>
 <CAAPL-u9D2b=iF5Lf_cRnKxUfkiEe0AMDTu6yhrUAzX0b6a6rDg@mail.gmail.com>
 <ZP8SDdjut9VEVpps@dhcp22.suse.cz> <CAAPL-u8NndkB2zHRtF8pVBSTsz854YmUbx62G7bpw6BMJiLaiQ@mail.gmail.com>
 <ZP9rtiRwRv2bQvde@dhcp22.suse.cz> <CAAPL-u9XwMcrqVRu871tGNKa3LKmJSy9pZQ7A98uDbG6ACzMxQ@mail.gmail.com>
 <ZP92xP5rdKdeps7Z@mtj.duckdns.org> <ZQBFZMRL8WmqRgrM@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694517007; x=1695121807; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Sq0fA/VatZ++ayfpGlQL3susC/RviepPCleB3baLTw=;
        b=ibueTLkYyDcakKnfmNNANAP0ZaZtuoHKt8ZiLX4Me5YTXK4m40JAcqFjJH463s68gA
         BCzfDROkDsS8eC4dlXWZ6nMWOJH12ce/HKdjFOmBD2wBBnHH11x9rNDPvb2ZfHfEqC+r
         4xgJML+gnriCrUO2Lb05RoDLr7IISXXtjM2NCh02a1hMd8zO6Pff0hR3XwylXCh3VAZJ
         F9+m07hsjzGA3YSAPQaTn4ZH/uXbhNGFO4fn0fDjlGqpRsMKCLwOmAeXvIThiBR94yJz
         zPRx3x8EjVpr+Cxj9xWR50hXpdArrUp0Ur0Dq1tNUbzCtPYzck+m2C1fd1v62U+LInqW
         cOoQ==
In-Reply-To: <ZQBFZMRL8WmqRgrM-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Sep 12, 2023 at 4:03=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Mon 11-09-23 10:21:24, Tejun Heo wrote:
> > Hello,
> >
> > On Mon, Sep 11, 2023 at 01:01:25PM -0700, Wei Xu wrote:
> > > Yes, it is the same test (10K contending readers). The kernel change
> > > is to remove stats_user_flush_mutex from mem_cgroup_user_flush_stats(=
)
> > > so that the concurrent mem_cgroup_user_flush_stats() requests directl=
y
> > > contend on cgroup_rstat_lock in cgroup_rstat_flush().
> >
> > I don't think it'd be a good idea to twist rstat and other kernel inter=
nal
> > code to accommodate 10k parallel readers.
>
> I didn't mean to suggest optimizing for this specific scenario. I was
> mostly curious whether the pathological case of unbound high latency due
> to lock dropping is easy to trigger by huge number of readers. It seems
> it is not and the mutex might not be really needed as a prevention.
>
> > If we want to support that, let's
> > explicitly support that by implementing better batching in the read pat=
h.
>
> Well, we need to be able to handle those situations because stat files
> are generally readable and we do not want unrelated workloads to
> influence each other heavily through this path.

I am working on a complete rework of this series based on the feedback
I got from Wei and the discussions here. I think I have something
simpler and more generic, and doesn't proliferate the number of
flushing variants we have. I am running some tests right now and will
share it as soon as I can.

It should address the high concurrency use case without adding a lot
of complexity. It basically involves a fast path where we only flush
the needed subtree if there's no contention, and a slow path where we
coalesce all flushing requests, and everyone just waits for a single
flush to complete (without spinning or contending on any locks). I am
trying to use this generic mechanism for both userspace reads and
in-kernel flushers. I am making sure in-kernel flushers do not
regress.

>
> [...]
>
> > When you have that many concurrent readers, most of them won't need to
> > actually flush.
>
> Agreed!
> --
> Michal Hocko
> SUSE Labs
