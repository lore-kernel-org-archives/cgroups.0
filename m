Received: from mx0b-0066f901.pphosted.com (mx0b-0066f901.pphosted.com [205.220.172.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EFB4B0497
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 11:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.172.220
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786967318; cv=fail; b=rgb0o/rAcorF0uOKW4H0diHUwIHe8DO+SGfMotiUwOvzecLESMwMd/ZP24XfREXM29T78WGhWJ+EIROcIytA9+ueaL5KRARH9esyfL64LTdauQ5jbleZtPbRQIuUnkRUOHFgYVyl7VwNc2ybUVDgGmrwaV4laXgS06IIk3X59R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786967318; c=relaxed/simple;
	bh=9MstDxgMo+f1cSpYy3AqzIMoll9IivFMyQfnnSLQTCA=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=L+Q60Im5/6Ay4zUwW55Rsai3b/jF+DczrGnnkLICbjrFBeb6nPzKY++KJDc07V0M8CDqzoL7/HCN324pKOwk+/utO5xFSMBu3skEMtkEiEpr1ey5uoy31KxCdhfSkqpqqSMLh9pnpFj3ep+dlKXaDOwN/Ka0UQJJq+mVK8YZPtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kyndryl.com; spf=pass smtp.mailfrom=kyndryl.com; dkim=pass (2048-bit key) header.d=kyndryl.com header.i=@kyndryl.com header.b=kGr2r8c3; arc=fail smtp.client-ip=205.220.172.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kyndryl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kyndryl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kyndryl.com header.i=@kyndryl.com header.b="kGr2r8c3"
Received: from pps.filterd (m0268695.ppops.net [127.0.0.1])
	by mx0b-0066f901.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HBD4JL2193839;
	Mon, 17 Aug 2026 11:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kyndryl.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp260318; bh=9
	MstDxgMo+f1cSpYy3AqzIMoll9IivFMyQfnnSLQTCA=; b=kGr2r8c37T2A0qsRg
	6Rc4BOUGVUDDIgQ+QZLX9/sl6pdCaRxxypfGlFeBtuCQgpxzCUQmBg1aLR9ywkqV
	NZFRfO/X4cl1XwDKiitNapvtHz9bTYg4H1aD9Bb8EryX9I8Nlfk/ZxdjBLEnEjpR
	i+/k/BB8+HSneVabUQhC6PknQuM+tXO/ACN5YRi0nZvb+8S3kLpFj+u9waxSJDxq
	avtZ4maEXIhEi5IkQDfV2eVz3HUKkmxvFZHtgS09ZU7x8UAKQNXAjQymgNKOkkrV
	E9kTneDyh6c3dg9WUp9J+KRQIgEVcsrTKNQst5wOvoczXWafA5vaFO9twlCQFnhW
	4J/Sg==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013034.outbound.protection.outlook.com [40.93.201.34])
	by mx0b-0066f901.pphosted.com (PPS) with ESMTPS id 4g417x88fr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 11:32:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+T3qQ1Uo1ak7ItP5kcSRPwEOHU0FEKt6g/uZQzVZTw7JufmbVGfq5vSOynmRFLOmyHI/d/Qr1a0CjyYGeolyYZzKPOZNyPrCrZE4EqojsJyh5WaWN74ibSf4VVvXjsoEyMjrRyiqwgE2QMw75ImZI7UbCnL+mlsPVh3rzSvGFkOV5Bbl5N5J510uPGH5EmGBztmHnm/Gn4Oi6SqGKvKjYEAhzaLsFenI2GCd7/YlWLtB9bOJLSGmciEZZoTQCyIi0WUjfn8+57w/H2RR2z4tmtOIYayfRM37HFkTm0bCdcu+siecjWrGuuN0RzXqHRm4i8ZHYFUO9VTEeT4ihksZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MstDxgMo+f1cSpYy3AqzIMoll9IivFMyQfnnSLQTCA=;
 b=k8+04pNGaxwrCspkit+VMdFGhg6YUW6mmFeEfOKgG3fSBSEavu7lBzA0LeTz6BULjrqkjdFGSMozKrqwdutLQ3R1N5meduxl+IyITU+EMuny0RdZqFJ9LXsjOzHbmGWYEvxuiPHsYEPC/WxLlEAo0oUPHT06bDqt5A1/hqyN84wqciNU+DeH1A5Xy6TxSKIPQ+8G1G9feY2A+dQkhCLCNzlzhzbNDo0eR1WBvXglm7MfnYaXAGY6rMEgVboNr/zrPjbzgvtW3wA4iATXGsVzwXpueFaJpfOsyCjqFV3vEfehenzu/VnQXz5aErdYl7dyGUQGwFulAnMBrJv6B0agHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kyndryl.com; dmarc=pass action=none header.from=kyndryl.com;
 dkim=pass header.d=kyndryl.com; arc=none
Received: from IA1PR14MB7824.namprd14.prod.outlook.com (2603:10b6:208:5af::13)
 by IA0PR14MB6305.namprd14.prod.outlook.com (2603:10b6:208:437::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 11:32:37 +0000
Received: from IA1PR14MB7824.namprd14.prod.outlook.com
 ([fe80::a94e:790b:edd4:7853]) by IA1PR14MB7824.namprd14.prod.outlook.com
 ([fe80::a94e:790b:edd4:7853%4]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 11:32:36 +0000
From: SCOTT FIELDS <Scott.Fields@kyndryl.com>
To: Lennart Poettering <lennart@poettering.net>,
        Demi Marie Obenour
	<demiobenour@gmail.com>
CC: systemd development <systemd-devel@lists.freedesktop.org>,
        Linux cgroups
 development <cgroups@vger.kernel.org>,
        Alyssa Ross <hi@alyssa.is>
Thread-Topic: [EXTERNAL] Re: [systemd-devel] Purpose of init.scope
Thread-Index: AQHdLZieGQTK7wTA9UmfSn49BkikmbaiHMR7
Date: Mon, 17 Aug 2026 11:32:36 +0000
Message-ID:
 <IA1PR14MB782409DC6E8D76E14EE156238AA72@IA1PR14MB7824.namprd14.prod.outlook.com>
References: <b6dd3b7a-18ba-4b0a-bc5f-9c92d8b2aa7f@gmail.com>
 <aoHfAHdsX6kE9msj@gardel-login>
In-Reply-To: <aoHfAHdsX6kE9msj@gardel-login>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR14MB7824:EE_|IA0PR14MB6305:EE_
x-ms-office365-filtering-correlation-id: 8be9628b-00a4-456d-00eb-08defc533cf3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|18002099003|22082099003|56012099006|38070700021|11063799006|4143699003|10067099003;
x-microsoft-antispam-message-info:
 ufEwHB84T12+oIDeegrCOi9BwUFADb2dAkhcKYDMq8HrlOfOoiunnAdD1qFewJ1aRXy95q/GvEeoV1FRYJZzCKYrRpSbBoaInfAcK7zeg6LzwRf3icwFU0KmZTIiU3BLvg9pSUSAEh195/G1Chq99/Jyz7o3FH6NeQO7RkQ4JGTAimhm25ZtbEFU3+weqTm6ov1mTmvIAWeqZVa5Ra2ePb1MOHqUuS6uaBOn/OKH8+JiJ+p3yrPIwcQlrfLlPRp06k0AhXsKtdM8FybYh6zP7lsMIUUbIuvou3P/sVh8SGB6GufmoHH0rv5/znYVVYVCMkogAzw3XxBE46UiRhS1OK+5SJ0b0o+e8IoZ1SiG+pO+IEl5BLLZWEbtdAmdnxpUqrVX65Tp7AOVGEvoSMfkO39/yEd7hDOO+jx610MF7afBWK38qvARfrZAnIMG+3Hm4VC427hcLclGio0Dgd7hEcMHDRHdmv4TqFVqMBhRi8Ym9UDM6hOiu7UWMj2hKLv3tjAXr86MFH5H91IqiokTU7fs3PMhjT2vUfrLazz7oR7XhXA/hj9/iyzk9+MB3CId4aZK5fzCOULO+8/YZSuxa1ANSt0kH9N+Pl2vRQhZJ8aYyRGHYgXOPg85gxc2Jk/uCAIPK0qq+MoC5JefLU1vBiVvUMJ0EYu28c8xO3fKusRcVfDXi8BoVbJN9DsV9Kt7B3DydZWlLfAZ8iWfPLvByIlKMzdUbmdNLy+/irQ9pjE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR14MB7824.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(56012099006)(38070700021)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?rnxHkKtLFploefozxPu0pTqaveFks2CQSn5Jr7g56e7pSWfkyu8ynPTFL1?=
 =?iso-8859-1?Q?y9T6Nn+cWHsfJEFK78DWv47q3WUpKC5KJzBAgr/cxux4C/9OqiAVlpPeQm?=
 =?iso-8859-1?Q?H/Iu/4309vNL2vGLOdS0Fyi5j0w/qUmg1oUHWEMZoqquueIzk4L7F3ywyr?=
 =?iso-8859-1?Q?fDyctVn+6VuiTWxkVlweeZwIAkRQBMVSuU9YifST14vOKhKX2T5waQNke2?=
 =?iso-8859-1?Q?3IlA8XknUte96AtnXBLLgYZBML2KLtfRdwIsHUAlfbzznh/PUa0kVWa60p?=
 =?iso-8859-1?Q?AQmtX1oV4C0nbUTPYUvyLv9Owoa7G0nvAzLXyFLFJ21pEx+PjBntEAAptl?=
 =?iso-8859-1?Q?7Iiow3ht4MFd+An0PGtBk2CjJhADykx2JuSCjVkpGkhtsZnE2QeDkEpfwG?=
 =?iso-8859-1?Q?xVPqHvTzVSE6zE1sGlawlzXc/P7tlbwwom5CFCNZwJCpOnS7yZLlnV7gE4?=
 =?iso-8859-1?Q?BlXG/qquKtJs+HLBTLeUomU5JC9iJRqLlMx5jc6bru7mE8Rd6wsxSkpEOl?=
 =?iso-8859-1?Q?u/E0iOvN2L8s7ekZXfyo5aDPeEycrxneyhU0dTnSK24KRgLUS7OvPWfH63?=
 =?iso-8859-1?Q?XmWbfMRhS1uAHTPvFjKYXryAYQOjEt33VI2wDOsJlzjzPPdonk8H8VE223?=
 =?iso-8859-1?Q?EG4K6e4Y3UzZt0qdlGTvw+To+S+alYOM3o/nrjC/l9Ffa8sJGYbpwJ8eEF?=
 =?iso-8859-1?Q?NagAfkL0DLJeSMr9e3mljUKZaxBHnNYfAFVvcA5pLM05AxbMJqgMl5Zm3n?=
 =?iso-8859-1?Q?7pUB4aHBV4+L5zAufuacLhpJ8n/r7zeFXA/aYgFxFgmffd/TVoVuwjpZZ4?=
 =?iso-8859-1?Q?orUmTTJWWfDvxOPEFjXPCaXuKDUNwMjqKjYnFMYCUCZ37WyxX9mswXQIoM?=
 =?iso-8859-1?Q?H3trTRJH1k1UdHJ6khtQfKxcvJ9HpyR0PEepFz2EO4ssY5+VXf6HVx8eOK?=
 =?iso-8859-1?Q?zi1Nrn3fRFf+ZZQlst3HYdyFbTtubfECCv8TUBKSKMfsK5yVKaAMyR7BnL?=
 =?iso-8859-1?Q?9kDNEsdosGAlixuRY1200jr2RiP0f/bHUk5hAenY/M/9JBYS/fhQqC/mhE?=
 =?iso-8859-1?Q?ttyRCYhlnClKVUTTLgvrtdCVUdetqUcZzaXuJiuRDjWtjFIgBOIDTsWtcW?=
 =?iso-8859-1?Q?SCWdc3QVuoc7m45Uak3WQet7WTqpdUZVy/xXj4hLKEE6tVl54BkhaUOoEx?=
 =?iso-8859-1?Q?ohHbBbO2jr1fHfQKv3TJ/nfSiFkf+KJItFmrQQiqyEu9/kl+WEHCj60V0o?=
 =?iso-8859-1?Q?FmNdfBQEPe7jZNKAYOM6ZfGsnIqTyX/oFJfHAlsEGGO/WKfQY2EK9H9MAF?=
 =?iso-8859-1?Q?IlkEL/dxEN9ej1e+T81yDq5JmWQ8JhF2H2rD/ErSJM2E4sTdQFmYfjQocO?=
 =?iso-8859-1?Q?5OIr7rT2ZXrRuW9VCTnVMa6l9UJghb17YOuoQ7q/6MZvvet8L1I2PIu5tY?=
 =?iso-8859-1?Q?M6uJ+gUhKMEV4a6wCgSkx2RxjeI4Bg5roEp8sAgmBbU0maZJkLXCVwU1af?=
 =?iso-8859-1?Q?EUUDFgBxWD/POpDo8VS/lSC4jbR8e/TeoZHAqs1hXOlAAf2mjrj2daVolw?=
 =?iso-8859-1?Q?4tMvXj4BUuCISVYNv+rf00TheLaKPql8zK9ZIzsyGF2qD4xZ8SjIv1O+Iw?=
 =?iso-8859-1?Q?pRoFsfVYdFh7HfwFC8pOwUK6KMdT7WPafzDDavtrCk9SKb3k+/rnzYAh2c?=
 =?iso-8859-1?Q?lEM6FO4kaFei24BH9QmddHQ7+d4RYH3L1xwwIPb5UN/PJsz29GuTIcWllC?=
 =?iso-8859-1?Q?+SxV1Z3IXeBGTLJh/Id7+/Xu4XFqfymuocJTYHjPBk3UyLQI/cn3AZgV1I?=
 =?iso-8859-1?Q?JQpUl5vzAA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	kSfzNSY8ywyrzz4FZdBx3vQWXmLFTd3BL+YlNCEDY+tGYl0FQ0lyjJ96HIEUW+N9+/6oQqqrw1mlyN7EFwQVHygt5xfOsDsHW3/fw/+iIWBfqjyR8khH0oU+VuWBW8LjkukHgHws19MoWR4bo+jii+X+qtLKEb/KdBDixvNWjQoBJ+VaEowPxKph4I9mv73wv1SgUzVWS0yzr3Kg2v78855cnGmd2x4nhTyvAuvfZAOwZiLRGlDQqEGGDhIoJFCAnh4CzT98rESa+BqUvXVyp5O4272h6pm4LwpqTceuNCZ8/QeBQuJ6je6pck8naS8Q17l2JeVhLbsvFA3ZXNsIZw==
X-OriginatorOrg: kyndryl.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR14MB7824.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be9628b-00a4-456d-00eb-08defc533cf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2026 11:32:36.7544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f260df36-bc43-424c-8f44-c85226657b01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2pHawuDBI2gwo79zObeq46WX59WYadnMcTFthHvZQN4gNjj8kao592v5+iKRAuus5c7FFKN8LqxNnXCD49G2BYP4aXqldjvMi+jVcIa/PdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR14MB6305
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Y+zIdBeN c=1 sm=1 tr=0 ts=6a82f157 cx=c_pps
 a=5W5/h04s0UwUCg87NMYX9Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=NsrarWwjvHujZezKbFe2:22
 a=IU-kE0szKVgBnUKoA86L:22 a=NEAV23lmAAAA:8 a=e5mUnYsNAAAA:8 a=yci-mEHRAAAA:8
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=GrUPzVheUnyHRE-Wfp8A:9 a=wPNLvfGTeEIA:10
 a=Vxmtnl_E_bksehYqCbjh:22 a=Lf0emuXcu_2dAdiKoQLV:22
X-Proofpoint-GUID: lpuZVC2FHzgFIHOtAJ9hcVjJiH-1KHyi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA4NiBTYWx0ZWRfX8ZeszOJySMP5
 VahGFUP5N4Y4aFc2apwgJa1B2/ZNpsSl0c+fEYAIzo/p5Nbx2AbqiymYvliHigKZ/nMy+vmlyVC
 ujuzA8wZITPEjCivyFCvniKpr5vBFaStgHnubawOS1LNm0tkbIKM1wKFbhqp/bTYutc+kiJ2A7v
 DXu/TUS6DfKMzV3VD70tH7ZQdTYiKKCClXwut8v0N028hXUhCt0JcZ46UrNjxFV3Vm09rJoyVfQ
 svIFJcAokPuze4Lbb6zBRUnGIG4GMPMaAWzYkWF0uptDA8yO/GOfc0i6Lk/qPuTFXo4CkawiCOd
 XJyR8VpAGq7r+SqK6ZX3FVQt3E+/HnLsj+o92ygMjaP0yeFgmGNmBfietB4T95LmgyuXjp0p8un
 ENqgKoBCbtrvxrSOgZS+wpNIBB4KdLqGCH5zDtVnv8jEu7E+3MAXKFHaCVytIKGf+/SD4Iz5yYO
 rcE4BGolw/QXgNhRfmw==
X-Proofpoint-ORIG-GUID: dYmb1cbhhucFWpmrT6pvrd_jY9kMNHh1
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA4NiBTYWx0ZWRfX6UeuKvx3x0CE
 lodNcPcnmBPvK9AXFM74lSFOT1pGvD3RTZvPJ4uuSp5NjGh7W41ISHm9su2xrbGh4csH+qUIMjh
 M5SNyIPm5izGN+yqBnDcrjbNL/OsO2w=
Subject: RE: [systemd-devel] Purpose of init.scope
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170086

For anyone interested:=0A=
=0A=
https://github.com/systemd/systemd/pull/1116=0A=
=0A=
"This moves PID 1 into a new "init.scope" implicit scope unit in the root=
=0A=
=0A=
slice. This is necessary since on the unified hierarchy cgroups may=0A=
=0A=
either contain subgroups or processes but not both. PID 1 hence has to=0A=
=0A=
move out of the root cgroup (strictly speaking the root cgroup is the=0A=
=0A=
only one where processes and subgroups are still allowed, but in order=0A=
=0A=
to support containers nicey, we move PID 1 into the new scope in all=0A=
=0A=
cases.) This new unit is also used on legacy hierarchy setups. It's=0A=
=0A=
actually pretty useful on all systems, as it can then be used to filter=0A=
=0A=
journal messages coming from PID 1, and so on."=0A=
=0A=
=0A=
________________________________________=0A=
From: systemd-devel <systemd-devel-bounces@lists.freedesktop.org> on behalf=
 of Lennart Poettering <lennart@poettering.net>=0A=
Sent: Sunday, August 16, 2026 11:02 AM=0A=
To: Demi Marie Obenour <demiobenour@gmail.com>=0A=
Cc: systemd development <systemd-devel@lists.freedesktop.org>; Linux cgroup=
s development <cgroups@vger.kernel.org>; Alyssa Ross <hi@alyssa.is>=0A=
Subject: [EXTERNAL] Re: [systemd-devel] Purpose of init.scope=0A=
=A0=0A=
On Mi, 29.07.26 16:13, Demi Marie Obenour (demiobenour@gmail.com) wrote:=0A=
=0A=
> What is the purpose of having PID 1 in init.scope?=A0 Is it functionally=
=0A=
> necessary, or is it solely for consistency with when systemd is=0A=
> running in a container or as a user service manager?=0A=
=0A=
PID 1 needs to live somehwere, so that's where we put it. Where else=0A=
would you put it?=0A=
=0A=
Lennart=0A=
=0A=
--=0A=
Lennart Poettering, Berlin=
