From: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 4/5] genirq/affinity: allow driver's discontigous
 affinity set
Date: Tue, 4 Feb 2020 11:11:25 +0800
Message-ID: <CAA70yB7ThwiaGFkM6J-cja4OcD0oH_6KTwH7vpmp9mVG0Xte4w@mail.gmail.com>
References: <cover.1580211965.git.zhangweiping@didiglobal.com>
 <c044e71afa25fdf65ca9abd21f8a5032e1b424eb.1580211965.git.zhangweiping@didiglobal.com>
 <871rrevfmz.fsf@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AQPvBn3+mpVQXLNFO7ln9Q3PQvFlywhORrkpfNdpRp4=;
        b=lx/YInbrNokwp5yZHxjAiGDoPWM9E2DKV37xld9nufJgcj4+Tu1yfL43ucz5nevePk
         LnNz27D4HpwIJGOaTtk8C0MnOYpbcXav3fJZY1FTPUOUG1wd2ISFOdZw4aXORQ0UotB3
         aPQMrXfuZ9/XNp4AIJOLGII5exFcPoOrViq9q3w3ZpzwInKdATwSVGJjkuJJyU6XRao4
         Y/ce3+O/FdwAZchKSzYBNHF22kFxA7zs3yzQfoJnOmxc+h6c/dZPdPxpon6xN25l17HF
         UyJS4pIwV5OLOvhsvCt4lMEbafQFOGDHUXmz8sdLPFUjMFAtgWdOkMEVYcwKUhSU7XO6
         wLZg==
In-Reply-To: <871rrevfmz.fsf-ecDvlHI5BZPZikZi3RtOZ1XZhhPuCNm+@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Weiping Zhang <zhangweiping-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Minwoo Im <minwoo.im.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Nadolski, Edmund" <edmund.nadolski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> =E4=BA=8E2020=E5=B9=B42=E6=9C=881=E6=
=97=A5=E5=91=A8=E5=85=AD =E4=B8=8B=E5=8D=885:19=E5=86=99=E9=81=93=EF=BC=9A
>
> Weiping Zhang <zhangweiping-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org> writes:
>
> > nvme driver will add 4 sets for supporting NVMe weighted round robin,
> > and some of these sets may be empty(depends on user configuration),
> > so each particular set is assigned one static index for avoiding the
> > management trouble, then the empty set will be been by
> > irq_create_affinity_masks().
>
> What's the point of an empty interrupt set in the first place? This does
> not make sense and smells like a really bad hack.
>
> Can you please explain in detail why this is required and why it
> actually makes sense?
>
Hi Thomas,
Sorry to late reply, I will post new patch to avoid creating empty sets.
In this version, nvme add extra 4 sets, because nvme will split its
io queues into 7 parts (poll, default, read, wrr_low, wrr_medium,
wrr_high, wrr_urgent),
the poll queues does not use irq, so nvme will has at most 6 irq sets.
And nvme driver use
two variables(dev->io_queues[index] and affd->set_size[index]) to
track how many queues/irqs
in each part. And the user may set some queues count to 0, for example:
nvme use 96 io queues.

default
dev->io_queues[0]=3D90
affd->set_size[0] =3D 90

read
dev->io_queues[1]=3D0
affd->set_size[1] =3D 0

wrr low
dev->io_queues[2]=3D0
affd->set_size[2] =3D 0

wrr medium
dev->io_queues[3]=3D0
affd->set_size[3] =3D 0

wrr high
dev->io_queues[4]=3D6
affd->set_size[4] =3D 6

wrr urgent
dev->io_queues[5]=3D0
affd->set_size[5] =3D 0

In this case the index from 1 to 3 will has 0 irqs.

But actually, it's no need to use fixed index for io_queues and set_size,
nvme just tells irq engine, how many irq_sets it has, and how may irqs
in each set,
so i will post V5 to solve this problem.
        nr_sets =3D 1;
        dev->io_queues[HCTX_TYPE_DEFAULT] =3D nr_default;
        affd->set_size[nr_sets - 1] =3D nr_default;
        dev->io_queues[HCTX_TYPE_READ] =3D nr_read;
        if (nr_read) {
                nr_sets++;
                affd->set_size[nr_sets - 1] =3D nr_read;
        }
        dev->io_queues[HCTX_TYPE_WRR_LOW] =3D nr_wrr_low;
        if (nr_wrr_low) {
                nr_sets++;
                affd->set_size[nr_sets - 1] =3D nr_wrr_low;
        }
        dev->io_queues[HCTX_TYPE_WRR_MEDIUM] =3D nr_wrr_medium;
        if (nr_wrr_medium) {
                nr_sets++;
                affd->set_size[nr_sets - 1] =3D nr_wrr_medium;
        }
        dev->io_queues[HCTX_TYPE_WRR_HIGH] =3D nr_wrr_high;
        if (nr_wrr_high) {
                nr_sets++;
                affd->set_size[nr_sets - 1] =3D nr_wrr_high;
        }
        dev->io_queues[HCTX_TYPE_WRR_URGENT] =3D nr_wrr_urgent;
        if (nr_wrr_urgent) {
                nr_sets++;
                affd->set_size[nr_sets - 1] =3D nr_wrr_urgent;
        }
        affd->nr_sets =3D nr_sets;

Thanks
Weiping
