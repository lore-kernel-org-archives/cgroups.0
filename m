From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 0/2] eventfd: simplify signal helpers
Date: Mon, 17 Jul 2023 13:08:31 -0600
Message-ID: <20230717130831.0f18381a.alex.williamson@redhat.com>
References: <20230630155936.3015595-1-jaz@semihalf.com>
	<20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
	<CAH76GKPF4BjJLrzLBW8k12ATaAGADeMYc2NQ9+j0KgRa0pomUw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689620916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qHz5V5lwxUlduWSVUZLKGbl1lWEkFIrU74CIU+5Jsd8=;
	b=GzDhDbaqmhUIrUx/hs9lggdhALbPT6ujFbRvFnYTPdFWYpprz1v1wZM80teH6EYOGN8s42
	A29slQUAhFX4M6A5BWJl7mV7YKvIV7CVTLx8kw5Hg2BBpj9eTD5bgyTIuatAl959AC1aoa
	UXN0vUn1CV5OvKptQ3AgecLmpYw2L7U=
In-Reply-To: <CAH76GKPF4BjJLrzLBW8k12ATaAGADeMYc2NQ9+j0KgRa0pomUw@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Grzegorz Jaszczyk <jaz@semihalf.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-usb@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>, Paul Durrant <paul@xen.org>, Tom Rix <trix@redhat.com>, Jason Wang <jasowang@redhat.com>, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Kirti Wankhede <kwankhede@nvidia.com>, Paolo Bonzini <pbonzini@redhat.com>, Jens Axboe <axboe@kernel.dk>, Vineeth Vijayan <vneethv@linux.ibm.com>, Diana Craciun <diana.craciun@oss.nxp.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shakeel Butt <shakeelb@google.com>, Vasily Gorbik <gor@linux.ibm.com>, Leon Romanovsky <leon@kernel.org>, Harald Freudenberger <freude@linux.ibm.com>, Fei Li <fei1.li@intel.com>, x86@kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, Halil Pasic <pasic@linux.ibm.com>

On Mon, 17 Jul 2023 10:29:34 +0200
Grzegorz Jaszczyk <jaz@semihalf.com> wrote:

> pt., 14 lip 2023 o 09:05 Christian Brauner <brauner@kernel.org> napisa=C5=
=82(a):
> >
> > On Thu, Jul 13, 2023 at 11:10:54AM -0600, Alex Williamson wrote: =20
> > > On Thu, 13 Jul 2023 12:05:36 +0200
> > > Christian Brauner <brauner@kernel.org> wrote:
> > > =20
> > > > Hey everyone,
> > > >
> > > > This simplifies the eventfd_signal() and eventfd_signal_mask() help=
ers
> > > > by removing the count argument which is effectively unused. =20
> > >
> > > We have a patch under review which does in fact make use of the
> > > signaling value:
> > >
> > > https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.com=
/ =20
> >
> > Huh, thanks for the link.
> >
> > Quoting from
> > https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-=
jaz@semihalf.com/#25266856
> > =20
> > > Reading an eventfd returns an 8-byte value, we generally only use it
> > > as a counter, but it's been discussed previously and IIRC, it's possi=
ble
> > > to use that value as a notification value. =20
> >
> > So the goal is to pipe a specific value through eventfd? But it is
> > explicitly a counter. The whole thing is written around a counter and
> > each write and signal adds to the counter.
> >
> > The consequences are pretty well described in the cover letter of
> > v6 https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.co=
m/
> > =20
> > > Since the eventfd counter is used as ACPI notification value
> > > placeholder, the eventfd signaling needs to be serialized in order to
> > > not end up with notification values being coalesced. Therefore ACPI
> > > notification values are buffered and signalized one by one, when the
> > > previous notification value has been consumed. =20
> >
> > But isn't this a good indication that you really don't want an eventfd
> > but something that's explicitly designed to associate specific data wit=
h
> > a notification? Using eventfd in that manner requires serialization,
> > buffering, and enforces ordering.

What would that mechanism be?  We've been iterating on getting the
serialization and buffering correct, but I don't know of another means
that combines the notification with a value, so we'd likely end up with
an eventfd only for notification and a separate ring buffer for
notification values.

As this series demonstrates, the current in-kernel users only increment
the counter and most userspace likely discards the counter value, which
makes the counter largely a waste.  While perhaps unconventional,
there's no requirement that the counter may only be incremented by one,
nor any restriction that I see in how userspace must interpret the
counter value.

As I understand the ACPI notification proposal that Grzegorz links
below, a notification with an interpreted value allows for a more
direct userspace implementation when dealing with a series of discrete
notification with value events.  Thanks,

Alex

> > I have no skin in the game aside from having to drop this conversion
> > which I'm fine to do if there are actually users for this btu really,
> > that looks a lot like abusing an api that really wasn't designed for
> > this. =20
>=20
> https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-ja=
z@semihalf.com/
> was posted at the beginig of March and one of the main things we've
> discussed was the mechanism for propagating acpi notification value.
> We've endup with eventfd as the best mechanism and have actually been
> using it from v2. I really do not want to waste this effort, I think
> we are quite advanced with v6 now. Additionally we didn't actually
> modify any part of eventfd support that was in place, we only used it
> in a specific (and discussed beforehand) way.


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
