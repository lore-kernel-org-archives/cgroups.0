From: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Add support Weighted Round Robin for blkcg and nvme
Date: Wed, 1 Apr 2020 00:31:17 +0800
Message-ID: <CAA70yB6PYH-W8-RRd7nxXOvpg6n+_-h_BLm6JA3EbLmsYG-ZSw@mail.gmail.com>
References: <cover.1580786525.git.zhangweiping@didiglobal.com>
 <20200204154200.GA5831@redsun51.ssa.fujisawa.hgst.com> <CAA70yB5qAj8YnNiPVD5zmPrrTr0A0F3v2cC6t2S1Fb0kiECLfw@mail.gmail.com>
 <CAA70yB62_6JD_8dJTGPjnjJfyJSa1xqiCVwwNYtsTCUXQR5uCA@mail.gmail.com>
 <20200331143635.GS162390@mtj.duckdns.org> <CAA70yB51=VQrL+2wC+DL8cYmGVACb2_w5UHc4XFn7MgZjUJaeg@mail.gmail.com>
 <20200331155139.GT162390@mtj.duckdns.org> <20200331155257.GA22994@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3e9ikjR7lUfigAH3hUl/FtkvucG7jL188AkHtbtxXwU=;
        b=JFffBG1O7hZhrL4iWKk+o5lwqbdFv84JlaqpK1TtGAaPpOY13zvdft43vmDz/CcmTQ
         nIHnNWsxIL0clp4kNgoxK0yQlGE98tVc7k9BZ+Aqj6wYm5nS2HCVA2SbKrU9fXydw8IB
         iWd7CDUllGJqvAqA8gggeh9RXn3bjDLGVF8C90bnvIopC1wIOhQ36QT3f0aufrC/iC/T
         SYPRvEgdHQcCB9EB5fGpEsED3mwVOy9S3w3yMl9SdggcVFZBQW9UvaTeJ2Both4xMGzZ
         lDLNirOa07shniq/V7jr1WOxVJ3IVPZJQlvZa+1IcsAKyOO8UT9j4q1l9/1ctw0DOTLF
         A+Zw==
In-Reply-To: <20200331155257.GA22994-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Keith Busch <kbusch-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Minwoo Im <minwoo.im.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nadolski, Edmund" <edmund.nadolski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> =E4=BA=8E2020=E5=B9=B43=E6=9C=8831=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=8811:52=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Mar 31, 2020 at 11:51:39AM -0400, Tejun Heo wrote:
> > Hello,
> >
> > On Tue, Mar 31, 2020 at 11:47:41PM +0800, Weiping Zhang wrote:
> > > Do you means drop the "io.wrr" or "blkio.wrr" in cgroup, and use a
> > > dedicated interface
> > > like /dev/xxx or /proc/xxx?
> >
> > Yes, something along that line. Given that it's nvme specific, it'd be =
best if
> > the interface reflects that too - e.g. through a file under
> > /sys/block/nvme*/device/. Jens, Christoph, what do you guys think?
>
> I'm pretty sure I voiced my opinion before - I think the NVMe WRR
> queueing concept is completely broken and I do not thing we should
> support it at all.
Hi Christoph,

Would you like to share more detail about why NVMe WRR is broken?
