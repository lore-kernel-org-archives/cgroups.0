Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.94
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795679017;
	b=mEnEQN7/g6yX7Y2gsNgKE4UvJNvXKO/wwGAmKyS6f6WfehYpdGc5Len2PosIlyPwoGPv
	 Zfm2m2nQ4hNX2POL6gqbML1ja8V2ncWd3wrJw3/YdaGC7NcJWnr5BokTCOCfp5JY9FZho
	 fdb6HR2ZBwn9hZ4MVpSyKYBT3OoDjXcKMXv+6v2TPF9tTJ/9wtfDvU1JU+uHchVw93x9L
	 L2UoYqqw5O2jo3BCOFXnVdO58M5EGIf3u212g+AY3jig8oNzSeVhsHV/GUqBFE6TSK7m3
	 xCdaIWzVXwaMSGoNAeh9YF+66fN+4JcXz3b8pM+vewqO0WZXEz4U/S6VMC6H2UQ6fbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795679017;
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
	bh=d8H9qBZBRLMqIyT0FxJfpUoZTUpqEVA3msPgQcX1pwM=;
	b=vo7oZZaY6bUvfJpwBN3RfrqQBvJiowZc4/2KIWAXfPMs9CshawfTu4Zn5jWEGtl1dk5y
	 FIzAVe7QvybJdBD7NMKfGFkkyJyJJZBNUvt/aRQ09SWcUELLVV48wZKKJNA/m1fnKygNc
	 KP42rZ8q5kAb9GW0aKFmRJV6JC6ZipuJckVMpjYx8ircMtgkCYAWM/X9NLtWepx95mVcC
	 ZcjFRNMv/yjd1/6qXbt8axYl7EJYDd4HJws8dThZVqfZsE/3uFEq7VsH0DinlZiNrXHCR
	 uqhw+XN9eeZjqFrBDGRtK2vvXcRNXE+PS7FDBMZnHqvkjsyLXe9JZhv6IG/ssjT4Uag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=biHpVYfK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.94
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023094.outbound.protection.outlook.com [52.101.83.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762A6606A329;
	Thu, 26 Nov 2026 07:43:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 762A6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=biHpVYfK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VMuVXE0Me4leierK2RYrVXt4gvbcVzKVEU0d6vRQiHexrbXrKCubRaMfqqaSPCSghg/MtydyOgJu8oleo39ZXpJ72jc792IbbyTdmGNx+4i1QoqsEQDn9X3+Ft8IUJ4KMXcPxtG+GeNgqG6k52027qO9NGVmw4Ehm2as1jc1QJPbtu0jxAvb+ZjTWRU067RJnoK2YvJU01fP8riynr3h5+WYTUNURpjxvifrw0aC6kiUi9ZH6rafR57AJX7j7MzgRC+aFqVb4RW1DoHaZYYHjdC0vO17qTfgyE9rkSOspMzZIN4Z7GoptWTjX1c2ROvDTzJVyVP5Xle1d/CMSo1eRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8H9qBZBRLMqIyT0FxJfpUoZTUpqEVA3msPgQcX1pwM=;
 b=blPFh5gv0SzLQI/hbbOHIqvhmMC1DFWEBkzb+PVtnjNAaSRn8j7PsveRGhwyJGcKoiy7BeOTadcO10GeqG1lC9duo9HuoV/S+XYB58ZdqAEHf9NOVGK2Z1JibBKbUGZVHNmpaUv2VeaakXqdL9m4J4tyyy2yN8ljEmNzMVPkkI7NroAUf4ItGL9NK+kBKbpmgtsPIitwZoYBbA/CF8RluVLmmU1KEj1GokIw6QAoha7yWFmbAG3ljy/Z9EiKWjRXyVn66hA4AK+ovDbQ8pwS4thN729MwtR5NP6ok0BdRAlXlQrldGxieyf+wsMHvpPh88i9RRyW1HNBIsXqNWz3dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8H9qBZBRLMqIyT0FxJfpUoZTUpqEVA3msPgQcX1pwM=;
 b=biHpVYfKlxKUU1qfptIn86W17ukPGs9AzPTMIc8+/T2+sDUPAXkUbM2NfaT2tLg99f1KnVZ0Cvf8Ds7oZC7Uw7Z+rtt/il8DnQ9uUoXWs7NQ8mo5HaCg8W8KXnan4IWrIScFj0lE1ZXrvmKaHcSEPfh7CorQpNgRUy2439K8y2Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by GVXPR03MB10708.eurprd03.prod.outlook.com (2603:10a6:150:21a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 07:43:26 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 07:43:25 +0000
Date: Thu, 26 Nov 2026 08:43:22 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
 bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
 hannes@cmpxchg.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org,
 rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261126084322.4abc6744@linux.fritz.box>
In-Reply-To: <awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
References: <58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
	<20261119151416.33f90a64@linux.fritz.box>
	<471bf8d446becabfca00041fb2a78067@kernel.org>
	<20261120120659.2e902463@linux.fritz.box>
	<6fef47e08a37079c08806b3c57994778@kernel.org>
	<20261120212418.10221f2e@linux.fritz.box>
	<06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
	<20261123084345.4e24e3ca@luca64>
	<awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
	<20261123151846.3fdcbf4e@linux.fritz.box>
	<awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0146.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::7) To PAVPR03MB8969.eurprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|GVXPR03MB10708:EE_
X-MS-Office365-Filtering-Correlation-Id: b3ffa028-dadd-49bf-11a4-08df4b90f422
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|23010399003|376014|7416014|786006|366016|1800799024|10067099003|56012099006|11063799006|5023799004|261028144727099003|261022105027099003|261026121527099003|261021123027099003|261026140227099003|261021121427099003|261102123227099003|18002099003|4143699003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YtL0yDUJB8xU2ZLfePSp+cVowexsiydqJZAyaErDCBbK73tMwWy8F8ChhUax34B/lUo2MlPB5VJ6KDo6gdcqN6/I4WSd7wm7AdcUaBjpXbeLl3dFOcrZYu/9nhu2cuFeCUO2r43hR+1FCvIq5CHXvDbmx+DgNdT0CVggbN7VGuuMT4kEzkDKIbTfw3azUiLd8l9YLWCE7wz/uGDqFVN94IUAPjVFQR/Ly+s8efjF7VO2RPEBBWKVWQTLjc3CWOzdUrsbeYsqJaNZ9qfzgEuclZjnnleyj5qEbKGFvBSZP1xDm0s8tmgOgybBx4waeocdDZUbfvqQwgwOZ6n88BHu0RAma7CtzxaO1m6XheTj0NBN3W5Vm4RD+Te/M+rBt1Dg3fi69FkYy+IU/vcUAbkUwa3gV4E1wyf/XVog62drf8SjOEYZlYK3TB24ZbI1bHnpwYDuRhDl5/eMYYRhffeo3W1d6m0wHLCTQg1JeBJF3guLjNOLXO8UvZMi/ZjJ1m5KTYi02Zu1akStieJ0BCaq04QGO9ofgJC3MzNkRbt44vXFT9t/nKXatzgXv3hgmpiMoS0L71m3aBtUCOxbw7eGzPeg0KQX6Hmn+lQM/1evR5VB4Z2+v6KnaI31fBC8KDPljp0SqoE74ucIfUnHUms+A7jm8glHK4bvpNTJqwfM6P0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(376014)(7416014)(786006)(366016)(1800799024)(10067099003)(56012099006)(11063799006)(5023799004)(261028144727099003)(261022105027099003)(261026121527099003)(261021123027099003)(261026140227099003)(261021121427099003)(261102123227099003)(18002099003)(4143699003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nBv31IAjHVppTAmX8rH3faSkkC/cZGQp1mybFOFUcmkn5jTFEbpcwZsRrDQG?=
 =?us-ascii?Q?y697CPNK8fII5oXQQgJewCywt1x4vvSFB2KToUJN+POol3ptA2Eud0qU986+?=
 =?us-ascii?Q?jej5/jVDrZk9oQJFhiOW8x61FdWn6AMMoOp/nPCAyyr7vRhYal0Ky3R4M21M?=
 =?us-ascii?Q?uOUNWRIcxvc1eUgj3a9tXAyE6eJMca8c0cpKhUCDWBprOlOZWvXI18CBXuph?=
 =?us-ascii?Q?Qi1vlvu4liUVibGT1oCI9k15Nu5T7MdbvAe2k3rqqr+5ekytLbzrG5ihr6Lm?=
 =?us-ascii?Q?JPvMo5pnhEKdpdLsje5ZbkO0Q6BNttKK50eMMzuOMqhxqidsUdQPdl8NssNF?=
 =?us-ascii?Q?1eXsg4+Bwt0vptdgmd43cVsvkBvJFnZNfD5K/Ib+3fEFN/3oH4PE+fXG+KUc?=
 =?us-ascii?Q?d9BlzgV0Vzv+t5F4GEIxgeSWNR18moZILNRGk/uxIkHW823qxZGsaKw+RJn+?=
 =?us-ascii?Q?xFne+N3aG6Ua5p6S03B8nQg+PLSOahOzP33fyEk4XtHzlCmY3TJX0G9T7EDl?=
 =?us-ascii?Q?jmakvaU4/gS7VjdeKSI4752ln/x+Rsqs7c23nmhJ+mA/MnE+Hvvjg2bz620J?=
 =?us-ascii?Q?ajhWSSmq4ni3xPaEGHPZDDiNKwb/ao4NTwe02AcIP2AozFpO5oT/rT5l90NL?=
 =?us-ascii?Q?TmGJ+3wofjNbp10fopF1/qafr3aoy+vKnPkFNQDAjnB9h4BX19ddWHCwYIp5?=
 =?us-ascii?Q?cOffuj3NVBBQKD4cWyhD7ohM26C37in2yedgiPj9YspJDpLlvnsehDiUYH8U?=
 =?us-ascii?Q?+3tY4FKRhFi0yOHA78XIKol1G2yyOCiVljvT31H7JF4oVDwpgOwZkbGBY1pb?=
 =?us-ascii?Q?vST7AeU7oj4HjBa0wVDqvyoDQ242fBDAvPQQTzqoJYUxdur6Isj335UfJKmT?=
 =?us-ascii?Q?YJtZIcyeV96Naesp4UHL1EaUFJYncRKjjX7767DxX6xrDP5O+6DfgLG5in78?=
 =?us-ascii?Q?jI3zCrmS7+hbpUbe+0WNlKOTXby5ooGoT1R/8Wm3GQU5ecVWD/1bs6+6EbY4?=
 =?us-ascii?Q?vPOg9NFA2HbODmT82EIhnPDgku4AvusxxV3b+sv4VeaB4QiHczi9jmexTQAI?=
 =?us-ascii?Q?Zlo6zcQWCTU8PyPA5bkZe7/J0ww7bAZAbWzycIUCBfzmGX0rW5GK+UvbtNE2?=
 =?us-ascii?Q?9PHrZUTykuB82aRqWjUiDQmLwAZYqRNZu9U+LaeEoAkqo26im0EZZLsFBFnw?=
 =?us-ascii?Q?j4qq8tgGlOZt6OIIoBiTWLHwd+C82rKOYoEef4Q7DNnKgvkV7Ym8nQvua817?=
 =?us-ascii?Q?dXLvZP/imyQKVBlCF75+Ap76LROEJY3uZyhZuuO6bIDKxkUC+WpCfzEPAg4c?=
 =?us-ascii?Q?d4e0hL9cFDc212qJ1Wbef3KF8Q4pK26pDn4d9kl+VQjvrMqgWkyZdNUhIXqt?=
 =?us-ascii?Q?C55ReY4NB0/OCpuZb9L44u1TvpOfFhzoag3rdoWpWklNAFwEahqfX8YP9zwp?=
 =?us-ascii?Q?JEcEXgv3rb/ctNJnUbsxBZ+sWGorS/1vgzTnFyxUaQtdtOhwE+Rbjq7UDt+1?=
 =?us-ascii?Q?pg3Y1yx2P7BmBcotNMnqRsd4wT0ha7jWAjrgf78/9+7Bs9UEr0bhOQxxQbOS?=
 =?us-ascii?Q?44xaOAo7qBaeym5399YtF2SRuwbFGSAEV5phytzcNH1rz668om/S3DcFKQPv?=
 =?us-ascii?Q?7+GK6P0Sqsufxid4oWP9r1UIiH+mWGIgN6psl6JM70QQ8Cx55ANgFSaMIdQF?=
 =?us-ascii?Q?5QWyHXU20pTndRLgJycP6iBrwD8rRSlO4SHDknStzcKwmVQlR9goTeMmjgbe?=
 =?us-ascii?Q?oiPgyK0AN1wFRbHt1zOlQBJmspWyq0/qDxmjFUH9BkxENO6xNqKSZSK1ED9n?=
X-MS-Exchange-AntiSpam-MessageData-1: DHvNkO4uABeJmw==
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ffa028-dadd-49bf-11a4-08df4b90f422
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 07:43:25.4991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5q0GmDP0rqeaEpdnwasUOQhEPv6MLecnSCuWQuHPVziG6x6aMc5vb+hZ9z/2wfWDy92gq3VBSb8sH3Pgl3O49KbopgCh2daAsqEIJmHZwlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR03MB10708

Hi Juri,

On Thu, 26 Nov 2026 08:25:50 +0100
Juri Lelli <juri.lelli@redhat.com> wrote:
[...]
> Just for my own (hopefully) better understanding, I tried to come up
> with a setup that uses a cgroup with entries on some CPUs and "max" on
> others, to reason about it more concretely. This is an illustration,
> not a deployment I actually know of:
[...]

Thanks for the example, it really clarifies things a lot for me!
I am going to look at it in more details, but, just to check if I
understand correctly: the "trick" here is that "P" does not contain any
RT thread, and all the RT threads are either in "P/noncrit" or
"P/crit", right?



			Thanks again,
				Luca


> 
> A container runs a single RT process. A few threads (control loops)
> need a guaranteed budget. The other threads are FIFO as well (e.g.
> comms or watchdog threads that must preempt normal tasks promptly but
> use little CPU, or threads that simply inherited the policy), but
> need no guarantee, and shouldn't run on the reserved budget, as they
> would eat it while the loops sleep.
> 
>   P/          cpuset.cpus=0-10
>               cpu.rt.max: 4-10 runtime=400 period=1000
>   P/noncrit   cpuset.cpus=0-3   (threaded, no cpu.rt.max entries)
>   P/crit      cpuset.cpus=4-10  (threaded, no cpu.rt.max entries)
> 
> Threads in P/crit are served by P's servers on CPUs 4-10. Threads in
> P/noncrit find no entry up to the root on CPUs 0-3 and run as plain
> FIFO, as they do today. cpuset keeps the two sets apart, so no task
> ever moves between a server and the root runqueue, which I think
> addresses Luca's concern about tasks changing reservation on
> migration, at least for setups that care about the analysis.
> 
> The mixed config ends up on P because of _delegation_. P's cpu.rt.max
> belongs to whoever delegated P, and it's what bounds how much the
> container can reserve. The application only arranges its threads below
> it. If a cgroup had to be "all or nothing", the admin would have to
> give P either zero on CPUs 0-3 (no RT threads there at all, not very
> flexible) or a budget there (reserving DL bandwidth for threads that
> don't need it).
> 
> Tejun, is this the kind of usage you had in mind?
> 
> Everybody, is something like this anywhere near what you think people
> might be asking for? Do you have any other examples in mind?
> 

