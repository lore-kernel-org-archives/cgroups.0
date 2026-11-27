Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.112
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795789593;
	b=XzC7o+8pDMsOcZyk5djWLlyvBlEFzoQmQAquw42ji0xK8ecx28oZiSYeqHUDMkJwuJrG
	 TJcySIlpcr6uwNunZpnqaIQ2HyweqXmTdBc/gVSBpgwm8tric8HqX1N/UKj/Up5eoJdMx
	 KaGZl8RLxbjEFo/tg1bQymeuQX7crIaPWiU7tQdtD5KfBmJNQdaac40rb87VaIZdMX7po
	 tJSU/hTJO8bZ9CcLcwDCgjdDeEkC2DW/vL25tYrahLmOSuzkZ5RDXsdKqoKW3MQPAl5pC
	 K8rqmrm+jGv/2DtvxDuDlF6HvZLDd7uPjtD1KvXe55vALMSFg0HuOVs5CgA3hjm8BCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795789593;
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
	bh=DqpOQ/KFob2tkJtf57g1nY9D73ZTnxPicb5xBobno4A=;
	b=xrRdfF2I+EOetXMRJhlLacAgy4bJ4cezrItbCe6luhIw5q79b6d3MeuKDh1HGK/W2aCq
	 pKPwuERh7KIduwXLsmB1vbyz8xg34005/plG6esstjJfRlTjkW4CYCz3KgCT5RO0t8Vxj
	 p8sl23HzKwdhEz7VM4DZmdnClT038fZ0jyvDk+uLnA5USGnzC9qXnhGreOFciyp4VJ9gM
	 r8Uq5DSFIEiUmZo4cSEbL2LWC1YxvGqklMvERE5Ei5a3JE935z1s3aJryDlWXwpM0BH1H
	 4qbnfYftihT56GoKaRXgHbEBI6nyPvpiGnse8gLvSkbjhZZGBRLkmU20IvPE8bVtwcA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=MCVEZkl+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.69.112
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020112.outbound.protection.outlook.com [52.101.69.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF149606A6AB;
	Fri, 27 Nov 2026 14:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF149606A6AB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=MCVEZkl+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t4j6jvc4Ipc7VkQg6+6BLQuUOTF9qBADIhBLyuswxVky9VkxZFck2QHHg8ljPfsjJWJubJ8mZfX8NGnAGCXkAUuMlPEwV1aHNsf1N+LzCrRaNfDgrYRX+WJlsoDQdtgvKolxwH3r3LBYiVsMyedj9TAV9vS9+e2xxpj4pQeiCBo2KKStj5UU7qmax1v8djdpfQ5kZeQ7lcURBPVzFISxDJsdTxYzufHYPoaz0GsAoi0bCwOmSAeIZSZ7rgGITPYk9fWIvXsQ8V6wIz5zPxUxP1csFrPqzmlWfb9I1DErG+cefkcbbfTBqam6uS6560P/9zsQ/ikym1+8Syq8qZDaWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqpOQ/KFob2tkJtf57g1nY9D73ZTnxPicb5xBobno4A=;
 b=A9fxOtlEYSaQIho6gJ2EqkZWrqVPad7NIDh962S3ap/2oc2jWkm4y1bBD2zdZ3Qsb8ic85EQyKaPA+lkO454949IcIQDY8Xj6pA/Kj/9FEjjLP3+spkVUdACDctMIhoEePNGcgkbRgL6hDIj/ePkrFJDa8AZ2+T4P5UydyLl7fa+dEKuj46BH+Oua7my7t38tLimcepf4TB7pPvgg/BnC/l47+KfLAvyxOwf6p8kRDHbQS6+vDK991FD60FY60kMMe6XYNTSOnvqbp/hybXV4OyTeaqcOyp0nxy0+11ilpBofiUr2iWf5fn1CbhbtHIx+6vgtK+VZuQQH/Woir6wwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqpOQ/KFob2tkJtf57g1nY9D73ZTnxPicb5xBobno4A=;
 b=MCVEZkl+IyYaKZjTzpRdYNbpfD1eKs2kPdu95U/TujZ7cOdUpJ/yNo6lHHeG8Rs96itG39g9OFOcU0UZnWetqTIaTDhjql9eDGx99uP9i1rrdTrG7jNOGCHdc5OslTFLKs16y2wG0XAlvaqfG+4PA9CQi4uRAuMO8qET3WGMj9g=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by PA4PR03MB7423.eurprd03.prod.outlook.com (2603:10a6:102:10c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Fri, 27 Nov
 2026 14:26:26 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0662.004; Fri, 27 Nov 2026
 14:26:26 +0000
Date: Fri, 27 Nov 2026 15:26:23 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
 bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
 hannes@cmpxchg.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org,
 rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261127152623.5555f9b9@linux.fritz.box>
In-Reply-To: <awhfdTbfDhpklaTN@jlelli-thinkpadt14gen4.remote.csb>
References: <471bf8d446becabfca00041fb2a78067@kernel.org>
	<20261120120659.2e902463@linux.fritz.box>
	<6fef47e08a37079c08806b3c57994778@kernel.org>
	<20261120212418.10221f2e@linux.fritz.box>
	<06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
	<20261123084345.4e24e3ca@luca64>
	<awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
	<20261123151846.3fdcbf4e@linux.fritz.box>
	<awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
	<20261126155736.20e64e65@linux.fritz.box>
	<awhfdTbfDhpklaTN@jlelli-thinkpadt14gen4.remote.csb>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI3PEPF00004EA8.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::44c) To PAVPR03MB8969.eurprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|PA4PR03MB7423:EE_
X-MS-Office365-Filtering-Correlation-Id: 58965603-13c1-45de-4309-08df4c926b8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|786006|376014|7416014|10070799003|23010399003|1800799024|261102123227099003|11063799006|56012099006|5023799004|10067099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261028144727099003|261022105027099003|4143699003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	He8hL+LVnKhQQT7e34moaWuAOVbQxWfIgGKzWyGOaEMjQqfU0jC7/Dsm1R5h910BFfz5bDdJaHuhiRg/KCl7GEXbWH6TLeCw97F1mMyYaBtSF2ZP5seJI21IdiabVxNPjXSTqToT3FQrqfRJf7KyeoR8cNbWSwyiGzzpF3+e9v4yos936oForsaqm9ZDVJ0YMEgchPwWzYrKpSS416pXPI/do7rVJ8rGbUobl/RkEAUSHd+dVuFuecltk3ZCpvKS5TN6uOCLBAJMbJRJ21qokBIP1+9bYDq4ayKji7Pxh2NBUGKG0wcWkj2Qwm8+9DBywxIyizEhmfXAWcQJY7Q7pHLjcYlNiA1Ae6azvIAWa9sYoNTd2WPcSe0Grv3nLzpvIel0EEMNII6UFAy4iGGmzksuuFZUaMJz0u4+dSOZ/OXB0k7ctcNWeHo2jkM9BJqwEwcAMRK2TFnigCbsV6T3i4hLArT/rko5kCIXndK9Mn7LI3dtmSZ9tvM32H7j370erxzTYJUM5jwyZ1hNzotaqIgKcIS9r0XLU4WLkdzUJ0op6zAscDxfY9mPgRuYUgan7jLVoKXXwv4N23Xnt10AoSG3zxbnfHbWsIC0TiJigxOCtambyPwhmLb0k6JCzY08erVkSU24CtDscHSDbE+QSg3tH1qDc4lCNlfaMKMZHbI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(786006)(376014)(7416014)(10070799003)(23010399003)(1800799024)(261102123227099003)(11063799006)(56012099006)(5023799004)(10067099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261028144727099003)(261022105027099003)(4143699003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A7noeKJ1Dj5NUgFQ26/EDpTw72Mc08occH9gli52ga5pgJO5Mvlw+BHdgmra?=
 =?us-ascii?Q?89dc/sY8Y2XGLMka5yycqr4APPu9Dn3ZOzrFsOehO8eYWfa7mZseh4d80STW?=
 =?us-ascii?Q?pPrsY9bQlUkEX1DULH1fuTLfMZZW+B18y3TrH/IqPE9Nwxsr/dd/NL9zkr/o?=
 =?us-ascii?Q?VQ2EofZx4TMjC0RaEbYF3qFEMC/ySdsjgPWjrEsRxJmv1N/b2REp5MSDmMAX?=
 =?us-ascii?Q?O2JmSAekxkRvkvKydumEIteAKHZokQd6ouvD8nYMie2LF+V9LOTnThGHuF3h?=
 =?us-ascii?Q?Sk/MEooP48344LY3utbOCSq4QO+05Hd8R3iqCdGRvEDnGPAfLXwqNxnL5oCu?=
 =?us-ascii?Q?Hxux30ShWgKEuMTOY9SswUlZijEwr2IuVGBWEry+QXXUDY333mwV9+vcpBng?=
 =?us-ascii?Q?21UzhGugBEM5pDQDVSuxqt3WNw6lp9L3EZlG4Rxd2zqolzoOolPTASWg4VGF?=
 =?us-ascii?Q?u6ViXP/0PC4tdB7r7rfInP3GgC9EYvgT7D4vS8+iwqu9DfDG+78zooL0N38w?=
 =?us-ascii?Q?bElTED4Z+3kBAdeHrScwRku874cntbDooA4TuKnGjAYDZKijWJe4RZjNRQF7?=
 =?us-ascii?Q?VMohwgJdcitxrJQTh1KR+grjPst8mF3/OsX1w52+Tqa5XUBkbK47gEE1J5Vl?=
 =?us-ascii?Q?x36feRdsES50C9BRQjziTORO/Xd4U+DokUy5ykXmezDadtIg9gEdGogp/1wn?=
 =?us-ascii?Q?sqI+7eWJDjJNLZhphOUj260B7Fn3d476jm6cMobGnjHqss3+b20+dkrvmwNX?=
 =?us-ascii?Q?4gae5Xs2r2e/zZ/H9MLdb6VswgpCoeE9KO+ybiGOy0nuAMoqBeKXt3Y4zSev?=
 =?us-ascii?Q?dn9JKCv3XgynsH+5Am/FmNtN/HMh0iqTweadG4TM4k56vbMiUM7kcuNcd0cj?=
 =?us-ascii?Q?9iG6WzOZhJl/ykEIqJj93CvFX3wXtjhtQ7KR7QuFrU8GBz7m31wsOu/c+1Ng?=
 =?us-ascii?Q?op2LSiMYG0roEK7rnEdagnKvm8ZbWZEbHFnVgqG8EaH68cFIdUUDARV6PR5e?=
 =?us-ascii?Q?qAEavq7Si8X11gfnY6bCaSi61fZ7lsUCa/M8xQf6A+Ats5phRrwuJJy9zCy7?=
 =?us-ascii?Q?B6HcMJ4S3OUR0f7tdE7Bvu6kGfQeE+XCQ0yAfQFU9l/zLXQbGogSVbttHFlf?=
 =?us-ascii?Q?opfaWFrGTODc8XW2G1Nczy1UdYrCKpywp6f5iZQvsTCXGaFST6SirjpxIlXo?=
 =?us-ascii?Q?XtIVqeq/YE0mXCwmsDFTWU1ZVXwuMho7co8dUiGu+qVPizIhmYfxh8Ii9nGn?=
 =?us-ascii?Q?HGBrGujMT+L59ErGd5IjzH/fhY+53a0layIj0SFq/d7eGqKJZGa0YLNIloSy?=
 =?us-ascii?Q?NGn0eejOklpXlERoomdZnByaPOW1F9W12e3CU6pRI3hkHw5Dqz2Mivc/CDE9?=
 =?us-ascii?Q?sh5eaGNALvu9SzDXlgAfStFFqMpu2Eu/zBTePIt5WQaGHlABk+uUkL2EFFTl?=
 =?us-ascii?Q?h5HVamcXh6JseZDNM4aNSWls8JumPeB2h3GNRdlmvg9z+Jy9T7Qze509vE2t?=
 =?us-ascii?Q?neILhKuM+eimP4y/aBJ6/PDewOpyAoEb05fqOLJ8xOV/EyTTFWrlb5s3UMMT?=
 =?us-ascii?Q?ecLG8UoQwYSWx7bu/56LZ41hCV7kZngcZLomOpprdHkzOk1bAfRfBCddLteE?=
 =?us-ascii?Q?ymUB8UormEqH1lOgaloNxG33/o9/eg2xSz3wQt5LUlDWMEK2DPIvLTwLjnUD?=
 =?us-ascii?Q?Z0315SOLNjYPiqpCIrpCLid/WQtPqR5usI1U7gnSOB57vdu5ia9EJvyP2LaW?=
 =?us-ascii?Q?2CLg57vWjfZFu+farJublLFZweW4czjCqeQW6ve8F5MlI2Z7BvZLpCob/sSk?=
X-MS-Exchange-AntiSpam-MessageData-1: 9jkJwLN9Oe8ZFg==
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 58965603-13c1-45de-4309-08df4c926b8d
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 14:26:26.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5o1iz+znOgSuTlFzUklTd46AyOAowW1ZKOVJh8segHS0CjDkgbBSZb2spRpjK9IlVYLhjYrnQP9VdNijoOEb3btsBi6RJGGsAxROyJzYOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7423

On Thu, 26 Nov 2026 17:33:57 +0100
Juri Lelli <juri.lelli@redhat.com> wrote:
[...]
> > > The mixed config ends up on P because of _delegation_. P's
> > > cpu.rt.max belongs to whoever delegated P, and it's what bounds
> > > how much the container can reserve. The application only arranges
> > > its threads below it. If a cgroup had to be "all or nothing", the
> > > admin would have to give P either zero on CPUs 0-3 (no RT threads
> > > there at all, not very flexible) or a budget there (reserving DL
> > > bandwidth for threads that don't need it).  
> > 
> > Uhm... In my original "all of nothing" idea, my plan was not to set
> > cpu.rt.max in P, and to set it only in P/crit. In this way, the RT
> > threads in P/nocrit should be served by P's parent (up to the root),
> > while the RT threads in P/crit are directly served by the dl servers
> > configured in P/crit/cpu.rt.max.
> > 
> > Would this solution address the requirements of this use-case?  
> 
> If the admin configures the whole tree, yes, I think so.

Thanks, Juri, this (who is responsible for setting cpu.rt.max) is the
point I was missing... Now I better understand the example and the
requirements.


			Luca


> In my understanding, it doesn't if P is delegated, though. Moving
> threads between P/noncrit and P/crit needs write access to P (the
> common ancestor), so P is what the container gets. P's own cpu.rt.max
> then stays with the admin, while P/crit's is the container's to
> write. With P at "max", nothing bounds what the container can reserve
> in P/crit, other than what's left at the nearest configured ancestor
> (or the root).
> 
> So the admin has to put the cap on P. If P also had to carry entries
> on CPUs 0-3, P/noncrit would be served by P there: with zero its RT
> threads couldn't run at all, and with a budget they'd use a
> reservation they don't need. Leaving P without entries on 0-3 (i.e.
> the mixed config) is what lets them keep running as plain FIFO, as
> they do today.
> 

