Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.118
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795679900;
	b=vsgHxd2yRLk6KQCg13aupXgeANUyBRSuXXJifwl28Ebm+vyCn3qYg1CksnGmWzWFDRn6
	 mdWg9BWqCV9J9q9l03bXSz01U7qyQHG1jrCsYxDBUjy/+L9OClc9+A6yrGDpW3kb4Pn7K
	 cWBumHs8fT4FWhvKs6PbwNQIHc0r8eN/ZFxbYXW5l4WBHt83RXE/yR8UliADRD/mOuJ17
	 20JacgCquOS2JLx6OFcAQsmaBAcDy4Ijp1UgRpI3Hf+27Hgogco1nEywkHSmy6q7dlW38
	 Mh0zY51b92kzv4HcG2jNg8/LPU9tvZuDk+taIl4TZL8SQPBdU4cHAvNZdc7ulT00DgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795679900;
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
	bh=hZ7jOctKUd9VcXuYBW7YnyG2SNkuQP6bOfcHtCIXCds=;
	b=rprKfnLxCGonsLmEaaUAc3uPcYr4nZAjtUO7ru/XphFePZB/s3R8ZzXxg4ILj5hVHuDI
	 eUm54ITgIEizQEEo4KacU+cnzRvK+5EBW3IWjLq2gBqr9ImoFk+P+H4ylbu4mdS0UV0hr
	 i4SMTfnSl2Hw2zAKaKBnF9Z/EU1N/Dbs0z5CfBzDok8J2DNhzjSdf71KwRsS3bpcKSSZK
	 GT74tMJ4h8K7iTUZmh1P5OJSux+eY2psskO7oJZORHQdfjd7CLCbKI3dm+ZCsmWaq2z18
	 O1+whMkf/oNxz4odCx67c+aetPd2VSA690cc9p2SLi0Bnd9TKSqqsqG7Hpt+tJSeWCg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=fePG8tcx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.118
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021118.outbound.protection.outlook.com [52.101.70.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9F8606A31E;
	Thu, 26 Nov 2026 07:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D9F8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=fePG8tcx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZxZ2G1brdJNqCLltpLwGHCEY/KaH4A6OSWQTFnOLTLCidozbfoQEPOqXjsn0ACZISyw6VLrHp3YCwB9jri9l8/kS4I5QyV9qK7DXEyKd+IVRm/o9/d8aKUVPwq+DT68Mf+S4heB1QrBwjztd/HRULr8mcgkfJft/zH//Bu97EzQGxwCIEqZ6q9FEYJdV8z34hGm5X/LL9E7OLVC3fv0fY7ddp3EzbN3EBu668hfFXhO6qWSFqec+bRbUo05t3m+k11vQ4oagSHu2KFgVE+XfPz+fj9SAYuIFW8wYDFJcfWqbQGgWYf5yfdav2VzkfrGgpr2t4u/LsYuTCE+ZWUzPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZ7jOctKUd9VcXuYBW7YnyG2SNkuQP6bOfcHtCIXCds=;
 b=MhXEPNrh3v/fz4jnVOff75SdkYMA4vB7467SNQqVPsv8VBsnunV23FfXBWbRuWWeglw05oEL3q7EtUqZ4BeiRuZD0sNQXtHAHJITXuHJ+sCohpMTvWJhixbBjwKJeXKCNsqEhu8oSVqiE8hEQi3rP5x4l6B9Tp3Xzt3wxX/Jd8GaY06p5rKE9C9WKPj0YyDSEwsi05tBmWI2h0UQhtjVDOgSq+m1kODj90diZp2909OCjIllhQU0hX2GgEy7qzI+30yqPK23/XgQuyhZlFRBokRlP8xiH0WUUmKjkESNbyxeBD+0a/emnU2fG/xsf30CTIY2AtrHNeA//0KUldboBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZ7jOctKUd9VcXuYBW7YnyG2SNkuQP6bOfcHtCIXCds=;
 b=fePG8tcx72LBvUNFOCzgMqSGJMUAvzgMn6W2kV+Hq7VdLJQsplYmmZTshEs0eI87+0/RO4oNXDFk37DOtQFY0z0vNGzETAPXfdOv1CSzma+86UfQO1RY7KHzj67oIvT2jeQVXnvv7JBLLKrhagBMVkWR8DPnFyIZEPj3oIpawg8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by GVXPR03MB11113.eurprd03.prod.outlook.com (2603:10a6:150:2a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 07:58:14 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 07:58:14 +0000
Date: Thu, 26 Nov 2026 08:58:11 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
 bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
 hannes@cmpxchg.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org,
 rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261126085811.33e7f074@linux.fritz.box>
In-Reply-To: <awfkczwhkLkXVEVz@jlelli-thinkpadt14gen4.remote.csb>
References: <471bf8d446becabfca00041fb2a78067@kernel.org>
	<20261120120659.2e902463@linux.fritz.box>
	<6fef47e08a37079c08806b3c57994778@kernel.org>
	<20261120212418.10221f2e@linux.fritz.box>
	<06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
	<20261123084345.4e24e3ca@luca64>
	<awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
	<20261123151846.3fdcbf4e@linux.fritz.box>
	<awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
	<20261126084322.4abc6744@linux.fritz.box>
	<awfkczwhkLkXVEVz@jlelli-thinkpadt14gen4.remote.csb>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI2P293CA0005.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::12) To PAVPR03MB8969.eurprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|GVXPR03MB11113:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f8f38c9-82f4-43da-266a-08df4b9305db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|10070799003|786006|23010399003|11063799006|4143699003|18002099003|22082099003|10067099003|56012099006|261028144727099003|261026121527099003|261026140227099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	pk08f57bZW8pDOa/MukHHaFY6+1hLxbeEbpOhPnWf9FQ4MN0Y0+tvhLy1MD9E2EZyiIhBOWmocdXAro3SSgAr4NO7Nl9hoGA1JeHTQYsTSQdShjjKPE4cFcQbo2kTVaJq7zmx1DHXgkR7fESMudRuJDsWVSY+8SW5ze6mluHKz4uiz6zfwPJniZiRZuP3xoADhBdglaNj6nuiy9+AEYWCS3uJfKfpPnM0+mynCAittqoIhmGR4GvlkKfK4MnUsWgrdIIVaqAnUfFTG6cWHGqHEefKwzXPsf+BnmWz5MDNeF+SdeubF0Zt0ggAwHLwCYqT2qtWnDb30IwjX7N3vRHBbs0kuVLhFwtNR2sIB2ENV6ykPDzeOgGAXgiN9v0imN/OqKgFpny30pfyH81+XvgvipElbs6uuyB9Sm+Dj5bhKstRpGrbscT8YPxAuOGknfVag74XbkEvWdMTkePLirnrepKSBgK61XRzMS5jKhl1JYNsRVstcERqQCYQ6ED5YVfquQDIoo8K2uD+lW9i2Uc5krib4YXzvCeu7DuWimelrvyyug2rDP291dHxNnaLeIFz1u98q/A29BNSzP47uA/oczHo8OhfXQjEdzZlUlfgRep/5w64dd5R2BzGsoDob9q5ODFO9f9SRuGYK6if4fZYypWHkYn8MBpQDlyiOtwdI0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(10070799003)(786006)(23010399003)(11063799006)(4143699003)(18002099003)(22082099003)(10067099003)(56012099006)(261028144727099003)(261026121527099003)(261026140227099003)(261022105027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6bV/fzPdvHgygYwU+Q8XPXWTsq8yNvNMn8VYmbzlhEb+lWpurhtCi8Zzd0ar?=
 =?us-ascii?Q?mPVyTwJtvTA1rK4AqFlxmm+hVLBkBsZ2gbmerIxTrdw82sFzLi2rc+peqUGr?=
 =?us-ascii?Q?smsid0vwBQEa1tKsR8w+K+McKYkc2/jopqmShd6E18FaKh+SvSR5ZzfrA+uV?=
 =?us-ascii?Q?WDuMlj6C8Omnf27M2v2VE1S0KVROm0qR5kZ0wbGp2FjvfmRYCcv29xLcq6+u?=
 =?us-ascii?Q?mm1/kTB9fMUONWa9xXa7Ui68ynPce2/k7mIErBNhXvEnZCQDgSWzKaLlYpfd?=
 =?us-ascii?Q?6eJI7mkTj51Q/aZZDekZGKbsayzh/IUHLxhD2jKBayJRobuomMJMCPQ5w7QZ?=
 =?us-ascii?Q?4GkH8u4dCv8NLeKuPfwn0mXSNmdeshqBAWHwNReZXo3wWVbju42cZderZR65?=
 =?us-ascii?Q?1wuTsv+d0DZPji/fAc//mJ3OtHdMOTXjrHLnsSNjZuZAklIrOHS8Ws+YbVk2?=
 =?us-ascii?Q?jkNMchIeyzPMZaXLs2TaPAWP6iIrFuWYvjrnEJ4vIhygqeAvNKXp0sGz7pcL?=
 =?us-ascii?Q?kdFt+TavFy4t5DQ+A79VAeFqW6tqYZ+h0XubSXINi6fmu1d+THTNyGUMo2zP?=
 =?us-ascii?Q?hNSo53iDyk9kYFdKvgFBo8RsC0i3uFWipY4qQmJzXNXEn5I6ymbFT+JQLzgk?=
 =?us-ascii?Q?DQgn3ReZvS7YlwnEhzud21GtMx0XF0jBJ7Tvsk551TyKPEQyHsmDHqhhTKX9?=
 =?us-ascii?Q?MMHaj7mm0XQwYneZgHETF266oACOitJcST5q7UC94cF7S5bgXQHaeCHB1f7Y?=
 =?us-ascii?Q?O2kBL39+sTA6NEF360Uzq49yrLKBQ+1oPNaWceoKk9Yq2gk3o9cyyj4z8Kcg?=
 =?us-ascii?Q?jknryfz+wQaw0Jx7wvnEjkBjFkKtOf7WmpFtAmj92W+/j94RJDADwbcH6MbE?=
 =?us-ascii?Q?I4MpWBSqkcjWoJ3666SMIsz5LR5jweVUUMbyISB5SczhUDeXkv3UtF+JrBWF?=
 =?us-ascii?Q?WDsoyFXlE9397CKVWPoogol5/od56WZeszsjH1plyKYC865J/tLrtuv8T3lS?=
 =?us-ascii?Q?46bOj8HL5BSx3XQRTGdUMRRm88ryaBBO53klSS9gpJ0fT9RlDQvGy3s8U+Lr?=
 =?us-ascii?Q?F8TyMSm9AqSvF9V8OC3T8PMWfPTIz1WApJ0Umfndc49KYsW9hKv099BK+xTv?=
 =?us-ascii?Q?8I+osZwdsOlyrDCSV2kXMNwyH/N1tpOAiLDb9TFKigjWnzQErcxa2Q2c3FNV?=
 =?us-ascii?Q?vyy3BYZbrX4EKnP50TxEEwezny2JpoxOgJYxeqEUW2TeLQVOH9OnyHnGceZY?=
 =?us-ascii?Q?ycT6wi9Y/VpnUbvZJNw8GCDjMfXIvZqT301+SQm48UbQIigGdVYs/gq56G1a?=
 =?us-ascii?Q?CQM0b2TVB2eFkgsJ3eojm69i8odREmCjHwC4RyEFt033/zgNvCZHxDEhPIe+?=
 =?us-ascii?Q?mrme29Ec3n8XYKu489+f53wYhA7bj5ewEKbMXrzUZkG/kfHXG1/buRWrS2My?=
 =?us-ascii?Q?MBIQiGbBeyEBXVbYm1QYiCDd7slumOa0gMZGjU4LOfp05xwa421V2oI7tYal?=
 =?us-ascii?Q?4Y3WpkCuZvTUl+m6ztoSu1XxDRZuLOFULGbkzj+3Vjt8zpgS1AwZ3GCYFmlu?=
 =?us-ascii?Q?MR4DrIePvPEhRAcRY6GktjPdRiHQdfp2PdXbyNrYLolnxbFEeiWsQnENUUW3?=
 =?us-ascii?Q?UtOD2ee8nO4ZZkSNDy0RkgNvNCXjazQB6luvCwpMTD9ikLvtz3Tw0nWptiqV?=
 =?us-ascii?Q?Txx5YezPho1XZ8JhBNKwvYsElQbGuw/e5I1FtM5cOR5ezSm0cHaxudMtGdIf?=
 =?us-ascii?Q?5YAJ1RPcV88De1Qd1ZY0EbXVHfGBIXdQqZ9AE1+Ag6boZ31Y5GOksyAXpypO?=
X-MS-Exchange-AntiSpam-MessageData-1: NDY9WsdQemloHw==
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8f38c9-82f4-43da-266a-08df4b9305db
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 07:58:14.1620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wMsGqwd1cb9cqz46Otu6OCo3gmZawREbF7rOkQdSix4OHbXS2uevrdDCWHeyp8AnigHpQlCIbGpPhR9EMLTtu2x/icNAwmySlLCDN1W+yaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR03MB11113

On Thu, 26 Nov 2026 08:49:07 +0100
Juri Lelli <juri.lelli@redhat.com> wrote:

> On 26/11/26 08:43, luca abeni wrote:
> > Hi Juri,
> > 
> > On Thu, 26 Nov 2026 08:25:50 +0100
> > Juri Lelli <juri.lelli@redhat.com> wrote:
> > [...]  
> > > Just for my own (hopefully) better understanding, I tried to come
> > > up with a setup that uses a cgroup with entries on some CPUs and
> > > "max" on others, to reason about it more concretely. This is an
> > > illustration, not a deployment I actually know of:  
> > [...]
> > 
> > Thanks for the example, it really clarifies things a lot for me!
> > I am going to look at it in more details, but, just to check if I
> > understand correctly: the "trick" here is that "P" does not contain
> > any RT thread, and all the RT threads are either in "P/noncrit" or
> > "P/crit", right?  
> 
> It would make sense to me. Also, I seem to remember we said it was
> actually a requirement at some point (threads only allowed in leaf
> nodes), but I might be wrong.

Yes, this was the original design...
But I think the removal of the "threads allowed only in leaf nodes"
constraint was requested in previous discussion (I do not remember the
details, so correct me if I am wrong)


			Luca
