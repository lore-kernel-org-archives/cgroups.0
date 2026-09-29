Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010031.outbound.protection.outlook.com [52.101.61.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683D0388E4B;
	Tue, 29 Sep 2026 19:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790711905; cv=fail; b=a9XlQUGE1nWTM2ZgIVGJmByP1G6vofrqRagLVuMQBnEpKYa7XcQ6nOCIz36do+gc4fKvjUvgjwb6BKMg+j/GaNr0tsJkkU9Yr60hJ3mRcs3hio6B5GomOOGaHt/FIr+V0hjaXuTDGGzitwBqPgIZ76/rX1Dv7Z2lAs6WmrPGhn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790711905; c=relaxed/simple;
	bh=V4of4D2m7ccw84UWZQo7kI1tzk4ybtpPqdWrWpsYTIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QdznclvlynmEXIANAW2bfwBgus4ZsQOZBLbuHvOfY4/awluCR9Jjl+knsb6az+zvfJkd6IbOhuBYgnawzbjOti+XfEl/sTC8w4uzPFcVXn10vJ10N/1SYQ2ygDxW2drRP5YoH8BQ7E6ROnoDoOL0WgTHleZs8xe6ACwGcBj4zBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qohFHI2z reason="signature verification failed"; arc=fail smtp.client-ip=52.101.61.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qohFHI2z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p81PlFX8bW5PWQ0l8QQFFri/Seq3KvrdSQWpmeLInpkh+GghVkf2OAY6H8Jp8yzQ9HtMiALrQBh9OyXOFShkDF0fNUhgz6GjYGqJ3CXbImGSfV40iqGOcOnz2jqImDDVwCHs1gr2dSF1ZyWwfQ0O7l+sAqjbHH6eflRtxfHjFeeWowoLfvjvncIx2VElm6S709yAECtWugtLgHQ+YVTWwkQ094RAutzYAETCChmmlN6oZyY+gjzL4qSaNvItCul+MvbG9KRJWUNp5uz4GwptWjxf++6LlV2Mdro8CDKJmzR38mq5rmbganBJy79hM9czKYzjfZgRYJDPorRl3CunFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nEC3+2Cs0OE2kwwP9J49EtCcb5k1dFvJNJucQiOUvdk=;
 b=gnwp/Xp83s93ihsCIzBvhDksKH7bZ2YIWW/YdCtFZurpsINFiAe0gFKgyP9yPUywNQtQ5PtqYoNCgmQiZ3Gz1zSKbusR7hL/KzrT/6lUkkJ2dMhTCQd1ECZv8LBuSG9aN+1jaLG089JnFbEAMwynE8sNHppL9ph+yoTkRTZ0szr+fI3opN8aciYZzXJUmN4qW+H2wOnr4Mr+tE/mxZZuUqBOWN8BKoo2m3u38/KQJg5sa2DxMDiONCndJ5NNJoVvvQUCsOgR4C6oR/eQ8h612lHa+trbt1Eqv2fYh6cx/OxPnGlv1P2FxQIuQbpfNhNGL4cVYHNvW5uR5w8Gki0pBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEC3+2Cs0OE2kwwP9J49EtCcb5k1dFvJNJucQiOUvdk=;
 b=qohFHI2zqtvOlOVlsg6Cwnc6N/NH5KgFhvaBL4moxRnHQFsCDlgNjIbKVSVqKxhvnUhJoGU5KaRXeAqJ72u2TiUbwUtJFZFbPX5GPf/O+69ma8HDxLIccc7537aFU7Mu1VLTwlM9DBKp3eeWYSC3TqXSVlenpg/ckvn1SjXfUt4IBnGuLdlAIIdwIMjLo+dKjDaR5NHnTtUqVjpj1/9xSRKy3NXr47/7D6pkyjPgXjvQed28LbQ5zS4LpTkwl0JZQWAvrR5krh3NEbe3y1dRYDUKbZkHYHNRbNI6IKb41USNanPBa+9Qcz+RyUn0KtyPU7LvnKwKTN2jrQBrI3kVBw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4827.namprd12.prod.outlook.com (2603:10b6:5:1d6::14)
 by DM4PR12MB8498.namprd12.prod.outlook.com (2603:10b6:8:183::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 19:57:48 +0000
Received: from DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c]) by DM6PR12MB4827.namprd12.prod.outlook.com
 ([fe80::6261:3040:864b:159c%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 19:57:48 +0000
Date: Tue, 29 Sep 2026 21:57:38 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] cgroup/cpuset: Protect is_in_v2_mode() in
 cpuset_num_cpus()
Message-ID: <arwYMtRrbObni2qk@gpd4>
References: <20260929084124.626693-1-arighi@nvidia.com>
 <20260929084124.626693-2-arighi@nvidia.com>
 <20260929-making-language-254d9c6a6605@there>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260929-making-language-254d9c6a6605@there>
X-ClientProxiedBy: MI1P293CA0025.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:3::11) To DM6PR12MB4827.namprd12.prod.outlook.com
 (2603:10b6:5:1d6::14)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4827:EE_|DM4PR12MB8498:EE_
X-MS-Office365-Filtering-Correlation-Id: cb3cd2e9-9393-442f-aa88-08df1e63ef91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|7416014|10067099003|11063799006|56012099006|4143699003|6133799003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	p3WBQ0OlC06zlhmH7gxF/whuzkemDAQslnha7cZ8BMhDVMykY9Q358PrQ/OhdnO02824qsasyCr4XeNOSa1nDV7vgH5QJcwJyYJvcmpTBYxrVVIEcSe0osC40/2k1s/F9EL9Aw9thTXgnwn8aN4N1D3XGq1UMKCkv9RPQ9zi8FNPXvxYnsUcJhvWsPYV+5qxRCUdqGg4SN4x2zRK+jbo+Fr3bIKXh3Fijtj0lbIX0C7rZJ5uI9xdh8FtBj3s28QnHCNCRTMoMbPnsBw1aQe5Wi+6pYZv2vhhRfWkS3t/1W48rg6VAB9pJbPtcfLbRsJX27vEdFh5KPsbFyPf/ua7agL4A44rUJQzsvBOpb+z1RhRKPz0HCTSfcMst6VFjiUyB6B5tsjVSM4KYgvVGnBirbbRPrVd1oBL2klbl7PP1rh3nj8BW7hXkdSkY732c27yFxmO2jL9hRWa/uVOZQMGSeTnsMFcViBBY8eOcKlyCgNhTcOBBTmLB+f1rMHVTpY2N2UHrCpERJKbNi4GjdSfW7kjWcb9/2uUc+qrTmS9W1GUuPCsfppvQDX1Dc9kpUl1pQjWU1JhsgCyI2NR7wZu/NpUi2nplmqu12LtKidc0TgvEua18Tvyus4zyEs8tvM/OZjj3ClDjyH8Z4koaGClOZGuO3q8ohzdHcTowXmjqiQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(7416014)(10067099003)(11063799006)(56012099006)(4143699003)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?QgVYPWt+YYCXaBpTZdqGLZKieWlBMjnvxo3wPq0qA5zOl7ZrW9iL5wuomZ?=
 =?iso-8859-1?Q?LF+JaQaBVfPQ6Soe/xM+gNBM5wOmHpLAjvST+DVWyEXw57uZu5kN3eD40e?=
 =?iso-8859-1?Q?I2KRBDGqWJYCsnyNAK2/XXKQO9s3QfuwhbHOs3SYN89oLlD/vilVj56kQP?=
 =?iso-8859-1?Q?dxdZTyT6dYMOPbckxurGufm7XwTRRmJ9XLSnLPOiN63RXWnSUrxnFxAZxb?=
 =?iso-8859-1?Q?Qri3mceND2kStIKukw/3hVj98E9U/NH5FMCeuKUqelw6Mg1EjWDwrETxa1?=
 =?iso-8859-1?Q?IaKfzhcMDYWop3rf9+NKGTHsASsoGGnp/MAhZopNInD3ZY7GqUZoGOEzQl?=
 =?iso-8859-1?Q?NK2nWM+YaGkB7CkwMq43BpLLcTbrbwpICLHP6bULXQQQj/gMuSa4kMpXI5?=
 =?iso-8859-1?Q?4b3bEfGz18XKKu+t2QiSx39TTjx2wEtjdjJYaPcthJbG2KNFz5eedYnqX4?=
 =?iso-8859-1?Q?lHnHOVfgiw59aY76NZYu0H/PCHEHQwvjPdle+yk8dwUVjtiVCWz9lPRKEc?=
 =?iso-8859-1?Q?JoTKWAdt13m+ei7DvNrHT9OqK/2iung0wPcZPOnp/2wpYLNXzoUZNmyGxF?=
 =?iso-8859-1?Q?2heA+HEjRoqSBXRJ+pnnRewkJkYu79SGDFyhhyJpigJH40uIeg8S8XNKd9?=
 =?iso-8859-1?Q?G4NxFvsDK7y4h+tcNlSLrTiyS+OrRi+dVRqfQq4aFG1RmMyYMFOsamHE4x?=
 =?iso-8859-1?Q?xSu2cwZKiGF8IXZ4Xy1aKi41JMzzkX8JHD/0ks+I4knFZsB4sZBynjlrR1?=
 =?iso-8859-1?Q?LycChfMyPfkbjh2HF9rvfGaJvuuyw2hAWtNX9a21agJuWEdQlpd3bgJeee?=
 =?iso-8859-1?Q?bAKmTysZPeTbI4oOgxX8FYv86V5M/rbB59Qf2VI2+J/8iM4R9N1yyC0DNE?=
 =?iso-8859-1?Q?eIityTrCIjM9il47tRePv4/lMduObMWNpgUy0cGcbnX7xW5Eo7IsbZ3yfg?=
 =?iso-8859-1?Q?CT7YrG6VLtQsyd/YaS1v4i1ChcuOInOf8/DHUZNdnNOnFdknomw0FhVKXV?=
 =?iso-8859-1?Q?sd9nNAMUsVKCN/0LOhvGW6S0ark/RIrVZaZkX0/0PEZ3h4teoSZZ72Jd3l?=
 =?iso-8859-1?Q?FLQDhAvijDP0xzukAURLTOtgQyG78GfFunljUGYxBeKgT6HrjHglrV1npo?=
 =?iso-8859-1?Q?aKuaO0Y2CN4mmJ8XT2KXF7xI/AtjJscHyPvlAZE0AK3kEM+7TELvgkjiv5?=
 =?iso-8859-1?Q?DgKWg6LOEFj7psxx7P2YBIKcTSTaVYcvYhEpbOb3GCly59U10c8Orb9oOD?=
 =?iso-8859-1?Q?epfAzCk3weReuBx1dLWAU7nr7OBIekvdjxgvPZO/qG+LHwSaE1tmVsc3Ad?=
 =?iso-8859-1?Q?5PoST3qlzJwXJ9Bz2bvXqFr/yLewXNYBspCn8RCC1PDATEFKzv4G64O8zu?=
 =?iso-8859-1?Q?embsiaGWHR6Uyo1OYs2y7hU8YNy5NyB6otgdbBNfKUihgCCpQgHDoYs3AH?=
 =?iso-8859-1?Q?qcqYhLkGG5wRmCdCtSY1Nj6dK92nP6xcWpJFeqf5sfhBCFMbZV42QN2DOt?=
 =?iso-8859-1?Q?ZofmqfqAHStj5NQ5wsJWYISN34L+Coh7yDSW5T//m+ZE7KEdCttxZaP3/V?=
 =?iso-8859-1?Q?qDGilduPPsVWlkBBA3MYWqjNvCkde1zfiN4Z0Xjhtr5evyO5qA+kV6IPjB?=
 =?iso-8859-1?Q?rDegwvD3VNc7GAR7a3ElAS1TU6pQE8yQNDdSlvjhjPCFEplIHw1ILHhh+Q?=
 =?iso-8859-1?Q?ohBym1OkfDQvkg/IuCW/Q2Dq3dfoaJKGtbJdT2v2a1laZW8F8FeVY+LFew?=
 =?iso-8859-1?Q?U1c/0lEtJduHBVy6xRcELR5OGjs4ANJR1GEXsd9CFtj6ipGxxPbHbzcXwW?=
 =?iso-8859-1?Q?3EpWQeXWVQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3cd2e9-9393-442f-aa88-08df1e63ef91
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 19:57:48.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zi4yGbotHW8k35C70q+gjTf7DAvdBA8K4o21sDTC4Ut9swS9GpTu4iBMLPvsQj7HpUyEOc19wbmF6OYjFgxx5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8498

Hi Michal,

On Tue, Sep 29, 2026 at 03:47:59PM +0200, Michal Koutný wrote:
> Hi.
> 
> On Tue, Sep 29, 2026 at 10:37:38AM +0200, Andrea Righi <arighi@nvidia.com> wrote:
> > cpuset_num_cpus() enters its RCU read-side section only after checking
> > is_in_v2_mode(). When cpuset is bound to a v1 hierarchy, is_in_v2_mode()
> > dereferences cpuset_cgrp_subsys.root, which is freed via kfree_rcu()
> > once that hierarchy is destroyed and cpuset is rebound to the default
> > hierarchy. A preemptible caller outside RCU can therefore read the flags
> > of a freed root.
> > 
> > The only current caller, fair's group share calculation, runs under the
> > rq lock with preemption disabled, so it can't hit this. However, the
> > helper already means to protect itself with RCU, and upcoming sched_ext
> > support exposes it to sleepable BPF programs.
> > 
> > Take the RCU read lock before is_in_v2_mode() so that the whole lookup
> > is protected regardless of the caller's context.
> 
> This feels like mere querying of the mode shouldn't require such
> constraints (despite it's needed anyway later down). But it could truly
> happen with the novel usage (CONFIG_CPUSET_V1 && unmounting cpuset
> hierarchy for some reason, I wonder how you noticed :)).
> 
> Then I'd welcome more structured approach with at least:
> 
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index 3754d697854b3..7f4d346cfb119 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -841,7 +841,7 @@ struct cgroup_subsys {
>         const char *legacy_name;
> 
>         /* link to parent, protected by cgroup_lock() */
> -       struct cgroup_root *root;
> +       struct cgroup_root __rcu *root;
> 
>         /* idr for css->id */
>         struct idr css_idr;
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 227d09704ca59..a718b5f521fb2 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1909,7 +1909,7 @@ int rebind_subsystems(struct cgroup_root *dst_root, u32 ss_mask)
>                 /* rebind */
>                 RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
>                 rcu_assign_pointer(dcgrp->subsys[ssid], css);
> -               ss->root = dst_root;
> +               rcu_assign_pointer(ss->root, dst_root);

About the __rcu annotations of ss->root, I agree it'd be nice, but it makes
sparse complain about all the other plain ss->root accesses. Maybe we could do
this as a separate cgroup patch/series on top of this one?

Thanks,
-Andrea
