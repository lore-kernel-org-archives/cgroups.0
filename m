Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF87B3BB115;
	Sun, 18 Oct 2026 06:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792306193; cv=none; b=XlUZB3KdpxMR/KQBqOg7gjmt0QxtYOAT4D7xOV5P5a58OwbRgXDH0h+419Hpf6q12/otcLbuK8gT9VP2DWp/x21sB2FyiDrbbSD9oUzbX0D7Y3RWraIVc6/UFAWvRjerJXq28RKaqjWgNAJDcaUwJQhf9Q58eUH3drUtfDSACNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792306193; c=relaxed/simple;
	bh=q/ntWjpRoBwAFRXgvSzE5667UQ5q5AK7Ik5KKRUhs2k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gFyCV2Qu/t0d8UJf9dQn33omNDTZJWn4UaCPDDuQkCdkAXgf/gsaDCLQFLxYMx1kVmc3qoaWdmpS4beB+Vih2UVPT9qpz6rIKk5l09L1BXX8BKBNzvo/HV5vV2j2MS+D9e2fegjZDvA0s2iO6o86uusKZT1gUZfxaBd9oMpyuFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b=Ff5qagFP; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b="Ff5qagFP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1792306174; x=1792910974; i=efault@gmx.de;
	bh=a9qFg4rh5rJY/94lKvbhTGLmNg2V/yvXn7/WIyaspCo=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Ff5qagFPpkA+0Jlj9rmsc35uY1Pp3VVaXAN7SgCbVRYxtSqeoOKj6topdYmV4T/c
	 ANGK4t/IFVMQCBLhodvKcizh6nKN/LD0JJzLtJJ4AnClAP3GkN59KjPlHQrwCvdHf
	 1bEb57VJK/29fXmNC+w4Oy6BZ/BYmHVL7l46ZqwpbDnUnJXxpjfgbyBGBsOd8jamS
	 lOsMZoi4rr53Hq78dX2GE7/2WZIPLIRajwEOwoED99jNCXHVpYfEuyWcrzLax8esI
	 YoePmeL3EoFxT8OvNP4pvbdZnTxs5b/508zfLvinDrwdQOEOHVuBr7Gf5LpjCxHgv
	 scr0A3c9Cf4JvfyEBw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MAwXh-1xTYyV2oQb-008pPw; Sun, 18
 Oct 2026 08:49:34 +0200
Message-ID: <b1002150c3e4f877d04790cd8e85d2149d17722f.camel@gmx.de>
Subject: Re: [PATCH v3 7/7] sched/eevdf: Move to a single runqueue
From: Mike Galbraith <efault@gmx.de>
To: Jakub =?UTF-8?Q?Oko=C5=84ski?= <jakub@okonski.org>, Peter Zijlstra
	 <peterz@infradead.org>, mingo@kernel.org
Cc: longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jstultz@google.com, kprateek.nayak@amd.com, 
	qyousef@layalina.io
Date: Sun, 18 Oct 2026 08:49:29 +0200
In-Reply-To: <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org>
References: <20260605105513.354837583@infradead.org>
	 <20260605124052.227463677@infradead.org>
	 <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Provags-ID: V03:K1:9iNAocpG5x1CJAmMXwVqsaAqdzptXRDOt1yko+dKLlbY5IwsXZV
 oG4luLShD2wb+EaulXzYgO0utVPpU7zbGV97FQD1NHvNoQe+bmjWghaVslZQ4JFumYWxd5M
 5X3eAJT2dU+PMUqdpPV/I6JasOJcs2oeQZpOlnVcMt4hrUS+h/aZPQtO5GxJAzw0cFCW9sZ
 We0UOdBc88kmCYETUmH1w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:yaoA2VtcRP4=;4mGPFCdxrx40IOU2VngsZhU1KuW
 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
 al560AGVFs79ItVQ6vLHMfflUJvfI=

Greetings!

On Fri, 2026-10-16 at 15:18 +0200, Jakub Oko=C5=84ski wrote:
> Hi Peter,
>=20
> On 6/5/26 14:40, Peter Zijlstra wrote:
>=20
> > Change fair/cgroup to a single runqueue.
> >=20
> > [...]
> >=20
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -9916,7 +9837,6 @@ static void wakeup_preempt_fair(struct r
> > =C2=A0	if (!sched_feat(WAKEUP_PREEMPTION))
> > =C2=A0		return;
> > =C2=A0
> > -	find_matching_se(&se, &pse);
> > =C2=A0	WARN_ON_ONCE(!pse);
> > =C2=A0
> > =C2=A0	cse_is_idle =3D se_is_idle(se);
>=20
> I think this changes how cpu.idle affects wakeup preemption.

My box claims this to be unrelated to the jitter you're seeing, as it
is present in 7.2.11, with and without the sched-flat set applied.

> With the single runqueue, find_matching_se() is gone and se_is_idle()
> reduces to task_has_idle_policy(). Wouldn't this mean that SCHED_NORMAL
> tasks in a cpu.idle cgroup are no longer treated as idle for
> wakeup_preempt_fair()?
>=20
> I tested my existing 7.2.9 desktop against 7.3-rc6 with the setup below.
> cyclictest doesn't reproduce it because it just sleeps and wakes, no CPU
> burn and therefore its accrued EEVDF lag keeps the latency low?
>=20
> cc -O2 -o wakelat wakelat.c
> systemd-run --user --collect --unit=3Dspin -p AllowedCPUs=3D7 -p CPUWeigh=
t=3Didle sh -c 'while :; do :; done'
> systemd-run --user --collect --wait --pipe --same-dir -p AllowedCPUs=3D7 =
./wakelat 1000 15 200 |
> =C2=A0 mlr --inidx --ifs space --opprint --barred --right label lat \
> =C2=A0=C2=A0=C2=A0 then stats1 -a count,p50,p90,p99,max -f lat then renam=
e -r '^lat_,' \
> =C2=A0=C2=A0=C2=A0 then put -q 'emit mapsum({"kernel": system("uname -r")=
}, $*)'
> systemctl --user stop spin
>=20
> wakelat wakes on a fixed 1 ms schedule, records how late each wakeup
> was, then busy-loops for 200 micros (wall clock).
>=20
> +-----------+-------+-----+-----+------+------+
> > =C2=A0=C2=A0 kernel | count | p50 | p90 |=C2=A0 p99 |=C2=A0 max |
> +-----------+-------+-----+-----+------+------+
> > =C2=A0=C2=A0=C2=A0 7.2.9 | 14998 |=C2=A0 11 |=C2=A0 11 |=C2=A0=C2=A0 12=
 | 1869 |
> > 7.3.0-rc6 | 13853 |=C2=A0 11 |=C2=A0 12 | 2029 | 2116 |
> +-----------+-------+-----+-----+------+------+
>=20
> count is out of 15000 periods. rc6 had 1147 wakeups delayed by over 1 ms.

Thanks a bunch for the proggy. I've been looking for a clear signal
with various loads, and stuffing wakelat+awk into one of my scripts
provided a perfectly clear signal, which I bisected and confirmed.

Note: below is box pointing it's little silicon finger at the source of
aforementioned jitter, not necessarily at breakage.

Reverting the fingered commit removed the jitter from 7.2.11, and force
reverting 68e37487810a + 333238da9a19 removed it from master as well.

333238da9a193ffc58792995f3e951e4cb87bfd2 is the first 'bad' commit
commit 333238da9a193ffc58792995f3e951e4cb87bfd2
Author: Vincent Guittot <vincent.guittot@linaro.org>
Date:   Fri Aug 14 15:52:41 2026 +0200

    sched: Update time before requeueing delayed entities
   =20
    In order to compute the right lag, it is required to update time to 'no=
w'.
    Without this, the delayed entity might appear younger than it really is=
 and
    receive less compensation for having waited.
   =20
    Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
    Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

 kernel/sched/fair.c | 2 ++
 1 file changed, 2 insertions(+)

