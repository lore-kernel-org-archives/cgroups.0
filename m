Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795102482;
	b=dvv6qp4p5AaKipY/NqsM5ceTKg0DfRgMs4WHnJI2VX23Cn9wQoe4ppHgSXKAJNA1fB63
	 FHRyZEmdpeM89ELarOCu+2XeCSTBN7HpdqtwNffM7aYS5reYXryeP1e3MO/AjGjMH6dO6
	 4wBqhrZwgartJR0T6C6uTFCCWMlV1/6ZZ+b54bqWWAaPXxec91RT/Efwq+k3dr3b8/fBJ
	 WS9XTPLaW0Oi9joHZk82WGSqDRYyfSvlnmR0hrINR4fxCUE0308cS72Xj53E+heVUf/BE
	 88dhCMuzFTm5ZYOB7vwfuRRLzMZkNT/RQmQ/lTzP2zum83UyzN+zguqd90pWgxzzulg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102482;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=sJkGdtO1VBa3wIrggjiPMFxDtEMshLg9apKNTyr43x0=;
	b=Mh/9ZF2NhHclLAZchTmAFhFedGITs4BQv6DroiPP3E4t3Cn/Q3vEUXbY9iYbhAdiGp0q
	 6ZQOq/WKCrTF3cfHLXWxoicO6BxwE99/3S7xwshG9Dd5c1p/3BV/KlgzUzZbukU3yW16e
	 rgjwK9FnSNk58pDGUpCuoHHnqS/swfSxfwF9gFTE8aoNpmQ6B/u/WGiW+VF1uIayA/YB6
	 jNj4UuLhGsz9B0Z1l6G2sm4U5v58+rqkgvvbwSYcUKdiv1FyltllxXnqDjvnA7faTR224
	 9Tl8Ab/euuM5Tx3oD42lGjmkzHe4QDxgoGex3Nhod8K+RqtmEldv3zcwgE9kHXkCPkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Rd8gYSuV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.30
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazolkn19011030.outbound.protection.outlook.com [52.103.14.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A6060A2618;
	Thu, 19 Nov 2026 15:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70A6060A2618
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Rd8gYSuV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rLRTAjS0+lVOiBsxrMmTnqL/T80/66ALRbsP6U7fAC2/zjmH9kvUETxc5qno13O43yguWbHT86tF5z7iNcnJsloNWAPV7M4ZvZ7MkXhzY1yHez+AEVcfk+hS5UDvgKQcJlnpTOa5jlESQH0WbnnIlfG8qEBtlaZbSkHSZmp17Z52CWnR2RRyNkMrqpZq2YCbxwM/VPfgveH0YJk5XhKPZCb8qe+XPGIVgqUbHGqBDMtNL9Pj0V2IHk+GhlZ2k7sZ8MK0rSD/4COHl9p2e7UcPPf+Te2+vmfRQwtgqd8llJwgZKgZaVrQUlrQEqPbvRiY18fdtX/CH5f2SyVGqcUkDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=sJkGdtO1VBa3wIrggjiPMFxDtEMshLg9apKNTyr43x0=;
 b=u35CbV9SH94y4CH4qGS0d3GeC/Riu7qEgr4iqVKBnMt2K9eqsUAFadCM83EuRClCgC5OtFsVRGwVVretLPXhCBXvBXhgl6rd7Kit/mF+7+EHZJIcH4OcPIMKSxOxhagg/TVeWU9KeThyFV6BAgP5E23h1+RuP+gDfWOgq0uidpvobiPt7WEdCEZZ6t1sGs63W2DDy5qNnRGXRt4RC4f/qfGzRwyUBf4kOjf2180JYPCizbzgmTOF15DdRlCJzcAtTJ+g48CJ4bwl/3nviMUQrpYCq8xW5/vbMBu3NxG7kqQBU09kyRiLd51kHY456NIBVfKRVSNpo41idMCBSh9P8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJkGdtO1VBa3wIrggjiPMFxDtEMshLg9apKNTyr43x0=;
 b=Rd8gYSuVrTgBJ+rfnhBUx3ovZTKNZS+fwipV/jBF34XMolMljRC6AnmwRtkmEnBpFhU1/hXt5TdPZ+NOVftUA3BTJz0OdagtouZhfXyYZz0X8UirzA8zw5vksToIOjjmpz91sY1e5kEXu3F9hhLmrDlmScWFdhlAjJxr18lf608g4vtJkHu5OijycyDWpn3j62/3Renawa7sqH+nmjL3BxOWdFD4AyX7HEosUrY32u49qM5G4ZiPx4R7bbwdI3aCHwcKmcTehuqF4bX1HT2LcmZAcdH85UkQDkvu1we0LdcEugftaYfovaL77kGGDZ2ublRh5nN9R3tFfSPI0uSehg==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by IA3PR05MB396616.namprd05.prod.outlook.com (2603:10b6:208:626::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 15:34:39 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 15:34:39 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko
	<mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton
	<akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH net 2/3] net: account IPV6_2292PKTOPTIONS and multicast socket
 state to memcg
Thread-Topic: [PATCH net 2/3] net: account IPV6_2292PKTOPTIONS and multicast
 socket state to memcg
Thread-Index: AQHdeDt94odJi8q5zE2aSTDt7OX5+w==
Date: Thu, 19 Nov 2026 15:34:39 +0000
Message-ID:
 <5f2e25611e300561db512cd3ad3190f4d782484a.1795102467.git.x-professor@outlook.com>
References: <cover.1795102467.git.x-professor@outlook.com>
In-Reply-To: <cover.1795102467.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|IA3PR05MB396616:EE_
x-ms-office365-filtering-correlation-id: d359ed66-c8b3-4d52-0b5c-08df46529fbb
x-ms-exchange-slblob-mailprops:
 7J/vb0KDx3j4EGtrWC76yZtYjXYOkK33La4TJqo5aDbY/0sdPaF9cPKDIOaCxTkKnt3cxRI3Vl5Sjt/llMajnPCdhJDy3btYcYkcqYQopCqHcQBztyHV3e2y1p0SklQnLq/aJBUJ2TbDGsa/0dqvjYQnoMIk8rvAOjt2LZy3eXnd5eA2HDLIb65so2UNcYJzlOQx7vuOSXazcbMPL5P0YhPyDAVTnZBNet2p+hzaF0httv3I08swuVN/55EhVNOMoY2rl6nVTYMiLsdat1WCuDtVTcn9rkZ2Ulumy5y4auQbhEZcOMx6XY9aoi5oNpySLR/6VwKSNB+dbgL9rZj96sT9BLOS83pFJ/L3z+iQiMdFnh7T/+zU1h31+1DrUqYNI02RyqakrtCUKQs4/bpvFT7qnum18onF9GAzk18hhytAz7cwEldVKbqbG/Uwsqtkm4c1odngDjlRF4d4gdEgqBLuYqO4inw1GSOO5fOaXXfAKB97zeXDd0j63RZwrjj3ByvxmNvjrU7vTTfsAPDMcP896bV69ykRlIuj3/eMtz36A4IdFiRO6F5q3bCiGesPA10IDoSxhy3eJBv51y5xotuxapC05hGVfpiQ5x/JsvJ8n0YN3zdG4kVzZ+2hru7FlTtk9IXBOElL0nK+UddSSRNUhacp2agKhyzpuF2ru+dOZxUdQZZYWN8xWgmk5D+5nigoYJkOFGzeZAObHk3C26bc5pYBnG8PR6jIl8keaCEyrW305AzP2JRUjXpPgLgeGFuaDBWBRcMqqG0c9w3Lf4WOEKhepUhDofFaF3sTLH8=
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|12121999013|10092599007|4140399003|51005399006|25010399006|21061999006|38102599003|8060799015|15080799012|19110799012|8062599012|41001999006|11091999009|24121999003|22091999003|31061999003|40105399003|26121999007|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?utf-8?B?YjFWMmxvcU5pU29la2tDKzc3anJCbWRWRDJBZmVVTmxXem9FMmlzTUNDNmhV?=
 =?utf-8?B?Ykd0dXNpVEFxcGs4UVExdm5tMjZDQ0p1UXVhK3ljN0lEb0c5ZUdaaitoVm1k?=
 =?utf-8?B?UDJSc1JuVHhvdnhPV3hBbDZHbGFRcFFGK0M2clV0M0wwaHc0TTVSQTYyR2ZK?=
 =?utf-8?B?Zk9pcWFhL2FZaGVOejlaUWwrc1hiZmpuYTJYSlQ1RVZGV2NQSXhCTzlCRjJQ?=
 =?utf-8?B?Tk43clAzaGhzK0FSRlZZTElLTFE1c20va3lRb05jZ3YzcHg3V0l4cWxBSFZL?=
 =?utf-8?B?MVM0VkRkcWF5dkM5SnVvRUpUY1d1WGpnY09tek5ZOE1KZTVRMnloSzBxVllO?=
 =?utf-8?B?dXBaNm1YSlcrYXhvcHRSd0J6SURwTVY5V1BpR0ZZZHB6V0JYWW1EMXF6TGUr?=
 =?utf-8?B?aXZjZ2ppcENCcldZZDIxa285cEVBTi8zcGxjWlJiQmowMGtJdG56RkF4MSt3?=
 =?utf-8?B?aGFwZFpLTFVleFJ2cC8vTGNnbkdVOUY5UFI3Q1BMcERDVGpKVHpZajlmU0JR?=
 =?utf-8?B?Y1dmSWdMeXhiUHE2NFBvMlRoeWZNbkk3VGN5NDRPYVZTdVpoL1lrZjMxandr?=
 =?utf-8?B?OXdoMWdENThvbEd6dFB0dWNFM2FFeUovRjFkdHcwdy92U0QvZ3JSZ0FIU2pZ?=
 =?utf-8?B?MlExalp5UUVmS0ZIS0xJT2tITkNFZGN1d0tLaHczWFlDVDdLNzNGcTFYYWo0?=
 =?utf-8?B?c3NFdmk1K2RZUXlVa2FjTFRqQ0NHOUFEeVA0UzQ4MlVmSlBVbHJ2QkhXL1lG?=
 =?utf-8?B?clUwQ3h2OGhHS1dvQXpoTUUxLzBsSjM3cnhQT0pkRkYzSG9BbGJmTWZ3M2RJ?=
 =?utf-8?B?YVNhcnZqcUEzR3V6ZjROOU00b3ZqOERuVk0zY1VyTHBjNUQ3NmEwT1E0NFB2?=
 =?utf-8?B?Q0pQUXYrbm5iTUlKMnhJTWtLalBNU1RmbVFqVFduZU5xVnN6OGsyT01STVpt?=
 =?utf-8?B?MVlBb2YrdXMrdERTTDRiTmZobkoycllMR2NTVlU2bER4MStsNzlNeTRrSGxD?=
 =?utf-8?B?bmVmeXBMQW9XWElaalhEYWFQZG9udldGRWFtOG5IZWEvUEdhd1ZlT0M4YVR3?=
 =?utf-8?B?TExsOEM3Sm95bHpNTldjVkdSWWl4VitsSzV0Wkl6aXFXcmJDZXQ5dzg2RHI5?=
 =?utf-8?B?TVdFcmlucnZUYklyWTBaYTI0Yk9ZYzg3eThnbFQvUHNrZEVCdnFmbWh1YkZR?=
 =?utf-8?B?enZrdy84SU5ZR0dOZThIbTdxVytMNldNSFQvYnpjZ1hKdVpTYzdiamh3eGs0?=
 =?utf-8?B?UjdJeUNnaWRWV2VwbjFST0g1aENrVGhQOHFLTDJ6UW94OUdkdVkwMmVjcFVB?=
 =?utf-8?B?dEhKWVlvb1pkOEVwckhWeXYvWTlVQ3d4MUVDYy9WMjE0VzZwcWRxZE9PVHd1?=
 =?utf-8?B?azYvRWZBMDFJUFhnWmJXZnorUXoycC9uTnA4YWxrcE1QOWZRT0YyRmhhUmZ1?=
 =?utf-8?B?WmtpVXI5aVM1bjBTbVdVa2lzOFQ5dmZoMXRxUE1ZZjV3WGhJTm9NdkFtTmpT?=
 =?utf-8?B?TFZQckM4RWNtcUI3V0NlNzljQXRzODBUZVdPK01BU0o2KzNtTlBBTXF5eE53?=
 =?utf-8?B?SytBZTM2dytDT2NEWnA3bSszdXVKMW1MbkYrWGx4V0w3cjlPRy93eTQ1Zy9u?=
 =?utf-8?Q?cUuECZ8YCU/ostC/10H1Nj88DJrLQkp4YxxpLu/54z9E=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MVVvbjV2dFdEbGdDOWppQ1lPS1dyVjZ6QzhCM1ZOdTVrenBtZUUwb1F6T1Yz?=
 =?utf-8?B?ZWZVeFBqNEltRWoyU0JxbEVBSFRWV0VDYnowRW1xQjR1UjBtSS9wS25ZcSsx?=
 =?utf-8?B?TE0zZ0xQWUtDcE9GbG1mWThpWlV4R0tuUTBGM2luc3VKU0oxY0ExbG9IZXp2?=
 =?utf-8?B?Ylc5eVdFdk8vT0lJQWVzNUpGc0FpdWJ4USs0ZUxYanJUckJ1ZDQ1SENEVkJD?=
 =?utf-8?B?Ylg3d3gwa0pnN3BUWHZDZFBrcjh2RHNGUWR4VWgzdWN1TUpwQmVjRFVyeVRz?=
 =?utf-8?B?dm9FNUtveGY3Q0dzZmtBL0RQcC8vRmU2MkZ6WmZ4SkpZcFpnTlF1UVFXSFZM?=
 =?utf-8?B?L0VrZERkcmFxajh2bnVBVHFmdzZQQVRpejB5ODhiRUxPSEdZSnNGTDVBa3Na?=
 =?utf-8?B?N1RiYmlpWW5NYzNoR04ybzNXaEtEaHRwaFduQXRxSnFyeFQ5SkJzTTJNTE0w?=
 =?utf-8?B?aWR6KytWVk1ZeTE0bUs5K3BzWCtSNkJPMzl4K09vaTUxY3F5aXRBMjFSa0Vx?=
 =?utf-8?B?NVdLcGVod09zVExlSm8zU3ExMkFrZ1N0V2sxRzc3UkhYMnZ4cFNEV25oSTE3?=
 =?utf-8?B?bTREU1dTalJmZkI4TFkxOWR3d0YzWmZDbzBLNHJXYmx2cm9sSGMyOVkvOVBW?=
 =?utf-8?B?Y2E4UmgrQkU1NFFScEFLUlBUb3JJanVkUVZCM2FJMlREaWhLZGprdExqUnpG?=
 =?utf-8?B?TEVKdVoyeHJ0RFF2RyszMzA3bzh5bTNoa1c4djc2dEpCcnl5MkNiQ2pNSk9D?=
 =?utf-8?B?Z1MxYXFrNFlFUTkwVHNlUi8xcTJkbU5PWENhWGpaODNQaTd0TDZLZWN5R0ta?=
 =?utf-8?B?SjdYR3NkcTFybUZkMC9VWVVwZyt4TkwrblhWNGkvVC9ZbXFhbW1QQU5zRnhB?=
 =?utf-8?B?Z0hKU1duQnRhVk9veDdaMWhxYjJrMTZITWE5Y0hnQVUyNjdCck15bVJzdGtK?=
 =?utf-8?B?T1A3Z0pBNkpaZGhSZGhPMjV4TFNicnBEVWRTd1h4QVk3bzJ4N0hzY2VjMStJ?=
 =?utf-8?B?WjhCcnBCWlAxbVdCWXFucE9RSU5UNDhSK2ZoSjc2c1lPcjEwU29yemF0cWJY?=
 =?utf-8?B?aFh2ZWpLSExWMXZadHBWTUFLNUZHNzJCcWQ4cGlOd2F4NXVhQ05jTzVQKy9R?=
 =?utf-8?B?Sm5UNm5Uaml6SHA0TlVtQ3k1cGZ0UmU4OW9jcEVIVlZOaTlwQVVacU1xQzgx?=
 =?utf-8?B?bmhQd0ErZ1ZRTWN5bEZ0WDA5bUx2TXF0enRNbzc5bDdGSkVQREthSVlWenJH?=
 =?utf-8?B?ODdESTN6M0F4Tm5XOXA5VmdsY1V0NUZPOFNtNmVrRHVhc0RSNWZiaG5vUFdO?=
 =?utf-8?B?ZXgvUklqbDBUVTI5Y0lyYWNta3drVG5lVHhZOWtic2pOMi84OW9IRUs2NW1m?=
 =?utf-8?B?YkdjbUVYWVJtSEFSdUJxOTJQbzZISEVmUUhUMTQ1U3pMejFJZytFTWk5WlBY?=
 =?utf-8?B?cHNNQVZvOVZxb1NNaVJvVWlCNFM4L1IwMjh5K013VzNqUGlQRW1Sck9xa2da?=
 =?utf-8?B?cnJ6cXFvZEZrKzNJWlNaSGtJYStWalpIS0VoNVBYeENoSjF3YmNYZVVibHcz?=
 =?utf-8?B?ZUJtSmtKU00wblU2b2IxdWR4b0xYak9ub2xpZGI0SVR3V3FyNGNIZmRDc0Ry?=
 =?utf-8?B?RVRlT1hDZTQzYlJCK1d0OFV1TWFNbjYzZ2RkZlV2WnBFaXBPRUhqNG9qbUtl?=
 =?utf-8?B?S3c4MzRsWUMwa3VWd0h4dmQxUi9VNFp2Tm1vUkUvWHhIejhrdVoyeG9MdzRi?=
 =?utf-8?B?WnM4dG1wcWJOZzh3ZUJ1c0xYN2tiS3RuK1ZjNTFZaUdmelJLb2VKbis2N3JT?=
 =?utf-8?B?VGZlcEx1NmY1K3BaM1Eva29ua3pYWUxuc2pGVkxHTHVERUU4cDU3c01uRVFu?=
 =?utf-8?Q?iGvROOdLpHfuI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR05MB3281.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d359ed66-c8b3-4d52-0b5c-08df46529fbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 15:34:39.0554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR05MB396616

c29ja19rbWFsbG9jKCkgbGltaXRzIGFsbG9jYXRpb25zIHVzaW5nIHNrX29tZW1fYWxsb2MgYW5k
IG9wdG1lbV9tYXgsCmJ1dCBkb2VzIG5vdCByZXF1ZXN0IGtlcm5lbCBtZW1vcnkgY2dyb3VwIGFj
Y291bnRpbmcuICBBbGxvY2F0aW9ucyByZXRhaW5lZApieSBhIHNvY2tldCBjYW4gdGhlcmVmb3Jl
IGNvbnN1bWUga2VybmVsIG1lbW9yeSB3aXRob3V0IGNvbnRyaWJ1dGluZyB0bwptZW1vcnkuY3Vy
cmVudC4KClRoaXMgd2FzIGZvdW5kIHdoaWxlIGZ1enppbmcgc29ja2V0IG9wdGlvbiBwYXRocyBh
bmQgY29uZmlybWVkIHdpdGggY2dyb3VwCmFjY291bnRpbmcgbWVhc3VyZW1lbnRzLiAgQXMgYW4g
dW5wcml2aWxlZ2VkIHVzZXIsIDIsMDAwIGFsbG9jYXRpb25zCnRocm91Z2ggSVBWNl8yMjkyUEtU
T1BUSU9OUyByZXRhaW5lZCBhYm91dCAyNTQgTWlCIG9mIHNsYWIgd2hpbGUgYSBjZ3JvdXAKd2l0
aCBtZW1vcnkubWF4IHNldCB0byA2NCBNaUIgcmVwb3J0ZWQgYWJvdXQgNS41IE1pQiBpbiBtZW1v
cnkuY3VycmVudC4KClVzZSBHRlBfS0VSTkVMX0FDQ09VTlQgZm9yIHRoZXNlIGxvbmctbGl2ZWQg
c29ja2V0IGFsbG9jYXRpb25zOiB0aGUKSVBWNl8yMjkyUEtUT1BUSU9OUyBjbXNnIHN0cmVhbSwg
dGhlIElQdjQgYW5kIElQdjYgbXVsdGljYXN0IHNvY2tldCBzb3VyY2UKbGlzdHMsIGFuZCB0aGUg
SVB2NCBhbmQgSVB2NiBtdWx0aWNhc3QgbWVtYmVyc2hpcCByZWNvcmRzLgoKc29ja19rbWFsbG9j
KCkgaXRzZWxmIGlzIGxlZnQgdW5jaGFuZ2VkOiBzb21lIGNhbGxlcnMgcnVuIGluIHNvZnRpcnEK
Y29udGV4dCwgd2hlcmUgY3VycmVudF9vYmpfY2dyb3VwKCkgdXNlcyBhbiBleHBsaWNpdGx5IGFj
dGl2ZSBtZW1jZyBvcgp0aGUgcm9vdCBtZW1jZywgc28gdGhvc2UgYWxsb2NhdGlvbnMgaGF2ZSBk
aWZmZXJlbnQgY2hhcmdlLWF0dHJpYnV0aW9uCnNlbWFudGljcy4KClRoZSBwZXItc29ja2V0IG9w
dG1lbV9tYXggYnVkZ2V0IGlzIHVuY2hhbmdlZDsgY2dyb3VwIGNoYXJnaW5nIGFkZHMgYQpsaW1p
dCBmb3IgbWVtb3J5IHdoaWNoIG91dGxpdmVzIHRoZSBzeXNjYWxsLiBXaXRoIHRoaXMgY2hhbmdl
LCB0aGUgc2FtZQp3b3JrbG9hZCBoaXQgdGhlIDY0IE1pQiBsaW1pdDogc2V0c29ja29wdCgpIGZh
aWxlZCB3aXRoIEVOT0JVRlMgYWZ0ZXIKNDk3IHN1Y2Nlc3NmdWwgYWxsb2NhdGlvbnMuIFNtYWxs
IG9wdGlvbiBhbmQgbWVtYmVyc2hpcCBvcGVyYXRpb25zIHN0aWxsCnN1Y2NlZWRlZC4gS2VybmVs
IHNlbGZ0ZXN0cyB3ZXJlIG5vdCBydW4uCgpGaXhlczogYTliYjdlNjIwZWZkICgibWVtY2c6IG9u
bHkgYWNjb3VudCBrbWVtIGFsbG9jYXRpb25zIG1hcmtlZCBhcyBfX0dGUF9BQ0NPVU5UIikKQ2M6
IDxzdGFibGUrbm9hdXRvc2VsQGtlcm5lbC5vcmc+ICMgY2hhbmdlcyBtZW1jZyBjaGFyZ2luZzsg
bm90IHN0YWJsZSBtYXRlcmlhbApTaWduZWQtb2ZmLWJ5OiBZaW5namllIFdhbmcgPHgtcHJvZmVz
c29yQG91dGxvb2suY29tPgotLS0KVGVzdGVkIG9uIG5ldC9tYWluIGUyMDNkOGE0NzUxZCB3aXRo
IHRoaXMgc2VyaWVzOiB4ODZfNjQgVz0xIGtlcm5lbApidWlsZCwgYWZmZWN0ZWQtb2JqZWN0IGJ1
aWxkcyBmb3IgYWxsbW9kY29uZmlnLCBpMzg2IGFuZApDT05GSUdfSVBfTVVMVElDQVNUPW4sIGFu
ZCB0aGUgUUVNVSByZXByb2R1Y2VycyBhbmQgcmVncmVzc2lvbiB0ZXN0cwpkZXNjcmliZWQgaW4g
dGhlIGNvdmVyIGxldHRlci4KCiBuZXQvaXB2NC9pZ21wLmMgICAgICAgICAgfCA2ICsrKy0tLQog
bmV0L2lwdjYvaXB2Nl9zb2NrZ2x1ZS5jIHwgMiArLQogbmV0L2lwdjYvbWNhc3QuYyAgICAgICAg
IHwgOSArKysrKy0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA4IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL25ldC9pcHY0L2lnbXAuYyBiL25ldC9pcHY0L2lnbXAuYwpp
bmRleCBiZmE0NDgwMjhmOGEuLjVmZTg3MzZjN2I0NyAxMDA2NDQKLS0tIGEvbmV0L2lwdjQvaWdt
cC5jCisrKyBiL25ldC9pcHY0L2lnbXAuYwpAQCAtMjM4MSw3ICsyMzgxLDcgQEAgc3RhdGljIGlu
dCBfX2lwX21jX2pvaW5fZ3JvdXAoc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3QgaXBfbXJlcW4gKmlt
ciwKIAllcnIgPSAtRU5PQlVGUzsKIAlpZiAoY291bnQgPj0gUkVBRF9PTkNFKG5ldC0+aXB2NC5z
eXNjdGxfaWdtcF9tYXhfbWVtYmVyc2hpcHMpKQogCQlnb3RvIGRvbmU7Ci0JaW1sID0gc29ja19r
bWFsbG9jKHNrLCBzaXplb2YoKmltbCksIEdGUF9LRVJORUwpOworCWltbCA9IHNvY2tfa21hbGxv
Yyhzaywgc2l6ZW9mKCppbWwpLCBHRlBfS0VSTkVMX0FDQ09VTlQpOwogCWlmICghaW1sKQogCQln
b3RvIGRvbmU7CiAKQEAgLTI1OTAsNyArMjU5MCw3IEBAIGludCBpcF9tY19zb3VyY2UoaW50IGFk
ZCwgaW50IG9tb2RlLCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdAogCQlpZiAocHNsKQogCQkJY291
bnQgKz0gcHNsLT5zbF9tYXg7CiAJCW5ld3BzbCA9IHNvY2tfa21hbGxvYyhzaywgc3RydWN0X3Np
emUobmV3cHNsLCBzbF9hZGRyLCBjb3VudCksCi0JCQkJICAgICAgR0ZQX0tFUk5FTCk7CisJCQkJ
ICAgICAgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsKIAkJaWYgKCFuZXdwc2wpIHsKIAkJCWVyciA9IC1F
Tk9CVUZTOwogCQkJZ290byBkb25lOwpAQCAtMjY5Myw3ICsyNjkzLDcgQEAgaW50IGlwX21jX21z
ZmlsdGVyKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IGlwX21zZmlsdGVyICptc2YsIGludCBpZmlu
ZGV4KQogCWlmIChtc2YtPmltc2ZfbnVtc3JjKSB7CiAJCW5ld3BzbCA9IHNvY2tfa21hbGxvYyhz
aywgc3RydWN0X3NpemUobmV3cHNsLCBzbF9hZGRyLAogCQkJCQkJICAgICAgbXNmLT5pbXNmX251
bXNyYyksCi0JCQkJICAgICAgR0ZQX0tFUk5FTCk7CisJCQkJICAgICAgR0ZQX0tFUk5FTF9BQ0NP
VU5UKTsKIAkJaWYgKCFuZXdwc2wpIHsKIAkJCWVyciA9IC1FTk9CVUZTOwogCQkJZ290byBkb25l
OwpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvaXB2Nl9zb2NrZ2x1ZS5jIGIvbmV0L2lwdjYvaXB2Nl9z
b2NrZ2x1ZS5jCmluZGV4IDgyNTczMjYwYjc0MC4uODkzOTRmOGQ5NjNmIDEwMDY0NAotLS0gYS9u
ZXQvaXB2Ni9pcHY2X3NvY2tnbHVlLmMKKysrIGIvbmV0L2lwdjYvaXB2Nl9zb2NrZ2x1ZS5jCkBA
IC03NDgsNyArNzQ4LDcgQEAgaW50IGRvX2lwdjZfc2V0c29ja29wdChzdHJ1Y3Qgc29jayAqc2ss
IGludCBsZXZlbCwgaW50IG9wdG5hbWUsCiAJCWlmIChvcHRsZW4gPiA2NCoxMDI0KQogCQkJYnJl
YWs7CiAKLQkJb3B0ID0gc29ja19rbWFsbG9jKHNrLCBzaXplb2YoKm9wdCkgKyBvcHRsZW4sIEdG
UF9LRVJORUwpOworCQlvcHQgPSBzb2NrX2ttYWxsb2Moc2ssIHNpemVvZigqb3B0KSArIG9wdGxl
biwgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsKIAkJcmV0diA9IC1FTk9CVUZTOwogCQlpZiAoIW9wdCkK
IAkJCWJyZWFrOwpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvbWNhc3QuYyBiL25ldC9pcHY2L21jYXN0
LmMKaW5kZXggMGQ5ODJmN2QyOWNkLi5lZGUxZjA4MjViYWQgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2
L21jYXN0LmMKKysrIGIvbmV0L2lwdjYvbWNhc3QuYwpAQCAtMjEzLDcgKzIxMyw4IEBAIHN0YXRp
YyBpbnQgX19pcHY2X3NvY2tfbWNfam9pbihzdHJ1Y3Qgc29jayAqc2ssIGludCBpZmluZGV4LAog
CQkJcmV0dXJuIC1FQUREUklOVVNFOwogCX0KIAotCW1jX2xzdCA9IHNvY2tfa21hbGxvYyhzaywg
c2l6ZW9mKHN0cnVjdCBpcHY2X21jX3NvY2tsaXN0KSwgR0ZQX0tFUk5FTCk7CisJbWNfbHN0ID0g
c29ja19rbWFsbG9jKHNrLCBzaXplb2Yoc3RydWN0IGlwdjZfbWNfc29ja2xpc3QpLAorCQkJICAg
ICAgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsKIAlpZiAoIW1jX2xzdCkKIAkJcmV0dXJuIC1FTk9NRU07
CiAKQEAgLTQzNSw3ICs0MzYsNyBAQCBpbnQgaXA2X21jX3NvdXJjZShpbnQgYWRkLCBpbnQgb21v
ZGUsIHN0cnVjdCBzb2NrICpzaywKIAkJfSBlbHNlIHsKIAkJCW5ld3BzbCA9IHNvY2tfa21hbGxv
Yyhzaywgc3RydWN0X3NpemUobmV3cHNsLCBzbF9hZGRyLAogCQkJCQkJCSAgICAgIHBzbC0+c2xf
Y291bnQgLSAxKSwKLQkJCQkJICAgICAgR0ZQX0tFUk5FTCk7CisJCQkJCSAgICAgIEdGUF9LRVJO
RUxfQUNDT1VOVCk7CiAJCQlpZiAoIW5ld3BzbCkgewogCQkJCWF0b21pY19hZGQoc3RydWN0X3Np
emUocHNsLCBzbF9hZGRyLCBwc2wtPnNsX21heCksCiAJCQkJCSAgICZzay0+c2tfb21lbV9hbGxv
Yyk7CkBAIC00NzMsNyArNDc0LDcgQEAgaW50IGlwNl9tY19zb3VyY2UoaW50IGFkZCwgaW50IG9t
b2RlLCBzdHJ1Y3Qgc29jayAqc2ssCiAKIAlpID0gcHNsID8gcHNsLT5zbF9jb3VudCArIDEgOiAx
OwogCW5ld3BzbCA9IHNvY2tfa21hbGxvYyhzaywgc3RydWN0X3NpemUobmV3cHNsLCBzbF9hZGRy
LCBpKSwKLQkJCSAgICAgIEdGUF9LRVJORUwpOworCQkJICAgICAgR0ZQX0tFUk5FTF9BQ0NPVU5U
KTsKIAlpZiAoIW5ld3BzbCkgewogCQllcnIgPSAtRU5PQlVGUzsKIAkJZ290byBkb25lOwpAQCAt
NTY0LDcgKzU2NSw3IEBAIGludCBpcDZfbWNfbXNmaWx0ZXIoc3RydWN0IHNvY2sgKnNrLCBzdHJ1
Y3QgZ3JvdXBfZmlsdGVyICpnc2YsCiAJaWYgKGdzZi0+Z2ZfbnVtc3JjKSB7CiAJCW5ld3BzbCA9
IHNvY2tfa21hbGxvYyhzaywgc3RydWN0X3NpemUobmV3cHNsLCBzbF9hZGRyLAogCQkJCQkJICAg
ICAgZ3NmLT5nZl9udW1zcmMpLAotCQkJCSAgICAgIEdGUF9LRVJORUwpOworCQkJCSAgICAgIEdG
UF9LRVJORUxfQUNDT1VOVCk7CiAJCWlmICghbmV3cHNsKSB7CiAJCQllcnIgPSAtRU5PQlVGUzsK
IAkJCWdvdG8gZG9uZTsKLS0gCjIuNDMuMAoK
