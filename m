Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012069.outbound.protection.outlook.com [52.101.53.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2613C8C5D;
	Mon, 20 Jul 2026 07:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784533441; cv=fail; b=TxLMHKr8KUZ9sMQANhGx8eIGzxkDYH3SfIOjOx34JBlM30V0ngt92jWE+gNTwWV3J7p1OJq8jv8aT4fK5tN9WR34MWHjD9q99yupkQg6oCX8IQukiAOmHH/AFUOAmetC6yNOg7s8dWiob8syTo3JiVyiM9qIHP6WCLwSJZKlXDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784533441; c=relaxed/simple;
	bh=c+UT2U1V0a4hczm0iSUuRFmxTVrp2k88cyNCSTsmmkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h49YeLEm+ugKa7mkpAvJff8F/sFhNlgPX2MUJZ6Q6qIi+/NlDykpohy/V4X7DitucPd2cggt1QFkWs3bLbFjuLHj80a8+tFAUZw2xAdGt/S7rCtvp0pWnueRONpf3LhluD/BFnSROtaGa1f4Ld80xAl842KroG3pNSbnQSx5vH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X5bWF2Ec; arc=fail smtp.client-ip=52.101.53.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X5bWF2Ec"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=geKNSHKbhLIm0wArer6Bar2W0RNRYOxA3ueNRqWIyWDNKdCg0wzXEsiGSmBWF1qf8zm8vm5qZGUlHJZQ7kWTMt14PhT5g+38xOAiAGM9K84fZSMJdWSUPIme+kM5kINrqQDm2RmfWY1cCUrT2FMdaSWdiCsPTEchCgJMw/jAqHg6xtBl4HqRs8VRYR2P4nLqI2wZhGHo+hzRQ4iw/sIKPkROA36yuCexCk1ER1pazxZb82pvHHIDnuBV1EnxbxjuuCcvpQnurx47JmI6r5Rh1QUJ4WZZRFdi+08Gs3hn3Q7X83AREARvmE9rYWNwanzTOG8LEmywP/cTcskRPUwAgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74/7ycvB0Ut3eJIogKRvM4WITrP5D/rmnoU3QW/tiSg=;
 b=yTv4k48T8rrvni/fQ1/Q/D/0ql09N+7BVYqfOMINrbDOZt34U3Z0Nekc3DECsduBHDeIoyrmp73Agibp7zTt9U+FBbAt5mCcwPtwzlc6kemTviqXZfWuOTNiDvobgSuiiETWoNEK3rYaISbmVb+rVjCGCT1ZVLbNBIvf50/ab8PB1XycSu0hGwXmsxKYiu9PtB+CLIT3mfjRdqxjCVL763zJTDWlqm4xKWdpH0PrwuegYKd6sWrY2phWTKxGH3/YknHpke6V8P2Du1Blit86LFomNqu2mGTk8wF7lZ7tnYaAieP5JPh7MGEeGbrnm54horWxM44thz5JQb2N7r0DgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74/7ycvB0Ut3eJIogKRvM4WITrP5D/rmnoU3QW/tiSg=;
 b=X5bWF2EcQwagxCqpo2n5LSBWabQEN+1U/jW1kIItj5aIajtO7+swf/cCPljgLVbnxMYnRWg7KtLmhVAkCJ4dDd2UPdNO/oe6YqmhMdR+SC6bJM29XXS7ItkOhXZGVpAX06LnR6tk0hhQoJ6BOIJG7hmsaqPfR5RJiNwGY1XtvLKn1yphdXVzvkBw2REZXJkENV6TSLwk98SwWyX+tVFeMauxm5804KorDIrZA6kuz0gtbyv6Ll8sqbZ7FYfmW4fiWCEuyVlfMLh89leVsjwf4sHzxv/n8shqjjt5mjZ3/ergdmbxG91nZLbfLJjO314PQjiW27e6PYnKgtBBze9p9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by MW3PR12MB4491.namprd12.prod.outlook.com (2603:10b6:303:5c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Mon, 20 Jul
 2026 07:43:46 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%5]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 07:43:45 +0000
Date: Mon, 20 Jul 2026 09:43:36 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Changwoo Min <changwoo@igalia.com>,
	sched-ext@lists.linux.dev, Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] sched_ext: Re-home tasks on cgroup migration
Message-ID: <al3RqBffB5Df2l1J@gpd4>
References: <20260718081727.582037-1-tj@kernel.org>
 <20260718081727.582037-5-tj@kernel.org>
 <al24GoeqoJhGS4_H@gpd4>
 <al3RCfmqImr8mNaN@slm.duckdns.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al3RCfmqImr8mNaN@slm.duckdns.org>
X-ClientProxiedBy: MI2PEPF00000B82.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::415) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|MW3PR12MB4491:EE_
X-MS-Office365-Filtering-Correlation-Id: 50cc3bf2-92cd-4fd2-8a90-08dee632a0a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	t2eNtyrCrjTkjOJvjcMcdfGalp3iof0At8C20BBdZamnIKzCMysU8jxEHsFc2Kv7cSUHZk0FftnxR3PIbp0TGoKjsNW4fEgEF2xUZmeX5lVEi5J9nDcEf3c73QvSzzk7h6dogVfum6Wy4Ex6oVmwTquvhJ76uxqTD7PUbLQLufBAfSWF3hnLh61Ij87Z+mNHERCs4FxMYxymaddYbg8XplZXdFHmwg2xgR4so96a2RWBTzYWLQOE20qXb//Wigi5pDniyRwYbu47w2qpFNi7FuuzILRfZV96WCpqrFRtsJ6BYldGhAmlkw/6jxyT+GdUQgIMhN4Q0K8Fa9AyP6v6GroHR6A378sE5yombYPxghJTMfbkuKvn1V5FgQbJ0T6Zady7bhmk1C49T+HnQ0y+WSn5Sj4XyZlDrkjl1V3J/xi98JwKTE7Xbfcxyr8VTOhcDsAJHq1q4Zxxeg1Z4jOuFQZzHRmKGA8d/3hsnu/neCW1ecldJebDlVJRY/zjwV+WeV/uhffQdpK/YIsbTW7BBLDyY/OaGObROm4YY/6q86GBaHs7+F6nqzWGR8a8IAj8JSaEZLffRLx+CeYgAq0jEDhsFj+GGhj6JpkFyW8fqHEOhHxLaEmsqvEEjMjeGSejy4phf6++KYryOHOBtpxDjbqn2HV1ZwHwz7XQL2qFlLc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lV+QI4XMtLygpynYIzo28ZVwJnYDvJ9iR4VxAhQ5dXyxB1yfz1+uAnhsu5gc?=
 =?us-ascii?Q?EiptAFwYZD5RnOPE5NR/e0UvPbsvAGnIwfwe0I/ptUPpAEl52E3H1au8QdWQ?=
 =?us-ascii?Q?F69i3YTKupiPk20II+3vBJ1zDWwdh/YknEBv0BOFcxNgOrcliFrgLuPLf3Z2?=
 =?us-ascii?Q?V4trz4ZAz4jalFBQGBintFd6u0zYLpvxnplDco9fpzy+ggni20u987ElAkCC?=
 =?us-ascii?Q?SH6DSKQE6Vv3N5SC9cTngt3YWavnpjRQLAx0D5jPDFjw+0blQRTn3iBo4g45?=
 =?us-ascii?Q?Olif4uya9oxaUm30LM7Dcj7FeX8jtabF9lac9sV/9IbD6Q8m10vIMkTNb0EQ?=
 =?us-ascii?Q?K9lX1jNP4Umvh4JjVQRL8k+qBhcchzYTdc7hoz/xfAJbzkkT4FlVnvt+g4h9?=
 =?us-ascii?Q?65yZ2Gl/S1VZiMJAPUGcDryHgMrYnfHM9p/BYpWkn63xYzGhXvQXSAMrRmZR?=
 =?us-ascii?Q?Urb8AtTC5btAvj613y7rVaC4diqo/CkAToo5Na/NN3LMkSAeQ97HLdy+nSqL?=
 =?us-ascii?Q?k3E750uz596kbV5jyVMlQp/1ClxuZvKTPUve8WhFSfQmmq4IIH8WLG0khzm1?=
 =?us-ascii?Q?TuvbtDIY9i4oNO+G5En/rHyvZtgJeuHB7qIAjOefGUENeyio6otCIaK2l61S?=
 =?us-ascii?Q?L9CDtKWeTTo/rT3gFSs9aq+rOy62k7YWzsdV8djLuBmYwRWXA6nMZCx4KQj+?=
 =?us-ascii?Q?Upm+xbpER44+PAFfz4tdcuXfyjqpyjbRZufFvBBh3SBWfDY7ooFO9qkAI5Q4?=
 =?us-ascii?Q?t6p6lUUoNKVaEx5kuGKax3CqoXVjxNPx9F2jd3xc6IFRChGfc+Az6jwSQAjn?=
 =?us-ascii?Q?SMi6P2qZpsWZFj2qyjf4EtLsXuQGzOz2zMwx7z2EGzz2UEztAwaHQqVB9XgR?=
 =?us-ascii?Q?M23ue6oVR9B4yiP92z72WWkcIxFxontkGmlp2mGPJOraQT8KHQ6wm9C2l8xP?=
 =?us-ascii?Q?9hwNXPJomdzsbsUgt0bbHAee23vfQdxLP9H2lCC5ZRb7RCDwGnCF1qvHbbqB?=
 =?us-ascii?Q?UqoTm5MASrv95pdXiVa9IGM3t9SEYQ/9qpPFL8ofUIinyCJ2x7J3ci2FG7As?=
 =?us-ascii?Q?QkycZJC2DaFKX6WxtDaih+PmWliPrFSkpIrXV+Kf289MV5VvAjVUxf8qn0+7?=
 =?us-ascii?Q?G57AKMJXAA0jVAp4bx74KzQlzbqrLS093h6swFf2td820oGLIoDmoaalhCNH?=
 =?us-ascii?Q?+fptVJ7EnKp4Ucmm+ZTz3vCq+mvwl4AyoreFJHUZ3PQoVbNC3AUMpj5UAQP+?=
 =?us-ascii?Q?w7/u7MBc1CRNyNnAUHJ0UoZZNd1Qaxgs/4r5ukIRkTABy+JSUBzpQg4t5hrY?=
 =?us-ascii?Q?J/ZgKFH/l65axZDaLmhO1Jf/xCA/mWIDC5WwTsoA2A5X664BiLCy37eu3DjV?=
 =?us-ascii?Q?BLv+56EcxBkvFOjobwGI1wm0BLZ0c1mvhQQZ+W4JyfMXpCug2HlfkkRGf/Jc?=
 =?us-ascii?Q?5fYXceb5u83hIqA/x/Jh8dD9rTxdcOrTqRz2V6sTEUZds2QfWDsXIVeNZj8o?=
 =?us-ascii?Q?+9CsZVJ8xzN+ehyycd7hoPHg4iSoHP+W66d7iIdcQkvRl7zBS4UXD2B6DgJ6?=
 =?us-ascii?Q?G8s4YuLBcR3MVRn3lAX6ikSoGrsEyY60ijKL03YlH1QofuCPpFMVWFCv1vR2?=
 =?us-ascii?Q?eBMdl+9Qyf4Gpv/ozIbbMgskLotMHBjOjkVP25eawA8IBHvAUDbMl+oyscKo?=
 =?us-ascii?Q?tKsleSMqpTRMXkDm1A4k8bjIIxkGgdvE80Nfu4bAwgghBZCnX/YPa/sH+zOj?=
 =?us-ascii?Q?p9KrNR62IA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50cc3bf2-92cd-4fd2-8a90-08dee632a0a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 07:43:45.2949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QocDUORkJAZCwqkiGnOhu/t6kOo0Rk8dfa88bzRunOooCvLj/pKySlZU1eRFrcbtxO4P7Jzvu0Rek/asrklsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4491

On Sun, Jul 19, 2026 at 09:40:57PM -1000, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jul 20, 2026 at 07:54:34AM +0200, Andrea Righi wrote:
> > Should we add:
> > 
> > Fixes: 337ec00b1d9c ("sched_ext: Implement cgroup sub-sched enabling and disabling")
> > Closes: https://lore.kernel.org/r/alnxrsexEe_nQwqL@gpd4
> 
> I added Closes but skipped Fixed. The feature wasn't complete anyway and it
> still isn't fully complete (the restricted affinity problem still needs
> solving), and there's a lot of code churns and dependencies inbetween. I
> don't wanna tag Fixes and trigger stable backports.

Yeah, makes sense. Closes or Link is enough, at least we have a reference to the
issue.

Thanks,
-Andrea
