From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Date: Mon, 20 May 2019 12:38:32 +0200
Message-ID: <98612748-8454-43E8-9915-BAEBA19A6FD7@linaro.org>
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
 <20190518192847.GB14277@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Type: multipart/signed;
        boundary="Apple-Mail=_07219B6F-DA69-437E-B510-B40644D71454";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=71NaxZ0L8zu4vqMxuvSbFUDbkTV6DcnDsTH5MC4+H5c=;
        b=QlmbpIsyI055sun3h2zHG6GAt6n3LbQOYblzUnEq6mMgKpUWKKadGGkW1Hbv2QF31e
         eDixZCI+v69fA1OQgoL1I9kRgiqWfoCixJ3D1Vgl1mEtbvKVKJD4Y/2jI47Kl4cG/Vby
         rkgYwnvAyf8QiTGNN9lEH6i+e0UbPG8vJRv08q4vztlEDsIJt0R8H9sdTEHAVBNveOsa
         JOcxUAO/sjjPHFYn+dM7hgYXX2TNWp2alCpVf2ch/oes4C7R0sMGd0r/JgE9Gr+W0UOT
         DrQJ1GK7TWs5t+4CQs+EBLqX6/E85ZijMslJ3sbch+0a1WNcwop3cpMXpt7H/2OJnclF
         62XQ==
In-Reply-To: <20190518192847.GB14277@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, linux-fsdevel@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-ext4@vger.kernel.org, cgroups@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, jmoyer@redhat.com, amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com, Andrea Righi <righi.andrea@gmail.com>


--Apple-Mail=_07219B6F-DA69-437E-B510-B40644D71454
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> Il giorno 18 mag 2019, alle ore 21:28, Theodore Ts'o <tytso@mit.edu> =
ha scritto:
>=20
> On Sat, May 18, 2019 at 08:39:54PM +0200, Paolo Valente wrote:
>> I've addressed these issues in my last batch of improvements for
>> BFQ, which landed in the upcoming 5.2. If you give it a try, and
>> still see the problem, then I'll be glad to reproduce it, and
>> hopefully fix it for you.
>=20
> Hi Paolo, I'm curious if you could give a quick summary about what you
> changed in BFQ?
>=20

Here is the idea: while idling for a process, inject I/O from other
processes, at such an extent that no harm is caused to the process for
which we are idling.  Details in this LWN article:
https://lwn.net/Articles/784267/
in section "Improving extra-service injection".

> I was considering adding support so that if userspace calls fsync(2)
> or fdatasync(2), to attach the process's CSS to the transaction, and
> then charge all of the journal metadata writes the process's CSS.  If
> there are multiple fsync's batched into the transaction, the first
> process which forced the early transaction commit would get charged
> the entire journal write.  OTOH, journal writes are sequential I/O, so
> the amount of disk time for writing the journal is going to be
> relatively small, and especially, the fact that work from other
> cgroups is going to be minimal, especially if hadn't issued an
> fsync().
>=20

Yeah, that's a longstanding and difficult instance of the general
too-short-blanket problem.  Jan has already highlighted one of the
main issues in his reply.  I'll add a design issue (from my point of
view): I'd find a little odd that explicit sync transactions have an
owner to charge, while generic buffered writes have not.

I think Andrea Righi addressed related issues in his recent patch
proposal [1], so I've CCed him too.

[1] https://lkml.org/lkml/2019/3/9/220

> In the case where you have three cgroups all issuing fsync(2) and they
> all landed in the same jbd2 transaction thanks to commit batching, in
> the ideal world we would split up the disk time usage equally across
> those three cgroups.  But it's probably not worth doing that...
>=20
> That being said, we probably do need some BFQ support, since in the
> case where we have multiple processes doing buffered writes w/o fsync,
> we do charnge the data=3Dordered writeback to each block cgroup.  =
Worse,
> the commit can't complete until the all of the data integrity
> writebacks have completed.  And if there are N cgroups with dirty
> inodes, and slice_idle set to 8ms, there is going to be 8*N ms worth
> of idle time tacked onto the commit time.
>=20

Jan already wrote part of what I wanted to reply here, so I'll
continue from his reply.

Thanks,
Paolo

> If we charge the journal I/O to the cgroup, and there's only one
> process doing the
>=20
>   dd if=3D/dev/zero of=3D/root/test.img bs=3D512 count=3D10000 =
oflags=3Ddsync
>=20
> then we don't need to worry about this failure mode, since both the
> journal I/O and the data writeback will be hitting the same cgroup.
> But that's arguably an artificial use case, and much more commonly
> there will be multiple cgroups all trying to at least some file system
> I/O.
>=20
> 						- Ted


--Apple-Mail=_07219B6F-DA69-437E-B510-B40644D71454
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEpYoduex+OneZyvO8OAkCLQGo9oMFAlzig6gACgkQOAkCLQGo
9oOCNA//TUcUosGLeUSBdmGsluf5dLY52jefwqIaLRp7mcuLR6tx65qplO6nyEfG
cM/WAyi7KJOLStW3fv3bxl9x4eLmpli8uhrgUuCI+YGQnyVYO5yzzkGj8n9aeQuW
+KXsX67MPKT9lBQIo61EeuYNA7uQqDFyae28TGQ5pnrJ7QTnkThRUTb7H+jL2ZZo
ypdu5f5j9OLuM9ggWU7OEOK25sRMpOEPhzUmJnlJsKpgl0wuC//buY9wya19zbqg
feQgJ4PTQQ/QCKu05o1BUwr/DWDxoz5c9iHJxcPn1MhzNHNmyvugakVDYBCw7IUZ
wKlJ7phFCHTYAwdgwyXs5+d1snORWoEzPOVXvS0RH0vUn3yuT5XCZGji+wX3M3Iq
msYg9C1lIEx6jGxBMqDhyQmYJOX0NrfrbGoNv/RNuyZAvsmGYgpZZR7m4sxFBws/
EwwMOanJ0qlZpl/tzVDIu9/pbXUbVZsPiTphjOhflZi0BhcqRElCIyuERJFCDgEz
bl9w4D4x50S7KxlzahdpkbNtmRQe4yxvk4kiqu0nCZIPCowZGte3HjnM0bzn2X2t
4ROTkyYBSxP2JVf6LpNtXJFYA56bzi7uL4fzYiWM5eH99lqvfoMMfc2J4earL4xE
E9OA6kkUyniJyVuzM8noACPSHwUv65cdyPhxhIuBu2e9hpZD+4w=
=rXZb
-----END PGP SIGNATURE-----

--Apple-Mail=_07219B6F-DA69-437E-B510-B40644D71454--
