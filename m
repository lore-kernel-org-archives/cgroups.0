Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792635179;
	b=awMyfSLez+zNoAUa1gvGBAb00tdcikqXUpycJHKg1t6YgfXYFOM8gTT5mRL7Z3B5F8v+
	 pj4x4ygZq+paNR381Kuxpo8/gRQFHiPdaRjeJyYIHiogIszsKXUi8CaC8dxza7NEtT6Hi
	 LPymHXBscqmEq6e9qBVWNLv/B8wSY9gS7w789B4Sarqk3HJjNy0Kbp4jTqaoY4ixLZ40G
	 4f+cVfUcG+WDl7ItzyVxUHhFXgvawacpIcvZJVvWvHo2Xg9aqcCkxS2UD4EcY1kaiOI+w
	 xtazdf8ht8cQlOdklhqZqy3WmtwBwaeD/HVuEj5wK7HhhLdGOq5g1yITDG4wA8o3w0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792635179;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version:X-Provags-ID:
	 X-Spam-Flag:UI-OutboundReport;
	bh=Ws4CZZphE9craop3jtLcdnjSRKKTY4HDA90eUDrgMyc=;
	b=HWSXQAqChkF94SoHizOfjd+jR/9bLh1Sfnj5ijOQfZZXs3KKEWzPnAqkES1FAIJkHo2e
	 PcvonJmyWFuKfkcGAZn/HpbTnZHOttEg4QAgr/aKlbg9XbpYPobwxwEV7US/gjU9agwba
	 WBmB4slxl7u4U7wnIsiZID97uz5stMJ8sfjaQw+wnNoglDqf5SGp+/XMTdGXASsSNyhXF
	 8Wa7bKp6/2pW9eMZyTrV/hctVmPsZsFjpGfe1jQZOf+HaxuhEl/9IuMrv/rrUJh8Zrs6O
	 biKmqXsJIPRGTar7aCkasHG4gDU40oVuAsB6KtT+pylMnyjvl8zSLUBolY7N76z45ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=efault@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b="M9j/2Z5D";
	arc=none smtp.remote-ip=212.227.15.18
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE50E606A31B;
	Thu, 22 Oct 2026 02:12:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE50E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.de header.i=efault@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=M9j/2Z5D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1792635145; x=1793239945; i=efault@gmx.de;
	bh=Ws4CZZphE9craop3jtLcdnjSRKKTY4HDA90eUDrgMyc=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=M9j/2Z5DRxciYX2g3v209uCmdqF8DXgv9K1wyb9dqrugMjcICNIqcfXXJ09V7TuF
	 FQ/ALblBQ71rrchNzltgFwP1ol35CPM1p0uBkQRGZLxLzYqj25zsRiGHaj2A5/XgV
	 I6eUDNv3nLNs6fCy71rwBCx6juiy0rXH7pAHd0N6IJSNBjjus33eTWPZNzrzlMkf6
	 ooSbs6q+QMl7NL8wFvRVz/T7jDeee278Ybnu0nVDaU8YkxBcJqFDuJ2fBxptMHLBw
	 rfOYj7QNNvHjUcCzgEpIQjoyygjxp6zNn1OZl3vSv0fdiGw4od8b7MO94JO3e2sG4
	 D7V3w1QFEhNBeessQw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MWzk3-1x3vXN3n7R-00OhSA; Thu, 22
 Oct 2026 04:12:25 +0200
Message-ID: <40443762033546b89044587f40b21018971a9867.camel@gmx.de>
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
Date: Thu, 22 Oct 2026 04:12:20 +0200
In-Reply-To: <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org>
References: <20260605105513.354837583@infradead.org>
	 <20260605124052.227463677@infradead.org>
	 <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Provags-ID: V03:K1:tuhTTeEmbLD2wQLQnz15Vq5GWtko0mv0ZuML+Ynv4I6V3R2GRkK
 TIzu3XUvO2/+7EZxTMdcqhR9cm5s3KDFz6E89nxsDSl3pWVfRzYwYfX7M9NpEzjSj8fbfNQ
 C5Bigb2cGp6UoRTOtsJkqItUIv0sqPH6iuYTdol6gxAgK2vfZxJj9jqKnU1iNglidRuR6mc
 FYM4pzF3Ica0qbApm5QLw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kjojVddcWeA=;FE+SEDxqa3B3Gp57J+y2XlGtLRD
 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
 GgOBq0vQ==

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
>=20
> With the single runqueue, find_matching_se() is gone and se_is_idle()
> reduces to task_has_idle_policy(). Wouldn't this mean that SCHED_NORMAL
> tasks in a cpu.idle cgroup are no longer treated as idle for
> wakeup_preempt_fair()?

Am I perhaps testing wrong?

What I do to produce the perf sched data below is stuff pinned hogs in
one cgroup, pinned wakelat in another, diddle the hog populated cgroup
cpu.idle... and watch wakelat blast straight through the hog between it
and the CPU just fine, regardless of cpu.idle state.

WRT the data, ignore perf's max below, take awk processed wakelat
output as gospel.  I can make the perf numbers match nearly perfects by
running all players in the background and terminating via a time event
but didn't bother here.  The important bits are accumulated runtime,
ctx switch count, and avg delay for the bottom two lines of each
report. Ignore report format, that's a local hacklet, and also ignore
the wakelat runtime delta between tested kernels when cpu.idle=3D0 in the
hog group, that's a DELAY_DEQUEUE issue I've verified to be the source
of the jitter I can reproduce.

BEGIN 7.3.0.g14c89774-master

7.3.0.g14c89774-master cgroupA-hogs-(cpu.idle=3D0)-vs-groupB-wakelat
wakeup latency >1ms: 4568  max: 2.4ms  stddev: 554.882
  -------------------------------------------------------------------------=
---------------------------------
  Task                    |    Runtime     |  Count   |    Avg delay    |  =
  Max delay    |    Sum delay    |
  -------------------------------------------------------------------------=
---------------------------------
  cpuhog:1267             |      60.048 s  |       40 |        6.186 us |  =
     43.523 us |      247.445 us |
  cpuhog:1269             |      60.047 s  |      102 |        8.867 us |  =
    144.492 us |      904.512 us |
  cpuhog:1268             |      60.047 s  |      126 |       10.899 us |  =
    774.840 us |        1.373 ms |
  cpuhog:1266             |      60.045 s  |       58 |       19.230 us |  =
    531.945 us |        1.115 ms |
  cpuhog:1270             |      60.044 s  |       35 |        4.708 us |  =
     32.297 us |      164.798 us |
  cpuhog:1264             |      60.033 s  |      492 |       27.200 us |  =
      2.383 ms |       13.383 ms |
  cpuhog:1265             |      60.030 s  |      783 |       23.775 us |  =
     83.871 us |       18.617 ms |
  cpuhog:1271             |      49.519 s  |    51947 |      202.691 us |  =
      5.607 ms |       10.529 s  |
  wakelat:1277            |      10.512 s  |    52011 |      171.849 us |  =
     10.416 ms |        8.938 s  |
  -------------------------------------------------------------------------=
---------------------------------
  TOTAL:                  |     480.376 s  |   107581 |                 |  =
     10.416 ms |       19.627 s  |
  -------------------------------------------------------------------------=
---------------------------------

7.3.0.g14c89774-master cgroupA-hogs-(cpu.idle=3D1)-vs-groupB-wakelat
wakeup latency >1ms: 0  max: 0.0ms  stddev: 0.500
  -------------------------------------------------------------------------=
---------------------------------
  Task                    |    Runtime     |  Count   |    Avg delay    |  =
  Max delay    |    Sum delay    |
  -------------------------------------------------------------------------=
---------------------------------
  cpuhog:1297             |      60.026 s  |       43 |        9.577 us |  =
     83.461 us |      411.831 us |
  cpuhog:1298             |      60.024 s  |       27 |        4.094 us |  =
     31.306 us |      110.547 us |
  cpuhog:1294             |      60.023 s  |       60 |       10.620 us |  =
     52.234 us |      637.217 us |
  cpuhog:1296             |      60.022 s  |      131 |       15.621 us |  =
    908.988 us |        2.046 ms |
  cpuhog:1293             |      60.019 s  |      224 |        6.861 us |  =
    593.440 us |        1.537 ms |
  cpuhog:1292             |      60.006 s  |      690 |       28.075 us |  =
    286.517 us |       19.372 ms |
  cpuhog:1295             |      60.005 s  |       26 |        4.119 us |  =
     32.429 us |      107.111 us |
  cpuhog:1299             |      47.903 s  |    60216 |      201.386 us |  =
      5.270 ms |       12.127 s  |
  wakelat:1305            |      12.124 s  |    60023 |        1.963 us |  =
      2.156 ms |      117.862 ms |
  -------------------------------------------------------------------------=
---------------------------------
  TOTAL:                  |     480.196 s  |   122918 |                 |  =
      5.270 ms |       12.394 s  |
  -------------------------------------------------------------------------=
---------------------------------

BEGIN 7.2.11-ag-flat+hack
Note: this tree has virgin flat applied, and the bisected commit reverted.

7.2.11-ag-flat+hack cgroupA-hogs-(cpu.idle=3D0)-vs-groupB-wakelat
wakeup latency >1ms: 0  max: 0.0ms  stddev: 0.438
  -------------------------------------------------------------------------=
---------------------------------
  Task                    |    Runtime     |  Count   |    Avg delay    |  =
  Max delay    |    Sum delay    |
  -------------------------------------------------------------------------=
---------------------------------
  cpuhog:1272             |      60.040 s  |       44 |        6.139 us |  =
     40.163 us |      270.136 us |
  cpuhog:1275             |      60.039 s  |      139 |        3.768 us |  =
    185.461 us |      523.864 us |
  cpuhog:1276             |      60.039 s  |      140 |        5.432 us |  =
     28.697 us |      760.493 us |
  cpuhog:1274             |      60.039 s  |      104 |       12.441 us |  =
    814.146 us |        1.294 ms |
  cpuhog:1270             |      60.037 s  |      271 |       13.571 us |  =
    637.071 us |        3.678 ms |
  cpuhog:1273             |      60.036 s  |       51 |       17.658 us |  =
    439.987 us |      900.594 us |
  cpuhog:1271             |      60.018 s  |      636 |       28.960 us |  =
    362.859 us |       18.419 ms |
  cpuhog:1277             |      47.902 s  |    60081 |      202.120 us |  =
      9.812 ms |       12.144 s  |
  wakelat:1283            |      12.122 s  |    60016 |        1.905 us |  =
      2.801 ms |      114.368 ms |
  -------------------------------------------------------------------------=
---------------------------------
  TOTAL:                  |     480.316 s  |   123011 |                 |  =
      9.812 ms |       12.352 s  |
  -------------------------------------------------------------------------=
---------------------------------

7.2.11-ag-flat+hack cgroupA-hogs-(cpu.idle=3D1)-vs-groupB-wakelat
wakeup latency >1ms: 0  max: 0.0ms  stddev: 0.455
  -------------------------------------------------------------------------=
---------------------------------
  Task                    |    Runtime     |  Count   |    Avg delay    |  =
  Max delay    |    Sum delay    |
  -------------------------------------------------------------------------=
---------------------------------
  cpuhog:1298             |      60.021 s  |      307 |        8.860 us |  =
    272.423 us |        2.720 ms |
  cpuhog:1301             |      60.020 s  |       20 |        3.661 us |  =
     30.994 us |       73.236 us |
  cpuhog:1303             |      60.020 s  |      135 |        2.070 us |  =
     28.715 us |      279.571 us |
  cpuhog:1302             |      60.019 s  |       80 |       14.390 us |  =
    782.611 us |        1.151 ms |
  cpuhog:1300             |      60.017 s  |       46 |       42.518 us |  =
      1.656 ms |        1.956 ms |
  cpuhog:1299             |      60.005 s  |       22 |        6.165 us |  =
     62.913 us |      135.646 us |
  cpuhog:1304             |      60.001 s  |      666 |       27.965 us |  =
     92.954 us |       18.625 ms |
  cpuhog:1305             |      47.900 s  |    60084 |      201.849 us |  =
      4.224 ms |       12.128 s  |
  wakelat:1311            |      12.124 s  |    60009 |        1.977 us |  =
      1.440 ms |      118.685 ms |
  -------------------------------------------------------------------------=
---------------------------------
  TOTAL:                  |     480.165 s  |   122809 |                 |  =
      4.224 ms |       12.364 s  |
  -------------------------------------------------------------------------=
---------------------------------

