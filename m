Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010043.outbound.protection.outlook.com [52.101.85.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2073B892D;
	Tue, 13 Oct 2026 12:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894168; cv=fail; b=P18JjqWsdCn0e1SXk6Y5kzNO2CuCp69u2GBXV1HwnGO7QZoX53CQx93cOEXY+sY3Ns1zbJw4wiPmnZHxYpRlpUjYpJ9YvbzVhXqAXbp7NI+vy7bFkUhAcaDlDgRpg2ll0fmWLbo8hWiCrSyvI+7Yn7e5nnLY1nDkr9OJWvdz7fU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894168; c=relaxed/simple;
	bh=wXmyGuPqtt4tOahdNTPMAEJMyYtSrcYOpWAFAg4iirM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nlLFWbexDEQ8HjfqE2/ou0TcehSLWzygxtSctoSruEoufGTobPkRfAHJYfBzxW3oJSWL6dMA2Y6vKll6HTVtJnR5GLWTHK+NdidcA5aOEagUIlBMMWljldTtWaacMYfm0t3yESr9Js1G3Ry1Jv8K9iYWC0fxySTawHemmwXSiV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rNN0xJWg; arc=fail smtp.client-ip=52.101.85.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rNN0xJWg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bSfg7CoM7QN4YaVYBMxYHLVqzT9OyC8v4HndltKDq/Fla6LeQQTpzBnxklCSV4To4PUCiOZMYP/RIUvykHpElGfYd+W+CU8/hQh29krtKJQ90Hm9+FxkJus/wQKd9XkRoObSgcfe4NqiI0Ug+3yYpaY++/fJJSwnXRCvAg5zoFyBZr1aEwbJp0JDzg8WgW8kCLJb+2f4Ss30pCrOchd36C3FnmutgMImKoDc6S09RjYqwSwBno1/DXh2K9/bD6rjDay+FLt9UkvpYF/7nvOSFvt5JRweIOnJqetvaZWSgBSRs8vpZRMbhwJqzRQ9s9EsTCUwGkrI4J22FkYj4V6JJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+wEt9RoxMstqYDfMgU/aZVdd2TgXoSCaXwYp6a3UlQ=;
 b=d5ulFDfOVrErUJITsFWBTOQ5Bij0WHKcutJTwhPLOO94bNOq2OJU5IRCnyBLbr5DR3YDi0ui/5zls5lBHMb9gvGPo9wzW4s2tThIp7SKawDgoQwvUzgnUbMa4Ewre1l359tqQ9sPdEJX4GysfwtVEVT1Rb+JUxGTjNE2w3KPwDNycif+rGYRiJUY16kt9kjH4JSEz7kRGWxai+cQibo+bFxf/qEj0sBRH4hUL/lmjIfG8l++9FBl95VxGC2c4yzRNrDTBz7GQI3tYaLZZM6R1hudhAt/4qcqOJIlNPm4Za0qBqzrSFJshtLnVP3Yi26eYfuMELbNgBLvB2osBnjjYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+wEt9RoxMstqYDfMgU/aZVdd2TgXoSCaXwYp6a3UlQ=;
 b=rNN0xJWgfZd3UxFXfL/HshtKE+k5cpt0+Zka8o4/RC0WsvbzTsduN8LWSfOi5k+6DsPBV73A68l8nclDuZsUkKBoGD4vRELlgBp8hLYCwvzuGJNmhvOLaalP9T5U2gcXCxIA0ANF2RKSI8pnfg6AYTHqbPzxUX9oWkkWHHvg4v0jTibFtn5Fa3GuqVB5rSPaMGWtZ8SCDYztUWAJPxzzQPUtCfA69eXOwH0aNWAWF/pxUXwfY01i6Llh312C5/BJJc/rsdgRZmqQFvW6gE1MUiLErH+tD7Ep2kcimBRfgvwOcX+ABw0EMf+3TbfXT8tqWgg5tgP3UrIs0PkSg7pCTw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB6564.namprd12.prod.outlook.com
 (2603:10b6:510:210::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Tue, 13 Oct
 2026 12:22:42 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 12:22:42 +0000
Date: Tue, 13 Oct 2026 09:22:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peizhe Liu <peizheliu@utexas.edu>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, iommu@lists.linux.dev,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's
 memcg
Message-ID: <20261013122241.GR13920@nvidia.com>
References: <20261012200823.699316-1-peizheliu@utexas.edu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012200823.699316-1-peizheliu@utexas.edu>
X-ClientProxiedBy: YT4P288CA0074.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::7) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: 0839bd9a-38bb-4261-506b-08df2924adc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4C7mDuG3OVog8beT9u+Y1yc35wX/9HZEKKX4mQuoaOWo7dzgJSgXH+1nVmkKYrH24jTdD9e9+SoSQ7MYP076uNnRq/aOH5W8gGCBxsUPo3L43UV+GSbO+CgUne1m4870DBXSr63LY6TwYy5tVC6nSxPavmdqGi/dIZ8bsC9omVKRCYY9bTyVgPu6HoOz/vBNuH+4ABJrDor8LRR45ViwVrmO3+WGVjgyozzYxlvY94qoPd14joWWxLwBsikqBGksGHjxvcyhrSX26JWaU7wLoz3apnRrBqA77q26DrPaffSznUm96tgWKZEGPQEXVzbB1dvDggwcf8fQ8AaopOuOp5c1bRs/iG/M1fGGmtsr6W4chXmEPS73uH97CP7HWBODVUNw/W6UYHCcWwmgKuh1nHjkwBuhfmv8p74Bow+XFpPlx0+OLPlnB4JqmKliuByTtKp+i0FLVozuqr2aM6Q56gE7Won86WFxoUb9zzqAmfoVN1GQ4Nk65+IESpIz2eUfh5JNZx4wRVLoFoGia5LzK9mAe9b1urXshJ7I0kYiaROnz4//hZO7s2fLMdt+4Hbu6Jf3RvkBfAe+DvJZMdZlhV4mceFJqurqVLMz7oveo3jv8vLHM+i5uLDnm4SHEyDjA4wOnptHeyTGWz2dmc7hL3E/S/20Anho0nc6Y5sDxYM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MSI7gjAPuPZPDZ8HyZUkQer2I654r5rtTSnJh3Q19ZkAamr1ZPaTDcu9DWSe?=
 =?us-ascii?Q?hUzxRtF7UPZxBILmOy3FALR+GrMtbr6rC38QDxgln6R/KVMCpJLpkkPY3lKW?=
 =?us-ascii?Q?jUoZveMFET84lvXESSpJ6OryxwBVA2oh7ldWG7qU6+5S6ign7qQ4g+CLtcRo?=
 =?us-ascii?Q?M9B8R3Grr4wjojjsVVstcX281DR3J55sPkz1aj6vPEouGLVH3iGFKLhtNtGa?=
 =?us-ascii?Q?XLU6xUcQ/VU8wmMtzXBwyMviBMKiqTvTZyHBX2Kt+/l0xoethtOIoUpSmBoI?=
 =?us-ascii?Q?Qf7xcAFE/80xx0v8aUHL26+kIBltQ48bG5CXQStv6c+bmqs3khtCKSzc6D35?=
 =?us-ascii?Q?KPEEXR4tOMI8Ed05geZ1G56q8ZKUBm3onnvl+EGXal442b0CidD29Rg7CjqQ?=
 =?us-ascii?Q?VpzRfiQ7iyoSSdcPXzaN9rfDJOKrpTnb4qHC2C1aRSmE5Xn+c++NB5ie/MYC?=
 =?us-ascii?Q?j8m3sLcWlFWvKqYDb01c0YUPu+TRc7Hs7qsL2aBnbnwcVUZZ9TQDfPRG2nHs?=
 =?us-ascii?Q?iMFfJUzOSieA+SJIt4otVHLHlsD90nVnjNIbFC9jPmkoyR9YxjvQqB+msaqT?=
 =?us-ascii?Q?yIPP7pb6aKEg0ollFbman8o+ffyV+bfgkJuryELvVWhBmBX8Y9TjNjRQAJVk?=
 =?us-ascii?Q?ws2LCzRMD+tvRMy2y0Vzn9QMh4TidV7jn2BNzLco9SaNZ5FsT1EbO6j+xhHL?=
 =?us-ascii?Q?98aK/LEHSoweECWe3yQijsaxHRpXyUpuXGLElkCeFdZNC6/ldYvR7AS7taPx?=
 =?us-ascii?Q?ujgS5r8AVJkYw20e8gPlakMIxeNNR9eVNohwvphaCNAjXtx2aFOMhYeblZ36?=
 =?us-ascii?Q?xM6lp53QPquYXqM5iX6K8J5aBtkBn0mt9VP1OluMe688kjlvYV7PqtBGnJeY?=
 =?us-ascii?Q?RJEYzjEvhTDNbgKipuwGgUo3zagOxvvpRNzUD5070gZgQFhPW2WBbaX54mWV?=
 =?us-ascii?Q?xa9SmwE0oePVUMq0SD+dP3Eo7qgxyK4nX6CJrdsibfASSWrgcnq5vbTJmlFO?=
 =?us-ascii?Q?c7v6vO3lhlapy5GrQMMhrYDaBwsaSb5PVpyMm+lSz8PSAz6eJZQm2vev349Y?=
 =?us-ascii?Q?pTJYBgXMAtOub5xHOdgY99eqY7TUoTq/J5ndCCaqBZvg5U5FR0Qu4H7Dqo8P?=
 =?us-ascii?Q?Se5MtENZoBIeRsd9IP4ZlXKR9xOdCoQm7vGOwKO3jt9gHa6P7nY6GXTn06hx?=
 =?us-ascii?Q?Lw+rd6enUpP2k48qBtgBPT8V+dGJnfJhuygGEEHYbQQkyc1qqhkh0BIp84Ek?=
 =?us-ascii?Q?ptwi+7dJdYOQyDrT54i78+XhZVq78Dd4ntOaj7w41nrrHcgB/CaUhjYb/r4j?=
 =?us-ascii?Q?BFmiZPa4F2dzR2JmJxvX7mgeA51MhLtDtev1wLuMW+PXzny1ekVk4IsfILUA?=
 =?us-ascii?Q?PziPWd5Owe78HN0pgMtQnb+ngH8kYaXlX7ViW8UoOE6qIpgDiozDIB3yR5dt?=
 =?us-ascii?Q?/S9QGYUN2DJMLGqbM3CByVP2dIEjpyvtUKQLOxk57drsVglLQR58vCAV4cEJ?=
 =?us-ascii?Q?onRYtyEm8WGV9m1tcPqXljSkItua/1kmgqnxSnsfsOEy+llfzKGhQnwfqHUj?=
 =?us-ascii?Q?2SAVZO7WcoIlvZHDge84h6KxG4BdApfgQmsKzn3B4j3UaEUAONAnWHIXwUEn?=
 =?us-ascii?Q?K0vKRbiGBZ2FsrWjWoMqTCNJ2jQX4uRyV7VsGLlBDkE6RztbQ3sqByjrD9nm?=
 =?us-ascii?Q?3xV+gYh0mX3WZoDEi5U+/KUuj5yQJgDRLqlyw9jY0AO1Nkr8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0839bd9a-38bb-4261-506b-08df2924adc1
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 12:22:42.1288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEbfVCIIfBCSWUdevXGyJzlhCxBYsCFWZSUBSuQDUnnnZVBkr0OXI3cU+LWGXAnZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6564

On Mon, Oct 12, 2026 at 03:08:23PM -0500, Peizhe Liu wrote:
> iommu_sva_handle_mm() runs from the IOPF workqueue and calls
> handle_mm_fault() for the faulting mm, but does not set the active
> memcg. File-backed faults can allocate page cache through
> mem_cgroup_charge(folio, NULL, gfp), which falls back to the root memcg
> when the worker has neither an active memcg nor a current->mm. Page
> cache faulted in by a device is therefore charged to root and escapes
> the task's memory.max.
> 
> Set the active memcg to the one associated with the faulting mm while
> handling the fault, and restore the previous value afterwards.
> 
> Fixes: fc36479db74e ("iommu: Add a page fault handler")
> Signed-off-by: Peizhe Liu <peizheliu@utexas.edu>
> ---
> Tested on a Xeon Gold 5512U with Intel DSA, based on iommu/next.
> Before/after testing confirmed that the block-on-fault case charges
> the page cache to the task's memcg after this change and is subject
> to memory.max.
> 
>  drivers/iommu/iommu-sva.c | 6 ++++++
>  1 file changed, 6 insertions(+)

It makes sense to me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
