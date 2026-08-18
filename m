Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B54C32ED55;
	Tue, 18 Aug 2026 09:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787043941; cv=none; b=li6SDVNJ6sBXZuPTyUfnj/HxzEX5yLE20bOfYM/E3dOEZM9DoW/drjjP61GTDol9ZT7etOj3ALOIMF0OGjaX67vBrFKceI7xcU6st+6iAbjU8RxNwaUxQvHH/k9OK4rret1VQKtk9AwluOlr6nCh1QqK1AYmvXCgdn8SLECDoco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787043941; c=relaxed/simple;
	bh=vku7d9m/M4LH1nzjmwUtmQZIMy3akYMlGE3p+l95Ckw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n1o9vE65Qq0Wnen27RsOyRBCLZaI8gqyJahxYjDnuaGRWy/vpGcUsj8kDnxOZNUnlz3JaTq1au1CjuueOc4HOH8H2CRAkIAJZYiHYkdRM85z9bepOfH0ZS/44/eD/I+7OsjdJ94jkO0vcZH/HGoZ2GlggZAX3vi4Ow0l93hWMeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EGp7blGC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EGp7blGC"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HM1atI758709;
	Tue, 18 Aug 2026 09:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=vku7d9
	m/M4LH1nzjmwUtmQZIMy3akYMlGE3p+l95Ckw=; b=EGp7blGCFJ7zKRyYC9dhrT
	VB1wq+heD8+yMi/6gGM7HPNKLWjiUkfECSZpCbQ9desmh9D1gopM4KK9y1V2GaZ6
	trFGtUmGOoFPuXSqi/CtCPcLK+Z1ZP5pPf/+WZNuMwAY0Dbc4VoJ/QY+axVGx8tL
	xnLWO9TVL6H5olE8Vxw5pnhwc30y9oWpLA0NwojjyM3PWfZuLVagYIHr9KOaQh1v
	S7tkoYo6mKqBhkha3kJD7cyW2XuUWzzugq6sZH20nkqSEM5r2q70vPoQmj/p6hsI
	968C3UMp92mAxvKeGKTsMlRV2kRDBNLNOnd4G2NtcVliH2xhg8ts0dIobMfbFp3w
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fsqq5c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 09:05:03 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67I8uLdp015175;
	Tue, 18 Aug 2026 09:05:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g32tw2fh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 09:05:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67I94wAE42860898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 09:04:58 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 237D72004B;
	Tue, 18 Aug 2026 09:04:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B0D320040;
	Tue, 18 Aug 2026 09:04:57 +0000 (GMT)
Received: from li-4c4c4544-0039-5810-8039-c8c04f434234.ibm.com (unknown [9.111.9.19])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 09:04:57 +0000 (GMT)
Message-ID: <ef9f077a6faafc747b3e144400dd3f5ad10e8e0a.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/7] sched: Flatten the pick
From: Szabina Korbai <szkorbai@linux.ibm.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>,
        Peter Zijlstra
	 <peterz@infradead.org>, mingo@kernel.org
Cc: longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
        mkoutny@suse.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jstultz@google.com, qyousef@layalina.io,
        euan@linux.ibm.com, huschle@linux.ibm.com
Date: Tue, 18 Aug 2026 10:04:57 +0100
In-Reply-To: <d690a668-7bb2-4cd1-a229-295e556d4f28@amd.com>
References: <20260605105513.354837583@infradead.org>
	 <fecf5eb215b4b86bec11ca47eb6b5b17f5e0fea5.camel@linux.ibm.com>
	 <d690a668-7bb2-4cd1-a229-295e556d4f28@amd.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA2NiBTYWx0ZWRfX5sspVmhCuK3Y
 zHSI38v8n2cnZjvfT6DOQhxPLgB3A/A/sclF+mPy9nXrXlY19LlbeMNgfJ4qT5lCGTUoHcb04o8
 uYT8omkwavfdwMKo+ynOvKJm+FsMFHtQn2ADrKyD0UxQxnkfG/nPDNdhIJpJOAcpvQ4Uq/p61gw
 NvfdO0h+HDBktWC8kKvwMSTuzSJgJhNbjodLkPmoWZs7HPyXt7DAZ1AICdF+mcjt6y7KQl5CaLL
 b8AbFiLAZNfvkf4d9LBHpWx65X0d9hfNUnOHU9IURSVdLClzWUSAx8Eq5xqA7gJWFKHz5zfMdr7
 5e+e1aIzlJahvpHGlh0s8MKVPBaWOLAgBz0xr1FE3ARwCLqdALJeLk7zy1VECdI2P0o6j1uGLa6
 rXapIpuIro2GOF0/6Xp7ZXQYdbs7gm1LjZtK9lHtQYRV8YnBL1NxBkQu6d3ccy5OvAlfmBD8Ch2
 GXnvToKsxw8Pw683KGg==
X-Proofpoint-ORIG-GUID: HgC3zz5kuieepGgpfXIhXn_YazUdOdsv
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA2NiBTYWx0ZWRfX3by2WI2SKw+N
 Vk4wMBnzEtOzmC770ds0cWQX8c7+aPDA4sQw7BSSmQtq2QSyd/dFdOBO65kQISNw7QX+3eCWaoB
 aqgJrrj9VTAWm+w4dGlQasJuOq9fN3s=
X-Authority-Analysis: v=2.4 cv=DJe/JSNb c=1 sm=1 tr=0 ts=6a842040 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=iUiB7RZVDRUJM2x9xO4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5Fi71tcEzR7BK4mU0cbSznpZYYJp6k4y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608180066

On Mon, 2026-08-17 at 22:05 +0530, K Prateek Nayak wrote:
> Hello Szabina,
>=20
> On 8/17/2026 9:35 PM, Szabina Korbai wrote:
> > Hello Peter,
> >=20
> > We ran the same benchmarks (schbench, sysbench, hackbench) as
> > Shubhang
> > has on s390 on an LPAR running fedora 43 with 32 vCPUs.
> >=20
> > We ran the benchmarks for each of the cgroup modes, and for the
> > baseline, we chose the commit prior to the patches (f666241e6bd5 -
> > sched/fair: Unify cfs_rq throttling via account_cfs_rq_runtime() ).
> >=20
> > We have also tried running stress-ng in parallel with the
> > benchmarks
> > (set to generate 50% or 90% utilization for each vCPU).
> >=20
> > Compared to simply running the benchmarks on their own, this has
> > revealed some performance trade-offs that the move to a single
> > runqueue
> > can introduce.
>=20
> Are you using tip:sched/core at commit 68e3748781 ("sched/fair: Fix
> flat
> hierarchy") for the flat_cg numbers or did you checkout at
> 85570f10a4c6
> ("sched/eevdf: Move to a single runqueue")?
>=20
> There are a couple fixes for vruntime update and Vincent's
> optimizations
> for preemption bits which might make a difference to the overall
> results.


Hi Prateek,

thank you, that's a good call. I did checkout at "Move to a single
runqueue". Let me try it with the fix included, see how the results are
affected.

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
