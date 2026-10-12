Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DA336B934;
	Mon, 12 Oct 2026 11:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791804506; cv=none; b=dnKNMbTIfn2mWeu3A690dCea9I3XmxlwJRuIKctnmnn7Qhr6/vc9a3BeOcbRSb09t3EMI2VAUZuHrt5J1NGEgvJDmcjOUWmgBgMquu2ZsJ4vUNxBfgAnoGVMnH5EsNCthri8kPizyJ07jUbfHYgV5a43l2dudxLd3P4UuViU2hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791804506; c=relaxed/simple;
	bh=Xe3ysctnOP/WlwH4oT+i5RjaQac9BV9NUkzQgwKW++Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mpj3/XL6YlZFv9FT9KWwRkV/DYZVErLQvSZKvlXlKLsGFLh1SwQQROi/b4bPQGPkJjd7a1w7+sQ+XyjqanCNGlmHvattv64LYG9Luw15I7CUEwwgYowcOtxb7L7OvhCq6TSGb3Mni2SrIF+1L8m6TzB25NMfmw7JteYyhDB19f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b=o2SEg7FA; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b="o2SEg7FA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1791804485; x=1792409285; i=efault@gmx.de;
	bh=x5BBFMF1gG5o+EQAeBTvQmrQMUPKaE6GcPhAe8NhLAg=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=o2SEg7FAnKEDQrWIwU+mnMQbIYQZyEunsuFyRDeHOYbH6mvUX7V+sC/hQLD5sp9t
	 QDfrJXOKT8oQYj8O1vDEgAW8dwxCfZyMeT2uYikcO2I1qd0Lf4GzQZ+uGyNk1r2OL
	 Vuxi8ihuS/jfqcXlpuzDJPaoOId+Z8NSMZnsl3MxLrt6uBkULfYVfxd/59lGNxWxr
	 Ye5a5mL4DFhHfrCDYIuLUwRq/hsEOYtaPFxF/xFIsYaGOHI7yY6vs/kVMjvAN/9mE
	 7AVhPZ59fQexJN1bSyhjNncptlSBd5JhW3fxsN/jH1UMP7eMPhq4uD8rfwNmy8KbX
	 gmTidtUEGhT89QLIZg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MfpOd-1wjOYf3cs5-00khBX; Mon, 12
 Oct 2026 13:28:05 +0200
Message-ID: <eac663e09be5dbadaded334f2f80d2c21f3b14cb.camel@gmx.de>
Subject: Re: [REGRESSION] [PATCH v3 7/7] sched/eevdf: Move to a single
 runqueue
From: Mike Galbraith <efault@gmx.de>
To: Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>, Chen Yu
	 <yu.c.chen@intel.com>, kprateek.nayak@amd.com
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
 longman@redhat.com, 	chenridong@huaweicloud.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, 	dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, 	vschneid@redhat.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, 	cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, jstultz@google.com, 	qyousef@layalina.io,
 Ryan Roberts <ryan.roberts@arm.com>, chen.yu@linux.dev
Date: Mon, 12 Oct 2026 13:27:58 +0200
In-Reply-To: <d9f31316-38fb-4841-9050-8a9f3a042847@arm.com>
References: <20260605105513.354837583@infradead.org>
	 <20260605124052.227463677@infradead.org>
	 <bd81bbec-ee59-401a-bec6-116196ad3a34@arm.com>
	 <arQCykkkCnADu5ek@chenyu-dev>
	 <128e93ca1424630546e39f9e9c1377f8185f7644.camel@gmx.de>
	 <arnbKNWNIIEcQ0a-@chenyu-dev>
	 <4d4f5fdee4d1f462ba3490a6b3921006285e7fcc.camel@gmx.de>
	 <d9f31316-38fb-4841-9050-8a9f3a042847@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Provags-ID: V03:K1:59f2PzY6Xiu44/s4q08HglAb/O/ultXatkzqDHMFsOS1T0h5xpQ
 Sf1gRa+CPnPBztZjnu0o7MV4hBNX7ICKTGYsUt+MtXryBkJPZFIPL4JZapT8Napn4TLb55/
 GbGocdmz2CSD3LYIof1oikZ6U9TJCnfK1777EIJt43Z5k4wln5VgBwqq2ufsfYGFrVBVuem
 HkeMyia31yW8NPJs9x1lQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Azj028gUsPU=;euZOiS8aL12xemZTMAtiN0tqCqP
 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
 nj6hwczH6n5Z+8FoUKHm1ATbhHC2LN2eJng==

On Wed, 2026-10-07 at 17:35 +0530, Aishwarya Rambhadran wrote:
> Hi all,
>=20
> Thanks for the suggestions. I ran a couple of follow-up tests on the
> same AWS Graviton3 (m7g.metal) setup with v7.3-rc4:
>=20
> 1. Disable WA_WEIGHT:
> echo NO_WA_WEIGHT > /sys/kernel/debug/sched/features
>=20
> 2. Use the "smp" cgroup mode:
> echo smp > /sys/kernel/debug/sched/cgroup_mode
>=20
> Both tests were run with 20 repeats across 2 boot sessions. Below are
> the request latency p99 results for schbench configurations discussed
> earlier (usec, smaller is better):
>=20
> message-thread:16, worker-thread:16
> v7.2 =3D 662869
> v7.3-rc4 =3D 969557
> NO_WA_WEIGHT =3D 958541
> smp =3D 723098
>=20
> message-thread:64, worker-thread:4
> v7.2 =3D 730453
> v7.3-rc4 =3D 942251
> NO_WA_WEIGHT =3D 740454
> smp =3D 818483
>=20
> message-thread:32, worker-thread:4
> v7.2 =3D 74251
> v7.3-rc4 =3D 56725
> NO_WA_WEIGHT =3D 59008
> smp =3D 82053
>=20
> For the m:16 t:16 case that I originally bisected, disabling WA_WEIGHT
> does not materially change the regression. Switching to cgroup_mode=3Dsmp=
,
> however, recovers most of it.

I took flat back to 7.2 (to test only that) and did a little mixed load
7.2-virgin vs 7.2+flat testing with defaults. CPU distribution delta
when switching competitor load configuration from 1 group of 8 to 4
groups of 2 vs a fixed 4 client netperf load made it clear that numbers
for anything cgroup vs cgroup will definitely wiggle more than usual.

	-Mike
