Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.72
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795443543;
	b=wobuxwrN95w1hpwevrjj6TOJB+fjSx3lbiLSP/WeE0uLDKglqWJTDurc9W7oqKmvCrtI
	 OVu2170lveMqkrdIzJlBxnVK5SO3X1D4c0ZFJufRF8OsjuedRytwig5HHWVCS3NGe5zSl
	 3SYrK+eCAZbpmSwp2vJ+MGsiP/Kxn/2HZuDlQcO9ybvPV2bLbPVcJi+mdnszqy5pDr3iG
	 KsQdSAA2RCBMi5RW07gYpXmRsB281L2uDeTkrtDxQT3QxkQsmVp3xtpZLsJxPQMBnBdNW
	 xOlMDb1eDo0NKLZnOQ+EzFZ8RXtO1kZ45zNS+i1ruKkoFlDTYPD/KyLdybJHzGTR2gw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443543;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:X-Mailer:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=q34xX59zX1LaQiAeWW/cxKkFi9xJPHaqUREKMIKSeh0=;
	b=NhYIM1aKrYxZCIvLhvJDBomNuqD8B0nqyIX6xX7RIhijzPwCZQuizrlq7egBdT76kxRG
	 cfcIoXv7v3cydoi8WTbaNcQ5r59c0m7Kyc3Fq1nSklZznZR+SPjH1js55Vm1Q6iOPtMTD
	 rSDS07CG10c1FyU1rRhyR5EPiQBOrRwe5CFEHRy7/GiIGr6jkg1dMCaZYA2DJ2s4K7rWT
	 lj4pJnEiOHSkD6Sv7Nh6QNZM5y921Qx0veRykRd/xB6U2xJoEYbzxCUYqLQN7bRHQ/6IH
	 o9zYnz2DvVOSFQx3rgOw+sNmrmQbidLOvTphrt+W+VvYUWjJIINsigNmb4+lmN3EgQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=0AJbl+fq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.72
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021072.outbound.protection.outlook.com [40.107.130.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D750606A689;
	Mon, 23 Nov 2026 14:19:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D750606A689
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=0AJbl+fq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ItnoK8AHhwC4/JRr/N5wdra/wfojF1WVGocF2JgVubQOv1NAV6c7umRz1VBTwWTBfCnSu1TteSi9uphGptEsz9bKGS5AhZCGJH8gtBf6K9mdk4SUi9fy3AiTHPDtSFelF2uL7k9b6SWSPjTodPx7PcoSB5f08tq/UxfriRyBiSVi2hoULUVXwJY762lX1GhuB0NmdfPsXkjqWXufBTqORD4vsGPbACw3ZlJE/dUND2nalrN8/7TS7ExuZXcmQTl5HaSXs1RHK7J/Xf/TPBZ/SSy4Vb9Gv+2lXVD5pzKAjTjLzEze9pXYDp3MerhGIFCtfBcmpajYTUV6mb/Secja8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q34xX59zX1LaQiAeWW/cxKkFi9xJPHaqUREKMIKSeh0=;
 b=m6cdc02wk6jL0dAU0GxcB+aSq6ldbp0o5Nh/spFVfR8ttsbuw/gRxojA5Qa7HkdCtzm1P+HjEVPMxFr0iiSophd0FwJ41dQIVNDki+TwIks3rxByCMKCKaneMvDZJxmnZmZXKAhupSj94DMSvz6tRy/6ZqGAe3Tl0tR3YLVaz2n4fWCScFBZ/9IrCA8Ch8wJqjYfCxReL9t2/Xp5lSpeoKEzlzeZ3aUt0elkGa056L1XJk73wuZgNBQm9VpvGwM/cQEP71VBmOTFq1ekqr7ldMvOcNWcQDHSGMijZPTPMZWlqnG5L48bzx5oLVZgfFWolfbGD8w0QOdtHUHSWYNqHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q34xX59zX1LaQiAeWW/cxKkFi9xJPHaqUREKMIKSeh0=;
 b=0AJbl+fqVdaisrt/lQBhYGE4Kgb4UotASFvcGqKm8r0P6gFigpPp3THzv7vmYZm2+f2fuVVoUIZNda27OtY8g1NnwYzb6omSpUtPkgSkNl4jOT9q4o8xsbuZ+zAz3bm3K0JCgOCn0hqIQHXUYngc4HcO+XPDD0pTmZpaB616Sa8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from DU0PR03MB8960.eurprd03.prod.outlook.com (2603:10a6:10:477::11)
 by AS2PR03MB9073.eurprd03.prod.outlook.com (2603:10a6:20b:5f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 14:18:51 +0000
Received: from DU0PR03MB8960.eurprd03.prod.outlook.com
 ([fe80::ffcf:20ef:45eb:6668]) by DU0PR03MB8960.eurprd03.prod.outlook.com
 ([fe80::ffcf:20ef:45eb:6668%5]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 14:18:51 +0000
Date: Mon, 23 Nov 2026 15:18:46 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
 bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
 hannes@cmpxchg.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org,
 rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261123151846.3fdcbf4e@linux.fritz.box>
In-Reply-To: <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
References: <212c244d534ee1fdb0538a980789e16c@kernel.org>
	<20261111175657.250354-1-yurand2000@gmail.com>
	<58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
	<20261119151416.33f90a64@linux.fritz.box>
	<471bf8d446becabfca00041fb2a78067@kernel.org>
	<20261120120659.2e902463@linux.fritz.box>
	<6fef47e08a37079c08806b3c57994778@kernel.org>
	<20261120212418.10221f2e@linux.fritz.box>
	<06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
	<20261123084345.4e24e3ca@luca64>
	<awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI3PEPF00008C05.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::467) To DU0PR03MB8960.eurprd03.prod.outlook.com
 (2603:10a6:10:477::11)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR03MB8960:EE_|AS2PR03MB9073:EE_
X-MS-Office365-Filtering-Correlation-Id: d3665c22-74dd-4816-2b7a-08df496cb25f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|1800799024|7416014|786006|376014|366016|261026121527099003|261026140227099003|261022075727099003|261022105027099003|261028144727099003|261021121427099003|261102123227099003|11063799006|5023799004|4143699003|56012099006|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	io5U3xHAqisc/JRmtboqpJZY6lR+cx8OLNdWntQpynF6I3FR+CDIlvUWR21G4srrbhkaMSmmppUrNFqzzoccb5pnoKG7+KnNCBRPe/bG4f0cQW6KZnihFbAPtW01zChe+zkN8/Xdy83wBDxltxvnEaWcMo18/nZgduMbfboJohkc2DJnqQTAQu/X4pP4sbVuQjzdfoIkZP+LFW05RvcoFpp8xaQvvrm5IUTxdPgucaOCnffJZbXFLX+RcjuHEjd6tWYBckmKWPt9mAve83gI6YHQ5/QTIM1jSD2Q/QCe2UAA33pIpBgoxKxjQXXUfG4LAw/VzPY9U1p+dVnm5Ruyjz4FonjKxNO3xn9rwouSD9gpY5+IrCxZeSX2th8oIfksS+MRkcUJ4lpcngET66XjX0FC/A+2kwzN0abtlu3OjdYOP0Z5CR2rQ5EKt195HwLlW84xy5mojHjRU06WPlFyDn+X5tC7D4WyxSaYSk8QmnywwQ1B4EzZLzIuJvWEI1n8iZG3AVmNMuf+wXKPCKcrRC0waqgw/Eeeg01oAOVc2gE+swYLKffUXwd0Wvf1reMiONsVcmpJAI1H5Y46IDMGFlxow0d2fY0zntXufdtT1xhnPdS9G9sy0a3ZNj/Tj+V6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR03MB8960.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(1800799024)(7416014)(786006)(376014)(366016)(261026121527099003)(261026140227099003)(261022075727099003)(261022105027099003)(261028144727099003)(261021121427099003)(261102123227099003)(11063799006)(5023799004)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SeAaKM8wytAp9pDrR3JQExofTJL4Q+cRzL4ln/xeuw7rtZBdpP44b3U8B1vj?=
 =?us-ascii?Q?GClzbYN1ka6vndKCB2vHzdFk7ILyLn6fd2aNcipt55G5xEl1BLXdj5XV7HQ7?=
 =?us-ascii?Q?lK+diEC7um43uUGN+sGMow5b4lQedIm/zWtwBzSjSTNUdt8tKNoumFGT2DXn?=
 =?us-ascii?Q?BF8GHU6saH8rH5CS+1Wvjq2HKvYIgcLUDqCFuiEYiOqN/VDAc2IkIw0XXQMS?=
 =?us-ascii?Q?aHkEVxR6ooJ26I6dZpiLMZS/feLS9nSW1kcIB9oWrl7i7ZgCswYsSeTgaeNJ?=
 =?us-ascii?Q?QBrLlfiYi1y4K8ZBGaG60a3V0nrUdlfvK6SnMpz3Raoor6OY4ZZKojGhvbhl?=
 =?us-ascii?Q?Xa6QaoxYSdGRCj8OlvSBU7KYfWDypMnfVFsdWcd6/qQKp7hBOnba+9IuGyxc?=
 =?us-ascii?Q?osKChJ4wXkn/iprJfepjqdziNf/FlGm0ReFjjTwI6Gqhjt5YSRSmPM6moWes?=
 =?us-ascii?Q?L0wUskpw42xSLN1t+WmL3qrQc6iYzbrohPwWFUwwHcOoo+4a0rSY5ZUs0E07?=
 =?us-ascii?Q?8fy8atkjx5dHwALjItUhHfbgM1WqLimjja//8pfoAqa+8HWuzBIgInpuKeDk?=
 =?us-ascii?Q?3aopAAmWWIm45Fb56/ngGpAIaRIffpab3MElWZLsuT9mWtbnjvnGDbz+mNUD?=
 =?us-ascii?Q?dcC5bzTCUj01cx9GIKPWVcFGslGNRiL0fbVkzothepKpYU9wd4o/FSm2QIE+?=
 =?us-ascii?Q?Gk93mORqxWGu8LsvqHvI54un1uAvorOiV1MO3yJxogyCbUaiHYZlnSc3N/Py?=
 =?us-ascii?Q?1QBLX83h8ZUu3sE6iTZvo+V+aeUEolbA9O8jtuLXG6IGXbTiPUgYHGLpWX+U?=
 =?us-ascii?Q?EuydAyv4wMdXNetaA9rhT2CKjufqXrraDoAgj/AtAVTgGGaltL8Xw8iVTTKJ?=
 =?us-ascii?Q?fOPhWohqPz/sHQdJTTXzJOl/OCZMLwLqL6zYhT1W4eBYCPHt3ZDcL2zCoT4O?=
 =?us-ascii?Q?PEJbeBHKCgk23gPxsnXBWSkEleKjJ+44TZN7YQRC8PN0p9ZA9WEJOY5ruQKg?=
 =?us-ascii?Q?6nTIPHYIYEnx26p1mDIaHdBvH3uJ22tuXDwi8i6qGLF5fOnqGcETeO+as2qe?=
 =?us-ascii?Q?/+m3CfkxN/8oTLs4lbBA2nC2gmxJzweAYRppVAnfhi2T3SltDmLkPA4hLmGA?=
 =?us-ascii?Q?guGKRJ16Yh/AdmeGkFYXdHBVaM2N6NBfqp0xeWKlMq4Ax6dobfhvdH337BWO?=
 =?us-ascii?Q?ARk/3MR0bXuBD+S48UPipJVAOvDoFpOsXNkfxKG8JZVv7EGXN1xJP8FbRhsv?=
 =?us-ascii?Q?vmMXqaKvgCLCdvqaWK2oDxBUsustbB8EAqvR7+DXFQK8FBqj95UXi3k9DZve?=
 =?us-ascii?Q?nsnKhgQbhNxT+MFX8PUJpx1/os10uUHfq4yiM0qwpgdC4LljKUbXMqyDM2X5?=
 =?us-ascii?Q?aOK488aJem3chKNc4zr3lIAfQTdwA++CqUt4mabjred1M+68GWOvCM2JCove?=
 =?us-ascii?Q?Y62XKiy4JbIvEdC5b0vQc/bbTVr8zxoR/8EpiBoCNHFzMuGAvU9tYUtMoeeY?=
 =?us-ascii?Q?LCISfdjMXw4ALxQgU3v61OnEfGe5OlD0GCyugXKwv4aSeEvsfGmFHx5C4GSq?=
 =?us-ascii?Q?F18CrzkB5EFuDPSv/lR0sot1JDNWDZzWybxuEJpfv/iRsAYGk4QtUadQyDFP?=
 =?us-ascii?Q?5fvXtgg/QRgKA3k4WrkycmxkU2GAxSf83m2NeG16LTqslUS8OLyyRGH0VmfR?=
 =?us-ascii?Q?YcAi41RtaOw2y+l8ugle+/bOz2ehHeO8wdgzsdCohQTK7zIX3PJS+79MO8vF?=
 =?us-ascii?Q?RGJo+ZZGx9CwAbmh8yyXH1UDXTj9rn8oK4JtwM9sASRYWei41j2zz26mTbqq?=
X-MS-Exchange-AntiSpam-MessageData-1: UWZRba12Xzt7Eg==
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: d3665c22-74dd-4816-2b7a-08df496cb25f
X-MS-Exchange-CrossTenant-AuthSource: DU0PR03MB8960.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 14:18:51.4555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESNGOkpvXfGO+HpKSrzLpxsUNRfDZf5dhVRwDy0dGro98QIHuxGzbjb+YsJGMvw3MnKHlta+Ob5DeZReMb8TwIEaRG5WxO8g2vxWYkXguO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB9073

On Mon, 23 Nov 2026 11:22:03 +0100
Juri Lelli <juri.lelli@redhat.com> wrote:

> Hello!
> 
> Me again interjecting, please bear with me, but I think we want to get
> this as right as we can. :)
> 
> On 23/11/26 08:43, luca abeni wrote:
> > Hi Tejun,
> > 
> > On Sat, 21 Nov 2026 07:24:36 -1000
> > Tejun Heo <tj@kernel.org> wrote:
> >   
> > > Hello, Luca.
> > > 
> > > On Fri, Nov 20, 2026 at 09:24:18PM +0100, luca abeni wrote:  
> > > > But the deadline entities serving the real-time tasks in a
> > > > cgroup are pinned to cores (one dl entity serves the cgroup's
> > > > RT rq for a core). So, they cannot just be added to the sum
> > > > mentioned above (which works for dl entities which are free to
> > > > migrate). This issue was solved by reserving a fraction of the
> > > > CPU time (and the root cgroup parameters indicated this
> > > > fraction) to RT cgropus, so that the SCHED_DEADLINE admission
> > > > control is still the same (we just decrease "limit" by the
> > > > fraction reserved to RT cgroups).    
> > > 
> > > I see. Can the fraction be the maximum across the CPUs then? With
> > > the root at "max", the kernel knows how much the cgroup servers
> > > have reserved on each CPU. If "limit" is decreased by the largest
> > > of those on all CPUs, every CPU has at least what its servers
> > > need set aside and the admission control for tasks stays the same.
> > > 
> > > I'm not familiar with the admission test, so I may be missing
> > > something.  
> > 
> > Uhm... I think this can increase the code complexity, but yes, I
> > guess it can work.  
> 
> What about a slightly different approach? Instead of reserving a
> fraction up front (or the max across CPUs), cgroup servers could be
> accounted like fair/ext servers already are: each server adds its
> bandwidth to total_bw of its root domain, and on top of the global
> test we check, per CPU, that pinned bandwidth (cgroup servers plus
> fair/ext servers) stays within the limit.

I am not sure about the SP theory, but if this solution is fine with
kernel maintainers, I think this will work, too (it is even better, as
it reduces work for Yuri :)



				Luca


> 
> IIUC reading your RTNS'21 paper with Stephen and Jim [1] right, those
> are its conditions (1) and (2) for semi-partitioned systems, and
> together they keep the system feasible. Did I get that right? The
> catch is that the paper also needs changes to the migration logic (no
> throttle bypass for tardy tasks, and the pushed task not counted in
> cpudl when looking for a target) for tardiness to stay bounded, and
> AFAIK we don't yet have that in mainline.
> 
> So today's DL isn't "pinned aware", but we already live with that:
> fair/ext servers are pinned and simply added to total_bw. I don't
> think this series should fix that too. What I'd suggest instead is:
> 
>  1. keep the interface per-CPU as Tejun proposed, and do admission as
>     above (sum into total_bw plus per-CPU check). When a config is
>     symmetric across the CPUs of a root domain, this is the same as
>     today's uniform reservation, so it works with the current DL
>     implementation with the same guarantees we have now;
> 
>  2. accept asymmetric configs too, but document that, until DL becomes
>     aware of pinned bandwidth, they come with no tardiness guarantees
>     for DL tasks (as with non-default fair server settings today).
>     Once the migration side is fixed (the paper's changes, or
>     something similar), they get the guarantees without any interface
>     change.
> 
> This also avoids the cost of the max approach, where 50% on one CPU
> takes 50% of DL capacity on all CPUs of the root domain, and it should
> be less code, since cgroup servers would just follow the dl_server
> accounting paths (dl_server_apply_params(), dl_server_add_bw() on
> root domain rebuilds), but Yuri should keep me honest here. :)
> 
> The root entry would then just limit what cgroups can reserve per CPU,
> on top of the above, which I think is what Tejun described.
> 
> Thoughts?
> 
> 1 - https://www.cs.unc.edu/~anderson/papers/rtns21a.pdf
> 

