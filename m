From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 00:24:33 -0400
Message-ID: <55F25781.20308@redhat.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
 <20150910164946.GH8114@mtj.duckdns.org>
 <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
 <20150910202210.GL8114@mtj.duckdns.org>
 <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
 <20150911040413.GA18850@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0d81L0RAWhLJer50GDDTF0isc68oqgeVL"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150911040413.GA18850-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0d81L0RAWhLJer50GDDTF0isc68oqgeVL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/11/2015 12:04 AM, Tejun Heo wrote:
> Hello, Parav.
>=20
> On Fri, Sep 11, 2015 at 09:09:58AM +0530, Parav Pandit wrote:
>> The fact is that user level application uses hardware resources.
>> Verbs layer is software abstraction for it. Drivers are hiding how
>> they implement this QP or CQ or whatever hardware resource they
>> project via API layer.
>> For all of the userland on top of verb layer I mentioned above, the
>> common resource abstraction is these resources AH, QP, CQ, MR etc.
>> Hardware (and driver) might have different view of this resource in
>> their real implementation.
>> For example, verb layer can say that it has 100 QPs, but hardware
>> might actually have 20 QPs that driver decide how to efficiently use
>> it.
>=20
> My uneducated suspicion is that the abstraction is just not developed
> enough.

The abstraction is 10+ years old.  It has had plenty of time to ferment
and something better for the specific use case has not emerged.

>  It should be possible to virtualize these resources through,
> most likely, time-sharing to the level where userland simply says "I
> want this chunk transferred there" and OS schedules the transfer
> prioritizing competing requests.

No.  And if you think this, then you miss the *entire* point of RDMA
technologies.  An analogy that I have used many times in presentations
is that, in the networking world, the kernel is both a postman and a
copy machine.  It receives all incoming packets and must sort them to
the right recipient (the postman job) and when the user space
application is ready to use the information it must copy it into the
user's VM space because it couldn't just put the user's data buffer on
the RX buffer list since each buffer might belong to anyone (the copy
machine).  In the RDMA world, you create a new queue pair, it is often a
long lived connection (like a socket), but it belongs now to the app and
the app can directly queue both send and receive buffers to the card and
on incoming packets the card will be able to know that the packet
belongs to a specific queue pair and will immediately go to that apps
buffer.  You can *not* do this with TCP without moving to complete TCP
offload on the card, registration of specific sockets on the card, and
then allowing the application to pre-register receive buffers for a
specific socket to the card so that incoming data on the wire can go
straight to the right place.  If you ever get to the point of "OS
schedules the transfer" then you might as well throw RDMA out the window
because you have totally trashed the benefit it provides.

> It could be that given the use cases rdma might not need such level of
> abstraction - e.g. most users want to be and are pretty close to bare
> metal, but, if that's true, it also kinda is weird to build
> hierarchical resource distribution scheme on top of such bare
> abstraction.

Not really.  If you are going to have a bare abstraction, this one isn't
really a bad one.  You have devices.  On a device, you allocate
protection domains (PDs).  If you don't care about cross connection
issues, you ignore this and only use one.  If you do care, this acts
like a process's unique VM space only for RDMA buffers, it is a domain
to protect the data of one connection from another.  Then you have queue
pairs (QPs) which are roughly the equivalent of a socket.  Each QP has
at least one Completion Queue where you get the events that tell you
things have completed (although they often use two, one for send
completions and one for receive completions).  And then you use some
number of memory registrations (MRs) and address handles (AHs) depending
on your usage.  Since RDMA stands for Remote Direct Memory Access, as
you can imagine, giving a remote machine free reign to access all of the
physical memory in your machine is a security issue.  The MRs help to
control what memory the remote host on a specific QP has access to.  The
AHs control how we actually route packets from ourselves to the remote ho=
st.

Here's the deal.  You might be able to create an abstraction above this
that hides *some* of this.  But it can't hide even nearly all of it
without loosing significant functionality.  The problem here is that you
are thinking about RDMA connections like sockets.  They aren't.  Not
even close.  They are "how do I allow a remote machine to directly read
and write into my machines physical memory in an even remotely close to
secure manner?"  These resources aren't hardware resources, they are the
abstraction resources needed to answer that question.

> ...
>>> I don't know.  What's proposed in this thread seems way too low level=

>>> to be useful anywhere else.  Also, what if there are multiple devices=
?
>>> Is that a problem to worry about?
>>
>> o.k. It doesn't have to be useful anywhere else. If it suffice the
>> need of RDMA applications, its fine for near future.
>> This patch allows limiting resources across multiple devices.
>> As we go along the path, and if requirement come up to have knob on
>> per device basis, thats something we can extend in future.
>=20
> You kinda have to decide that upfront cuz it gets baked into the
> interface.
>=20
>>> I'm kinda doubtful we're gonna have too many of these.  Hardware
>>> details being exposed to userland this directly isn't common.
>>
>> Its common in RDMA applications. Again they may not be real hardware
>> resource, its just API layer which defines those RDMA constructs.
>=20
> It's still a very low level of abstraction which pretty much gets
> decided by what the hardware and driver decide to do.
>=20
>>> I'd say keep it simple and do the minimum. :)
>>
>> o.k. In that case new rdma cgroup controller which does rdma resource
>> accounting is possibly the most simplest form?
>> Make sense?
>=20
> So, this fits cgroup's purpose to certain level but it feels like
> we're trying to build too much on top of something which hasn't
> developed sufficiently.  I suppose it could be that this is the level
> of development that rdma is gonna reach and dumb cgroup controller can
> be useful for some use cases.  I don't know, so, yeah, let's keep it
> simple and avoid doing crazy stuff.
>=20
> Thanks.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--0d81L0RAWhLJer50GDDTF0isc68oqgeVL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8leBAAoJELgmozMOVy/d3TEP/08g+E9g9KtC2XJnPdFa7Q8t
33ckjkLk1RwsS7+6SehJpgcOxSQ7xHPbMgP51z643Qjrm2wtNTsoR5IYEQ4ItPnJ
6BRdN8wd8AfT6A4FjV7MUYcm71Zs9dJtXiMTiYMp6FykLa1E25qpuSknhHsPiB3b
Us2QfwmCgS6D2bixLld9wYjMQht4yPjJidZ8zq1AHrYp9LQlYuuquoF8Y/6r7C+/
Q6MsbgyAP+AV0ebmXDGGQqncM1+FvU6l3Wo8g0AhDu7ka3xjUqIHnpNbBoVERsWD
LFTxErsEQE70iSStw71unOBJkGUeCH1BeACWwyhPiWhUvKd259f1OjaHfWMrN+N9
o0L78ggL5vwsBRou5jywuXXEduErTIc2+u531dGrXoAERiBw8rg+SPw6Fq3h4ppa
fEx3guycBqUEmMtIgctnHfDySS0rGIebC4QuNf3DGCqE2ZGvXl+MZxLGSHhoWNm/
hyVip/y0nzgfhvQty9dL+vVYO2hRLA4VNoTSN8hYzyYUOilqVxJG6/InyvxBRWER
L3jOnSJXdp6iL8wj2Xvm94VEUTtzcKGRzCLXI/Cdo2zY9mA6zmB0oJAITHJCUOG+
AxNg/uXu2QVpyx4xuwe1dAF/J3ftKytBlltt0mn8YxBDCO3Yd0k0TRGNPuTregSx
mDHTavK5p2duPu215MWk
=u/8U
-----END PGP SIGNATURE-----

--0d81L0RAWhLJer50GDDTF0isc68oqgeVL--
