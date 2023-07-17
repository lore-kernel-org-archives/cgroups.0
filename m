From: Grzegorz Jaszczyk <jaz-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/2] eventfd: simplify signal helpers
Date: Mon, 17 Jul 2023 10:29:34 +0200
Message-ID: <CAH76GKPF4BjJLrzLBW8k12ATaAGADeMYc2NQ9+j0KgRa0pomUw@mail.gmail.com>
References: <20230630155936.3015595-1-jaz@semihalf.com> <20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1689582586; x=1692174586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrEcIar0BkfpmBL+8BCmNKqe2TUSK3LL+WBdNYsOjsM=;
        b=e52IJgo7nORao0Gl4I5dRpwwbrYRCXZTSuwaC/thRVodGrQS/Ih+iZx/Zsqn89WU3w
         pQgXUWQS+Vk59/Fh6rrIEqzCQJkEny2i0gy7zEPOvxwj9yUxhnNvrizRbt8YsZpplHpx
         RjVLFZyrzR9wafddakUgpMo5lLKlNumHP6uiacp/wGVyLbBbCgrHIUP/7snpf7XV2sof
         jlaeLm95LpwgAuzcjO7UCvT+e3bh2UJ0I6TbCUpKBOZvGLRTw6wJXY5zbY52dacz1/1P
         iPPOvh8ArwyYCroEOLn3Y8OJKVgd78PUACDF8tTPiPB+Om3hyy+66x8dhT2yU/74h83y
         v2JA==
In-Reply-To: <20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Rosato <mjrosato-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Paul Durrant <paul-LM2mM/qkH7s@public.gmane.org>, Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Vineeth Vijayan <vneethv-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Diana Craciun <diana.craciun-0KzQaVfr69FBDgjK7y7TUQ@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Xuan Zhuo <xuanzhuo-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Harald Freudenberger <freude-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fei Li <fei1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

pt., 14 lip 2023 o 09:05 Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> napisa=C5=
=82(a):
>
> On Thu, Jul 13, 2023 at 11:10:54AM -0600, Alex Williamson wrote:
> > On Thu, 13 Jul 2023 12:05:36 +0200
> > Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > > Hey everyone,
> > >
> > > This simplifies the eventfd_signal() and eventfd_signal_mask() helper=
s
> > > by removing the count argument which is effectively unused.
> >
> > We have a patch under review which does in fact make use of the
> > signaling value:
> >
> > https://lore.kernel.org/all/20230630155936.3015595-1-jaz-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org/
>
> Huh, thanks for the link.
>
> Quoting from
> https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-ja=
z@semihalf.com/#25266856
>
> > Reading an eventfd returns an 8-byte value, we generally only use it
> > as a counter, but it's been discussed previously and IIRC, it's possibl=
e
> > to use that value as a notification value.
>
> So the goal is to pipe a specific value through eventfd? But it is
> explicitly a counter. The whole thing is written around a counter and
> each write and signal adds to the counter.
>
> The consequences are pretty well described in the cover letter of
> v6 https://lore.kernel.org/all/20230630155936.3015595-1-jaz-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org/
>
> > Since the eventfd counter is used as ACPI notification value
> > placeholder, the eventfd signaling needs to be serialized in order to
> > not end up with notification values being coalesced. Therefore ACPI
> > notification values are buffered and signalized one by one, when the
> > previous notification value has been consumed.
>
> But isn't this a good indication that you really don't want an eventfd
> but something that's explicitly designed to associate specific data with
> a notification? Using eventfd in that manner requires serialization,
> buffering, and enforces ordering.
>
> I have no skin in the game aside from having to drop this conversion
> which I'm fine to do if there are actually users for this btu really,
> that looks a lot like abusing an api that really wasn't designed for
> this.

https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-jaz@=
semihalf.com/
was posted at the beginig of March and one of the main things we've
discussed was the mechanism for propagating acpi notification value.
We've endup with eventfd as the best mechanism and have actually been
using it from v2. I really do not want to waste this effort, I think
we are quite advanced with v6 now. Additionally we didn't actually
modify any part of eventfd support that was in place, we only used it
in a specific (and discussed beforehand) way.
