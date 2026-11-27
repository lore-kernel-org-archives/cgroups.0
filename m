Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.111
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795792178;
	b=fEF8gDGsNsQrXu4SrbK3YmamOknWR+T0E1e0nP+H8I9cVyrZTbfJUNp0TOG28rpR2tmy
	 4fw4otxFsDAXxxWvcJAaawBAlJx9GdpNi2Nr5usxaVrousmypF9i4oxJGyUzSn/zK440g
	 WBXiDTxzgGWB5vISohFPXJqrBdeaIk75kGwU4sJMI2W0tTIEj70qsaqCYVm1Wf9DcQ0WI
	 9FpS3KNvDhkcP2g99p25aH3dxfahLYq02Vg57yYC5YUvIkV71ngU3kssxaIWLtSm/YkJR
	 MR4wtgFvFHLsLQOz8Kawl2ooLh4Gh9k+sWUwZHbgXAc6I4PUKc20SSAZjjov0HhBjqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792178;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:X-Mailer:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=0ZP7Mw2CHdFwR4VmAx/dDSG4bwrNk0nWS/1PZx5UZrE=;
	b=AfmZig1Y6tSqmOcx4YN8k1FDaTUbUcZ2Ne/PSDYGagtIHi8iVRQ47vab3yd/zpmefk7B
	 e/NwRmutlE5bQbbLFhG5nETEES/kwSQyecq0g2KklWuQ25H1578BN4l7FkmF/CK8et4cU
	 wgvNYHsPAA+pFfu8F9XnnIbnc1NevAMUyIYYgHA7nYd9zrCT3Xeu2OYrm8HKZD+qN56Za
	 PgUV1sOgRtZHgLrnPwC7yZb70jGUmz43fs34x7Lq5ILtGZTghn13HORKgYrr+ScOsDE2a
	 rZWHc9PKtSKEgn2ShngVeFf3U8itKz/cUHTN8k/E8bByrRTdLxhYLXpNMFpELqeIjVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b="ST/JD0ZP";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.111
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021111.outbound.protection.outlook.com [40.107.130.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6536606A335;
	Fri, 27 Nov 2026 15:09:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6536606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=ST/JD0ZP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lP91eI19jPHrxlKSASQUZHdubGaybKl4IRk2d48sVwEAt0mNyrtcIKGEU9aoltBYclx1LJJw21QhDC6aY4dGPkY3b4n2nRJ42rzg0R79+a5t2P02KnP4gZAe0PVlJ8TrwwYoQ9Vu3jBfHQmATksutRF3YGn/liQvQwA/rrQSgGLkwvlksh0BDRzs9IiQs8YcDU8lE14apYbriOw57BNXeTqc7cnIESFyuSZG7p9Hzg7+2rEgZJDQ2tDi/4d9mCnlt+khKu+xYBDrAeD+g7+TJutdcG0JjUHIczCY1zdsYtRV+BOMUyNUE18oqN5FMH/VZPQTPnGL0pSPLM7K7/MRoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZP7Mw2CHdFwR4VmAx/dDSG4bwrNk0nWS/1PZx5UZrE=;
 b=qUoeQ2Cr4rUd999H5jvehYIfi/9zKZeXjHrTlzDh34t+HraKCYTupZy5jzDwBF7iAiwnqoEfz+7Q0jYoKd3jmRTDXPcENT2fQCg5/vlklAcVukml1r5z8jOE4p68zor2HkeHSTnG8LhL9vaquJ+kdjr0Uk3/dJba9fE8irpu886KCRapcTbpMvDvGuRhDzX+vBedsOkSzogBTL/dF/kGlLEvTG1AIrasejg0280NPOhSemwztxTrdkWNq5PnJABmUr3XR0xhG8Ofro4wRUo+pkoL5MzgbzIQSTQm769WS/KzQHF0bSaiTSYf1njfuor2uO0DDgETgm0jQQFlrTN2ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZP7Mw2CHdFwR4VmAx/dDSG4bwrNk0nWS/1PZx5UZrE=;
 b=ST/JD0ZPRG7JaWoVY/w/nImD5Q2X4imslNUBhhf7vdnCUHdSvMP6esuGE98e1Zm6aig8bvc5k2tLByBFjfqiD1cRs3oRn8ehht4vaLIohPAvDTukx/bSw6MSFUq0r8DnDPgJt5xA1DiZh70mxjE8sGiMzwX6d0wWd+otkZtaA1A=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by DU0PR03MB8392.eurprd03.prod.outlook.com (2603:10a6:10:3b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 15:09:29 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 15:09:29 +0000
Date: Fri, 27 Nov 2026 16:09:26 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>, Tejun Heo <tj@kernel.org>, Yuri
 Andriaccio <yurand2000@gmail.com>, bsegall@google.com,
 cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org,
 kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, mgorman@suse.de,
 mingo@redhat.com, mkoutny@suse.com, rostedt@goodmis.org,
 vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261127160926.20090712@linux.fritz.box>
In-Reply-To: <20261127114828.GS49833@noisy.programming.kicks-ass.net>
References: <20261111175657.250354-1-yurand2000@gmail.com>
	<58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
	<20261119151416.33f90a64@linux.fritz.box>
	<471bf8d446becabfca00041fb2a78067@kernel.org>
	<20261120120659.2e902463@linux.fritz.box>
	<6fef47e08a37079c08806b3c57994778@kernel.org>
	<20261120212418.10221f2e@linux.fritz.box>
	<06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
	<20261123084345.4e24e3ca@luca64>
	<awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
	<20261127114828.GS49833@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MI2P293CA0012.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::10) To PAVPR03MB8969.eurprd03.prod.outlook.com
 (2603:10a6:102:32e::7)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|DU0PR03MB8392:EE_
X-MS-Office365-Filtering-Correlation-Id: 64ebd4ef-9c1b-42e2-07f1-08df4c986ede
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|786006|1800799024|366016|7416014|376014|10070799003|23010399003|10067099003|56012099006|261026140227099003|261026121527099003|261022075727099003|261022105027099003|261021121427099003|261028144727099003|261102123227099003|22082099003|18002099003|11063799006|4143699003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	u+u3RRm9mZTpwk2mTMHmkwDj7hFUpJVDtnXaBoIk0aQmCfqlr9NJAXdZVRwCNUFmWFPCs0erlvLQ9gqymf6pBWtRIM/I8rOPnhoWnzPLkR0TBuafMUaFq7Ti2Tp7PqpwiJSdUVxqcZleqej2z9PuM3L6ktL9hTyUkzn0tfNEEhfWpnbSnAT4JTxX5NZbCRRDmTTaC2ORMMwDD0UScTQDojDiQ+oPPzi9KVLg2VUy6BomPu2IfMwtk3eYwyV/f5bLos/ltXl9Rt+XKkVfA3mj1pYm2HdQcT884cfn5QtLlpKLXLkP4Ulf50zBDPoM7+gzS+Ei+UHLEL6TqdcJXjCUICI4FNFul9KFgK3Um1ERhfKYzkgxpk+4hTggMVa7HCe6S3FPDPUMquRSebuvVfq6NoXXgajOY2XxwvD6zZotYmuAnw0wT6frrAMcIuSsjTEoPBAjtXjLhZb7+up9k1hoprO0cu2mkHhKhXv+WtW8h+OMOak4JURPU4zGASe3YIrYTOQJ9/lt3fstEfIw04KgxpU3HAfOKkFIquapUzLLlLv0BGkxi8iVXEHLEBo+ry1zn5gOMyCvbfcXENkmchriaqwsayGjJthGpMwUc/7jZA35YnIs0ROOnGQcrdPFN26SmFyD2hiZaGdtyuuPtXmIjPHH9t/vYWv5Hnu8/6dvNXo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(1800799024)(366016)(7416014)(376014)(10070799003)(23010399003)(10067099003)(56012099006)(261026140227099003)(261026121527099003)(261022075727099003)(261022105027099003)(261021121427099003)(261028144727099003)(261102123227099003)(22082099003)(18002099003)(11063799006)(4143699003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jOp5mGCaX5pU9tFFdkn4/cGfhYn2prcB5vR2ISje5871Hci3F6QwbQeR2oMI?=
 =?us-ascii?Q?AoGf3OuERfK+uIMjiVkX0A/5iQusST7pJhfkoLIoD2SwYL56Y7TMnKeTEvla?=
 =?us-ascii?Q?adjGi3rLLbp5W2FZ4zVyVuChngGw9aQp4o5Q/ZxAo5zou2sYVZf9b5MzFRQs?=
 =?us-ascii?Q?AxtKRC60lw1pSP/mrureTckmt9EuSyIjnAD+s06PFUUXpUEPpST6tDOBUSfc?=
 =?us-ascii?Q?viFtmggTcIiBB+HE5pQZbuk4jQYRV9Q73a/Op7DJehvw4RGsl8LNvj51b9Cz?=
 =?us-ascii?Q?dWU3Mq87gftzohR8SEvkK6syGCEEDyYCEHcilSTVbkBaU9oEJPpfragPmkcN?=
 =?us-ascii?Q?Fujufi7IN7V4RNk0dy5rdxn7tAmPdve3dglq1A9J32UCeOA7UqH+yGc7GO22?=
 =?us-ascii?Q?qwmlRJCyfNFrlb8NQMu1x0GMnct7OvUkHLI5pUKg2p2F/e4EhwSiHhlvQSQK?=
 =?us-ascii?Q?vhZcVNboSt9n03ydMHIxif8M5LyzaAJ29pDebx8Vd8fdq2AOkTdtMzjDOBw/?=
 =?us-ascii?Q?B7jr06glbxfnuTkCgNvMJ8WDmedj2xl1lUfbO3Wip68gt0Gv6DyLLXjXXfGW?=
 =?us-ascii?Q?3QJaa8KVJPf+q9xvDdA3ls94fxDgwX/ylAF27i+CEwf2GK0VxLZHHbMt2LYl?=
 =?us-ascii?Q?17UCGguzLvxUpRk1nALTw3Nk5BrlFKLKc/yYW071+kp89Dyflj0x9Nv0ZphE?=
 =?us-ascii?Q?Uv8Sd2oUGBh9NhPA9+w5wLkDOik67kRAN6cGIzr167zIBsd+v5mjYKeMAoBj?=
 =?us-ascii?Q?i3ToKX6BcL3reO5BJDKw/4dOi70R9ucoOfsQb84Y+GcF/ZpPoei4SylBc3x4?=
 =?us-ascii?Q?pE+rGOaiF1AqI3DjhYzuNYEEXzHh/SeLezlf7K3mdX7iOKY4JA6M7bkDaDwk?=
 =?us-ascii?Q?KD9fMN6HbDubu3PfHMHfYZhro2Tky/FZjOM4A5ns81os404CtQ623UfLjEEo?=
 =?us-ascii?Q?LhWOqTaWIdfHFSQw6MmfsTI9GTgfMYEJPJRqzkmpLRRvPUxJ/3GvdANh0Tqs?=
 =?us-ascii?Q?TGAjm8m+ZAhPWWcEzrUUiC7bL87eU0rMh3RvihtMzS2XAUm8IdZ2NyzAbQeC?=
 =?us-ascii?Q?XEoj3OO9kISe4VtkdKs8y8DW48rL1gcuOkXjliPIf32cv167Up+PgGSP1BdC?=
 =?us-ascii?Q?L4aRj1IX7qaa8ypUAX5gPWTRwfDudaPyz3X6ne2j6czvXTTxyx7n1jsmzaCj?=
 =?us-ascii?Q?wdSEr5Il0rXJ5r6C0kZO9RwHjun9YZhfh2WUBkgsIQuqkO2a6/4a0DxpflaU?=
 =?us-ascii?Q?TWa9ifXJ7LiXEZF11bFDSXBFCJmLrd93S6AdW/ynT+gEoTREuo6NLs7j1mwc?=
 =?us-ascii?Q?e6y7ZNMaGJx3yStLcJ8SZBBqyCb6L+jCifkQTqZetLq5ez8kWnKUTcycqK4V?=
 =?us-ascii?Q?3QesEPxSk7mlRTOvFatdO/68XPwAnUAcsBrj2vDeOrrAWUfjbCvoiZE57Skx?=
 =?us-ascii?Q?ugjkUp+oaKKv5wNJfYalejFtG3Fns+cVL3kLEZmcQHik3a4xiZcailcWSCLM?=
 =?us-ascii?Q?yJTOYcplwMrzzou+xKXecjsj5F8sc77V19jtZrbb4RckA4G8Wmu/+5mB65Fv?=
 =?us-ascii?Q?0vjmtBGx6lwlnJLV5H3QOun0luzEsSqLKqSJR1CNpOGQtk7MMw0tjCMjD/+j?=
 =?us-ascii?Q?xlEzP07HwfCNZDv6SS6EFDRnC95LlQJ5r5tk8kdRSRm+xeS4APMgabUGLsR3?=
 =?us-ascii?Q?B/VhrKLmPZKCKE+mZi3GPbV+m0UskLj+tYjC6iynhRCjR+v/AA/589inxerB?=
 =?us-ascii?Q?w60CM3PB1H2JPL1Fyzp4HfCuwp6A9g57vmit3t8Xm538PnMUiC14dpqXmx9+?=
X-MS-Exchange-AntiSpam-MessageData-1: +nwc1dqM3yk5DA==
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ebd4ef-9c1b-42e2-07f1-08df4c986ede
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 15:09:29.0274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VvaAGD8SE5rNZ3fchcJdry1s6Zr03rHk12JXwIwgdYzZX7YMI+Wiib3iqQJITM+dKBJQzp9LPBQhG6pctC4eiZsTcLCdlcuk6jqMvUMfMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8392

Hi Peter,

On Fri, 27 Nov 2026 12:48:28 +0100
Peter Zijlstra <peterz@infradead.org> wrote:
[...]
> Still slowly working my way through all this email :/ So bear with me
> if I missed things already discussed elsewhere.
>=20
>=20
> So my suggestion to make all this cgroup-v2 only and couple with
> cpuset is exactly because of the bandwidth accounting. Specifically,
> cgroup-v2 makes it possible to map a cgroup to a cpumask (exactly
> like we do in tg_cpus()). This in turn means we have a natural limit
> on the bandwidth consumption -- a cgroup's deadline servers will
> never run outside this mask and will thus never consume bandwidth
> outside of it.

Yes, I agree that this is much simpler and makes a lot of sense from
the theoretical point of view.

But if I understand the comments on Yuri's last patchset correctly (I
hope I am actually misunderstanding them :), this is not flexible
enough...=20



> Without this, you get to account every cgroup to all CPUs, which is
> incredibly pessimistic; to the point of not actually being worth it.

Yes, this is the first part of Yuri's patchset. In the last patches,
however, it allows setting the dl server parameters per-core (so, it is
possible to set runtime=3D0 for all the cores we do not need, avoiding
the problem you mention - if I understand well)


> As to bandwidth accounting; I once started adding per-cpu
> reservations. Sadly I never finished it and I seem to have misplaced
> those patches. But yes, that is something that wants to be done.
>=20
> I'm not sure I see how all this can function without having that TBH.
> All this runs on a giant pile of per-cpu servers; without strict
> per-cpu accounting much goes out the window.

In the current patchset, the admission test is performed both per-core
for the dl servers (so that we avoid overloading any core), and
globally (the maximum utilization of all the dl servers is added in
the "standard" SCHED_DEADLINE admission test).
Juri is proposing to keep this "double admission test", but adding the
actual utilization of the dl servers instead of the maximum one (which
will work, I think... I think there are papers by Anderson showing that
this kind of admission test is fine when we have a mix of pinned and
global tasks - but I need to double check)


[...]
> As to the whole max thing; am I understanding things right if I say
> this means the cgroup itself will not have a constraint? I saw talk
> about one cgroup having mixed constaint and no constraint CPUs?
> That's crazy talk and makes absolutely no sense. Please don't support
> this.

I do not like this mix, either. But I think the last example by Juri
shows that this kind of configuration might be needed (and we do not
want to end up with something that all the distributions will disable
because of some interface issue :)

From some discussion, I reached the conclusion that this kind of "mixed
configuration" might be needed only for non-leaf cgroups (and that
these cgroups should probably not directly contain any tasks), but I do
not know enough about cgroup-v2 to be sure...


			Thanks,
				Luca



> Either a cgroup has a constraint or it does not.
>=20
> I would suggest that writing a reservation into the file that is not
> specific to a CPU, results in (runtime/nr_cpus, period) for all CPUs;
> where nr_cpus is the cpuset's effective weight.
>=20
>=20

