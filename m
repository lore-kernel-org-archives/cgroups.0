From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 11/12] block, bfq: boost the throughput
 on NCQ-capable flash-based devices
Date: Wed, 4 Jun 2014 09:56:27 -0400
Message-ID: <20140604135627.GB5004@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-12-git-send-email-paolo.valente@unimore.it>
 <20140531115216.GB5057@htj.dyndns.org>
 <36BFDB73-AEC2-4B87-9FD6-205E9431E722@unimore.it>
 <20140603171124.GE26210@htj.dyndns.org>
 <03CDD106-DB18-4E8F-B3D6-2AAD45782A06@unimore.it>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=l2BylzeHv6Wg5MICvGEs9Vj1A8LN1jLfWhpN4/Albq8=;
        b=BoRFlu8NyySGAAfQhrAHdlnz0X2alWy6sy47C35c6Y+LAMLGORUbBAoWxXx25nSnfR
         nH+8Xs58nl6c+MItRTpaz42V7RjWBSBKXvLkqvYrJEENdxTFF+U4iWo+sZOug+aOZcvV
         rJw5b7SLfjq1ojG6LD9SE5/iGc8uv9E6DrL4VIs9sw86H9glgnbbMyQrhjPn9Dgxqjfd
         rF1xJsJx4+uVPY85xiFTB/tJwn9WHd5bytuGeIylYUZXcovLK7jVl936WR/3X0AYuF3q
         YN61ifFjHmLdM7MONhA2eVa31SJGVUclFh6BXV+1Cy0HAQyaHr7QOic/VWT+AKyGQVM6
         CUyg==
Content-Disposition: inline
In-Reply-To: <03CDD106-DB18-4E8F-B3D6-2AAD45782A06-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Paolo.

On Wed, Jun 04, 2014 at 09:29:20AM +0200, Paolo Valente wrote:
> > Shouldn't the comparison be against the benefit of "not idling
> > selectively" vs "always idling" when blkcg is in use?
> >=20
>=20
> Exactly. I=E2=80=99m sorry if I wrote things/sentences that did not l=
et this
> point be clear. Maybe this lack of clarity is a further consequence
> of the annoying =E2=80=9Cnot not=E2=80=9D scheme adopted in the code =
and in the
> comments.

Ah, no, it was just me misreading the message.

> > I'm not really convinced about the approach.  With rotating disks, =
we
> > know that allowing queue depth > 1 generaly lowers both throughput =
and
> > responsiveness and brings benefits in quite restricted cases.  It
> > seems rather backwards to always allow QD > 1 and then try to optim=
ize
> > in an attempt to recover what's lost.  Wouldn't it make far more se=
nse
> > to actively maintain QD =3D=3D 1 by default and allow QD > 1 in spe=
cific
> > cases where it can be determined to be more beneficial than harmful=
?
>=20
> Although QD =3D=3D 1 is not denoted explicitly as default, what you s=
uggest is exactly what bfq does.=20
I see.

> >> I do not know how widespread a mechanism like ulatencyd is
> >> precisely, but in the symmetric scenario it creates, the throughpu=
t
> >> on, e.g., an HDD would drop by half if the workload is mostly rand=
om
> >> and we removed the more complex mechanism we set up.  Wouldn't thi=
s
> >> be bad?
> >=20
> > It looks like a lot of complexity for optimization for a very
> > specific, likely unreliable (in terms of its triggering condition),
> > use case.  The triggering condition is just too specific.
>=20
> Actually we have been asked several times to improve random-I/O
> performance on HDDs over the last years, by people recording, for
> the typical tasks performed by their machines, much lower throughput
> than with the other schedulers. Major problems have been reported
> for server workloads (database, web), and for btrfs. According to
> the feedback received after introducing this optimization in bfq,
> those problems seem to be finally gone.

I see.  The equal priority part can probably work in enough cases to
be meaningful given that it just depends on the busy queues having the
same weight instead of everything in the system.  It'd nice to note
that in the comment tho.

I'm still quite skeptical about the cgroup part tho.  The triggering
condition is too specific and fragile.  If I'm reading the bfq blkcg
implementation correctly, it seems to be applying the scheduling
algorithm recursively walking down the tree one level at a time.  cfq
does it differently.  cfq flattens the hierarchy by calculating the
nested weight of each active leaf queue and schedule all of them from
the same service tree.  IOW, scheduling algorithm per-se doesn't care
about the hierarchy.  All it sees are differing weights competing
equally regardless of the hierarchical structure.

If the same strategy can be applied to bfq, possibly the same strategy
of checking whether all the active queues have the same weight can be
used regardless of blkcg?  That'd be simpler and a lot more robust.

Another thing I'm curious about is that the logic that you're using to
disable idling assumes that the disk will serve the queued commands
more or less in fair manner over time, right?  If so, why does queues
having the same weight matter?  Shouldn't the bandwidth scheduling
eventually make them converge to the specified weights over time?
Isn't wr_coeff > 1 test enough for maintaining reasonable
responsiveness?

> Besides, turning back to bfq, if its low-latency heuristics are
> disabled for non rotational devices, then, according to our results
> with slower devices, such as SD Cards and eMMCs, latency becomes
> easily unbearable, with no throughput gain.

Hmmm... looking at the nonrot optimizations again, so yeah assuming
the weight counting is necessary for NCQ hdds the part specific to
ssds isn't that big.  You probably wanna sequence it the other way
around tho.  This really should be primarily about disks at this
point.

The thing which still makes me cringe is how it scatters
blk_queue_nonrot() tests across multiple places without clear
explanation on what's going on.  A bfqq being constantly seeky or not
doesn't have much to do with whether the device is rotational or not.
Its effect does and I don't think avoiding the overhead of keeping the
counters is meaningful.  Things like this make the code a lot harder
to maintain in the long term as code is organized according to
seemingly arbitrary optimization rather than semantic structure.  So,
let's please keep the accounting and optimization separate.

Thanks.

--=20
tejun
