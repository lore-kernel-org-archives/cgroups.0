Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E64391E43;
	Fri, 21 Aug 2026 10:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787308727; cv=none; b=tPKPwvTn9+1f3g7IymEH586VFA7mLmByYI0UX92pN/0/8v+BEsBQ1hUoPMwvWE1uvGdggpbFC+Cu3542fN19LJsiRnGHMByQdW1omka5KkvFxFFWZMgH+CRy0/GTGX/IKoFVeG8dIdfUlukncaUWTcBy/LAAj5UqYGfFyjeY1vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787308727; c=relaxed/simple;
	bh=gc2oq8j53nrEIfLo0W2/hqYffe9uWXz36YDkdy3vM6M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AX2+qjupeSGTCzI78RK1+oAhZ8o4WrW5VptvfSWMcD9B3aVXtm1p2odglpM359xXXRk0ABOohpkpbqC/0c/cVM16ZO4iWHeDiEMiYKVbA0dMVkfab5UvuZ+BpOsgxONAGIzAHfvOrlzsLcZB3HSEae45qC41EUNK7M3UIi4m1Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WOjXgZem; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WOjXgZem"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67L9VlIp1131493;
	Fri, 21 Aug 2026 10:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Lm+DaE
	oyJhYc4NWtUrXpggKTcNdP54L2gqm7nocFR6w=; b=WOjXgZem3y1m+lMzS6ZZiW
	hdFTSjSKe1zLHsu+0KdsSI2YyQ6/ITpIeL6ZIWH4HTyOChL0roBzdUORWfMXgWLH
	PoWWn/Daevk+fzB6EFgkT12P+S94sb8G6eFalQcSsyQof+wZYNR/27i1nFHAYbUb
	TjhktxHYLlAmwKeeTiYdYw0ZczgmqpG+fIsjE8wiyALo5+zYKOGUAIyD1PrKW/5q
	8DuHWtCrV30orBu5asQkPBpXJ4eFFJBX0M4yx+46CBQ5b456VfSzT6Zv2TL2uxVn
	aqkwodgAaP/XvneCXRoyp7MxuHtIsCiC5r6qXe9+/E2uS3OAw2a1fMjXZ3Su4/ZA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu4gj8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 10:37:33 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67LAQIno006463;
	Fri, 21 Aug 2026 10:37:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33ekm259-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 10:37:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67LAbS3T41681378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 10:37:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D701C20049;
	Fri, 21 Aug 2026 10:37:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E260420040;
	Fri, 21 Aug 2026 10:37:26 +0000 (GMT)
Received: from li-4c4c4544-0039-5810-8039-c8c04f434234.ibm.com (unknown [9.111.46.197])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Aug 2026 10:37:26 +0000 (GMT)
Message-ID: <84288ab70c4b17be9ddd7c73d4ef60678109e9d0.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/7] sched: Flatten the pick
From: Szabina Korbai <szkorbai@linux.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, mingo@kernel.org,
        longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
        mkoutny@suse.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jstultz@google.com, qyousef@layalina.io,
        euan@linux.ibm.com, huschle@linux.ibm.com
Date: Fri, 21 Aug 2026 11:37:26 +0100
In-Reply-To: <20260818091649.GC1247881@noisy.programming.kicks-ass.net>
References: <20260605105513.354837583@infradead.org>
	 <fecf5eb215b4b86bec11ca47eb6b5b17f5e0fea5.camel@linux.ibm.com>
	 <d690a668-7bb2-4cd1-a229-295e556d4f28@amd.com>
	 <ef9f077a6faafc747b3e144400dd3f5ad10e8e0a.camel@linux.ibm.com>
	 <20260818091649.GC1247881@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=CpuPtH4D c=1 sm=1 tr=0 ts=6a882a6d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=7jvryX0o1xBQLwhLMPUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: pTxS2JWnV9XWtDAuHN-B4fZruntqEA6L
X-Proofpoint-GUID: YpsSznFtNdCBeE8tkoS98BOcd5qS_ys3
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDA3OCBTYWx0ZWRfX1nCETWEW+lSt
 W8Qx+dXr/B+f2cQbTfTASk/AzMjWjzLNMtcFajDLlNT0N33qv8R7dKrv1xedH7bpbY63c7w3RxK
 +hbEyZko78cF5Fr21nNMWgyFvjtFZM8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDA3OCBTYWx0ZWRfX3tMvlunenjGl
 cc971/LdZy5ybAttoDHorUnMmwsnH9raUQEgADUDKEFrsqvcXeaWB5jXFX32sHy0nU/fym8RwLb
 RkV5TbOvQtNY/ATLjktk119qcG42PpE0+Q1yGYQAkYM0pZbOWjPRmJ8xvA6YXmBFow8wzCJACHz
 EI7ToioMYXrkhrSiWjwnpkKwmeJ71FqX9w1VRlm9Qn9ihaUZW/SVyTWScKCkPqqAYyQ+l/0QQmJ
 dHgRDpHiglU2C7ib/E9BsyTgqi4bzYx3T9SCefDCHfAAEB/HOz7ODT+8qB3hML/4jc3avAEwbyY
 1X20mPE3bev3dMoDvf+uYefC0WcnCwMGtzUROLzojTchbwWalGm2YyGo8CdPvNyt174Hww13OGs
 oK816+fqbfiK4ySHwQ1KU51huAAcdpyMCyQjosocGpkftKxu1393ik6DNpl8ttsS4WjzjfXoVNR
 +c2ZxpIwNg0+8Nd5Q0w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_03,2026-08-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608210078

On Tue, 2026-08-18 at 11:16 +0200, Peter Zijlstra wrote:
> On Tue, Aug 18, 2026 at 10:04:57AM +0100, Szabina Korbai wrote:
> > On Mon, 2026-08-17 at 22:05 +0530, K Prateek Nayak wrote:
> > > Hello Szabina,
> > >=20
> > > On 8/17/2026 9:35 PM, Szabina Korbai wrote:
> > > > Hello Peter,
> > > >=20
> > > > We ran the same benchmarks (schbench, sysbench, hackbench) as
> > > > Shubhang
> > > > has on s390 on an LPAR running fedora 43 with 32 vCPUs.
> > > >=20
> > > > We ran the benchmarks for each of the cgroup modes, and for the
> > > > baseline, we chose the commit prior to the patches
> > > > (f666241e6bd5 -
> > > > sched/fair: Unify cfs_rq throttling via
> > > > account_cfs_rq_runtime() ).
> > > >=20
> > > > We have also tried running stress-ng in parallel with the
> > > > benchmarks
> > > > (set to generate 50% or 90% utilization for each vCPU).
> > > >=20
> > > > Compared to simply running the benchmarks on their own, this
> > > > has
> > > > revealed some performance trade-offs that the move to a single
> > > > runqueue
> > > > can introduce.
> > >=20
> > > Are you using tip:sched/core at commit 68e3748781 ("sched/fair:
> > > Fix
> > > flat
> > > hierarchy") for the flat_cg numbers or did you checkout at
> > > 85570f10a4c6
> > > ("sched/eevdf: Move to a single runqueue")?
> > >=20
> > > There are a couple fixes for vruntime update and Vincent's
> > > optimizations
> > > for preemption bits which might make a difference to the overall
> > > results.
> >=20
> >=20
> > Hi Prateek,
> >=20
> > thank you, that's a good call. I did checkout at "Move to a single
> > runqueue". Let me try it with the fix included, see how the results
> > are
> > affected.
>=20
> I've not yet managed to digest your various benchmark results, but
> also
> double check that patch 6/7 from this series is not to 'blame' for
> the
> some of the changes.
>=20
> The 0day robot fingered that patch for at least one issue.
>=20
> In that case the benchmark threads ended up 'heavier' than before,
> which
> resulted in less preemptions. Probably ksoftirqd getting ran less and
> causing a regression in network throughput for that thing.
>=20
> I did suggest trying to change the slice of ksoftirqd down, such that
> it
> might be ran more readily, but I'm not sure that ever got tried.

Hello Peter,

I've repeated the benchmark runs by checking out at tip:sched/core
85570f10a4c6 - "sched/eevdf: Move to a single runqueue" and cherry-
picking the fix (tip:sched/core at commit 68e3748781 - "sched/fair: Fix
flat hierarchy") on top of it. The baseline was 4f166adb5cb0 -
sched/fair: Fix overflow in update_tg_cfs_runnable().

It does look like most of the regressions/inconsistencies I saw earlier
were addressed by applying Vincent's fix.

Overall the effect of the patch series on system performance is now
more positive than negative, though there are still some
regressions in some cases. (Up mode remains something of an outlier in
this regard.)

At this time I haven't yet applied Jake Steinman's patch (sched/fair:
floor tg_cpus() at 1), but neither did the system experience a kernel
panic.

Observations by benchmark:

HACKBENCH

More parallel threads/processes benefit more from the patch, while
fewer ones show regression - without an additional stress-ng workload.
This is the same trend that Shubhang's benchmark results showed.

With an additional stress-ng workload running in parallel, there is
regression in the hackbench benchmark, but the bogo-ops/second metric
of stress-ng does improve to a much greater degree (for example 1.30%
regression with 32 threads for concur mode - and a 66.22% improvement
to the stress-ng workload).

There was quite a high variance to the stress-ng results though,
especially to the baseline: worst was the 32 processes case where the
CV was 15.83%.

SCHBENCH

The improvement in p99.9 tail latency is now more consistent even at
90% CPU utilization. One exception is the 32 threads with no locking
case, which shows a ~5% regression in concur mode without the stress-ng
workload.

Additionally, with the stress-ng load set to 90% the p50 and p90
latency of the hackbench workload still does show regression under some
conditions.

Aside from up mode, schbench RPS and stress-ng bogo-ops/s values showed
more minor changes (<2% difference) individually, and usually balanced
each other out.

SYSBENCH

The two (sysbench and stress-ng) workloads together showed overall
performance improvement (~2%), but not sysbench on its own.


Numbers below:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  HACKBENCH RESULTS
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

* - CV over 5%

(lower =3D better)

Hackbench % diff from baseline by mode:

[s-00] Hackbench =E2=80=94 % diff from baseline by mode
+-------------------+---------+---------+---------+---------+---------+
| Argument          | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| 1 thread          | +2.07%  | +2.55%  | +2.14%  | +3.11%  | -5.10%  |
| 2 thread          | +2.65%  | +2.84%  | +2.16%  | +1.34%  | -1.37%  |
| 4 thread          | -1.98%  | -1.63%  | -1.62%  | -2.55%  | -5.29%  |
| 8 thread          | -5.71%  | -5.09%  | -5.19%  | -6.46%  | -8.83%  |
| 16 thread         | -9.62%  | -8.66%  | -9.09%  | -10.38% | -10.75% |
| 32 thread         | -7.47%  | -6.08%  | -6.11%  | -7.94%  | -1.15%* |
| 1 process         | +3.00%  | +3.28%  | +3.39%  | +2.61%  | -1.95%  |
| 2 process         | +2.22%  | +2.46%  | +2.70%  | +2.49%  | -0.51%  |
| 4 process         | -1.65%  | -0.90%  | -1.65%  | -2.28%  | -3.50%  |
| 8 process         | -4.45%  | -3.76%  | -4.66%  | -5.49%  | -8.01%  |
| 16 process        | -8.58%  | -7.75%  | -8.81%  | -9.53%  | -9.59%  |
| 32 process        | -6.56%  | -5.26%  | -5.86%  | -7.53%  | -0.57%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Hackbench =E2=80=94 % diff from baseline by mode
+-------------------+---------+---------+---------+---------+---------+
| Argument          | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| 1 thread          | +2.88%  | +3.44%  | +3.23%  | +3.25%  | +2.29%  |
| 2 thread          | -0.57%  | +0.16%  | -0.26%  | -0.88%  | +1.35%  |
| 4 thread          | +1.38%  | +1.77%  | +1.57%  | +1.08%  | -2.44%  |
| 8 thread          | +7.57%  | +8.20%  | +8.69%  | +7.22%  | +2.94%  |
| 16 thread         | -0.32%  | +0.36%  | +1.54%  | -1.13%  | +8.17%  |
| 32 thread         | -1.65%  | -0.61%  | -0.70%  | -2.50%  | +12.28% |
| 1 process         | +3.27%  | +2.87%  | +2.83%  | +3.11%  | +2.24%  |
| 2 process         | +0.09%  | +0.46%  | -0.10%  | -0.40%  | +1.80%  |
| 4 process         | +1.03%  | +1.66%  | +1.24%  | +0.79%  | -2.38%  |
| 8 process         | +7.82%  | +8.33%  | +9.05%  | +7.89%  | +4.85%* |
| 16 process        | +0.80%  | +1.55%  | +3.47%  | +0.23%  | +6.80%* |
| 32 process        | -1.09%  | +0.06%  | -0.12%  | -1.86%  | +17.00% |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Hackbench =E2=80=94 % diff from baseline by mode
+------------------+---------+---------+---------+---------+----------+
| Argument         | concur  | max     | smp     | tasks   | up       |
+------------------+---------+---------+---------+---------+----------+
| 1 thread         | +7.32%  | +7.55%  | +7.03%  | +5.90%  | +15.32%  |
| 2 thread         | +9.16%  | +9.38%  | +8.95%  | +8.19%  | +13.79%  |
| 4 thread         | +18.34% | +18.44% | +18.34% | +17.76% | +21.62%  |
| 8 thread         | +17.14% | +17.64% | +19.50% | +16.86% | +21.07%* |
| 16 thread        | +7.39%  | +8.01%  | +10.73% | +6.20%  | +26.18%  |
| 32 thread        | +0.14%  | +0.58%  | +0.87%  | -0.55%  | +22.58%* |
| 1 process        | +6.12%  | +7.08%  | +6.46%  | +5.84%  | +19.06%  |
| 2 process        | +8.79%  | +8.31%  | +8.60%  | +8.09%  | +14.79%  |
| 4 process        | +18.76% | +19.15% | +20.63% | +18.46% | +21.42%  |
| 8 process        | +17.55% | +17.99% | +19.75% | +16.96% | +19.02%* |
| 16 process       | +7.49%  | +8.22%  | +10.65% | +6.81%  | +25.28%  |
| 32 process       | +1.30%  | +2.95%  | +1.77%  | +0.50%  | +23.78%* |
+------------------+---------+---------+---------+---------+----------+


stress-ng (int64 stressor) mean % diff from baseline by stress level
(Hackbench):

(higher =3D better)

[s-50] Hackbench =E2=80=94 stress-ng mean % diff from baseline
+----------------+---------+----------+----------+---------+----------+
| Argument       | concur  | max      | smp      | tasks   | up       |
+----------------+---------+----------+----------+---------+----------+
| 1 thread       | -3.16%  | -2.78%   | -3.38%   | -2.90%  | -2.76%   |
| 2 thread       | -0.32%  | -0.48%   | -0.64%   | -0.23%  | -0.61%   |
| 4 thread       | +14.47% | +14.50%  | +14.76%  | +14.82% | +14.61%  |
| 8 thread       | +38.73% | +38.45%  | +39.97%  | +39.00% | +41.90%  |
| 16 thread      | +42.93% | +44.01%  | +46.30%* | +42.41% | +71.38%* |
| 32 thread      | +47.79% | +50.61%* | +50.44%* | +49.75% | +129.7=E2=80=
=A6* |
| 1 process      | -2.19%  | -2.80%   | -2.94%   | -2.56%  | -2.72%   |
| 2 process      | -0.30%  | -0.58%   | -0.76%   | -0.61%  | -0.49%   |
| 4 process      | +12.84% | +12.70%  | +12.97%  | +12.98% | +12.90%  |
| 8 process      | +37.22% | +36.93%  | +38.34%  | +37.60% | +40.19%  |
| 16 process     | +44.33% | +44.00%  | +48.00%* | +44.04% | +61.75%* |
| 32 process     | +51.70% | +51.24%* | +50.52%* | +51.62% | +142.8=E2=80=
=A6* |
+----------------+---------+----------+----------+---------+----------+


[s-90] Hackbench =E2=80=94 stress-ng mean % diff from baseline
+--------------+----------+----------+----------+----------+----------+
| Argument     | concur   | max      | smp      | tasks    | up       |
+----- --------+----------+----------+----------+----------+----------+
| 1 thread     | +2.68%   | +2.61%   | +2.63%   | +2.48%   | +5.19%   |
| 2 thread     | +5.85%   | +6.20%*  | +6.06%   | +5.92%   | +10.09%  |
| 4 thread     | +23.55%* | +23.53%* | +23.64%* | +23.79%* | +34.50%* |
| 8 thread     | +47.11%  | +47.47%* | +49.44%  | +47.59%  | +61.43%  |
| 16 thread    | +56.40%  | +58.08%* | +63.22%* | +55.92%  | +102.2=E2=80=
=A6* |
| 32 thread    | +58.54%  | +59.72%* | +60.52%* | +58.75%* | +164.9=E2=80=
=A6* |
| 1 process    | +2.16%   | +2.50%   | +2.44%   | +2.46%   | +5.99%   |
| 2 process    | +5.48%   | +5.37%   | +5.58%   | +5.70%   | +10.38%* |
| 4 process    | +23.87%* | +23.74%* | +25.94%* | +24.97%* | +33.32%* |
| 8 process    | +45.77%  | +46.32%  | +48.47%  | +46.12%  | +57.70%  |
| 16 process   | +56.41%  | +57.84%  | +62.58%* | +56.79%  | +100.9=E2=80=
=A6* |
| 32 process   | +66.22%  | +72.01%* | +65.52%* | +68.43%* | +178.1=E2=80=
=A6* |
+--------------+----------+----------+----------+----------+----------+


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SCHBENCH 16T -- LOCKING: NO
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Schbench % diff from baseline by mode:

(Latency: lower =3D better, RPS: higher =3D better)

[s-00] Schbench 16t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.00%  |
| Req p90  (us)     | +0.23%  | +0.23%  | +0.23%  | +0.23%  | -0.45%  |
| Req p99.9(us)     | -9.57%  | -6.84%  | -4.79%  | -6.84%  | -7.18%  |
| RPS p50  (req)    | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.35%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Schbench 16t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | -3.54%  | -3.81%  | -2.99%  | -3.27%  | -3.54%  |
| Req p90  (us)     | -2.19%  | -1.97%  | -1.75%  | -2.41%  | -3.29%  |
| Req p99.9(us)     | -3.11%  | -2.59%  | -0.52%  | -3.63%  | +1.82%  |
| RPS p50  (req)    | +0.96%  | +0.96%  | +1.28%  | +0.96%  | +0.64%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Schbench 16t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +3.52%  | +3.52%  | +3.52%  | +3.52%  | +3.52%  |
| Req p90  (us)     | +6.04%  | +6.24%  | +6.24%  | +6.04%  | +25.91% |
| Req p99.9(us)     | -16.82% | -14.59% | -14.18% | -17.63% | -3.24%  |
| RPS p50  (req)    | +0.37%  | +0.37%  | +0.37%  | +0.37%  | -4.08%  |
+-------------------+---------+---------+---------+---------+---------+


stress-ng (int64 stressor) bogo-ops/s statistics by stress level
(schbench):

(higher =3D better)

[s-50] Schbench 16t -- Locking: No =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 442.34     | =C2=B10.48%  | 0.48% |
+----------+------------+---------+-------+
| concur   | -1.32%     | =C2=B10.76%  | 0.76% |
| max      | -1.28%     | =C2=B10.86%  | 0.86% |
| smp      | -1.37%     | =C2=B10.77%  | 0.77% |
| tasks    | -1.23%     | =C2=B10.75%  | 0.75% |
| up       | -1.07%     | =C2=B10.45%  | 0.45% |
+----------+------------+---------+-------+


[s-90] Schbench 16t -- Locking: No =E2=80=94 stress-ng vs baseline
+----------+------------+---------+--------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV     |
+----------+------------+---------+--------+
| baseline | 524.18     | =C2=B11.51%  | 1.50%  |
+----------+------------+---------+--------+
| concur   | +0.03%     | =C2=B11.19%  | 1.19%  |
| max      | +0.17%     | =C2=B11.57%  | 1.57%  |
| smp      | +0.18%     | =C2=B11.16%  | 1.16%  |
| tasks    | +0.14%     | =C2=B11.25%  | 1.25%  |
| up       | +4.94%     | =C2=B113.42% | 13.42% |
+----------+------------+---------+--------+


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SCHBENCH 16T -- LOCKING: YES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Schbench % diff from baseline by mode:

(Latency: lower =3D better, RPS: higher =3D better)

[s-00] Schbench 16t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.00%  |
| Req p90  (us)     | +0.23%  | +0.23%  | +0.00%  | +0.23%  | -0.23%  |
| Req p99.9(us)     | -10.29% | -13.01% | -10.59% | -13.92% | -17.55% |
| RPS p50  (req)    | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.35%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Schbench 16t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | -3.21%  | -2.95%  | -2.68%  | -2.95%  | -5.35%  |
| Req p90  (us)     | -3.33%  | -3.33%  | -2.22%  | -3.70%  | -6.56%  |
| Req p99.9(us)     | -3.15%  | -5.15%  | -5.72%  | -5.72%  | -9.44%  |
| RPS p50  (req)    | +1.37%  | +1.37%  | +1.03%  | +1.37%  | +2.39%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Schbench 16t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +3.51%  | +3.51%  | +3.26%  | +3.51%  | +2.01%  |
| Req p90  (us)     | -0.76%  | -0.38%  | -0.38%  | -0.76%  | +9.56%  |
| Req p99.9(us)     | -7.08%  | -2.10%  | -0.26%  | -6.82%  | +32.77% |
| RPS p50  (req)    | +0.77%  | +0.77%  | +0.77%  | +0.77%  | -3.56%  |
+-------------------+---------+---------+---------+---------+---------+

stress-ng (int64 stressor) bogo-ops/s statistics by stress level
(schbench):

(higher =3D better)

[s-50] Schbench 16t -- Locking: Yes =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 453.53     | =C2=B10.38%  | 0.38% |
+----------+------------+---------+-------+
| concur   | -1.54%     | =C2=B10.53%  | 0.53% |
| max      | -1.57%     | =C2=B10.60%  | 0.60% |
| smp      | -1.59%     | =C2=B10.68%  | 0.68% |
| tasks    | -1.59%     | =C2=B10.55%  | 0.55% |
| up       | -1.92%     | =C2=B10.58%  | 0.59% |
+----------+------------+---------+-------+


[s-90] Schbench 16t -- Locking: Yes =E2=80=94 stress-ng vs baseline
+----------+------------+---------+--------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV     |
+----------+------------+---------+--------+
| baseline | 531.40     | =C2=B11.73%  | 1.73%  |
+----------+------------+---------+--------+
| concur   | -0.26%     | =C2=B11.14%  | 1.14%  |
| max      | -0.16%     | =C2=B11.71%  | 1.71%  |
| smp      | -0.13%     | =C2=B11.49%  | 1.49%  |
| tasks    | -0.32%     | =C2=B11.19%  | 1.19%  |
| up       | +1.91%     | =C2=B110.60% | 10.60% |
+----------+------------+---------+--------+

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SCHBENCH 32T -- LOCKING: NO
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Schbench % diff from baseline by mode:

(Latency: lower =3D better, RPS: higher =3D better)

[s-00] Schbench 32t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.00%  |
| Req p90  (us)     | -0.23%  | +0.00%  | +0.00%  | -0.45%  | -0.23%  |
| Req p99.9(us)     | +5.14%  | +1.47%  | +6.97%  | +3.30%  | -1.10%  |
| RPS p50  (req)    | +0.00%  | +0.00%  | -0.35%  | +0.00%  | +0.00%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Schbench 32t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | -2.70%  | -2.70%  | -2.43%  | -2.16%  | -1.62%  |
| Req p90  (us)     | -2.20%  | -1.98%  | -2.20%  | -2.20%  | -3.51%  |
| Req p99.9(us)     | -3.40%  | -1.05%  | -1.57%  | -2.61%  | +0.00%  |
| RPS p50  (req)    | +1.27%  | +1.27%  | +1.27%  | +1.27%  | +1.58%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Schbench 32t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +3.27%  | +3.27%  | +3.02%  | +3.27%  | +3.27%  |
| Req p90  (us)     | +12.35% | +12.35% | +12.13% | +12.13% | +32.08% |
| Req p99.9(us)     | -16.45% | -16.06% | -17.04% | -16.06% | -6.07%  |
| RPS p50  (req)    | +1.11%  | +1.11%  | +1.11%  | +1.11%  | -3.34%  |
+-------------------+---------+---------+---------+---------+---------+

stress-ng (int64 stressor) bogo-ops/s statistics by stress level
(schbench):

(higher =3D better)

[s-50] Schbench 32t -- Locking: No =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 438.90     | =C2=B10.49%  | 0.48% |
+----------+------------+---------+-------+
| concur   | -1.55%     | =C2=B10.63%  | 0.63% |
| max      | -1.59%     | =C2=B10.71%  | 0.71% |
| smp      | -1.50%     | =C2=B10.79%  | 0.79% |
| tasks    | -1.49%     | =C2=B10.63%  | 0.63% |
| up       | -1.86%     | =C2=B10.62%  | 0.62% |
+----------+------------+---------+-------+


[s-90] Schbench 32t -- Locking: No =E2=80=94 stress-ng vs baseline
+----------+------------+---------+--------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV     |
+----------+------------+---------+--------+
| baseline | 523.09     | =C2=B11.70%  | 1.70%  |
+----------+------------+---------+--------+
| concur   | -0.33%     | =C2=B11.21%  | 1.21%  |
| max      | -0.29%     | =C2=B11.36%  | 1.36%  |
| smp      | -0.40%     | =C2=B11.24%  | 1.24%  |
| tasks    | -0.27%     | =C2=B11.31%  | 1.31%  |
| up       | +3.62%     | =C2=B111.49% | 11.49% |
+----------+------------+---------+--------+

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SCHBENCH 32T -- LOCKING: YES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Schbench % diff from baseline by mode:

(Latency: lower =3D better, RPS: higher =3D better)

[s-00] Schbench 32t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.00%  |
| Req p90  (us)     | +0.00%  | +0.23%  | +0.23%  | +0.23%  | -0.45%  |
| Req p99.9(us)     | -19.66% | -11.98% | -18.98% | -24.41% | -36.38% |
| RPS p50  (req)    | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.35%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Schbench 32t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | -3.18%  | -3.18%  | -3.44%  | -3.18%  | -3.18%  |
| Req p90  (us)     | -2.59%  | -2.22%  | -1.85%  | -2.96%  | -5.45%  |
| Req p99.9(us)     | -2.97%  | -1.49%  | -2.38%  | -3.27%  | -6.54%  |
| RPS p50  (req)    | +1.70%  | +1.36%  | +1.36%  | +1.36%  | +3.06%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Schbench 32t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +3.27%  | +3.27%  | +3.02%  | +3.27%  | +1.76%  |
| Req p90  (us)     | +2.69%  | +2.69%  | +2.69%  | +2.69%  | +47.36% |
| Req p99.9(us)     | -8.60%  | -8.60%  | -2.28%  | -8.60%  | +41.34% |
| RPS p50  (req)    | +1.54%  | +1.54%  | +1.54%  | +1.54%  | -7.39%  |
+-------------------+---------+---------+---------+---------+---------+

stress-ng (int64 stressor) bogo-ops/s statistics by stress level
(schbench):

(higher =3D better)

[s-50] Schbench 32t -- Locking: Yes =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 451.63     | =C2=B10.40%  | 0.40% |
+----------+------------+---------+-------+
| concur   | -1.82%     | =C2=B10.45%  | 0.45% |
| max      | -1.80%     | =C2=B10.45%  | 0.45% |
| smp      | -1.72%     | =C2=B10.55%  | 0.55% |
| tasks    | -1.76%     | =C2=B10.46%  | 0.47% |
| up       | -2.61%     | =C2=B10.87%  | 0.87% |
+----------+------------+---------+-------+


[s-90] Schbench 32t -- Locking: Yes =E2=80=94 stress-ng vs baseline
+----------+------------+---------+--------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV     |
+----------+------------+---------+--------+
| baseline | 529.80     | =C2=B11.78%  | 1.78%  |
+----------+------------+---------+--------+
| concur   | -0.75%     | =C2=B11.12%  | 1.12%  |
| max      | -0.72%     | =C2=B11.14%  | 1.14%  |
| smp      | -0.66%     | =C2=B10.96%  | 0.96%  |
| tasks    | -0.67%     | =C2=B11.19%  | 1.19%  |
| up       | +5.03%     | =C2=B115.81% | 15.81% |
+----------+------------+---------+--------+


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SYSBENCH RESULTS
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Sysbench throughput % diff from baseline by mode:

(higher =3D better)

[s-00] Sysbench =E2=80=94 % diff from baseline by mode
+-------------------+---------+---------+---------+---------+---------+
| Argument          | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| memory            | -0.18%  | +0.12%  | -0.36%  | -0.18%  | +0.00%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Sysbench =E2=80=94 % diff from baseline by mode
+-------------------+---------+---------+---------+---------+---------+
| Argument          | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| memory            | -1.71%  | -0.43%  | -0.71%  | -1.07%  | -2.21%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Sysbench =E2=80=94 % diff from baseline by mode
+-------------------+---------+---------+---------+---------+---------+
| Argument          | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| memory            | +2.94%  | +3.97%  | +3.46%  | +4.34%  | -6.76%  |
+-------------------+---------+---------+---------+---------+---------+



stress-ng (int64 stressor) mean % diff from baseline by stress level
(Sysbench):

(higher =3D better)

[s-50] Sysbench =E2=80=94 stress-ng mean % diff from baseline
+-------------------+---------+---------+---------+---------+---------+
| Argument          | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| memory            | +3.59%  | +2.78%  | +4.36%  | +3.60%  | +1.46%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Sysbench =E2=80=94 stress-ng mean % diff from baseline
+-------------------+---------+---------+---------+---------+---------+
| Argument          | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| memory            | +0.85%  | -1.35%  | -0.00%  | -1.79%  | +18.47% |
+-------------------+---------+---------+---------+---------+---------+


Regards,

--=20
Szabina Korbai

Linux on Z development
Software Labs Campus Unlimited Company
25 North Wall Quay,
Dublin 1,
D01 H104,
Ireland

szkorbai@linux.ibm.com


IBM
