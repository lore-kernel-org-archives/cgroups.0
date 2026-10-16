Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azolkn19010090.outbound.protection.outlook.com [52.103.10.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354AA3546FC;
	Fri, 16 Oct 2026 15:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.10.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164375; cv=fail; b=qjvCZT7ci1xfdcW3vdlgvtL3PiRMClSj5rtMP5tydT/tobHmlrQMQjuBQa0N/D7G6IMyWfG56eOQr7ch+WWQMf1Zx1pBbvZb8DugjC1QAd/+NsryBs5O9gfxWN3LjDhIAIfkwEDTSEWYuqpwKKF79mrCZ7fu4R2gMDMMhoaa3L4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164375; c=relaxed/simple;
	bh=QxJiCccMo6h1D4qVDJ9ZsZ2MLLlMZU6RFAQlrxBi5lo=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=K5gwEmRbVohJh1BnLjXg2ghtWnfVzIgq35Nwb74vF8xUi3QSefXRwhoi7JRB1h53xq64+Ws6Q8PVHd0BHb7UNsLnULY3u9nRRnrQsb+mZcvsgzVv2Vgq/H/8HnFj0O8p3v9YHEXj0/quq3I3o5K90aFdvEWb7iNxpFAJcvJajFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=blqLWh+D; arc=fail smtp.client-ip=52.103.10.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="blqLWh+D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZU1rttdwN1E5C5aVppDrQAL29biE8mawQqQvXIT3b/fmqwTYnirDK7FbrRkY0iMkKSJ+F48SUhRGi1JIB8YePA+/YjfYVMyO+oi1zo4kTeiEj8wsXTjUOaUESIWyjFCpm4RIn8xEFCW7VUnAML1l1fFVcEz5EaK2nCIKoek/mOC8PuRlfQmMB2qqUPhn9u3FJSdcMJLSU7Q/gC5mbMRlHdUd+8yPMm6U/YWxHgmlSTAwhTxcJMDkSBzfanaC2wSIjJy8tr8c5KEjjafzB5hCD55cytple9C5oAirCYl02yqOR5LVtsJ4JBeLg5tXQPXT9SM7xu4fGWp/zNvGiBL/GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=QxJiCccMo6h1D4qVDJ9ZsZ2MLLlMZU6RFAQlrxBi5lo=;
 b=t3sX+k63zbOmx3oNoxvFrPgnlKYvGcEZMAdTBYSXwwWFp5UBgiSWPjY4TAEInFTuYEEStz0TLKMVGdlVL2eQ0ms89qgh3nZ3bVixIebmYRuYjBPi79mXsT2qts1kCWU+WRnMMIo4aRpbJyRNV6pL2tnnh+XLOwXfee3SUAFP8TTcuXZDLLZ5Ggl1pr4Su0H6pK3zkdxR5BehLD7XnnmOatv5ch0MPpmEpBo4yZijTlAQGGWJ5qFgCTDSm4aNGyytfDkCAlp+5eitFIH17Pk1OvhzW0N2T/vpSUUPlBJzyam5/6mFCn2ysY6KXHeZPuff+xN/FjP2vdKph6PLZyp1iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxJiCccMo6h1D4qVDJ9ZsZ2MLLlMZU6RFAQlrxBi5lo=;
 b=blqLWh+Dv+lv3EF/J2Yp3CqU8eLsrCI+ubddWhgFOjoRyqbbskQ0Ct2CgGbh4YhYdry6SsDWlVy7fSFCnuA3rkrJFUaNL9a/SJ8rxQ7JjVwUceerctFsPIn2yRVy12M6U5gE59TEj8AU5q8fzcB8x8ZnYNXbvvzIH/A0slGpGKeBasYKv9IYSFy622qz+i57TbuuWDAyD0/momPG2rr3sF0co1gwphORx2VpP99S2XCIzsjIU2Ed1xvUaGP0Ya7OAATRgsElr9opLoVbna0RCrmMpJ089DJjviqKmA8JjAuQSk3rbDs1sBpP0YzVgfhUyHOHYQFvmPT15kZDJwh22Q==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB999059.namprd05.prod.outlook.com
 (2603:10b6:510:42e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.17; Fri, 16 Oct
 2026 15:26:11 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 15:26:11 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: Alexey Gladkov <legion@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>
CC: Manfred Spraul <manfred@colorfullife.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>
Subject: [PATCH] ipc/sem: account enlarged sops arrays to memcg
Thread-Topic: [PATCH] ipc/sem: account enlarged sops arrays to memcg
Thread-Index: AQHdXYKsJFm8JcYiG0umhbOnIRhIBw==
Date: Fri, 16 Oct 2026 15:26:11 +0000
Message-ID: <20261016152609.2528805-1-x-professor@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB999059:EE_
x-ms-office365-filtering-correlation-id: 65e01733-d5da-4f55-9c14-08df2b99cf10
x-ms-exchange-slblob-mailprops:
 7qh87CJt6y1mqZO6407WRLxlypE3k+ejUdHeIAqpRx7/7eIE1LAo7Zq0zal1dh59oecMLyIoY0XMQnRlOh//u0753S91fBFxDqba4Ga5hNes3lGPaYFwLil9viWBBdIRvzJAjh2XNbrzftp9JOQF3qvUTgRdYL4Livh5e5UvAApOq8fUtCL8YjHjqGXptrz8LoGwVx1C/T3zmxGMDMoTHm9id+fWwPPFOqUcviV0X66OU4zUScgtQKlnJ6AQUPRb+jVHG3qOBkw8PFl/mZ9Ls3lPDj0BrAhur4ZKpwWaI3E228PrtcfxKtvFBk0A2szljjHUYeiYtdLfnss3ATlNuEjvtkFYqLhRwsvgRyKuJUINKj0Kpd2Q60WUpOZ1CTdDEJZd8TlIeV0WwQ6spcub6v1MQUnvSOtT6GQM6Ve+yFsj+QnSqof9VogZIByNcCntxlVcrQ6l6NdHQ+SCQH05DLGQXD+AW97i4o2Ew5BHBI/mmkY88XkDH1A1HFDuot3mKTWWisvtk2kkAbk1nXJIs5A8qdIjdrOEET0BiZM6hByD8y91FSCTaaHEuXL2aAFRZH8kcYMpUwjFTcSAUqAN4xnB/c7GPI/1tzyVLg5Iq0kqh+bHLfGx2hwNYUmNBVfW17Q6ffBIe7q803D2XP2tWxNC2AP9N587MfPTzlfm9A0JrvHIch+IR9JbdIa4OFwEEhfTT8fEYN1Cv1K34pyj+CQ9c3esWZivIEIaeS+R5nFBwyMzdYjeYmjbND7/GJYs
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|22091999003|8060799015|15080799012|31061999003|8062599012|19110799012|12121999013|24021099003|21061999006|4140399003|11091999009|6050399003|38102599003|41001999006|3412199025|440099028|102099032|40105399003|52005399003|26121999007|3430499035;
x-microsoft-antispam-message-info:
 =?utf-8?B?U2w5dEZZbjJwdDZ1ZFgrT2VUSldvWFpkbWtvdnhMVCtZbUNJWGkzMGlIOS9j?=
 =?utf-8?B?UUl3MS8zeExldDF0WTdValJNdE9kd3R3aHNyZDhMOSt4bks4eTJzL01WbVls?=
 =?utf-8?B?cW16amQ2a0Y3Sm93R2Zlb1c3dU41eS9QSDNZR2VtZXZIbHZubUwvL3dLcDdO?=
 =?utf-8?B?QWFCNnlRbVluY3VacUhxWjVvbjJFblc4UlJpaHRpKzhsZm12OEEzQ3JuazVS?=
 =?utf-8?B?a3NDNlhzQ1BzcTA0dTRCaHJKQUQwS2FUemdVZFcxME9wbnhBVlFDRDFQNDFE?=
 =?utf-8?B?N2o2NE9WcDdaZk1XZk4xbXg0citWMVlGdDNkUHJVRzBqUDZ6eGk5WURuNlVh?=
 =?utf-8?B?ZmxWVzBVN01YMHdvWGNNVXJsU3JmeVp6eTVvdmRNSUlLdHFPc0g0SWJnNFdt?=
 =?utf-8?B?U1VkN0FoSXBTYWNTUDY1eDI0dWhyUU1UMDBkNkh6djJFU3o0RDhVdjA4V2FV?=
 =?utf-8?B?U3d1VmFBRCt5bTRhelJUa2JQVlVGeGlHVW52L3ExRHE2NDdhZnM4b3hVK3Y4?=
 =?utf-8?B?RDBKdVY0OHg0bExlNlV3RytnQ3RkeEVHdHpqZzNPK2NtdFpMdGRlcVRCS2Rh?=
 =?utf-8?B?V0Qwd0NYYXBPam5CQmUycVFadTUrRUM0TkdSalZqamdQeG9sK0s5R1U3TDJt?=
 =?utf-8?B?RDU1UVQ4eWxpamJPRzh6NEhrb0RJSzFOZ3lTOW93OXpvdUVMRjFjTUNkSmFW?=
 =?utf-8?B?Sy8rbkpKdGwwYStDL0ZFTXZUNlkwT0lsRFRzd3ZlbjB0VksvbUFEN1RYT2E3?=
 =?utf-8?B?WHAvTTBreG11S0RORnl5SHVianA3Qjd2bWFJcWhXMTNpZEY4Ukl3YjRZSitq?=
 =?utf-8?B?L2JUeTZBUFB2Z2Z6WTNjUGlYZXVRWlo0R3B2d3NEV3dxTnFkTkxYaG9FTy9X?=
 =?utf-8?B?a3BQM2E5R05ZeFFKMlVneWgreXZ3YjczeG5jNGdVOURFMTgvL1FsUXFzTFlD?=
 =?utf-8?B?M3lySmFhNno3RnJxT1RGTGlxQVpvR3JmUG81QzNLc2lmbXAvdDBMcmYyR3V4?=
 =?utf-8?B?bEtZQ2VLNTl5c0ZIbThVb3RWQ21PS3prYTlUVjNwMDVVMHdYdjlaS3dhMnox?=
 =?utf-8?B?ZWFLTldqSDB0QTZYb0pZdG16d3lLUXZTV3o5Q29EN1h0bzNTVk5PdnY2cHlY?=
 =?utf-8?B?T3I5RDVJNUp1ejc4VGlBTC9CcVNqOVBIS0lvVzErTklVRTUxKzZLSlVkcWYx?=
 =?utf-8?B?dU1xUkR6cFNhWUxud2FXcGMrLy82dEk0QzhGZXZMU3BlQzlnZXNGN3NOVE9X?=
 =?utf-8?B?SEc3Qkx1Z3JyNnp5TnRUS1c5Q1JtRDBTS1cwNGNRL0VONFVjdk1QTjlWU3pH?=
 =?utf-8?B?cG1vSDB5Mjd0aVB6cHVFRkhFZUl6bFNNRjdyYmNVaEQ3WStPYThMV3lueFZY?=
 =?utf-8?B?UlpQMjlMVFV1R282RUtLbGlWQmM1VHVncEdMeVM4MGNXTXN4U1EycnJtZnNa?=
 =?utf-8?B?UjZMSjZIT3hYaUpEWmM2cElaTzlMYWExUGZBQkpKVFFDZDRvS3hoUXIyTENa?=
 =?utf-8?B?VnNqZHFaeldRL0w3NHNsQVRQdGM4TjRDRWJvM0I1Q1huTkxhbFY1cWxrelht?=
 =?utf-8?Q?PhK5HvFRx6FjBg2EagWnA/WzgOTd6pLzHtXmwVZMcNhCoF?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bHdWT3BEMXB5cUJ3eXF1bUN3TlVPSHJJdnBQR0s4UEVEOUlwWGo0djJnRFgv?=
 =?utf-8?B?R0dRczBkekFRM1Z0cVFnWjJXK09IdFZ1ZzJNWFkzTjBlWkdtTnlkK3A4ZE1U?=
 =?utf-8?B?Q2E2clBBYk9FVjdGV09NWGRQUXFLYUs4MFMrZjh4NWtBWElJSEdZK2o2ejFk?=
 =?utf-8?B?NWIvcS8vWTE5b05pNnMzV013ZEpJY1k4akJzUzNNbVZGVHNoQVVGUjRrWkJO?=
 =?utf-8?B?aUNUQXRRVGxoMTBVdWg0M25nRUczTnVpcjVWZW9salBVK1NaTGQxR3dDSWVv?=
 =?utf-8?B?QkMrTDRCSnpEdG55WTJ0S2F3YkZWTjd2d2xQVmxkWkFGYVRYN0x0amhQTkZk?=
 =?utf-8?B?YkdWcnFKdzZWMUQyY0lOamZOWHFzYUZTbFJmV3ZiY296dGM5WFdDU2EwTldj?=
 =?utf-8?B?V0VMaW8xTElWV3NKNU5XUnkzaWR6aUltZXp0Y3pmdW5DaUxLUzhBTTNXbE9K?=
 =?utf-8?B?a09NNWNTOGZBUDlSZzZzQnRiS1VuajAySUllWWZ0UHFBNWhuMnJ3eGI0NGNS?=
 =?utf-8?B?MHl2ZFVMdi8xUXlPTzU5ZFV2UjVtREVYVmRFazBtQlJNTEZOSXJseWFqaHNt?=
 =?utf-8?B?eUJwb3ByT1YrVkpqays2eTJxN2VPcXdZaVRia21QelBNVVhHUVhmWUxiMFU3?=
 =?utf-8?B?RUREKzc3U1huWWlUSjZDeEJLRVg1bDBmYThqdC9xQVpHSjkrVjJscTZ5YWhH?=
 =?utf-8?B?MFVuTWV1b08yZlpGczFHY2VVdFdhcm9Pbzk5NjBFZ3VIRG1OZzVRdmUrVmdW?=
 =?utf-8?B?eTBrVTkwNCtORHZaZ1Z1R1hDbXVvTld0MDVPK1luSDV1amt3NFdLcE5ybEk1?=
 =?utf-8?B?L3IweEJ0ZlBNZmt2VGlodlFzN21VdzU3Y1dMdWt3ek1tYmxFSjVmMHhGNitW?=
 =?utf-8?B?NkdZK3VwbXNCN0thY2N2MWxmUXd0YjNyektENTV0dzZrMjJFd2N4akFVdGFC?=
 =?utf-8?B?YlpSSkxVWVZYS2RvNnRaUklwM1J4TmRINFBJNGdzb3JvSURKVW1UV2NxWGcv?=
 =?utf-8?B?VHQxMU1FZnF4b25ZeDBzTmZyMlMvc05UOFN2NVg5d251QlNLQ1VPT0Yyenl6?=
 =?utf-8?B?VVNRZjczd2ZDSHZsNmhhOWFrU09RYUV0bUhwWm1VZURpVXpYQzkrY1JzY29D?=
 =?utf-8?B?NkdmV2lnTWdSYW5PK2Q1WjFweHNkZ3luc0hHUGxrWGlnL0NIUjZjclEvYkll?=
 =?utf-8?B?UklGdnZYazdjNmhrZ1l5RGV1dU41RDJ6OSs0NFhNYWdJL01ySFErUDJGSlF1?=
 =?utf-8?B?TFd1R0d4TGpTdW1wamdyU0RLYXZ4d2NvNllRNVdCd0Q1WFE0b0xOZjZoMmdD?=
 =?utf-8?B?b000SGE1VmVZM1NCVnhhd08xUHQ4ek9ZSGNCeVJOc01tV2lQcnVnZEI2L3Ry?=
 =?utf-8?B?WVRiOVduK3pKWUpjS2htMU15YlZIdkpuSlNybHg4eG93QTg1TFdtYjMwWEFG?=
 =?utf-8?B?bUVKdGtGWnRvSHV4S3RlUVhZUFNVazY4MUdnWWlnUm1IRGx1SDh1VFd3Q3dH?=
 =?utf-8?B?ZjhyUUtCUjMrSWVaTlBUalVpdnByek8yNysxaDE3Q2VVRDJaV0NaNGhSeTdS?=
 =?utf-8?B?dWZHZml4NTI0c0RkOUpVdGpVMzVkdXdjSkw3Q2R4WU5EVTRiV09jL01ZTnU2?=
 =?utf-8?B?Q0tMdGVRZ3BVNHpZUlEySUF2YUdGSjFCREN5VTQvdHM3ZjJUeXlPenIvTkxo?=
 =?utf-8?B?aDJZbytlN29TS2wya1ZXa3c5TGJsckdXQnlxb2kzUHo1K01hbHNYSWVhSHlr?=
 =?utf-8?B?NGo3RmdLNW9yRGoxOEljbXQwaWN6ZWQ5RlB3T2tPbjdCRjU5bTBLbGFnY1p2?=
 =?utf-8?B?QmlVdDNXcHdJMGFmZmxkRW1wUDdzTEdvU2JHZngvK1BSYS9pVVhCaUY2NHRV?=
 =?utf-8?Q?9JBeKvBXlLL2i?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e01733-d5da-4f55-9c14-08df2b99cf10
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 15:26:11.3283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB999059

Q29tbWl0IDUwZWM0OTliOWE0MyAoInN5c2N0bDogYWxsb3cgY2hhbmdlIHN5c3RlbSB2IGlwYyBz
eXNjdGxzCmluc2lkZSBpcGMgbmFtZXNwYWNlIikgbGV0cyBhbiBJUEMgbmFtZXNwYWNlIG93bmVy
IGNoYW5nZSBrZXJuZWwuc2VtLgpUaGUgU0VNT1BNIGZpZWxkIGRlZmF1bHRzIHRvIDUwMCBidXQg
aGFzIG5vIHNlbWFudGljIHJhbmdlIGNoZWNrLgoKZG9fc2VtdGltZWRvcCgpIGFsbG9jYXRlcyBu
c29wcyAqIHNpemVvZihzdHJ1Y3Qgc2VtYnVmKSB3aXRoCkdGUF9LRVJORUwuIEEgYmxvY2tpbmcg
b3BlcmF0aW9uIHJldGFpbnMgdGhhdCBidWZmZXIsIHNvIGEgdXNlciBjYW4KcmFpc2UgU0VNT1BN
IGFuZCBob2xkIGxhcmdlIGF0dGFja2VyLXNlbGVjdGVkIGFtb3VudHMgb2YgaG9zdCBrZXJuZWwK
bWVtb3J5IHdpdGhvdXQgY2hhcmdpbmcgdGhlIGNhbGxpbmcgdGFzayBtZW1jZy4KCk9uIHRoZSBj
dXJyZW50IG1haW5saW5lIGJhc2UsIG9uZSAxMCwwMDAsMDAwLW9wZXJhdGlvbiBjYWxsIHJldGFp
bmVkCjYwLDkzNiw0NDggYnl0ZXMgd2hpbGUgYSAzMiBNaUIgY2dyb3VwIHBlYWtlZCBhdCA5MDks
MzEyIGJ5dGVzIGFuZApyZXBvcnRlZCBubyBsaW1pdCBldmVudC4gU2l4dGVlbiAxLDAwMCwwMDAt
b3BlcmF0aW9uIGNhbGxzIHJldGFpbmVkCjEwMCw4NjAsNDE2IGJ5dGVzIHdoaWxlIHRoZSBjZ3Jv
dXAgcGVha2VkIGF0IDEsMzEwLDcyMCBieXRlcy4KCkNvbW1pdCA2YTQ3NDZiYTA2MTkgKCJpcGM6
IHJlbW92ZSBtZW1jZyBhY2NvdW50aW5nIGZvciBzb3BzIG9iamVjdHMgaW4KZG9fc2VtdGltZWRv
cCgpIikgcmVtb3ZlZCBhY2NvdW50aW5nIG9uIHRoZSBwcmVtaXNlIHRoYXQgdGhlIGJ1ZmZlciB3
YXMKYXQgbW9zdCB0d28gcGFnZXMuIFByZXNlcnZlIHRoYXQgZGVmYXVsdC1zaXplZCBwYXRoLCBi
dXQgYWNjb3VudCBhcnJheXMKbGFyZ2VyIHRoYW4gdGhlIGRlZmF1bHQgU0VNT1BNIHZhbHVlLgoK
V2l0aCB0aGlzIGNoYW5nZSwgYm90aCB0ZXN0IGNvbmZpZ3VyYXRpb25zIHJlYWNoIHRoZSAzMiBN
aUIgY2dyb3VwCmxpbWl0IGFuZCB0aGUgY2FsbGVyIGlzIHRlcm1pbmF0ZWQgYnkgdGhlIG1lbWNn
IE9PTSBraWxsZXIgYmVmb3JlIGl0CmNhbiByZXRhaW4gdGhlIGVubGFyZ2VkIGFycmF5cy4KClRo
ZSBzeXNjdGwgYWxzbyBhY2NlcHRzIG5lZ2F0aXZlIFNFTU9QTSB2YWx1ZXMuIFNpbmNlIG5zb3Bz
IGlzIHVuc2lnbmVkLApTRU1PUE09LTEgYnlwYXNzZXMgdGhlIGludGVuZGVkIG9wZXJhdGlvbi1j
b3VudCBjaGVjay4gVGhpcyBjaGFuZ2Ugc3RpbGwKYWNjb3VudHMgYW55IGFkbWl0dGVkIGFycmF5
IGxhcmdlciB0aGFuIHRoZSBkZWZhdWx0LCB3aGlsZSBsZWF2aW5nClNFTU9QTSByYW5nZSBwb2xp
Y3kgZm9yIHNlcGFyYXRlIHJldmlldy4KCkZpeGVzOiA1MGVjNDk5YjlhNDMgKCJzeXNjdGw6IGFs
bG93IGNoYW5nZSBzeXN0ZW0gdiBpcGMgc3lzY3RscyBpbnNpZGUgaXBjIG5hbWVzcGFjZSIpClNp
Z25lZC1vZmYtYnk6IFlpbmdqaWUgV2FuZyA8eC1wcm9mZXNzb3JAb3V0bG9vay5jb20+Ci0tLQog
aXBjL3NlbS5jIHwgNCArKystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvaXBjL3NlbS5jIGIvaXBjL3NlbS5jCmluZGV4IDVlYzQx
ZGU3ZTg1YjJiLi44YzllZGVjYzE2MDc2MyAxMDA2NDQKLS0tIGEvaXBjL3NlbS5jCisrKyBiL2lw
Yy9zZW0uYwpAQCAtMjIzNCw3ICsyMjM0LDkgQEAgc3RhdGljIGxvbmcgZG9fc2VtdGltZWRvcChp
bnQgc2VtaWQsIHN0cnVjdCBzZW1idWYgX191c2VyICp0c29wcywKIAkJcmV0dXJuIC1FSU5WQUw7
CiAKIAlpZiAobnNvcHMgPiBTRU1PUE1fRkFTVCkgewotCQlzb3BzID0ga3ZtYWxsb2Nfb2Jqcygq
c29wcywgbnNvcHMpOworCQlnZnBfdCBnZnAgPSBuc29wcyA+IFNFTU9QTSA/IEdGUF9LRVJORUxf
QUNDT1VOVCA6IEdGUF9LRVJORUw7CisKKwkJc29wcyA9IGt2bWFsbG9jX29ianMoKnNvcHMsIG5z
b3BzLCBnZnApOwogCQlpZiAoc29wcyA9PSBOVUxMKQogCQkJcmV0dXJuIC1FTk9NRU07CiAJfQoK
YmFzZS1jb21taXQ6IDJmMmY3ZWVlZjhiMGExYTliOWNhOTk4MjMxNDE5ODczY2NhZThkNGUKLS0g
CjIuNDMuMAoK
