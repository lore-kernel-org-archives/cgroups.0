Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012030.outbound.protection.outlook.com [40.93.195.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4C34EBAD3;
	Fri,  4 Sep 2026 15:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534640; cv=fail; b=d/T9evcNLDS6LdMLQrL7jQOo96cpVpowCDSfuGoJFCzVlRLEoin4Dr346HIiV3eL21PUrHZhIIJj3URQl511UOzxmohQL0GzrZIMmeE8Yf364wjnekHqO8/9OeLCnQDgjmEH2ITkLvKFSRY+Pi1eqs39pSjJJSis3nbXX3ir924=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534640; c=relaxed/simple;
	bh=y3uxwc5q7BQ3E0PiX4Flh2lZvijxug9OQAnP7uYdEMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QrrReCtvYUYYik3oRl9l4U5zYPbtPCaBRF3XdkOisdh2lBEy3Jr10aIhI5ElHEwXuapzO1RMi8QqarKl+En+WeVZPhDSObBViGVPfjEbsxN48RRRN1t6Lpy6CcZosmx+6BPS6AroMjnU6N/jjVSDja7ERePJXgBKARrKAnI2icw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UZoxQoc+; arc=fail smtp.client-ip=40.93.195.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UZoxQoc+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vFOCJBFQTfWdjtVEAVoTCZzxbWR7ogIKcJb+QSEtAWYBqmdDo8Z6ia6bTOSbFgVVbF/2V1lCzztoLZMLoPbPXdl1W02Jz+WL0Cv7MIEe5Yh03yUff8Jf/0/w2PLrd4rjj1yLMl/DTX5DXN8cMhse8TN1nqZE96QWnjG+/zWHXr41iXq+BbEKH2R0JfynNoJagk1N2T6MDX2ljqufL1685tV3DseYaqXiYf1eS2LQDRm5feleYnsk9GfSk989LNLcWSbVvA7sva2qq25yWzRe7mfM+zTkwuulycmuIC8lU04oNaCag/XmjcD0EV8uTasjugR8JftGFI1UWmvX1Gb1Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=55CKOlJDuzcxiVxXB/ipq9IEKZ5il8Exdsy9b4Arfvo=;
 b=SPab+2oD3D++53oPB4wq3oDnmCDBYPEOC2liuyoLvvslK5kysVeqwPom4+s3i0tVOOsmVNPOzJEGpXIkgo69dkdWnz0WlSLKkrk8jbfA6rBJlGoa7TqeVS6K0EIgNZqgIUGx+1X/4S87ptWeP+z9A3AXdriUr2QPrqMMy04JRbXKDjg4d0cPVWYXEpkJ5QRMBhXgRBYlFJQ5utR6H6RKuab2Y//UM2Xs55kqhfk2ylVf5dIa9KgfzY+RdwFbr6bC5sw16A5h6ywYvI6/Ig9zjYW1mgzaIemScsEURqYYy/MZMxyV8oKHq4RJciNoDqjNM1B1yk1hY6Khzkmc0UeT3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55CKOlJDuzcxiVxXB/ipq9IEKZ5il8Exdsy9b4Arfvo=;
 b=UZoxQoc+hqybpr/8bJKrxIebvTegZx05cSQksLdE/uQeQnCzXrB7g5rCkRHOdv0DX8qBYLAnFD9xhFr+rXQ6PG7Ljg8h3+WAE3llp/Q7ygSp2aQjn8cYRELBg0piWJO/ADkszDZNC9jEx3P/gWUYoBuPrtrTiPxXf7590dxP5nEm0fA8T91gv+IpZvCHS+ZmkDgNMA7AavkOD5O9jC0EY97jyiWpgJQPrDnri8ziHr1xAMgMZo3fRNJYQBMdt4b7EsJjzCznz4PB7f2UCbV7aIzJMqr67uUSSRcyCC2M9lHJVjPLZLha9bsTlpqJOt77Wrw90d4nwSubtVpqPNtHeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8502.namprd12.prod.outlook.com (2603:10b6:8:15b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 15:10:30 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 15:10:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Xunlei Pang <xlpang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Chris Down <chris@chrisdown.name>, Chuanhua Han <hanchuanhua@oppo.com>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcg: settle memory.high debt after THP faults
 with non-blocking gfp
Date: Fri, 04 Sep 2026 11:10:27 -0400
X-Mailer: MailMate (3.0r7028)
Message-ID: <6B46E8DF-679B-4254-A4AF-7B992B0F6460@nvidia.com>
In-Reply-To: <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
References: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
 <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8502:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ecab842-dca8-420d-ed9a-08df0a96a867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|11063799006|10067099003|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	5fPWWy6Qn+0YEyHNFbvrI693IvS9bvzpRBiZBsH3Izz8FlhE+SL6kC9gzIaPWRc6ByJ/COeZE/tJRYtFGjNKWAGqP4PcWC2NJJfCwJKiHvR/Z9mBdznbzmQBBzB1VtlZkzbqFMiTPXa5+eBxvf2DLv8Q9XnL4UlAOgJPoB7Zk2Atpo9c6l5beCWarnSWdV+LJq+Zah2qHn4N9sXB6th6pOA3xpICfyKebzbBdXzqxmjkSMiDbrwK2+7leKWQe42eBsCs8obkKjAZu3AiDFCz+uFPUaGENfT/SOhYW1ILJojYDadyd4yEc8FjuNg0wuC5scIbw4NNexB2kLKaLEmnEArJw5sHHiWErzS7D/nCnK8STHbP8ozzPcuweNKSY/to1nTffbu21UAztkPWmGX7/zBOrLDOYPnnE03wglU3kTRLcEa9VKQwXWGcM5eOM6vLDAcUNUs+z8y1CWIj9sLTvpd01wZo5XVQ/0bXcQxriA8eedZhblbsX/vdBjlpSwQzJW+1KwBlZKKw8zDQiaY1gohmsQvBYXhLcHlCU3xBwiKycIPNyIbpVKEqB6zG0Wsexk7D3Mwau73psLE5MZXE9iOibIUolVDzqt5kQwSSMXIJqSSNyTtr+LZBkZoZpTj8wVYpHwg+ASW52vJhiImCit+J+6iQQG1Rw4ChAfbOc6g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHU4ejVEZHpQR0M4TGJjci9NWWF5MVRlUlVHaTZ5L0tEWDhVM3crVWtzTzg5?=
 =?utf-8?B?dW5IemNDd0MxZ3N4ZWg0Q3djY0h3Wi8xN1lmZS9lOWFzcy80NUthbU04aDAv?=
 =?utf-8?B?WnF4dWk1ZFh5RnByUHpCMndkemsyelpyUjhnTHVGa1RPdkVWUkV6YnRubVdD?=
 =?utf-8?B?bHg0cmUyOStmSVN0cGhIOC9qZFNFcXZKZkwxSm41Y1lLbHNRMDR2bmJoa0tM?=
 =?utf-8?B?dWVHT1k5M2hrVTk3NmFzaTl2akYvV05SRkNpYXorQzhWdVpiczU4SkZyN3pn?=
 =?utf-8?B?NlBYeGdmNW01dTZKSmZLYUtaYTFGMEFmRUp4NitHSTUxWk0wY09kNzlFYmIw?=
 =?utf-8?B?Mk1BdUZ4K2gvMTB4S2NIVCt3TW1pRlJINjlxTWwyS2ZGaEdwdFBRcFQ2emxP?=
 =?utf-8?B?SzBObTdiS2lrQitJMjljcnQxNVZkd08xRkdsT0lQTklvZEdPR3Vub0t6NDVa?=
 =?utf-8?B?ektNTWNGVkplV3dPNGY2eUJUcHc2MUZrQ1Q1cXhQcWxZZTY2QU5ZQXloTGd2?=
 =?utf-8?B?UTBLRkorOUR1UlM4QkRKSWFvbHA4M1paaE1iSkQ4bEs1NWQyb1NYd2R1RzZS?=
 =?utf-8?B?QVN0azBkMitkTHRERHQ5WFBtU1M2WVh4czFzTzBpWVhrY0t4NFMwc1k0RTNH?=
 =?utf-8?B?RHJGbzl0ZFVuL21ia0JGMUlNcU44TzlTR2RRM2ZXNXRZWCtLcWdXa3pZSnUw?=
 =?utf-8?B?SDFNL3phTE1seG9lTlhJbElMWG0rUzd5SWFXS2puNmhjSjl1U25SSU9nMUdZ?=
 =?utf-8?B?NmxjMXVWaTFuSDE2QWIvaXhSL3VJYlk3czhLZHdjS2RrTXY4ajYvL3Z2dFFy?=
 =?utf-8?B?cGFUaG1vaUpTcEt2WTZUVXE2UUk0K0lzM2o3ZWFPT1RSN3h5dUtjZ1BkOWlN?=
 =?utf-8?B?Zm9NQjY5cFNaMWExVDIyZWZ0RXgrYWdhdDhxZE5qQ0t2RHMrOHVXUDlvMkt5?=
 =?utf-8?B?aG5QQ0VhZm43cmpXOUVlNlFUYmRyaEs0SGtNbTRvNGZmdk5veks1ci9LTmZN?=
 =?utf-8?B?UDNrd0hnK1JZemxQNkNIcjZtTmdPZ3NMVmRuSDd5YXNoeEc4blQ2T3ZMcGhp?=
 =?utf-8?B?VGVnR1laNEdMdm5WL285Z3RpQVcwUHZLY1Q2THd2K2Q0WE9nZTdIOGt1RWFC?=
 =?utf-8?B?RCtWallMTUdPYTFtdHJ1eitueDFja3FzRGNNbEtGTzFjKzVsdkNMSzVuRmFu?=
 =?utf-8?B?dEtINk10UGpGNGViNmIvLzdDMWt4Y3FTZjJXUnlzNlh3UmFxaHhqKzFaU3Bq?=
 =?utf-8?B?bUVBYjFVeFNHenF3cGF6K2dZQkZtV0R1WlcvYkx3b1VYZFFzRmpTdy9VeGov?=
 =?utf-8?B?UUkvbW5JeHVPZWpaTFlyRWhOb2lPZFFTK3c2eHkvbFR2YWM4Yndsak1mRVls?=
 =?utf-8?B?M2pIUjZLWE9CcThuUDBSeUIwRzJjRHZmdnREY3VSSlcwZ3JuM1NiSjNUOExO?=
 =?utf-8?B?aWpjUnlVWHozZEhGdFpXaTRTaURjaWpwVTBVWGNJYjdUTWlUdVI3V2pXL2FL?=
 =?utf-8?B?VE8xYTY2SC9MYnNTQjJhQ3lmREpJUUhXVnZWcFZ0R0laYS9sdDdvV1R3OXNG?=
 =?utf-8?B?Y3F6Z2hTVGJKWnIyZGVBQWJuWm5XQ0Z5cnFBZXMyS3ZFMW9NUDVyeHRGcUdW?=
 =?utf-8?B?SlhxaUtqcmRVVW5WaDhLcmsrUkJPWXJ5T04rNUJFK09XQktiOTliMWVUQlIx?=
 =?utf-8?B?ZFhqTjhOY3hmS1JuSytGNVhBYVZMSG9UaUllRngvRzVxRS94RWhSTzMvWGpI?=
 =?utf-8?B?c2VTOVRva1JFbVl3ZzNuT1htSUp6MzNMa0NvOEVVOGhXcUNneGFTdkdlb1JM?=
 =?utf-8?B?K2lXUm1HMmI3allZc1JnQmRkeHJqQ01QVDFHaCtGdnZEdURhMkY1MnJVS2h0?=
 =?utf-8?B?dVlXdFlmbjRqcHdERjErSmkxbVlxK1dRRzNNNzl2MmdBN1RxZVpJNVNxN2JD?=
 =?utf-8?B?cHhBSDVuLzRRb3ZkMEx0VjNGR2NIOWRKMEs0dXhnWXJ0TUNlMW9hTFdmOG82?=
 =?utf-8?B?a3RJR3ZodUxFeCtrbUNZZjlydlJja3ZEUlZUbE11SUpKUVMrY1JiNU9HcDhN?=
 =?utf-8?B?UG1UYU11VzJFand4MDNYYW9iam1kQlVrQVBhK3dzTFdIajdXaXlmWmo3RkRP?=
 =?utf-8?B?Z3pHRTFZek5HdUl1SHJDNEtXcWo0Z2czYWxUQitvb0NQdytSaGU2aXJyekYv?=
 =?utf-8?B?Q01taWtxWnZsdnpaTVdiRUxkM3BoRjMyVFd4WUF3YlIyRUV3cFlrZlVLekhU?=
 =?utf-8?B?Ty9QckU5WXpxZjFVSGFFNjBPck81ZU1SZElqSU5tS1FqVnRaUkxSMWdMNk9z?=
 =?utf-8?Q?SHXXVthUdHpaaPZ8+j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ecab842-dca8-420d-ed9a-08df0a96a867
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 15:10:29.7606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: txGp9Ck4q/vyCt0dxqJzH7h9a2mABddYFv7zcEkceM+KGB3a8WWi5gdYhQMLdxaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8502

On 3 Sep 2026, at 23:54, Qinyun Tan wrote:

> Anonymous THP faults happening in a kernel loop that does not return
> to userspace -- the populate loop of a single mlock() call, or any
> GUP-driven population -- can drive a memcg's usage from memory.high
> all the way up to memory.max with zero reclaim and zero penalty
> sleep.
>
> This defeats the containment memory.high is supposed to provide:
> above high, the documented promise is that "the processes of the
> cgroup are throttled and put under heavy reclaim pressure", and
> userspace OOM handlers (oomd, Kubernetes) rely on the high..max
> buffer as their reaction window.  Only after hitting memory.max does
> the non-blocking charge fail, THP fall back to 4K, and

Why not force THP to fall back to 4KB when memory.high is reached?
If reaching memory.high means the processes are under heavy reclaim
pressure, I do not think it is reasonable to give any more THP.

> folio_prealloc()'s GFP_KERNEL charge finally restore throttling --
> by which point the entire buffer has been consumed.
>
> memory.high is enforced at two points after a charge succeeds:
>
>   1. from resume_user_mode_work() on return to userspace, requested
>      via set_notify_resume();
>   2. synchronously in try_charge_memcg() for large overcharges, added
>      by commit c9afe31ec443 ("memcg: synchronously enforce memory.high
>      for large overcharges"), gated on gfpflags_allow_blocking().
>
> A populate loop does not return to userspace between faults, so gate
> 1 never runs.  Gate 2 is defeated by the charge gfp: since
> commit 3b3636924dfe ("mm, memcg: sync allocation and memcg charge
> gfp flags for THP"), the THP fault path passes the allocation gfp
> from vma_thp_gfp_mask() to mem_cgroup_charge().  With defrag=3Ddefer
> that gfp is GFP_TRANSHUGE_LIGHT | __GFP_KSWAPD_RECLAIM; with the
> default defrag=3Dmadvise and no MADV_HUGEPAGE it is plain
> GFP_TRANSHUGE_LIGHT.  Neither allows blocking.  This is the right
> policy for the physical allocation -- a THP is not worth direct
> compaction, fall back to 4K instead -- but try_charge_memcg() also

Right, why doesn=E2=80=99t memcg just turn the THP allocation into a 4KB fa=
llback?

> interprets it as "this context cannot sleep" and skips the
> synchronous enforcement, even
> though fault context sleeps just fine (it holds the mmap or per-VMA
> read lock).
>
> Fix this in the fault paths, which know their context can sleep:
> after a successful THP/mTHP charge, settle any accrued over-high
> debt via mem_cgroup_handle_over_high(GFP_KERNEL).  This reuses the

Why a magic GFP_KERNEL? Would adding __GFP_RECLAIM to the existing gfp work=
?

> existing throttling machinery (reclaim + calculate_high_delay()
> penalty sleep) and is a no-op read of
> current->memcg_nr_pages_over_high when there is no debt.
>
> Deliberately not changed:
>
>  - The charge gfp itself is kept coupled to the allocation gfp, so the
>    fail-fast behaviour at memory.max (charge fails -> fall back to 4K
>    instead of reclaiming or OOMing for a THP) that the coupling was
>    introduced for is fully preserved.
>
>  - try_charge_memcg() is not touched: gfpflags_allow_blocking() is the
>    only signal it has, and it must stay conservative for callers that
>    genuinely cannot sleep.
>
> The pre-existing selftest test_memcg_high_sync, added alongside the
> synchronous enforcement by commit 6323ec54b450 ("selftests: memcg:
> test high limit for single entry allocation"), readily reproduces
> this: it mlocks 200M against memory.high=3D30M and memory.max=3D140M
> with swap disabled, and expects high events with no max events.  On
> systems with transparent_hugepage/enabled=3Dalways it fails without
> this patch -- the population bursts through to memory.max -- and
> passes with it.
>
> Fixes: c9afe31ec443 ("memcg: synchronously enforce memory.high for large =
overcharges")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---
>
> Note for stable backports: mem_cgroup_handle_over_high() only gained
> its gfp_mask argument in v6.6, from commit 9ea9cb00a82b ("mm:
> memcontrol: fix GFP_NOFS recursion in memory.high enforcement"); on
> older kernels the call sites take no argument.
>
>  mm/huge_memory.c | 8 ++++++++
>  mm/memory.c      | 2 ++
>  2 files changed, 10 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43..543ba4a74dc3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1329,6 +1329,14 @@ static struct folio *vma_alloc_anon_folio_pmd(stru=
ct vm_area_struct *vma,
>  		return NULL;
>  	}
>
> +	/*
> +	 * The charge gfp encodes THP allocation policy and may not allow
> +	 * blocking, which makes try_charge skip its synchronous memory.high
> +	 * throttling. Fault context can sleep, so settle any over-high debt
> +	 * here instead of letting usage grow unthrottled up to memory.max.
> +	 */
> +	mem_cgroup_handle_over_high(GFP_KERNEL);
> +
>  	if (folio_memcg_alloc_deferred(folio)) {
>  		folio_put(folio);
>  		count_vm_event(THP_FAULT_FALLBACK);
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3d..24cbf2a26905 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5362,6 +5362,8 @@ static struct folio *alloc_anon_folio(struct vm_fau=
lt *vmf)
>  			folio_put(folio);
>  			goto next;
>  		}
> +		/* Same reasoning as in vma_alloc_anon_folio_pmd(). */
> +		mem_cgroup_handle_over_high(GFP_KERNEL);
>  		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>  			folio_put(folio);
>  			goto fallback;
> --=20
> 2.55.0


Best Regards,
Yan, Zi
