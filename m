Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022123.outbound.protection.outlook.com [52.101.66.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E250C4756D3;
	Fri, 16 Oct 2026 12:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153661; cv=fail; b=OqxECPsTREDsU+yR/jRMFYo2GTWBZjvSgS7m6v16Eoy99yFABR5rEuoyz3QGWBZjW/CsdhNxgUhWguYAlh/Hh4iWOX4QER7io+XR2ogUBEx9yMkPz0X0GhN0guEoFh+Qo3QRgDMxKhzif85J3Tgle9SQ3vR8J+Iwdm3OR3pQDH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153661; c=relaxed/simple;
	bh=nKBhTKrsqjXWnPX93DCWIEAJQ5IEP+CnB+n82tipHy8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=igMOeClLQ/mu2RfP1AlLLnBQcrkOL17rK1So2FIvFDHGjBXTdJ2gpu2RGTVIZQ1JlntObP7KIiTgoQ63svc9qF5jHzxw/zN2Gb4xmucuQU81rwt6k+xuLApxvNJf2lzWndBhrDFaOcXZ6d2V369fawC9oMAQAHuiz50IzLV/OOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=C0xxYPSx; arc=fail smtp.client-ip=52.101.66.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="C0xxYPSx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZR/f2o4wxGr8L4xq8x//EjkogGoQBFk4qlkGK/iEUYP47a7n8zaOWVUhBVyeZ90famWJ86miEpKmLdJLoNVEusBzj7QOTWQ/uQJnch8u1BsB0sJ1WTvWyKl0Ryn5FF0jhcbkMvVd3xcrpB1VOrGH6KbuSuwz46wk3l2VsAIzJz9Leqp+P4TAF4NqRPxEx5nXLqhrng2grbtl9m8gVq9IjVXCEU+Xm3mLnemaguQh7T5mJ9sO4TYBFVKDcnN+o2C4j1LJPTb+SCk2AJ/F51pBWGKvD/XAjps2Viwe6jThw6ga6jJpOPUS0/KhcNC/jdU/PjQy8UjdnoeDlBcGr67sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sDs8yymC7kt1hu+CCj3hvfDmSkC9LcuDYb+F/NTbs2A=;
 b=FPUefpTwhlcqvui1vsywN6IHkskL1Q34gGHl5/GbA7+5gUXTYhz0PcoQvL3ZCOsQRi+u3VvosIghg86EGO8IMZt4Crz7d3nnw9EcMD2x3jEblkrFM41QV4TYBLXRiLQMsVmbUo2r+MIJ1mf6e6etzu0FxYbAEa/n4RWvN8cGiWOZQjQz9K/JGjPVpaTfWu7e8h5JI/ilRozVVEdyaH/5tnCW4zbMnJMDqwBAI8slZWYgBpw3TiDTAIkbWqefGxWnCKNAL2vYLFfiuPp8XARKw6sG8/W0M3doA1ZJsKMk1tkPOah55pzwkK6IC3z3rNsmtoJoRIMHo4lFavJTrd2Zpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDs8yymC7kt1hu+CCj3hvfDmSkC9LcuDYb+F/NTbs2A=;
 b=C0xxYPSxJJYEbxmaJLv51VLOjfnkgq2rV/o8YlWuZYU9TdvOY2GYqKZ4uAJIYfpDcaIBQ6LtWrZs/04Vhp4mgdgV2hJeGHkNuedAbDffRi4T7ckugaJUfiz/ZcvUH3BNRnAA98VShb2L9KRk2ZAbR7YUtvyI2In2UYca5JmkKDPEyAOOwYofswSfVLm4jbUxZsIVK4gpiYhBQUr4nyZwlHjSyQKwsTrP0GEl+Vh7Xv4+htWE+dfdqrk7qBdXXhQFisrUuNr4n4VWQtYJb8a+4g1xPbYhHwsqiYSEqbKhZil54XA3Zh/mUZmTxyFpSXtlNL1LWG+MLw3Vz+MZ5IOU4w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by PAXPR08MB7395.eurprd08.prod.outlook.com
 (2603:10a6:102:2bb::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 12:27:34 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0546.006; Fri, 16 Oct 2026
 12:27:34 +0000
Message-ID: <79c1246f-8c9e-4e2a-adbf-e730732b33b1@virtuozzo.com>
Date: Fri, 16 Oct 2026 14:27:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units cheaper
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
 <20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
 <84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
 <20261015175836.efc93cf9de01306402da61f9@linux-foundation.org>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <20261015175836.efc93cf9de01306402da61f9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P195CA0007.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::7) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|PAXPR08MB7395:EE_
X-MS-Office365-Filtering-Correlation-Id: e2603f1b-55ef-457d-86ac-08df2b80daee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|5023799004|56012099006|4143699003|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8BsWWbn50ZUrAqCq/i7O+qHMqUl2zbnJsAoVTqUyXt0z4aczlpMmsweqOF65/vaRpe84Du3xfhaSVlZ+KsdgC/NUn2iHE8fhRH44jNpa/yIMpi2HdugnzEWHHztFDGWAPr/AS54ADb3fJQlxc/lRxJGWwv/YxNSD+s0L66HBoES3b34YXbvBAaejzSrsa5rc/ASmBt/brevjGfnrIW8fZbqi0MFV6ebSN9SPIFqIVB8y7tpxm1US2YOzE32W6IJo6gCXUm07+UaVQDRFXAsJ21tqij8mlTjKFZQI5PzkDzsCPjG056yG0d4O6vblVIZCqG1IgXORhtQeKG/KZO+50s+SNDkSOr5WbQf+yLGe1AQ3ebzSXbDKYEnDaqmBa7fUHCb8sevtLLC4BYAeVBVZQTT0N06k0uEaU4GBvaJtFd/GFsso190I/axKWJpPpFHaEX70ajAO+tMsVMJR9K691aLy6AJRVCVsTJ+CqezRIhHlVGNXa2l5UJLg3ql/9huM5PZMrtYu4kOzM15PosDY2tsr6RanAS8m+qvvMcU4UYFcHTXrtGjsjnA6yLdoZ6ilnZbq9kJUVZ+6HCHXQj6O3oSagV4kHdmOcuwibYgs/kO+Zz6E/NJzct/avtrD7NxMd3Szlszfphcx7L8DxJVNAwROF+UiKB/e3bS9FcQBlrs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(5023799004)(56012099006)(4143699003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjBhOUNaUDNkUTY4OWdUcEU0MThXWE9peTVoS3lPVW9JRkVRdU1mK2hHcXVJ?=
 =?utf-8?B?Ulp1eGxOMFp5VjFkUUlVRURRQkZ2UXRwUHU3OC9MaXZHTUVpeXdOaUM2Sm9Q?=
 =?utf-8?B?R0ZxVTNYSjNjTDgvWUlzZU9vZTliT0hxTVo1eCtTZjhjd2g4enhOd202OVVt?=
 =?utf-8?B?MWFWNXd6SjltMXlVLy9tdXcwMlNJZkptTk9tU3luengzckJieEYzbHdWeUdE?=
 =?utf-8?B?TDRWY01uVDBWdHFmK2g1VHhUVXZVWWl2cVhEV3FvRnhHWEpRemxYL2xEQ2ZN?=
 =?utf-8?B?R1lDM0J4Q3MyYUlUMkZPbzhNeUIzUGVDcTVkb2Nic3pOWnlTck0rU0tpbkVu?=
 =?utf-8?B?eFVKRW1sYldMRStnM3NWYnFpRWV2bEZUcFl0RWhnb0lJUDF5Vmcva2hKUjFY?=
 =?utf-8?B?dDFYVXlRbGUrWit1Y3BJeTN1M0VjUWROMDJvRVAvQVhZS0JOYXJlWXZRT05X?=
 =?utf-8?B?allJdFFhUE9HREhSckIrY2VFSzhLaVhyMXlwQ1pLYkxKaDA2bDhmNTRjcGtF?=
 =?utf-8?B?ajJKaWR6czRiS1BtakRNSVhlaEpzRlFJdGhkbHI5MGM5VmJMQUNSV1Z0QzJV?=
 =?utf-8?B?Zk8ySysrMm5xSnFIYjRqL2Z3WUZqdlV2dHdjVGE3djNMcUd5YWVPeUttdWs1?=
 =?utf-8?B?dEVoMWthd0NaWjlBd2JRMzV2YVRjaXNCSGZYbTJxTUxoUWUrY3VLNjhab0Nr?=
 =?utf-8?B?WEJuRE5RUk80cXRRclZSKzVLOTZWWDhCK3pRemhLWTU3OFlaNkMvMmVQM3Qz?=
 =?utf-8?B?NDArZXBRbSsxYkp4ZjN1U0pqMjlIL2hNTjZpRC9IQlJaQzZ2R2NhcCsyYzhE?=
 =?utf-8?B?YVlhL2ZGRHRkcUcxdCt3VzNReGQ2NVhqZmhkNEs4MUJqVWRmWnFVZnNhN1pX?=
 =?utf-8?B?ZXBUL1lYaGJWWVR0NVpUd3lkTUh2cElMbmVNVU1Ib1R2b0Q1THkwdXU3Q1pH?=
 =?utf-8?B?QWFIZjVZTGxsZzlIRUI3OFJuTW9zelZKYURyVE5ubFdxSFVoQk9aQlhqajFv?=
 =?utf-8?B?K1JsK3YrbWdwVEt6eHhzaUU5U01KNXZ0bHQ3VEo3dFpYMjE5elh1dVZXaUVm?=
 =?utf-8?B?T1grYmdPT2NaOHZMSUl2eFRPS2FzVm0xZHBtV3ozTWhzaXdTZEZ5RVNsSzR5?=
 =?utf-8?B?SjA4YXNZV2tlMW5SbGNEd0pCQlVVaGU2RUsvL3V4OHowTXkyd0U0aDNoNVRX?=
 =?utf-8?B?OTFXVi8xMlhJWGt2ZUtmY2Y2WHM2WS9aWFcwTmI1cmY2L3pFMHlGVkJiSXhC?=
 =?utf-8?B?WThyRnZsWG5uTmtFSzhPNW1ZQ0RUTnBWTkxWbjl0SFFGaTRmejVKMmE3dEFk?=
 =?utf-8?B?bEdJV0h3MEVLNXppSkgrL2Zuam9oWUdieGVaSVdqME5PR3Z3azdmbHhBalNP?=
 =?utf-8?B?ZXV5dEY1RHNuREU4ZjdwYnhDS3d6ODY2dUlWZ3pyMFByeFhyaDVJTnFtNS9x?=
 =?utf-8?B?SWt3ZXNzd1o3blBsOXlNdTlzb0EvQzRJMkRtTTlqbEp1Qk9CU1FZQ3FUQmt6?=
 =?utf-8?B?YTJQelZHamRnMHJsVGNtUFlxbW9YZG1VeERMZWV4RVFOZFI1L3hEWGpzUEJx?=
 =?utf-8?B?M2tBZHNZK1pnY0t0amlHWTd6azRNbExyVjh1eTgyV201MFM0QXg2cUVETDdF?=
 =?utf-8?B?bitOTE1BVm5FQ3BTWVdRaG5XdDJ1U0ZrQ3dyVXgxYzRCYSswd1F1SmNFUi85?=
 =?utf-8?B?WEhSK2NEczZzalVoRXZxTGd4SFAvM1B1MXlKaDlWRVlwSTdhU2NId2J0MGdo?=
 =?utf-8?B?dUUyTThJVUFrQTZUWmhCOUVISUFZbWViaVBoZWF0aHo0NkNXTHNycm81a2Jr?=
 =?utf-8?B?RkYySVNTMWJCU2luMm9LcExjWnVGZWhoTFVYdEtmZ2VXQzJpTzhhUUVXWENK?=
 =?utf-8?B?akhQa2pKK2pSM2NNcXRxNzd5OFFQZUdYcWt6TFdpNHFYcU1UbWpVQ3ZVL3N2?=
 =?utf-8?B?c3RlcHVGL0ZvVUVyTE81SkJINUNKTTkyU29vL1RMSko3NGtRR1VGZmxISlVE?=
 =?utf-8?B?TDlWaEFWcUlDZE54aVlvajI0ZEVLcnJpWnRLK2hqT2lRYWxlVGVIMWJxelVX?=
 =?utf-8?B?b3NWNTZIV21Va3JDRjdoUUhNanhlMHVJbEJMS1dhT2pCeUVEbG9US2toR2U0?=
 =?utf-8?B?VDNhRHRqbUFhV0N2dWhTRkxvT2RMcEJJQmJhUTFJYm1nTHBNSGc2SHBXZkQ1?=
 =?utf-8?B?Y09ZWU1PekZ5TUt4MU1nNUZ2VTE3K1RhQmhyY1pMR3V5R3A5NTdaRjlNRmFD?=
 =?utf-8?B?ZGtSMGRPRUhpNjVJZTkrdGJGY01mS05VMUNwYzErSi94V2hERG1RbE13Tk1E?=
 =?utf-8?B?cmU0cXpYcnNvSVRhZFpISFU5dldhOVJ3cTZaZ29FTEZxbG5TUmlJUT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2603f1b-55ef-457d-86ac-08df2b80daee
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:27:34.0482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UhIOew/mGYn/q94KmTj49zkCDDS9D3c8JlPoz2OW/eDEwekEtZ9iLx1Lm7/fhAF8g8pyM69tCSFIVwaYqo9rlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7395

On 10/16/26 02:58, Andrew Morton wrote:
> On Thu, 15 Oct 2026 13:42:41 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
...
>> If you prefer the cache, I'm happy to redo patch 1 that way.
>> Patch 2 does not care about the unit size.
> 
> OK, thanks.  Yes, using a kmem_cache is a simple no-brainer.  Let's get
> that done first and then let's look at additional optimizations on top
> as a separate activity.

OK, no problem. I'll redo patch 1 with a dedicated kmem_cache and send
it separately.


> But a tweak which reduces 145GB of bloat to half of that is lipsticking
> the pig, and what a pig it is.
> 
> Why the heck is memcg allocating so many of these things?  What sort of
> rip-out/rethink/start-over can we do to reduce this by 99.x%?

That is what patch 2 does:
  [PATCH v2 2/2] mm/shrinker: allocate the per-memcg shrinker units on demand

Today every memcg allocates, on every node, a unit for every 63 shrinker
ids up to shrinker_nr_max, whether or not it ever has an object on those
shrinkers. Patch 2 allocates a unit only when the memcg gets a list on that
shrinker's list_lru, so a memcg pays for the shrinkers it uses, not for
every superblock on the host.

In the synthetic test from the cover letter (8000 tmpfs mounts,
shrinker_nr_max 8064, 2000 empty memcgs, 4 nodes):

                     units               slab per memcg
  base               1011518 x 1024 B    548 KB
  + patch 1          1023787 x  512 B    289 KB
  + patches 1-2          136 x  512 B     42 KB

So patch 2 removes 99.99% of the units, not half. These are the numbers
of a synthetic test, of course. The 42 KB left is the memcg's own
structures plus 8 KB of shrinker_info pointer arrays. A memcg that uses
two filesystems gets 8 units (4 KB) on top of that.

On the host from the cover letter I'd expect the 145 GB to drop to the
pointer arrays plus the units the memcgs really use. The arrays are
about 1.4 GB there (45000 memcgs x 4 nodes x 8 KB at shrinker_nr_max
52480). That is an estimate, not a measurement.

What remains is the pointer array: it is still dense in
shrinker_nr_max, per memcg and per node. We can finish that path, or
do something different.

One option is to replace the array with an xarray of units per memcg
and node, indexed the same way.

Pros:

- An empty memcg pays nothing, and a memcg that uses a few units pays
  one or two 576-byte xa_nodes per node. The worst case is about what
  the array costs today: a leaf covers 64 units, i.e. 4032 ids, so at
  shrinker_nr_max 52480 a memcg that touches every leaf needs 15 nodes
  (8.6 KB) against an 8 KB array.

- expand_shrinker_info() goes away. Today a mount that raises
  shrinker_nr_max past a multiple of 63 reallocates and copies the
  array of every memcg on every node under shrinker_mutex: 180000
  allocations with 45000 memcgs on 4 nodes.

- shrink_slab_memcg() walks only the units present, with xa_find(),
  instead of every index up to shrinker_nr_max / 63.

- The shrinker_unit_lock that patch 2 adds to order an install against
  the copy in expand is no longer needed, the xa_lock does that.

Cons:

- The install can run under the i_pages lock with interrupts off
  (__filemap_add_folio() -> xas_alloc() -> memcg_list_lru_alloc()), so
  the xarray needs XA_FLAGS_LOCK_IRQ and its nodes are allocated with
  the caller's gfp. That is one more allocation on that path that can
  fail. A failure fails the list allocation, as a failed unit
  allocation does today.

- set_shrinker_bit() and the nr_deferred accessors do an xa_load(), a
  two-level walk at these sizes, instead of an array index.
  set_shrinker_bit() runs when a list goes from empty to non-empty,
  not per object, so I don't expect it to show.

- Root still needs its units up front for the deferred work of global
  reclaim. They would be installed when a shrinker registers instead
  of in expand.

Size: it would replace patch 2 with two patches. The first turns the
array into an xarray, with the units still allocated up front, and
removes struct shrinker_info and the expand path. The second allocates
the units on demand, without the lock and the expand handling patch 2
needs now. Together I expect about the size of patch 2 today, around
170 changed lines, mostly in mm/shrinker.c, with fewer lines in total
than now.

Which way would you prefer: patch 2 as it is, or the xarray version in
its place? Or something else?


Cheers,
Konstantin
