Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.111
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792775985;
	b=LU1EQ2w4EER/tIVr2kG2zYT6fwl+V+VawRwX7+5apJK6rLia4KSC5r9Tm3gJoyQi0li4
	 T1PBtQSv2uap6qJYuu4MOTSkrdULhuMEc3zUgBXRnK2ezcnv9Xyuq3JYNLjbksAyH6A/T
	 E+KCaNAaEHYMHu6XIjBEUlpGrduofNC5pHLMt/sPeG8rjIpk278SucpfwDSLAdDS++gKS
	 PhgZt/+bGpWrJu6LLO2dn8d9IM5rlMx2YU9HtLg/I+uzzmRkdw1dUaJa42zPoZ6HGptSW
	 R9pRcxCj9mf00A0NAxHsLIGEd+uwKRkXJjs/ogFS1ukBYHKZALu3VoKGlQR+miMHb4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775985;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=csil+VD8fYN9wYsrCxQJQvi7MHF0b5SKlPieWB2FkNA=;
	b=Ke164ne3VsJIDzvYYcFriUuf7SVYAOLZBHT3s7BlUdqlciOX9QlYD1MGO4CONpldpWhE
	 l+vZuzbJgrd0XDcymMfw92MXwcNDP5mnm5so33kiPVrGRdwi3RzRp1RuWFIinXjgKVT4S
	 euY6mPk9JpCVMiLU7mKDvFSE5RqTzypsPniquE/Mq8L2+HFK09s10JcK1hzMVf44AvirM
	 cR+SkO9b/2uqmXrbfHCU0/dRMVdWYxgQpgU/AbpdEYW0S0S9hGAKDkVPiHQ9/0gLDt/bp
	 VZYH7+gQJz91pbCZ5inykyecHVanci9dfiz65+OogJRe6rbXBXy+9UBx9LYGeQQty+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=yM94vcvY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.111
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023111.outbound.protection.outlook.com [52.101.83.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0399606A31D;
	Fri, 23 Oct 2026 17:19:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0399606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=yM94vcvY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DKWmEdlC2E7aafveY1yvFfbmnKRZylaAG2pnyxK2VBK2K0wPpAn9lcglTJUV9ymftr0SIuQiNuVsffvh+TU5NA0loMii+8/lC12y7d1dr7HAPeKFptR55UzKnEV/gQrcWVDcz42gwCYPKF7yFmmHiNGiHJA+WfCGdchf9u0VfYjndxxdO7RFgoNnbtSfs4kWEtCNYgAHn6uWkDT/IJXnUiGU6fy6hGXnlGl1LnviIe1tQPcHrC4cd3s9flesZmQCR8iNDL79itOVGmhRlSVuUTPVY9T3mN2NS9r/emCxNJo7ETCXyzv6vbOkTsNZIsRgHcWjgZSeElMUXqutxIOtog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csil+VD8fYN9wYsrCxQJQvi7MHF0b5SKlPieWB2FkNA=;
 b=EfYzfsVD3FgUnNMp+UF8TzwFGVbl9n1PEwlSDarFasv7fwMw4Rhu4qT+d2YaGk+H4IbXGJPydavUSPCpZzBenoQhZPQSC1caf4X2UL3G+7abepLj2PaBSVr9IbMTqvQ0ihPvYRTE+iM2kvgR8KovCkZS0J2fB0aT6HTiJtMAeaee5uc9tLs82pGSRtUFijLeTnWQBvq7gRSzJrpLZgqFVu0PTWxRS4ere4DdYJAaSwPCq9ylEvlawj3EDdglcEYipveTpbdxO6E3rzOzypY8vtE532HRKU51PiNnOIhTmpDrhcPKuJlBbtQVsbakxcH652N5YNxmyP12OiKOjN7Upw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csil+VD8fYN9wYsrCxQJQvi7MHF0b5SKlPieWB2FkNA=;
 b=yM94vcvY1e1LQpeVuaoi6b5BhszlPEVv72nEdb5icm/ToMS2msVyHCvcAvSR9ERlBDqedx65kyO8/z39zmG9RsSl01+4BKNMdstxIcogzXZanjyu+sCADO2xrDgfk5utHgMAkWkLpfzJ6wTYYaGWchM09UBEY/yeRSFjO80Yv5k=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by DB3PR0302MB9136.eurprd03.prod.outlook.com (2603:10a6:10:431::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Fri, 23 Oct
 2026 17:19:32 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0546.012; Fri, 23 Oct 2026
 17:19:32 +0000
Date: Fri, 23 Oct 2026 19:19:26 +0200
From: luca abeni <luca.abeni@santannapisa.it>
To: Tejun Heo <tj@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal =?UTF-8?B?S291dG7DvQ==?= <mkoutny@suse.com>, John Ogness
 <john.ogness@linutronix.de>, Shrikanth Hegde <sshegde@linux.ibm.com>, Yuri
 Andriaccio <yurand2000@gmail.com>, Yuri Andriaccio
 <yuri.andriaccio@santannapisa.it>
Subject: Re: [RFC] RT throttling, DL/ fair server, RT_GROUP_SCHED and
 everything
Message-ID: <20261023191926.7458ab76@nowhere>
In-Reply-To: <f29f77edb2776b734306fd482b47a64f@kernel.org>
References: <20261023161348.t3lpPLQZ@linutronix.de>
	<f29f77edb2776b734306fd482b47a64f@kernel.org>
Organization: Scuola Superiore Sant'Anna
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.52; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To PAVPR03MB8969.eurprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|DB3PR0302MB9136:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a991d67-3095-48f9-3ebe-08df3129cd48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|7416014|366016|23010399003|1800799024|786006|261021123027099003|261022105027099003|56012099006|10067099003|18002099003|22082099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	04yMWdQqXsyzNFFEkDdOuLxZFfaMOiBzlJALnjnLl6NXdNUm8zqaAYa3K0w4oJah2ji77ELhGyizpiSG5Hcbk+2nUyHcfEN5yAI6PgRCEJc1W1j8kOJzxdLTSp9b92FOeOzRCbeF4e7MKRL0Gzjh9NHCDuATYCrshpBABMbFVXB7N6kWsqzZ53TVIkUzbRgHkVSc5vyOVw+i+noyhJlvV4iv+B9KM15PYnQ5eBZ7j+Pa6m1dUxLD71v1tk/7fEL0QEm96PR4fHacfCYl+4vRELbznyeaL2N0oyeUGBMMSpL4+Cnr6Pxs/yH6U9pb+A49xKEUmK9nAft/FxrmzoSWy0lQeXgcx1RbP5wwgBmBYidZE3lYko8LEQM4eL71ZYNLwPIn7702+h1lHSFuRe22OK46yniViJbnL7ZapSGpG0tMOXvG+RvCu/Azs19IbCOYgRDSOTaGcsyyGud/f2MFT0ucRUlNEqRAIcqYRIGEigja95mRKn/A7CXEVtnlhugKZmSD4NBrXQQhnenbM4mV7L2UOsxvy500nDx+4AUKMp/WO/eoHAdMVxyyc1aZQAFboJGTgjfWdcNtYlWD/TrLPPJ7oM+EqO0LVC1ESixkv5cc6W4tnwiFKIbU5M4ZHkea
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(7416014)(366016)(23010399003)(1800799024)(786006)(261021123027099003)(261022105027099003)(56012099006)(10067099003)(18002099003)(22082099003)(4143699003)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tMZUWc94wu1p3TiukrWBW4yoeTdDNGkqFaY9EFzh1Jv7NcPFGQpqX1eqikNo?=
 =?us-ascii?Q?7qk6glIYi6KSZNR1ybflsaoiGDgYoGuRjq5e+7LDNXWfOR6q8/769Zw4DFPw?=
 =?us-ascii?Q?MwDn3vzg7qRVrzp0tocm/iNnY+A0fyC2MdS1LcJqH8mcuSMlbR9eqcHfUu0R?=
 =?us-ascii?Q?9BaNQlviUCxtNevG5zxA8pz1Uw7WU8Wq/xUnNIIYP9wJ+FKyUtIF8WViSInr?=
 =?us-ascii?Q?4qTOgL3D1mZKba/xRZMNxak8smxmtURGfMcIJP/ooJUeUXVAgzciyg7ENKpP?=
 =?us-ascii?Q?9R3kYguKbMxLLq7JkwxwWqSay01bhK5Wto5tWSGsbhQ8GVQrktIRpCMyHGzb?=
 =?us-ascii?Q?qfE9A4xR/DlwjFpgyL02H3SRTUzeETbeeURQS4lfcxygpRjBQKUQbIgLeVs5?=
 =?us-ascii?Q?q1UUAVSdduaWvNt/5VngNCFqyw9as818sjVV6oRJcNoi15oo2QB5lUs2mC14?=
 =?us-ascii?Q?dse/hKvQA0HSImPnAFU/maJFVAyW9Ey4MQN1sMy00zThV0AkYk1LF7vcL0jg?=
 =?us-ascii?Q?ytNpxAe8A4qKsqxaFfIx4YBAN1Q6RDtDSv9xFKdkX/GnAuvFoxVEYWSslaQP?=
 =?us-ascii?Q?gCkI6A0UIhnmZ19DmId+mHUBI4fh+XQPJGnXLGHSKGYWJ3pGdQo6z1c1b8xE?=
 =?us-ascii?Q?xJFMz6NhvLmA1uWXDsLJ+v4vKgcWgghYnW6wESSxb8X5F/6Ic4ixNFU5tAgJ?=
 =?us-ascii?Q?DeBio1ztFhZIRdv+l54at29LD26768/aWZkpgPP2FZrftT5brZyAxUYvocGx?=
 =?us-ascii?Q?RghjfBnJtrKyuzqHtDaD/aloRnPmrcY+bvyUMRe9sHvNaQRU6RpGrfcoRBTO?=
 =?us-ascii?Q?HWXQhdqR+6h5xdHkOTzfG65hQ/nNexYKF3BwNEA4LHTCpGGnGjjyvggi4+5u?=
 =?us-ascii?Q?1zugDJIQMKVXzGz5Ddx6PKXRciz9CFnaCNZ+9mdsc6I3PKC9D4cvVLjxDw0N?=
 =?us-ascii?Q?JoHmmVuxZVmI9HG9JMa/kaNpSZqB4dMF5dIS7Qxc22yTdqA551KnZe27vIBM?=
 =?us-ascii?Q?2BGGEgoROaoJV3WP97+4k0uM+VgjDuOlAn657pTH1VBIHg6fhXT+8RT8aTCs?=
 =?us-ascii?Q?bzhlOinxr+bnzErIYLjEI6BiRKHT6K1E1AYGdvAvdiGVbPDfD5fBM6nDqVMu?=
 =?us-ascii?Q?toaVdS6rBcdWNZcqoOxnPnncDn+zVUWXjbUqXuC0VazfA+nU3EqKdMqmL8Y4?=
 =?us-ascii?Q?iyIt0AQHMK4xnE8tqNx3skHHv99VQsn5c1SCLqujBb5zWroeh60f6dtZz3gJ?=
 =?us-ascii?Q?lgNVO8tQd5sQgH8+Vq8XHdkWDyAstkVzUULJmVjlevH6BwG58WGkStFBp20p?=
 =?us-ascii?Q?uMTI47v90o1KYFr9leea+pFUaLt7GvSnvkrXhlShXY6wrmhtQqqjC30cEwUn?=
 =?us-ascii?Q?oD5t90CEJbkJU2pkEMiWBNdFDvVM9FyVT6PYIHK6I4FVP9gUqeFUI4/UYmRu?=
 =?us-ascii?Q?I+m6ici8tVOfO7pcg2mnRpIW9vCeDjR0RqxCRWFnspqq0SL6IELsdmwsnACW?=
 =?us-ascii?Q?tY9xvCaMM8CMcQZsTQlxYluXKPpG3dh7efFSTmpBWk384AwMAd56f6AsXwwJ?=
 =?us-ascii?Q?b4Z/MWluLTOL9c3yOwf7K+SHWrJ1AVpo3OPzX8O230y8EDRHR3t+JWLLvh7T?=
 =?us-ascii?Q?nvYwxofQUaVXX2mC6cst+mPhm1HturP4BrwKCfU+nSCuYPOWA4OfC9MOTflq?=
 =?us-ascii?Q?OIu+G06I7Pyth3016fL17ujuiLTt3zaxAmUQzGKfhhA9Q9xsp/AKbrOb6TYr?=
 =?us-ascii?Q?ogFFXJoDOljtRYw+Tb2zLn6uokSGvjuzdNPfjbe7tipxGVBrFhjCpXNXwi7d?=
X-MS-Exchange-AntiSpam-MessageData-1: UNXjA9bR9hqZVwJx//8Z6Uh9feoboP95imA=
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a991d67-3095-48f9-3ebe-08df3129cd48
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 17:19:31.8767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sfLE+Wexgrim+yA2S3oK6W6JWnXd5Rb/7zkZp5TEyg3MxVvGcPVmlGMTsDbHjT2/0rl9K2bW9GoBbloNf2MT8ThyWvCmK+9C1sVXhWMy4D4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB9136

Hi all,

On Fri, 23 Oct 2026 07:16:10 -1000
Tejun Heo <tj@kernel.org> wrote:

> Hello, Sebastian.
> 
> On Fri, Oct 23, 2026 at 06:13:48PM +0200, Sebastian Andrzej Siewior
> wrote:
> > - Remove CONFIG_RT_GROUP_SCHED
> >   [ ] Yes [ ] No, because
> >               _____________________  
> 
> RT_GROUP_SCHED in its current form isn't widely useful. No major
> distro kernel enables it (Fedora, RHEL/CentOS Stream, Debian, Ubuntu,
> openSUSE, Arch and the Android GKI defconfig, PREEMPT_RT flavors
> included). I have no objection to removing it.
> 
> There was an attempt to make it more useful: the Hierarchical Constant
> Bandwidth Server (HCBS) patchset from Yuri Andriaccio and Luca Abeni.
> It replaces RT_GROUP_SCHED with per-cgroup deadline servers and a
> cgroup2 interface. The last posting was RFC v6 in June:
> 
> https://lore.kernel.org/all/20260608121546.69910-1-yurand2000@gmail.com/
> 
> The effort seems to have stalled.

Yuri is working on an updated version of the patchset... If everything
goes well, a new RFC should arrive in few weeks :)


			Luca
