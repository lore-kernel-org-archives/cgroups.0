Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D111D425CEE;
	Mon, 17 Aug 2026 16:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786982780; cv=none; b=ACAxJAztXdKLcV53Qy5YElpudwJ76JB9LltvRn5YabjnJhIJDu4+voKALgMmciwj+xjGHmUEtbgnftJJi7HgbziACoJ4FRDx1xNwoftg4WLcSr0Qal0sV6OmO4YWLwpUpdUUuQzUNhYJrJzuuJ4lgBB3HVV026mZkYP/gozPIiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786982780; c=relaxed/simple;
	bh=8tEW5aI1pJhx2DzRELe9uxi5+myfyP+wflnN0Fw9AcI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XST8q10bTf0e/Pbaaly4gIkBbxrLSOit2iehjv0Yt9anjbYbswMYalTqzUVFaOwr7X/I7RxZq3+pnulLfM1m/72bux7WPBZCQOuxgW2LE/h+cgqAR7NzO8pwmOZ8cLkaAWY+J+/DkHIXcV/wvedwYIvDabBZ/V42ryA9oowU+Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UiXbhiEE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UiXbhiEE"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HFfWI04133382;
	Mon, 17 Aug 2026 16:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RjPKkN
	rr6XnomC0L1kzwz/F6nx2VhUoS3MxrxAPD5i0=; b=UiXbhiEEKdJ2cTZJI6eojk
	Npxo3Qy+ymRy0XbuT1znufDWrrvASR4ESix1VOgo1AvZFAYrUHcrHaTod86eb/mt
	wO877LSQrIpKWHUZJ+3aHp8CCgEKFqc2iezv/6UaHPvrTLQAKJHEhA4eh4ExfnKu
	AhqZYmIAzYFt8zTPU2uV2nE3ofNtw1LWaHnwNIEALGqFE3GqPQpmcIKr6K5wpCPC
	ZG9gkFr1WSDtJFqzSSRzz9bOw+qg8cFB362B/dgKruRFHs/uoCZphpOx+PM6BYIp
	Fppz1rlmkd/IYA/YKN11yayTkmd6G2GNlaGdEjpNweDxwZjhLOutBUlqsVxibQCw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fsqk4qs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 16:05:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HFuQE8023307;
	Mon, 17 Aug 2026 16:05:32 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xgxnfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 16:05:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HG5SjP51315038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 16:05:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E85092004E;
	Mon, 17 Aug 2026 16:05:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0355B2005A;
	Mon, 17 Aug 2026 16:05:27 +0000 (GMT)
Received: from li-4c4c4544-0039-5810-8039-c8c04f434234.ibm.com (unknown [9.111.67.227])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 16:05:26 +0000 (GMT)
Message-ID: <fecf5eb215b4b86bec11ca47eb6b5b17f5e0fea5.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/7] sched: Flatten the pick
From: Szabina Korbai <szkorbai@linux.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org
Cc: longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
        mkoutny@suse.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jstultz@google.com,
        kprateek.nayak@amd.com, qyousef@layalina.io, euan@linux.ibm.com,
        huschle@linux.ibm.com
Date: Mon, 17 Aug 2026 17:05:26 +0100
In-Reply-To: <20260605105513.354837583@infradead.org>
References: <20260605105513.354837583@infradead.org>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDEyMyBTYWx0ZWRfX/tPf9nXXRYwq
 1nSbOdQvuvYnLnUt9/IWToZAWELAlsvoWoby2QVD3WwZZ3EZRxGIKi3KU+UH/IaqnADSzUwT0SR
 TgfBOTNe9w46EGBBbBRJZts/JY3TbtdPFMDUk3lmookCwh0I1Rtdl2fQHfU8rgLkOXtghgAQJIF
 zasNUcxCLlvjvnP7q0wFbVmtCntVHRyTwyvQbif1CUeiIxXLYg1nuv2f7XI+ilQMcvrmX8G8BC+
 V3LMs1TvD63Fjoh5oK7k4FzSZQLE1Us8oqwf3TsWdsD/3DNeMz2KamXz+SyBTW9lBCsOk+vuSeC
 BxqDTigta+7J7YNz4CCOTghnRkfGd+2QYPR1M/LBAd1DS18c/u1BV8DN73Ew0SDxCrIarRZEyss
 99N5DO1RY5FfZkYBJLB89i8+vzxuKfGgVjZUIji6oV1H3oGvMEiGnEf4iqNO4Ei1h8YumKI+Czg
 rYLMAjUj04EgtdVgENw==
X-Proofpoint-ORIG-GUID: dkJao_hzTgav2BF6pMSplo8xSO2HcLZI
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDEyMyBTYWx0ZWRfXw9XAEfcLDg0G
 3shaIzapdhx5hmwUHLKIj2X0F/B1ZMzVJFTWMnSLGtcbNIqTWhEmNkMpmcm8xDTbdKBOl6AUYBd
 MJuzyD2Vn6rg7IBm2fn3Z1EXfLjNtXk=
X-Authority-Analysis: v=2.4 cv=DJe/JSNb c=1 sm=1 tr=0 ts=6a83314e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=7kUOe9JQjjZ_hdsZbSUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: T4tRtnwL1e9cE3WiiSDPjxVoD2LowekV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_02,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1011 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170123

Hello Peter,

We ran the same benchmarks (schbench, sysbench, hackbench) as Shubhang
has on s390 on an LPAR running fedora 43 with 32 vCPUs.

We ran the benchmarks for each of the cgroup modes, and for the
baseline, we chose the commit prior to the patches (f666241e6bd5 -
sched/fair: Unify cfs_rq throttling via account_cfs_rq_runtime() ).

We have also tried running stress-ng in parallel with the benchmarks
(set to generate 50% or 90% utilization for each vCPU).

Compared to simply running the benchmarks on their own, this has
revealed some performance trade-offs that the move to a single runqueue
can introduce.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  HACKBENCH (via phoronix-test-suite pts/hackbench)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The hackbench results were quite consistent, CV was under 2.5% in most
cases, a '*' marks the cases where they weren't.

What we've found is that if there is no other workload running, the
results were generally favorable, especially for higher number of
threads/processes.

However, with stress-ng also running in parallel, while the high
thread/process count cases showed even greater improvement, the lower-
count cases actually started to regress, which got worse at higher CPU
utilization.

To compound this problem, the stress-ng results also showed regression
(the stress-ng figures were recorded over the whole hackbench stress-ng
run for a specific mode, so currently there is no higher granularity
data for the 32 process case for example).

(lower =3D better)

Hackbench % diff from baseline by mode:

[s-00] Hackbench =E2=80=94 % diff from baseline by mode
+-------------------+---------+---------+---------+---------+---------+
| Hackbench arg     | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| 1 thread          | -0.40%  | +0.81%  | +0.40%  | +0.37%  | -2.82%  |
| 2 thread          | -0.50%  | -0.96%  | -0.65%  | -1.68%  | -1.55%  |
| 4 thread          | -3.67%  | -3.95%  | -4.27%  | -3.67%  | -5.38%  |
| 8 thread          | -6.21%  | -6.62%  | -6.86%  | -6.30%  | -9.55%  |
| 16 thread         | -8.90%  | -9.09%  | -9.21%  | -8.58%  | -8.39%  |
| 32 thread         | -6.67%  | -6.57%  | -6.84%  | -6.25%  | -5.64%  |
| 1 process         | +1.41%  | +0.84%  | +0.19%  | +2.36%  | -3.50%  |
| 2 process         | +0.23%  | +0.91%  | +0.00%  | +1.49%  | -0.75%  |
| 4 process         | -3.21%  | -2.98%  | -3.54%  | -3.31%  | -5.57%  |
| 8 process         | -5.55%  | -5.40%  | -5.53%  | -5.56%  | -8.47%  |
| 16 process        | -7.77%  | -7.75%  | -8.33%  | -7.47%  | -7.89%  |
| 32 process        | -7.44%  | -6.92%  | -7.19%  | -4.76%  | -6.89%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Hackbench =E2=80=94 % diff from baseline by mode
+------------------+---------+---------+---------+---------+----------+
| Hackbench arg    | concur  | max     | smp     | tasks   | up       |
+------------------+---------+---------+---------+---------+----------+
| 1 thread         | +5.73%  | +0.98%  | +0.65%  | +0.77%  | -0.46%   |
| 2 thread         | +3.24%  | -1.82%  | -2.04%  | -2.11%  | -0.65%   |
| 4 thread         | -2.51%  | -4.50%  | -4.49%  | -4.18%  | -8.75%   |
| 8 thread         | -9.29%  | -18.48% | -18.05% | -18.33% | -21.06%  |
| 16 thread        | -14.77% | -35.28% | -34.42% | -35.24% | -28.20%* |
| 32 thread        | -5.79%  | -39.03% | -38.58% | -39.16% | -27.75%  |
| 1 process        | +6.35%  | +1.20%  | +1.01%  | +0.87%  | +0.34%   |
| 2 process        | +3.91%  | -1.87%  | -1.90%  | -2.26%  | -0.54%   |
| 4 process        | -1.71%  | -3.54%  | -3.95%  | -3.69%  | -7.42%   |
| 8 process        | -8.96%  | -17.83% | -17.35% | -17.82% | -21.43%  |
| 16 process       | -14.86% | -34.80% | -33.98% | -35.37% | -30.54%  |
| 32 process       | -6.72%  | -38.85% | -38.81% | -39.50% | -33.24%  |
+------------------+---------+---------+---------+---------+----------+


[s-90] Hackbench =E2=80=94 % diff from baseline by mode
+-----------------+----------+---------+---------+---------+----------+
| Hackbench arg   | concur   | max     | smp     | tasks   | up       |
+-----------------+----------+---------+---------+---------+----------+
| 1 thread        | +17.81%  | +18.24% | +17.29% | +17.40% | +31.11%  |
| 2 thread        | +5.81%   | +5.43%  | +6.34%  | +5.59%  | +11.62%  |
| 4 thread        | -8.69%   | -8.65%  | -7.40%  | -8.80%  | -5.85%   |
| 8 thread        | -22.75%  | -22.69% | -21.47% | -22.88% | -23.04%  |
| 16 thread       | -37.81%  | -37.71% | -36.49% | -37.84% | -28.13%  |
| 32 thread       | -39.75%  | -39.97% | -39.45% | -40.06% | -32.54%  |
| 1 process       | +23.63%* | +22.55% | +22.17% | +21.17% | +34.84%  |
| 2 process       | +7.54%   | +7.44%  | +7.34%  | +7.47%  | +13.74%  |
| 4 process       | -6.61%   | -6.87%  | -5.53%  | -6.45%  | -4.03%   |
| 8 process       | -21.92%  | -21.70% | -20.40% | -21.79% | -21.90%  |
| 16 process      | -37.17%  | -36.92% | -35.98% | -37.31% | -30.01%* |
| 32 process      | -39.20%  | -38.32% | -39.03% | -39.19% | -25.16%* |
+-----------------+----------+---------+---------+---------+----------+

stress-ng bogo-ops/s statistics by stress level (Hackbench):

(higher =3D better)

[s-50] Hackbench =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| concur   | -3.35%     | =C2=B10.15%  | 0.15% |
| max      | -29.48%    | =C2=B10.75%  | 0.75% |
| smp      | -29.57%    | =C2=B10.68%  | 0.68% |
| tasks    | -30.01%    | =C2=B10.42%  | 0.42% |
| up       | -24.68%    | =C2=B12.27%  | 2.26% |
+----------+------------+---------+-------+


[s-90] Hackbench =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| concur   | -13.55%    | =C2=B10.23%  | 0.23% |
| max      | -20.19%    | =C2=B10.44%  | 0.44% |
| smp      | -19.72%    | =C2=B10.57%  | 0.57% |
| tasks    | -20.61%    | =C2=B10.33%  | 0.33% |
| up       | -25.52%*   | =C2=B15.86%  | 5.86% |
+----------+------------+---------+-------+


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SYSBENCH (via phoronix-test-suite ciunas/sysbench) - throughput
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The sysbench results showed small improvements, but more interesting
were the stress-ng results, showing regressions across all modes at 50%
CPU utilization, but improvements at 90%.

RAM/Memory testcase

(higher =3D better)

Sysbench % diff from baseline by mode:

[s-00] Sysbench =E2=80=94 % diff from baseline by mode
+-------------------+---------+---------+---------+---------+---------+
|                   | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| memory run        | -3.91%  | +0.02%  | -4.05%  | +0.44%  | -4.11%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Sysbench =E2=80=94 % diff from baseline by mode
+-------------------+---------+---------+---------+---------+---------+
|                   | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| memory run        | +2.84%  | +1.09%  | +0.73%  | +2.62%  | +1.91%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Sysbench =E2=80=94 % diff from baseline by mode
+-------------------+---------+---------+---------+---------+---------+
|                   | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| memory run        | +1.83%  | +4.03%  | +2.64%  | +1.16%  | -12.52% |
+-------------------+---------+---------+---------+---------+---------+


stress-ng bogo-ops/s statistics by stress level (Sysbench):

(higher =3D better)

[s-50] Sysbench =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 588.34     | =C2=B11.72%  | 1.72% |
+----------+------------+---------+-------+
| concur   | -10.77%    | =C2=B12.52%  | 2.52% |
| max      | -6.24%     | =C2=B12.21%  | 2.21% |
| smp      | -6.16%     | =C2=B11.93%  | 1.93% |
| tasks    | -8.51%     | =C2=B13.21%  | 3.21% |
| up       | -10.88%    | =C2=B13.25%  | 3.25% |
+----------+------------+---------+-------+


[s-90] Sysbench =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 726.96     | =C2=B12.00%  | 2.00% |
+----------+------------+---------+-------+
| concur   | +4.22%     | =C2=B11.24%  | 1.24% |
| max      | +4.00%     | =C2=B10.90%  | 0.90% |
| smp      | +3.10%     | =C2=B11.73%  | 1.73% |
| tasks    | +4.28%     | =C2=B11.83%  | 1.83% |
| up       | +15.61%    | =C2=B15.10%  | 5.10% |
+----------+------------+---------+-------+

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SCHBENCH
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

All testruns were done with footprint set to 128kb.

There is some variability between the different test environments
(especially between the 32 threads-locking-yes case and the others),
but there is a general pattern.

Without stress-ng running in parallel, over the different test cases,
we did generally see a reduction in tail latency while other metrics
remained largely unchanged.

At 50% cpu utilization, tail latency is still improved (or close to the
noise floor), but average latency shows a more significant regression.

Then, at 90% cpu utilization, all latency components show regression,
tail latency the most of all.

RPS is not impacted as strongly.

Throughout this the stress-ng benchmark results show improvement at 90%
cpu utilization, while at 50% the changes are quite close to the noise
floor.


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SCHBENCH 16T -- LOCKING: NO
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Schbench % diff from baseline by mode:

(Request latency percentiles: lower =3D better; RPS: higher =3D better)

[s-00] Schbench 16t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.00%  |
| Req p90  (us)     | -0.23%  | +0.00%  | +0.00%  | +0.00%  | -0.23%  |
| Req p99.9(us)     | -7.23%  | -5.16%  | -3.10%  | -5.85%  | -5.51%  |
| RPS p50  (req)    | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.35%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Schbench 16t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +13.51% | +15.57% | +15.27% | +13.80% | +14.68% |
| Req p90  (us)     | -1.48%  | +2.32%  | +2.53%  | -2.11%  | +1.48%  |
| Req p99.9(us)     | -8.99%  | -7.53%  | -5.35%  | -8.75%  | +4.86%  |
| RPS p50  (req)    | +3.65%  | +1.00%  | +1.00%  | +3.65%  | +0.66%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Schbench 16t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +7.72%  | +7.72%  | +7.46%  | +7.72%  | +8.49%  |
| Req p90  (us)     | +4.76%  | +4.36%  | +4.76%  | +4.76%  | +19.35% |
| Req p99.9(us)     | +34.35% | +34.35% | +34.35% | +34.35% | +38.10% |
| RPS p50  (req)    | -1.09%  | +0.00%  | +0.00%  | -1.09%  | -7.56%  |
+-------------------+---------+---------+---------+---------+---------+


stress-ng bogo-ops/s statistics by stress level (schbench):

[s-50] Schbench 16t -- Locking: No =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| concur   | -2.17%     | =C2=B11.50%  | 1.50% |
| max      | +1.08%     | =C2=B11.61%  | 1.61% |
| smp      | +0.37%     | =C2=B11.63%  | 1.63% |
| tasks    | -2.20%     | =C2=B11.00%  | 1.00% |
| up       | +2.27%     | =C2=B11.56%  | 1.56% |
+----------+------------+---------+-------+


[s-90] Schbench 16t -- Locking: No =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| concur   | +3.23%     | =C2=B11.05%  | 1.05% |
| max      | -0.25%     | =C2=B11.12%  | 1.12% |
| smp      | +0.93%     | =C2=B12.70%  | 2.70% |
| tasks    | +1.33%     | =C2=B11.62%  | 1.62% |
| up       | +8.09%     | =C2=B15.19%  | 5.18% |
+----------+------------+---------+-------+



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SCHBENCH 16T -- LOCKING: YES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Schbench % diff from baseline by mode:

(Request latency percentiles: lower =3D better; RPS: higher =3D better)

[s-00] Schbench 16t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.00%  |
| Req p90  (us)     | +0.23%  | +0.23%  | +0.23%  | +0.23%  | +0.00%  |
| Req p99.9(us)     | -12.86% | -15.25% | -2.39%  | -11.66% | -8.67%  |
| RPS p50  (req)    | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.35%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Schbench 16t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +10.16% | +11.85% | +11.85% | +10.16% | +11.00% |
| Req p90  (us)     | -0.36%  | +4.63%  | +5.35%  | -0.36%  | +2.50%  |
| Req p99.9(us)     | +0.58%  | +0.87%  | +4.05%  | -1.45%  | +2.03%  |
| RPS p50  (req)    | +3.21%  | -0.36%  | +0.00%  | +2.85%  | +0.71%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Schbench 16t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +7.70%  | +7.45%  | +7.45%  | +7.70%  | +9.24%  |
| Req p90  (us)     | +4.13%  | +1.50%  | +3.38%  | +3.75%  | +102.2=E2=80=
=A6 |
| Req p99.9(us)     | +18.21% | +13.94% | +16.22% | +13.66% | +306.8=E2=80=
=A6 |
| RPS p50  (req)    | -1.52%  | -0.38%  | -0.38%  | -1.52%  | -26.95% |
+-------------------+---------+---------+---------+---------+---------+

stress-ng bogo-ops/s statistics by stress level (schbench):

[s-50] Schbench 16t -- Locking: Yes =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| concur   | -1.29%     | =C2=B11.16%  | 1.16% |
| max      | +1.26%     | =C2=B11.18%  | 1.17% |
| smp      | +1.18%     | =C2=B11.15%  | 1.15% |
| tasks    | +0.02%     | =C2=B12.05%  | 2.04% |
| up       | +2.31%     | =C2=B12.56%  | 2.56% |
+----------+------------+---------+-------+


[s-90] Schbench 16t -- Locking: Yes =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| concur   | +6.16%     | =C2=B11.47%  | 1.47% |
| max      | +3.10%     | =C2=B11.89%  | 1.89% |
| smp      | +3.91%     | =C2=B11.83%  | 1.83% |
| tasks    | +5.68%     | =C2=B11.87%  | 1.87% |
| up       | +16.60%    | =C2=B18.60%  | 8.60% |
+----------+------------+---------+-------+


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SCHBENCH 32T -- LOCKING: NO
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Schbench % diff from baseline by mode:

(Request latency percentiles: lower =3D better; RPS: higher =3D better)

[s-00] Schbench 32t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.00%  |
| Req p90  (us)     | +0.00%  | +0.00%  | -0.23%  | +0.00%  | -0.23%  |
| Req p99.9(us)     | -4.80%  | -3.77%  | -6.17%  | -7.55%  | -10.98% |
| RPS p50  (req)    | +0.35%  | +0.35%  | +0.35%  | +0.35%  | +0.35%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Schbench 32t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +11.76% | +13.77% | +13.49% | +11.76% | +12.63% |
| Req p90  (us)     | -2.52%  | +2.31%  | +2.31%  | -2.73%  | -0.63%  |
| Req p99.9(us)     | -8.99%  | -6.80%  | -4.13%  | -9.96%  | +2.43%  |
| RPS p50  (req)    | +2.61%  | -0.65%  | -0.33%  | +2.61%  | +0.65%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Schbench 32t -- Locking: No
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +5.55%  | +5.55%  | +5.55%  | +5.55%  | +7.06%  |
| Req p90  (us)     | +2.62%  | +2.62%  | +2.62%  | +2.62%  | +32.73% |
| Req p99.9(us)     | +31.57% | +31.11% | +31.57% | +31.57% | +34.33% |
| RPS p50  (req)    | +1.46%  | +2.55%  | +2.55%  | +1.46%  | -10.66% |
+-------------------+---------+---------+---------+---------+---------+


stress-ng bogo-ops/s statistics by stress level (schbench):

[s-50] Schbench 32t -- Locking: No =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 478.27     | =C2=B11.98%  | 1.99% |
+----------+------------+---------+-------+
| concur   | -2.85%     | =C2=B11.45%  | 1.45% |
| max      | +0.12%     | =C2=B11.95%  | 1.95% |
| smp      | -0.23%     | =C2=B11.22%  | 1.22% |
| tasks    | -2.39%     | =C2=B11.96%  | 1.96% |
| up       | -0.27%     | =C2=B11.59%  | 1.59% |
+----------+------------+---------+-------+


[s-90] Schbench 32t -- Locking: No =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 577.45     | =C2=B10.69%  | 0.70% |
+----------+------------+---------+-------+
| concur   | +2.17%     | =C2=B11.54%  | 1.54% |
| max      | +0.25%     | =C2=B11.28%  | 1.28% |
| smp      | -0.33%     | =C2=B11.42%  | 1.42% |
| tasks    | +1.07%     | =C2=B11.17%  | 1.17% |
| up       | +10.70%    | =C2=B15.47%  | 5.47% |
+----------+------------+---------+-------+


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  SCHBENCH 32T -- LOCKING: YES
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Schbench % diff from baseline by mode:

(Request latency percentiles: lower =3D better; RPS: higher =3D better)

[s-00] Schbench 32t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +0.00%  | +0.00%  | +0.00%  | +0.00%  | +0.00%  |
| Req p90  (us)     | +0.00%  | +0.00%  | +0.00%  | +0.00%  | -0.23%  |
| Req p99.9(us)     | +7.31%  | +10.05% | +13.70% | +10.35% | -16.74% |
| RPS p50  (req)    | +0.00%  | +0.00%  | +0.00%  | +0.35%  | +0.35%  |
+-------------------+---------+---------+---------+---------+---------+


[s-50] Schbench 32t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +8.30%  | +9.96%  | +9.96%  | +8.30%  | +9.41%  |
| Req p90  (us)     | -0.71%  | +3.54%  | +4.60%  | -0.71%  | +0.00%  |
| Req p99.9(us)     | -4.05%  | +3.76%  | +3.47%  | -2.89%  | -4.92%  |
| RPS p50  (req)    | +2.11%  | -1.05%  | -1.41%  | +2.11%  | +1.05%  |
+-------------------+---------+---------+---------+---------+---------+


[s-90] Schbench 32t -- Locking: Yes
+-------------------+---------+---------+---------+---------+---------+
| Metric            | concur  | max     | smp     | tasks   | up      |
+-------------------+---------+---------+---------+---------+---------+
| Req p50  (us)     | +5.55%  | +5.55%  | +5.55%  | +5.55%  | +6.81%  |
| Req p90  (us)     | -0.77%  | -1.16%  | -0.77%  | -0.77%  | +55.49% |
| Req p99.9(us)     | +11.00% | +11.28% | +14.67% | +19.18% | +92.67% |
| RPS p50  (req)    | +1.51%  | +2.64%  | +2.26%  | +1.51%  | -15.16% |
+-------------------+---------+---------+---------+---------+---------+


stress-ng bogo-ops/s statistics by stress level (schbench):

[s-50] Schbench 32t -- Locking: Yes =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 506.91     | =C2=B11.74%  | 1.74% |
+----------+------------+---------+-------+
| concur   | -6.03%     | =C2=B11.28%  | 1.28% |
| max      | -3.98%     | =C2=B11.68%  | 1.68% |
| smp      | -4.23%     | =C2=B11.31%  | 1.31% |
| tasks    | -5.75%     | =C2=B11.47%  | 1.47% |
| up       | -3.84%     | =C2=B12.10%  | 2.10% |
+----------+------------+---------+-------+


[s-90] Schbench 32t -- Locking: Yes =E2=80=94 stress-ng vs baseline
+----------+------------+---------+-------+
| Variant  | Mean %diff | StdDev=C2=B1 | CV    |
+----------+------------+---------+-------+
| baseline | 555.39     | =C2=B11.03%  | 1.03% |
+----------+------------+---------+-------+
| concur   | +6.59%     | =C2=B11.38%  | 1.38% |
| max      | +5.05%     | =C2=B11.25%  | 1.25% |
| smp      | +7.28%     | =C2=B11.90%  | 1.90% |
| tasks    | +7.07%     | =C2=B11.46%  | 1.46% |
| up       | +18.88%    | =C2=B17.68%  | 7.68% |
+----------+------------+---------+-------+

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
