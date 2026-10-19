Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792434134;
	b=xsTkdvngT1fXMbXBFiJVU1mnD0w9e/9M/XEZOUCS4b0mZAqb2wemAK9fEe/qI7ffy03X
	 UvO9pAH6ihrhg4Fnd2ufchUM/jt46r0yPuIbPbCVCqnSdwaoJsRNbUdnZyF2jP1SGWll5
	 kxDTBFFOgHsSaKMkUW98HxC7QavalFoSs5RRFJx9tYW7bgwKSpYdJO0dwngPBgOa15dbq
	 Tp8/g6aZOPNEA39w67e6zHdmvM7708VJMKqBfqK4GTPZFcMOizLPGx1jt9p84/j+05nen
	 bbtgbUucicNKpdgJor5Ycl+HFBS+fH8P3pREJ/m8NtBMDd0kzbvsFYE0rTY+cQfkALg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434134;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:Subject:Thread-Topic:Thread-Index:
	 Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ld-processed:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=ulUzyu5xj1zXU07XDwoZWbJk8OQoH9zaQ64GXBcB9w0=;
	b=HtGmc4ASfavEajX/fSWElbbIt+sxk/sUE5CtFSjcA437VecBM/xu9ild+x2JpiXdG4K0
	 qcWjBd9C3iPOjNc/Iwf5GDjug7QNjD8pS+J5civRcsgSEZDmo2wsHC2wlpjZ/KQGz6wfQ
	 mkOhhmjvq0Q4B+CRxTRDLFZ0R0n16/wNUFX9LJVeIXA4PPnOo1iJueGAesL/7oyF0XCtE
	 QYnR3/cTxI89OMW++pwkA0wsdnLVajMVqV2bpxMBb9JF2lr98ZFMUA1yQxxzQsuhv9RfO
	 KTe6zRGn0Qgi3f783hR7Wxmmbq+5kVYl3Xg2AGZip6Ckg7X65SfZiA+zoprGLinIEmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=J595iUQt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E93606A31C;
	Mon, 19 Oct 2026 18:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72E93606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=J595iUQt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792434132; x=1823970132;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ulUzyu5xj1zXU07XDwoZWbJk8OQoH9zaQ64GXBcB9w0=;
  b=J595iUQt5rsP0gH+5ga1OubNkuMRyCgq7IYdlJLrFSarl/Vr5bN76lt/
   SHty4autWVF07gCMh9xlOR+l89aSeB1NlX/Q6KBdLB/7REX20g0skIcNb
   rfQ36NSBFKLobKu23AYBw9f0UA+pRu2aX9KMx09nLpgZQqvhRq9VRFvJ3
   GRJI57qge4+rVvy9GD2/udGtAyIKXRFzoggq10RL94MhvtmNOj8EvjgRS
   GRfk3vR61YVhJ95CI/kQo94o9mE8qowjK/fg0cYYGMvly/RLy0yvmRVgC
   hSqprLbdqqPxb1Jre3GujTiNmKpEUf4nNY/lxdiMhjHPg+1nozl9LJ3wF
   A==;
X-CSE-ConnectionGUID: hXOQbCOvQjKrD4y4fVWP5w==
X-CSE-MsgGUID: FLxQ5TvHRAGpTp3BTnAUNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1026609"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1026609"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 11:22:11 -0700
X-CSE-ConnectionGUID: /IjvaEKbQvOutOsFQILInw==
X-CSE-MsgGUID: BxG9IwJnTHuQdZzpHOd+jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2585713"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 11:22:10 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:22:10 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 11:22:09 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.67) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:22:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZWPgOmevmox9EWvbCnrBdsLWp0FpeAeMZInPTu7lucexVbPSaIv8s5xvfHQ+neZoB9pCQrwt5jfJjQj/ET7+OCdGlfLPKEz1OkWu0dmhi215dzrCno60E/k1cdJGd2OdT0S/Dw1Jw10rmcQmwXdkIz0aAwWMM6cEX8xylnWidmpoh2/Ww1EA/4wkvLZHJAlChjSGqGcvCwXEldutngWOTBAWkEYXXUM2zTmW9abQzdFwZLOgzmfqRA7dxj6wnZbXimrOYymG8WElGdTyGETE+G4OlOsila5rnNqMDtR/EcT131kX1XUhKBU77K+HS7tsIMAjaoWs1FizPoMmY4RpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulUzyu5xj1zXU07XDwoZWbJk8OQoH9zaQ64GXBcB9w0=;
 b=vBnQib6yVcCkuCbkbYXJBEUZzcYFtb/RA2s7ssDb7f3N7D+Ez/xLDqEzy3MoPpnE/l0TCbHBXgaoF4WCCML4nr4tOXh0LPk/sPeD6ZIqxyu1oYicOxImm3coGIFthwutB/BTzs3mh4wWvBTCuwDikfObpR7GUlAgWppEPvttZ+Eft47T+SwBIr6Qt0GHdNLXI2xe+TAJ0yoO9XFd9csPo71acDKHBj0Fhk3C88C2HAdKFchizgn9fSc8lbROpttlvUNH3QCfUXUExLUKtQCmpYYBtYb+KipAIs/fbbgAlzdr6PeOh3LEPh7PZDz29fVnx++4efymRK8cgEEFuugvOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB7115.namprd11.prod.outlook.com (2603:10b6:806:29a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.18; Mon, 19 Oct
 2026 18:22:07 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 18:22:07 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, "kees@kernel.org"
	<kees@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"juri.lelli@redhat.com" <juri.lelli@redhat.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"vschneid@redhat.com" <vschneid@redhat.com>, "kprateek.nayak@amd.com"
	<kprateek.nayak@amd.com>, "vincent.guittot@linaro.org"
	<vincent.guittot@linaro.org>, "bp@alien8.de" <bp@alien8.de>,
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "david@kernel.org" <david@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"seanjc@google.com" <seanjc@google.com>, "ljs@kernel.org" <ljs@kernel.org>,
	"zhangguopeng@kylinos.cn" <zhangguopeng@kylinos.cn>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "surenb@google.com" <surenb@google.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>, "tim.c.chen@linux.intel.com"
	<tim.c.chen@linux.intel.com>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>, "pratyush@kernel.org" <pratyush@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "gmonaco@redhat.com"
	<gmonaco@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "mgorman@suse.de"
	<mgorman@suse.de>, "Graf, Alexander" <graf@amazon.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"liam@infradead.org" <liam@infradead.org>, "ridong.chen@linux.dev"
	<ridong.chen@linux.dev>, "blum@kernel.org" <blum@kernel.org>,
	"longman@redhat.com" <longman@redhat.com>, "bsegall@google.com"
	<bsegall@google.com>
Subject: RE: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large
 systems
Thread-Topic: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large
 systems
Thread-Index: AQHdX2dIvJ5EZSvEr0+jfa7rd1zKWLcFLFbQ
Date: Mon, 19 Oct 2026 18:22:07 +0000
Message-ID: <SJ1PR11MB608365E406C4DA7CB91858A4FC982@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SN7PR11MB7115:EE_
x-ms-office365-filtering-correlation-id: 10c429b9-fd4d-4372-afd4-08df2e0de204
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|38070700021|921020|11063799006|56012099006|261009223027099003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: lzLbd4unzW+qIHYeufMybapC63MDt2uLH9mqS7BpTtPg8mVCRd7qJ3n80zBXUFixjZ1YvQNO6SMVJ22Sbhw91xQWTpPe5kyZkk8phFWOjtnQ/mgegUglaGmrbeCJc4qLXDLhX5UpKxegWWZQr691ASxMkSnSoolNRKu7FN4IMx5h2HzX6Zi/N4Zw1eRb1HXglPsflnOWvTSO1JsoTaVKNZs+sNWuBfMWW51Ja58NxH8lEM7VK4WzNRuO9u/fxSEp2okwln/rlnMgP+HB9y6O66tm6o1B9R80Y/cOw+FSMT3zlIBK+aNZCmIkQj1ytlwhFpgnbxfvQlHXzpQUn8diHvYnogWQuilN2VTtFci1J6Niym2SLBGDUXVhulNUwIfslL2MOwVnQOdlCFl543ra8e/CrO2igdYAMXUV4eVmbYuJLRC0u564i4w0S7zD1iqI50Ey2BCiA4wAEnUWhITt8PUUdMBozXDUWQA5JZUvH8LcrMJNnpSSZ/bBWlgLqCa37ZryEnzOPWwniVqyIwoKkw1+DLUY93tszCeWL1tx7DSucUB1fuJxPKnCAwda/wXMtcknmuiZP8gNwm2LARlxWFCNvRxGZxYDA7Nkob/3vgilvYH22J5I4cKLq14+CIv4iPLnyTYfKTCBuBGj7FATAiqCOdMox1N5mCOhQur0K9T+ZzfjESglOeIlcy3Ddmy5iKfL4GtueaVJGfdqMZ4kLyrZHqGBWHsXt8MU0ofySw/8x7zxib0eifhUCKAjHd/d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(38070700021)(921020)(11063799006)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TUdETmxjRmhGWmRrTEI1U2pvY1ROcy9LMkNiZDFJYlIrM2s2MmR0WXhvcnU2?=
 =?utf-8?B?TDdzeXRZbnBmdzc3aExJSUNLU2xKUTdOOE9Hbm1RYmViVmZUYU1wVnZBQXlv?=
 =?utf-8?B?bERYOTZxSmJhVjdzNDRaVFRxUXBOUW5QVUswSFhleTNrblc0RkFiWWxUMGl0?=
 =?utf-8?B?NUVta0ljcEE3d1dpcGE3ZFlRWVJXMEtOeEVySEtzRmUra0h5VnhVcmR6NlFk?=
 =?utf-8?B?eE16L0hBQmc2RlRKZHI5TjR4d0ZYYkFTdFpNa2k2NURlYXpYandNZU1LQTBi?=
 =?utf-8?B?YXgzVDlIRk84aC9RU0ptYThXRi9KSEZvMWI2ZzUrQTh6QUFyanJoc2NVOGJC?=
 =?utf-8?B?MFcxOWtIUTgxZ1BDNkNCaVhFQ3lrcmRBYncvTlZFV1htKytvTXlvaTdPSWZo?=
 =?utf-8?B?Vmh0OE5OUmlnWEZacnV4OXdVRUJlZFN4ajNGcU9MbVdycWNXRzNrUnltVXdi?=
 =?utf-8?B?enNGeDFuUWl2SkNPdFpuVVpaUStBeFIrSHFnY0lyNVpKQjlvNkJDZDlEQXlU?=
 =?utf-8?B?Tlo4Rko3eFBtckZjajk5UHE2bHEvRUNPY2Faa29WWG5qSm5VTWYwOXRJcUVQ?=
 =?utf-8?B?ZjBnWGpwaFNYb0VYL3ZzeENDWmVxSTRvUjNlUVBpK0JYQ08yNW9LYm4vM01P?=
 =?utf-8?B?eVJDRVdQa0JmT1ZXNnVsRHphbWlPVmV2V01mNjZRbk1ITFFGWiszYmNNU01o?=
 =?utf-8?B?VTFKOHNJaWZIWUZNRkZ0YkFCR2hRcG1QNStjb1NXbEVLM0ticE5sck9sQldq?=
 =?utf-8?B?TkJQRy9iM0NYOC9sbU5ybktpTjduZ1RiZGwyVG1WeFBUdFg3Qy92NVVyVWpu?=
 =?utf-8?B?L2t5TlBBTXh5NFlxcUpmdGkrdlJGcStMR243VnBCU2JISzFzbkkxKzd5ek1L?=
 =?utf-8?B?WXNSbmFmVnUva0YvY0NLNE9yRWt3bTJDL3g2aVFrUU9pRlRCMUZTdEVqZlZS?=
 =?utf-8?B?NjNDbnYzRHBzMUFWVWxmWlpJbDlnanZTQUNQY1l4UFRDQWRPdlJ4SUtRaXNx?=
 =?utf-8?B?TWF1MmxGZ0x4U0pVdVJSTlliNFY0OHRYVnJvcW9NU3Z5cnlDNW5oMms0SnR1?=
 =?utf-8?B?ZUtaa1QrZXZpN0F1cmFFb0ZsbXFCOTh3Q0pPbTRtUVJFeWhzczVxTmxKTVUx?=
 =?utf-8?B?alcyd1BPMko5QkpFZXVVWGRiR2lpZzRUMWhZZC93QXFBdmcwYTFnbVpRckho?=
 =?utf-8?B?MjFDMk5DTUN3bUgzYWVkQUdoWGNwUWU1SG1qUUNTUW5vRU1OQnBKTmxrSS9l?=
 =?utf-8?B?SEFYdVlYa2IrUG9YRmFPalowK2IrZzJjbXdWNGRveVE1R3R1STczYXhPbW82?=
 =?utf-8?B?V3NDeUtQdGIvcXpZbkJNcjlrSllOY255V1M3YThsREgray8rVHJpVW51WHp5?=
 =?utf-8?B?MUxuaHJodmxZSkF6Q0xTc3V5L2EvR09UTk85UVU2SDVoU3Z6bkJDZ0hsQUEw?=
 =?utf-8?B?blM1MURoTUtJRWhJOGhQajFOTnFSZkhMM2NBY0wwaUp2Rk9aTlc3N0lXMUsv?=
 =?utf-8?B?cE53cWRMVE9Td1JFM1draVVld3JRWTQvWXhDQWtmc0VHdFBsd05ZemxyV3kr?=
 =?utf-8?B?bVNrTTVaUUJHelFhK2loTzZlVCtmckVOU3I3bHUrUTJwZHJXd0hSNHVlemcz?=
 =?utf-8?B?aXFVQWZEUy8rVzFYVmVOcXBGbTR2RE41NXBMaGNRaXEvOGIvU0MxcHloY1dD?=
 =?utf-8?B?d0JtaWlWMDhGTlJwWVd2M0p0UStjQm5GQkZPVGlhYVFWVXVuMXFlc29LWEo1?=
 =?utf-8?B?Tk5FK2huMkJSTEV2dGVxM0dkYjhFbWljK3hOUlJ2bE1abWg0MDJXQ0lOZ0lt?=
 =?utf-8?B?STFGdHRkaE9odHBUMTZQbUZpandSNjNHVFlxWCsxWDVRcGl6dCtYZUd6NElq?=
 =?utf-8?B?RDAwSmRpUFdhRXd5SzBscUl5dTVvcEJKT3JRSTZmcitVZXJtMWRpNFNndWFq?=
 =?utf-8?B?ZGRLTjkxajZib01hd3lVSW1BdVJERlpuMjlpY3A4bDhvd3F5YWdqWEpGaGtN?=
 =?utf-8?B?bnAxNWlmYTdQbGZ2Ui9BaDg4QlN5OUpreld2WWtsRXo3SnZIZnR6Y0Q2Qkhy?=
 =?utf-8?B?UGdzdzhHbG1UMGI4akNuL3hHeGpONlZPUkQ1WHU3QnI4akcvOC9iWVBmQkVn?=
 =?utf-8?B?WUpFR2lvVnRhZ1JaSmRLSWx1VFVOVGZoUEZOQ0w4WDFRL0xlb1FneUczNGw0?=
 =?utf-8?B?cmVBWXZNWjVGV3B4U1lPN01oY1NIeFBvREFxb0Nzb3AraG4rYnBhb0xFSjZ1?=
 =?utf-8?B?QUlweHdjZnhWUWF4bDR1Y0dqcmpGc2Q4dnBIblM2TlBRektSSUZtTld1R3JB?=
 =?utf-8?Q?T3oXlKvXIaKmhVatdj?=
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
X-Exchange-RoutingPolicyChecked: eI2THX9Ae1FEODJdc+BvfuRR1TiZvAdHSv4U4IXmw7LsoCRPVTj6m+xjb7JfsLUqVrJ+UFZ2IqPtT0kkO9s7a8dYSNIHIiB4i1IhBqQf8XUF6VuxZrpFV7uhHBJ2jlLNuhc5ZruQCyvw/52GsfEuZ9ctpUHmV/3urZSn9Nw3FpHG0KQHbEcqPEIDFzIuwId19msQT4MTk6w9ahJrfvVyouZztLLsySj8Ze4kMX/wMpUBHGZVhaFUR5Vlx9JV6Ag3cz+CTQiB2EQ9dcraTlNY9l8PKDI4KZ6qX8JmewKjgpt6ffEPQgtIdOB76Bbd47JzcAZDjougeP2UnuYHjIEgIA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c429b9-fd4d-4372-afd4-08df2e0de204
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 18:22:07.0869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6GbbATxYLx+ykgN49sGENngF0knOEB+uHCCSBVO4iftDyNj20Uhq0qx6snoj8sSz6JT1X8bIbboKJgb+R79ffg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7115
X-OriginatorOrg: intel.com

PiBCZW5jaG1hcmsgd29ya2xvYWQgKG1lYW4gb2YgMTAgcnVucyBwZXIgc3RlcCk6DQo+DQo+ICAj
IGVjaG8gMSA+IC9zeXMva2VybmVsL3JjdV9leHBlZGl0ZWQNCj4gICMgZm9yIGkgaW4gezEuLk59
OyBkbyBlY2hvIDAgPiAvc3lzL2RldmljZXMvc3lzdGVtL2NwdS9jcHUkaS9vbmxpbmU7IGRvbmUN
Cg0KU2lkZSBxdWVzdGlvbi4gSGF2ZSB5b3UgaGFkIGlzc3VlcyB3aXRoIHRoaXMgc3RlcCBmYWls
aW5nIG9uIGxhcmdlIHN5c3RlbXMgd2l0aCAic21hcnQiIEkvTw0KZGV2aWNlcyB0aGF0IHN1cHBv
cnQgbWFueSBpbnRlcnJ1cHQgdmVjdG9ycz8NCg0KU29tZSB2YWxpZGF0aW9uIGZvbGtzIGluc2lk
ZSBJbnRlbCBoYWQgc29tZSB0ZXN0cyB0aGF0IGxvb3BlZCB0YWtpbmcgYWxsIENQVXMgb2ZmbGlu
ZSBhbmQNCmJyaW5naW5nIHRoZW0gYmFjay4gVGhleSBjb21wbGFpbmVkIHN0YXJ0aW5nIGFyb3Vu
ZCBTYXBwaGlyZSBSYXBpZHMgdGhpcyB0aGVpciB0ZXN0DQp3b3VsZCBnZXQgZG93biB0byBqdXN0
IENQVSAwIGFuZCBDUFUgMSBhbmQgZmFpbCB0byB0YWtlIENQVSAxIG9mZmxpbmUgYmVjYXVzZSB0
aGVyZQ0Kd2VyZSB0b28gbWFueSBpbnRlcnJ1cHRzIHRvIGZpdCBpbnRvIGp1c3QgYSBzaW5nbGUg
Q1BVcyBhdmFpbGFibGUgdmVjdG9ycy4NCg0KSXQgd2FzIGEgd2hpbGUgYWdvLCBzbyBtYXliZSBz
b21ldGhpbmcgY2hhbmdlZCBpbiBpbnRlcnJ1cHQgY29kZSB0byBoYW5kbGUgdGhpcy4NCg0KLVRv
bnkNCiAgDQoNCg0K
