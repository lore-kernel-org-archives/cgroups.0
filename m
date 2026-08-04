Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010063.outbound.protection.outlook.com [52.101.61.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731584BCAAA;
	Tue,  4 Aug 2026 20:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785873627; cv=fail; b=udDxgu7tHLi82hgLnemaKgWT0o3GnqOl/uNti/zMCzU1R8/XkdWUV0iBWoNuljum6Pu60xt+nHhChhzVK1pOahGgMd3HtJn31BjCJnnMWLCMmJEji06FTWOKjgOWvK5SsXEjhM5ZTEBhoWvMkKTkYkTJlDlRel9FAo9/eQo49+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785873627; c=relaxed/simple;
	bh=tLZNT5ffHsZuoMzZDi75ZdsZgVjAsbTfXvSqlIvG3uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Votr5MUa7oX10tPVLvQm/B9g+iHSsS81VQm8rEnuVI4GcWeFWteiy5YBiGHXJgxxnlgCD0vwwRlKwlIqaxWbmOzjC8iwBdOBCeD8j0QZQz3MVyeXaDqiBI3YfB7pKqBUz/ixtmrix78lE1/WqR7+k8mwzof1/PdavdEhzID0E2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YumSjKfh; arc=fail smtp.client-ip=52.101.61.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YumSjKfh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OxYbVymp68YICJTYNsh3c7Ybt9/5c/wRWMjHpGZ7zRMwDQh4Fk2x88+4S8L3781bU5Baw135zvjqqTBnJ789cDXIB/z2hzVohN1HQuT3cl3AodKqUWqh7uKMLs2lH0zkN7FxnApjYQD/vjLZqAGRmWhelHVF+QCWwoDZDiETWo9ZR5nRyB+rU4LbShdoXaAaxChMstRUjgg7BluWhSSxVPj4dwr29VPoi4C7auB/glGv98u80opx4WiweBMBwcA7YbWk7ye9YuhwIANZTVo5LUIfjjX4C1wbI9PVx2eEBC00yWJOV6q6eFKdXU3rpZP82RIcRdhHXoQwBjf4e8mZxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N44b6O4Fzk/mdkztiDEuQne/BrsT+hA3jO/HQv4stgE=;
 b=SnxsUG2KmEnv/qMxK0rGDtwlAyse662GbptjsoFUEJ7NFiVhaBZP/d3OX5cqHNi0qAhrxeq+LVRdkq8ahVLtj0QNU0sVUrc05gF976amMD24sXlWjy1f/1DvmgTG8zj74q/MYo9XzV3PSSXg1cvrQ8WXUatf9mdMimH5mVenaakJsjZPH0HmuaNCYIbB1BTyfkpke/lnp+936fL7+1DeJw9aQgS0jzEiiSYfjmkJ1sB7lcLSdYvYjhWl2HK87oscTSE3yZZv4hzDNXXHDlSQ4BX96ck5Y8bLQOnctLqjvfpsbvMYAFyLBDoIGFBC1eC13pRz27gDVm6Wbf2rafRbYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N44b6O4Fzk/mdkztiDEuQne/BrsT+hA3jO/HQv4stgE=;
 b=YumSjKfhnm2LZVaBHkrC5wBtrqbqxmoSAGQJUws33TPaSbvP/QI4X0JL1Xb68CLgoahlXCx0rnXdyPJXeYUW2+hjSuUgOM2YewUgGwao2fnIhJFIw0hTHeJkq/6fubUmU8ilpnWfds0mq1etmpSfYDrbfHap4b+EucEkMGQ1XPi7t/FoV/9NDrGgPHiJQw/G59fImCj2xNrUxvKogh1E3fUYUNS/fgZhmroQsc5SEgy1RmnW1uAMTQf4pWSeaGRImZzET9QG+qRt4K5Tx818lEYkkpLm2PzQUcSQPK+U4AG4kHgg9ROnt1zH5Pr/H+yZSylUf/2/eTybV4KG9KDLXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 SN7PR12MB7274.namprd12.prod.outlook.com (2603:10b6:806:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 20:00:12 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 20:00:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
Date: Tue, 04 Aug 2026 16:00:09 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <F6E125F6-87E6-4724-93D5-34276D6D6F12@nvidia.com>
In-Reply-To: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: IA4P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::14) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|SN7PR12MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: 926e274d-4433-48c2-3c57-08def262fe62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ngdBcH7YTXfTp10AXY8KpuU+n7czLUMwFly/iAgvTOLepKTr/QrkC2oE0rGoVa0T8MEWwr+aUZMIRUjx6ywgqtMhs9GWu6vXR/i1hPz0bQs+uVj0BebSdGM4EkaIr/bhXlowe1qBnRNl1R5mznaGi6RGi+sf1iRWK27FG3+w1MlcU9zuDVFwW4p5BErIEdlcCFjT5KFAFvIZh1tyu4B6vwQpoN2X6rjUJRFCmrxrvpY0W8Kenz3VhC0qdWulUQrFJ++gXlbx1CPhakn27yDj8zsbVJp3FvNPTKNwwj7BmCb1+F/oYNI/vZJkNW0/97ixqudYo2h+P71CF/HGHzB/Re66oeNRhEGsjI6bf5l9KpGYIk7qGJomRga/gIO8CGYEy0KGN0fYxI4NPFmdgwu8nf4KHkW2k+rYOZpQeMnU4cje8OGQJC0qvO97eGXTrJHvRbqGy00MiL6cBVlS6qcudWOp8M/w8D+lB1gG1v/2LGtQLai/Germh+3rjU09Iz4hF39ryG9lg6AoYAFWe7NeeurYLv7b32XCUrFUsLCcJZw97/GdrBVzqTD1XJWCKgu8VO/H51iuzbbd6WLdMhjrXbSi/Zym49irDY/DvPgYpo0c/ArgGjijJxlNY/pY30RB/xLKnwcErW2kBQQi/SuBqX9kczS/AW50b3II/GKWn6Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uqGhT5lvhkktxBNM+VRO7/jBzdKAvGbVvvxMOhefQIabToKAE1gOlNJAQv+3?=
 =?us-ascii?Q?zf3t4LXOq4SW2kvNhUAeufFUvmuV0Q1IJk9Ne2CMGyToeX+uaDBUeMfNxc1k?=
 =?us-ascii?Q?YA3YNCCoIDWfbYZtXByshnPtFVbRY6zrX1a7UqPevNI/9sPlRgoEt59QjOr3?=
 =?us-ascii?Q?542v9qnZq449sV/+ABNgJnixd7a+5cuhEq7LlcCDBKnHto2Rc46fqGoJiTKz?=
 =?us-ascii?Q?yFFurZTElgMqypEPjViqthN9XvMXm6rVCT6vqIB0g7qYKbz5FF5lIvydPW5G?=
 =?us-ascii?Q?K3Hxtyj6VCMtTej6sVROT9kXWscBxTBldEixloUBpsallCKfgaCKv69GVqko?=
 =?us-ascii?Q?DWDlyHmRLu7Ignw7GiAWZneUg1tBuw2QXNpNJlfbdEsHpJF/jpQgSBWd8EHP?=
 =?us-ascii?Q?AqOJ0VZ7XjRyFaYKbEfecQ1cb6BbNfRp8TwGHU/mbDhP5xEbUIplAcQB387W?=
 =?us-ascii?Q?sV3CErQWqThXgApTxwwIbBMdNz3EKv6PbynYILhEIXMqnNTnRjHgfl40CUDT?=
 =?us-ascii?Q?ywyXQoERaErAvD8W9fOgVJHfZLqeuWwSJdtWbgD+0j9tjmUdZTiei7zQLG+p?=
 =?us-ascii?Q?sEyYybxWQd330g7anAvR0J3Dr/AC6KZ3daGBnWmiBKAUtZCh9BukfLIGU/bU?=
 =?us-ascii?Q?dhcZBPbXX2ntQw/BGHGhfjaLZjycteQWQa8nfa2Dm22Ptfx/u7HkBLRbTVM+?=
 =?us-ascii?Q?fPssc+tuqYngNPG/Gf7abPq5ZAa8k4akyF4jjNd+jf8ba4wSyOt+W6J3bx66?=
 =?us-ascii?Q?MCmR3cTh/h9SUUFbEhajOIJsAS0aM58YQ5d7ajM85k+It4uD9hWtrgDSo8vP?=
 =?us-ascii?Q?2+hDcScJbU0hdCzPeE49v6d+lOu3fAOiiUpWBSp7qS0fo7PBXYDBzuwZKMaf?=
 =?us-ascii?Q?31BM6BbTzELWFXFr1EK00EYV8gFoeDsVHKyzyG6SkHvmRMMM3Ka5wEb6m4+X?=
 =?us-ascii?Q?sW+jFbWxQwkrHMbYhg4h8F/fSK6+S5XQZDs+yTkx/c8V6nZyRf3weTfUdg77?=
 =?us-ascii?Q?33k+aLaMgoNd19L422HRvHaollqem2hgUFqdXMCl0/fEJbHLZPyGe1z0cxJU?=
 =?us-ascii?Q?CnD0eDzdq5j8jk9a1LjKoIInRjwGeVi4Ys5Cqqo4FwZzz0kq4rZeSZpGAOwU?=
 =?us-ascii?Q?FVqQw600Tmf1ylhJdIUNqVd+UXGG6Xvray0PR0rHbPQA4ygH5QiFrh4NX7EJ?=
 =?us-ascii?Q?+EVA9yTKFUXrB8ao73aWBJM7F/2MFpzmURVUnP438xUjS1Pr9+WM2xS4OuUi?=
 =?us-ascii?Q?qRneWFaPFaBiyKMXdJo9p+WZ8d9y+y+jnnCGnykaWM6Q8+CFi+9vL2jyKr7V?=
 =?us-ascii?Q?iFJb5Usbnw9JfnVCe5El2WvMOcZ60mvEKU8mJda93xOo2JUebhBwQzWBf++v?=
 =?us-ascii?Q?CEXVhAR3KOHUvJvk5Ul6BeBxEfttyPzQaPRLaVnIRdyLjfaFJstxYGN9K2ZC?=
 =?us-ascii?Q?6uTRpbnXnYVclhV158Y0l2vtoiO1tfBy4EOOwZtzPAPRmZ0G2CY8wQr7FLJ3?=
 =?us-ascii?Q?13a2pkRGJqP5uWLYnS2/5tag8hdkOd1cohSKhORz6EVZKIwxs3hyw+0NbHp3?=
 =?us-ascii?Q?hHC1EEHEW5HvoCMK6T6juU46a76ayLbz/CO8Qoo6Bjl8J///S8Z1QimgTxv8?=
 =?us-ascii?Q?FonfghlB/LBoT3a2kAZZcIt8jpYW75rDoOZPYpJLll7mde6X2fTT1pzLTHR/?=
 =?us-ascii?Q?NvNirSQppHS5E9UrUi3P5UnpbDuX6v5Y0TGdi47C7Qk7EhcQ/gOgQfMbA0Qv?=
 =?us-ascii?Q?OAOrKPDj3Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 926e274d-4433-48c2-3c57-08def262fe62
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 20:00:12.3297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a6AAJLBdb9spHFiZkT1+a+NssdUoaFDQCcwOXMA0Q1xfM1eeHosoSGP2cWmrrzhq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7274

On 4 Aug 2026, at 6:08, Lorenzo Stoakes (ARM) wrote:

> There are a number of internal headers local to mm/ which reference
> functions and data types without including the relevant headers.
>
> mm/vma.h is a special case that intentionally does not include additional
> headers, but the others are not.
>
> This breaks tooling like clangd (which is where I noticed this), though the
> build is OK due to the C files including the headers happening to include
> required dependencies.
>
> It's better to be explicit about dependencies anyway, so add the missing
> includes and fix clangd as a bonus.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/cma.h           | 1 +
>  mm/hugetlb_cma.h   | 2 ++
>  mm/memcontrol-v1.h | 1 +
>  mm/pgalloc-track.h | 3 +++
>  mm/shuffle.h       | 2 ++
>  mm/swap.h          | 1 +
>  mm/vmalloc.h       | 2 ++
>  7 files changed, 12 insertions(+)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi
