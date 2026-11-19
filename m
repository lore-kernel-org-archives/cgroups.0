Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.143
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795098474;
	b=B0KbeUZ34S5AxJVI53l/4KycsP+r9JLAK82YMNOwJ6T5lvsX1Xd8eWmyjn7XKwk/ion9
	 w2YUpfmpppW/ZGXJdiAg4LOjVQDr+tqxUnktq06p8W8e8rPUIJw4IPF9iXol2R4ZfX68j
	 2jBSVck88FikFLcPix86uMJuwET1noILAStHe47UHuVp87NPiLlDUlJm48Nczw8v17xUD
	 II+aaXJMeaJZwRjfbY7FOmfCewbErAD2i1xSfRkUcoYpWqyPcRInaKWngCXgMfNcu3j0f
	 ZVpCGNznVdDNG822nBoln1evK0FBQnvs8of6Qr/124eZr3WsCVMRydCN3z8UYrJRzmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795098474;
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
	bh=KTFpSFPiCE7jFTvsD52N8kx8IxtLDBPbpFjXlvJhs20=;
	b=VSwUA9t2D9/yMGZDxqZSPEMIPQ9qLu9u+B0fIfDD+F5y9GNHxl9qUSkiOu3Pu8ei3p9M
	 OBqvS5A6I4ToAAjVgf8xWhbjp5F5Vc1Kx6Zy0Plb879rMJIHz5mTWfo094DKVhQ1euyu8
	 ibfwVZjqNuZNEMXh8cTInotsmDS1Lms1RP4FO92i1eoNVdhdsJoac3cMLtz+IPbUt4OBz
	 HuXKge5xG9FnOxeWl55CTnqkqjHAqqqGRLk6EQIdP/529DB3kBgzu+A7hooanoPQdFvXg
	 exONWoogB1hHx/uL+Dj/clyjHHtZ/cAe8dpD/nyYNSye5IJnJadZo3pjBTINNGLAhPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=d6JC1pjx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.143
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021143.outbound.protection.outlook.com [52.101.70.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3B7606A331;
	Thu, 19 Nov 2026 14:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF3B7606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=d6JC1pjx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mwcwjX2nZJnPICMt4uSt3VDpCTUCluiZYBwWsFmUIM7c2zgt3AsQ644jSuraaQoC4vzadL/it6zTjMW+9JBNZLHnMVBR+i7eG//FDvHG36X/lVar6eM0pY4ZmzTdxA6DpRkD0rm9wOptgUnphNXFgi+X+dHp09mTiuThoqgxEDFenZ/qDTqaqrC4BjbKk9vYKX2jI7ge0PeNKZKUAMn3GOQKPfI9L9J4QGsjMiEoCWbw5TSDsk3965iU8axyJXbGbyW/CGvmIBerQ6IJgn3+I9Y2CvFbrFxlo6PHberYwPaLero56PerGKH5DS5ccuZiAdYczUfOBL1SfwXmeBr6jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTFpSFPiCE7jFTvsD52N8kx8IxtLDBPbpFjXlvJhs20=;
 b=qd5R1bGpHZyjCiVXAtDi47PdyTnTOYj/4VivFzDGa2TaO2eDPzJAk4M/JQ4puALKL1snwvLZ9Rsbf0zBxXu9jIrbojULdChmLm8OCtSUWKstoC1u9UCTyJnWk+HuDPGzUEL3daVUlQyUJJAafglCC5B7BjopuQYHqVYtO+JkgFhdQfuIDP83uCJshyofi7/qV8ZurId0pQmJQY9mAtUp8wJe76gsjXmNeUi0jwOCBDj3nB7PKiJU1zg88PWKoMp3CF5kPI+zWr5Rj5FbjPD/282vJ4PvYZzEF1+1y0QXU0317MhVRoZkskPETmMu0aqqipVX/kFCQvErbQYSe6pLZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTFpSFPiCE7jFTvsD52N8kx8IxtLDBPbpFjXlvJhs20=;
 b=d6JC1pjxhoO4ymunP15Xcj6IvBKnoK+ERqvSE9QgowjDXtbHN3iXxPmDco3SFO6cD9+PKkUKp+pQJjrixvqrjHoWkb2Kh89xa0x8Uo/xTEKPwdzWCyXzkyl0lvVBCmBIuUUHdALx74mAs9vuk1vMHELdZ1Sb4RRY0TSO84VKf4Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by DU0PR03MB8437.eurprd03.prod.outlook.com (2603:10a6:10:3b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 14:27:48 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 14:27:48 +0000
Date: Thu, 19 Nov 2026 15:27:44 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
 bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
 hannes@cmpxchg.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org,
 rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261119152744.3a2f7aed@linux.fritz.box>
In-Reply-To: <av7cRIyAMoiIR5k-@jlelli-thinkpadt14gen4.remote.csb>
References: <20261109163616.195264-1-yurand2000@gmail.com>
	<212c244d534ee1fdb0538a980789e16c@kernel.org>
	<20261111175657.250354-1-yurand2000@gmail.com>
	<58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
	<av7cRIyAMoiIR5k-@jlelli-thinkpadt14gen4.remote.csb>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0032.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::19) To PAVPR03MB8969.eurprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|DU0PR03MB8437:EE_
X-MS-Office365-Filtering-Correlation-Id: 694e4459-faa0-41f5-fdb6-08df464948c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|786006|1800799024|376014|10070799003|23010399003|261028144727099003|10067099003|5023799004|11063799006|4143699003|56012099006|261021123027099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|261026140227099003|261005181811599003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	9Wuy3GBqVFKO+xiARrnFWiExoEm9a7vCPII3Mebt9IG1LYqmvT0vzXh2sVgvYIqelv3R1zNxKPFQZ3A1QbJMb6j2IoqiWPWbN4e5Vl7xDmS3VklctRzqlv66Vh7BQEiFQudajV+JSGspgwwuNmAk16NWINxaN1Zy4nIinocJAqmuLdGow/0+gOTB3R6mrdUk9VEbvtJKpY7DKHzsBSvXA4StT2qB9DYa8WB0AzrZS2JSxio1f/k9VLQ86pkXtjFy/y7b4/lIQKbPhMuxD5iluF+yqgVrOw0evqfJEs1UVAB6LfB/A5tN2YUl7SxNKxLDM5CHcVfsi5eRmcSPTFOGBx2SmjWEhEiNHyBVYqw0PzBJDJvsbaq6UtSs+J8k4NqHGmJr3PbKXLlu0/rbbfo3dMAUCp7Nox/zlHyb4mHJX9Dk0jAzPE7snpzItjjqUs8JsVaD/4ImkjK0U6Ruos5QQ5TafZXxprYzooAzPSZ3GaCavNP9RkrJq7ZaWwpFqw00rSvwy3d1xeSj7UMpghNN3aLbDxd0PoVhtxzbx1tKb/j6HLMAcMhT/RXXkb4swCzImKiEHqCx4jU5lqVtgpxdiVeI0fdVFx3X9vl8m74w0Q/JjAdxakpjtyHfgCz/rqcyEDA62S5dtjtOR/t44hjVRGf4geCj2oIK7PvWHiJwY+4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(786006)(1800799024)(376014)(10070799003)(23010399003)(261028144727099003)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(261026140227099003)(261005181811599003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XRx4PCvhxVRoYcvchvvKrO1E9sYjsBoCUTJpd0cwmnBqoT8bmtYqaEMVNpCf?=
 =?us-ascii?Q?dI/KowpX49D479+8GKC42y3blTfS4/bVcDgc7eA8sYix+PXJtwHtPKeqGyIW?=
 =?us-ascii?Q?S9a2+uE8UCbnk+WMQ6CTZfI4hV7Bf9OAsrYtWuzPcNyyLs6pE3JYTiRmH5ro?=
 =?us-ascii?Q?NP0iWdoCChfvIGtTY0778V0WdNFMx3N2+sBeZfXS9MzpRj3CfcuW9JtS4Uig?=
 =?us-ascii?Q?1QYiaZ5BXhVP1vednraR/acjtOYn+i6QMH5nZQxDFuGkJEX3ac1iRcxIv5y4?=
 =?us-ascii?Q?CI2EJSWydCAOBZUKHALuHFEArMhEe29ys6ydrgxVilwMlgmu00N3ZpBOcU+a?=
 =?us-ascii?Q?FD3VnKTD1Pfi4lCREUlZnjkjreixLuqwcbYuchX/Zb8HoLvaWpwgcoFr4jE0?=
 =?us-ascii?Q?Uj1QUaY4CjHbX3Zq5hEkGCxzHFu0GECwTC+f43cQFahqzaE3d/KTVOmysI1L?=
 =?us-ascii?Q?vuPXckjMs6zks3+veQfERtBJ3mYCj505cQyJEf//tNNtYj9igGx+yVf6wJd/?=
 =?us-ascii?Q?EF5XVBXDi7DRZ2l9yf3rAvPgmEPwWA62Zievo4TGlsxr3ySADTJYsX9NT3mx?=
 =?us-ascii?Q?cBPRvmabtsAM747yNNrt3ZjYLNeaagWRR/PaVed4SJDQdRuT/YZMxOIEdG5H?=
 =?us-ascii?Q?RRGf1RL0bHDRYMeRTiEO99E0CELD+5XOvw7KDLG//rFrGhm4ytMF1KyJB7Sr?=
 =?us-ascii?Q?BsSYguKUv6RjcXfmSqnPFcyZcKLicHVBPQshC/LAmnFcBOk61L/S5MhcX0qp?=
 =?us-ascii?Q?nPR7RPKQ/wExnVn/w0tGkc492CVjTJGBaeyv9cpjYImHbZvJ+DQMhMTMWpaR?=
 =?us-ascii?Q?bgqEJm6yrLUSiRqnUrIjKavgtaVyD5zzMUepm0C7IxfF8GL5rVRmcwW5IN34?=
 =?us-ascii?Q?JNd11vBaDaaST6BexKWqOUopQ2b89HnLWA2RBUT2ggFK8j9Hc8S02M428cNk?=
 =?us-ascii?Q?I6soFqIczamo0kflHYlji9PVhip2+i565aR9BXj25EDqcUdDdk/itvAsR/CB?=
 =?us-ascii?Q?tamDFEbgMbvOj0C7gpa7xAJD6vAxMUS4JkXe7fTuYXAEqBJV5uQqSFzNzAcV?=
 =?us-ascii?Q?pG0CPDaM08dZeclg3QD2uSMFFD99sWOpfP4V90FsDizeiGCagkafNgNMPQg2?=
 =?us-ascii?Q?x5kL424DMqwRKR/uRWWCa7/yrQlKqvxlfhNEGDA5OvhrePtCKtQm8cw2LXQ7?=
 =?us-ascii?Q?G0+W64HpnTZJ49UyfI7N+Dzae87DJaacjapnZYim3ZaeoIQu7CYq6g5sM16j?=
 =?us-ascii?Q?5JISavvh9YjF1olxR1o97GmN2N9MRnsBRVOOxYOObZT0PXvhRr4ZZ2YYum3Q?=
 =?us-ascii?Q?Kp0gpagkBYX/xBqC4TSwJHjAzIjUoglYnJ4YK+ExlFqqrFvAO27r1dC5P48b?=
 =?us-ascii?Q?3mahripPfz/3LwQTdImHy/eNHDJzj1vwgCtqXNvO6XBdSKd/lP6z9leXYYXO?=
 =?us-ascii?Q?4TkxfVLPb75MqiboDPK9926yYg6KUCCAGE9KxnONkcM8KLu2QlURrwHHW1et?=
 =?us-ascii?Q?DqisX1xLEJDGTGcuC4wyCRoXuik0BntGyzJB8yIzfluJEUwJGxf0TsYTK9xs?=
 =?us-ascii?Q?bDOpv7ZJddUmvyQIhuJa14J9v93BlXwW8n1QTpI300YxiPKKj7MYxsARqyMS?=
 =?us-ascii?Q?s7UzPOkFewWBCRXkgFbAyJNEMhduGm20FoRyLwxVjO6wigQZBropAS65duHj?=
 =?us-ascii?Q?WckAosml4HyjdP07TvV3RYtODG1GGy24FAEHDv7UJ7wb1GcYnJDr4FbA43bZ?=
 =?us-ascii?Q?9lZ3mDX8qh8uUSWUKOFEBo/vbOiBDvpddYEEzrHELTKwnnfVBpA5AAS5Z3JQ?=
X-MS-Exchange-AntiSpam-MessageData-1: UfOOjYItsddc1A==
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 694e4459-faa0-41f5-fdb6-08df464948c5
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 14:27:47.9079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8t1lWaeP5+dYHIddNFNcZQOknTEcOGdCvwmjDbrzLnoRg6MTmIMLZErvd5m8ahbHEr1Wr3uyqCKwrow/fGHQ1vI9zBK4pxwMfaqV3YHBzII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8437

Hi Juri,

On Thu, 19 Nov 2026 12:23:48 +0100
Juri Lelli <juri.lelli@redhat.com> wrote:
[...]
> > On Wed, Nov 11, 2026 at 06:56:57PM +0100, Yuri Andriaccio wrote:  
> > > - `cpu.rt.max` only accepts per-CPU settings, so the global
> > > "default" is removed. Removing all overrides means the cgroup is
> > > a "max" cgroup, while just a single override means that the
> > > cgroup has its own budget.
> > >   + This new interface disallows zero-runtime overrides, as a
> > > zero override is equal to an empty override when there is at
> > > least one non-zero override. As an example: [<CPU0 10ms 100ms>,
> > > <CPU1 0ms 100ms>] is equal to just having [<CPU0 10ms 100ms>].
> > > This seems a bit odd, how to make this better?  
> > 
> > It's odd because a missing entry means "max" when there are no
> > entries and zero when there are some. Can a missing entry always
> > mean "max", per CPU? On a CPU that a cgroup has no entry for, its
> > tasks would be served by the nearest ancestor which has one. Zero
> > then becomes a regular value which is shown on read, and the two
> > configs in your example are different. The former can't run RT
> > tasks on CPU1. The latter runs them on the ancestor's budget there.
> > 
> > This means that a cgroup can have its own budget on some CPUs and be
> > "max" on the others. That is a fundamental part of the interface,
> > so I think it's best to get it right from the get-go rather than
> > starting with a restriction.
> >   
> 
> Agree on making zero a regular value and on a missing entry always
> meaning "max".

I think "0" as a regular value is agreed upon by everyone :)
But I would avoid "missing entries meaning max"... See my previous
email.
Basically, I think a cgroup should either inherit from the parent for
every core, or define a deadline entity (even one with 0 runtime) on
every core. Mixing the two is, in my opinion, problematic (for example,
it would change the serving reservation when a task migrates from one
core to another)).
I hope this "all-or-nothing" approach is acceptable...


[...]
> Making a missing entry mean zero at the top would bring back the
> ambiguity you pointed out, so what about keeping your semantics and
> adding a validity rule instead:
> 
>   A cgroup can be served by the root either on all of its CPUs or on
>   none of them.

As mentioned above, I would be even more drastic:
   A cgroup can be served by an ancestor either on all of its CPUs or on
   none of them.

What do you think? Can this approach be acceptable?


> In practice, a cgroup whose parent is entirely root served (e.g. a
> top level group) has entries for all possible CPUs or for none. A
> write that would leave some CPUs served by a server (or zero) and
> others by the root fails with -EINVAL, like the existing admission
> checks. Further down, a missing entry is fine and means the parent's
> context on that CPU, which is always a real server or an explicit
> zero.
> 
> With that, per CPU:
> 
>   - no entry: served by the parent's context on that CPU
>   - runtime=0: no RT on that CPU, shown on read
>   - runtime=N period=P: own server on that CPU

If what I wrote above is OK, I would just avoid the "no entry" case,
and I would define the interface so that missing entries are not
possible (for example, see my previous email: we first set a (runtime,
period) for all core, then we can override some of them... But not with
"max").


> > The root has no ancestor to fall back to, so a missing entry can't
> > mean anything there. It has to always carry an entry for every
> > possible CPU, which defaults to zero, and reject "max":
> > 
> >   0-127 runtime=0 period=1000000  
> 
> Also, related to the above: on the root these numbers mean something
> else (how much DL bandwidth cgroups may reserve, not a server for the
> root's tasks), and showing them in the same file and format is part of
> what makes the example misleading. Would you be OK with dropping
> cpu.rt.max on the root and exposing the parameters through a
> separately named root-only file (or the existing sysctls)? That way,
> having no entry all the way up consistently means unmanaged FIFO/RR,
> and nothing on the root looks like a budget those tasks share.

Regardless of the filenames we decide, the defaults for these settings
indicate the fraction of CPU time that can be consumed by all real-time
tasks that are not in the root cgroup, right?



				Thanks,
					Luca
