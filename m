Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.84
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795099337;
	b=Vzql+E5CRZoFq6ki+94KJPvOaayrd2k6RWqIeBPaYtoVyF6NIaPLmwCY8qoC+Xe0cA65
	 3MF7S3TI3Rs2CrXVunLqfNsV69B178KfvM7fIlNB/fzFSXM8KhBoecz8uaW7hiqESnHL8
	 MzeGwROo77hFur2FQcseSrdcOd6JoxeYDNe+6cb8qmGRjdStBPiLbLs0/AucdaHbrkANo
	 Z5Z5ZrT3vi9ikdDbpwu2G6pfO47jCl6aomFYgQZx7sv9i5zHNk6dRdS6B7W/H8pXOkdam
	 kFS/73sqsikBzHIjr/pctvoXetoj1RhuJ3MRZpE8bff1GV94hzrrQiLqc8A5hVFfc9g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099337;
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
	bh=c921SPMOQsfcmponr5NlvfFRSDM1i4bxOk8lebXUCxo=;
	b=LGvaxq3WppGrGDFo5HYP9Fvi7Zht8HNCv2r2rt+0Hz8wOApF49dSyfBSJ13w78Sn2rPe
	 Fx1pPcV2xyF7oSOsInaiMDviOUX/gExwNbCdJozRgpmj4osGt57jf61qoIWcZmbNYMcfk
	 qE/A/PHHWNi7zztniJTP+BRsKttbs+SfCJ8o+TBM/DigS6zUuTQW/NQh9OmLLUANkgykX
	 jPjSNKjYpzmwTSjF8MtpmsdSPrvq7zQiKiDaOwgenfAxU+E1uE72dn/pXP8ocXoLMz9xY
	 eV7IAMrKHSAJIGJS9TKAiVAYXM2EnFS+r6BxYE4qThu6aYlaJb+fXc73cc2iEK3QyLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=pT4qgoNh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.84
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021084.outbound.protection.outlook.com [52.101.65.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7B2606A320;
	Thu, 19 Nov 2026 14:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F7B2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=pT4qgoNh
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E39SLkSvHH092KrdFJOfHFQZBrbP7DqyEncQxqArqXBN7TFWKuHMi1R6IwzBLHFaUiI0FAMrRbaJQhNE3j2IM3Ycr/HnYjXq/ufTlnpXHRaOAaDI8OfRp8hGK01PI/Zz4j/m1enYs5pn2cWTGAKYUg3PuU3XDanPDWKOW2cnCnMEIjGrW53viJEWRzgm3WI0HMS4twj7UguEVp+A57qbHGUkRenn6K9GdeeRS4uca4rxl7jAvT0sD93oCjvd7L9NB34TFWvGk1pNqePMiLXMGesyjvn5lU1KqVttts5UMVUq5imFS2tSOPujncg4cgjbltvHABOw+qI+cbVmeIx3gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c921SPMOQsfcmponr5NlvfFRSDM1i4bxOk8lebXUCxo=;
 b=aa0zVQUU2ajFrNtqN3QGAKBOFe6ITnaul0rkxqpWLQH1WyB1qJqcyr5RqrRHntxh98sbPvUx2Enl1suLF2RybgOvwUPG3YZmt9dO7v3LxPGDikgUuQo9P8/dGhw5A+Yu8zo/xc/OEjCNKCJrO2ZXKVrodCqMWEy18GhjPM/xfCrMR4isTkYCgGCUmlktLcviD4/whXibLaD80horP+Us+QIK73GJh5cR7XUH3rEg7b6ZtVk7BKui4u3EqB4u6BSFzxhSfCW3B4E2hs6C9TMBQg0TbFzvIOdFE8Uz+UBlQS7FpQnKGycJlGiDTlfY5i2dhUdlREYbRjW99olGuOrpug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c921SPMOQsfcmponr5NlvfFRSDM1i4bxOk8lebXUCxo=;
 b=pT4qgoNhnNiXtbH32CLgSxx8YZyJtP5Hym+ek2dxDGCgqcP35ptJnih5U4hLW9RRkoQrknZUtmK59dvbo3yO/G+C2xDCmfe/oxtsvMdJnWpyFjpngkgLX5pf/KnXJ1mHH/B4if5j8Md4/aGjyHNMmirtw7YK2BkU/0t1Zh5qLd0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by DU0PR03MB9005.eurprd03.prod.outlook.com (2603:10a6:10:478::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 14:42:07 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 14:42:07 +0000
Date: Thu, 19 Nov 2026 15:42:04 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
 bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com,
 hannes@cmpxchg.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com, peterz@infradead.org,
 rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261119154204.503ea610@linux.fritz.box>
In-Reply-To: <av8JUXtjhd3PoWL7@jlelli-thinkpadt14gen4.remote.csb>
References: <20261109163616.195264-1-yurand2000@gmail.com>
	<212c244d534ee1fdb0538a980789e16c@kernel.org>
	<20261111175657.250354-1-yurand2000@gmail.com>
	<58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
	<av7cRIyAMoiIR5k-@jlelli-thinkpadt14gen4.remote.csb>
	<20261119152744.3a2f7aed@linux.fritz.box>
	<av8JUXtjhd3PoWL7@jlelli-thinkpadt14gen4.remote.csb>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI1PEPF00000AE1.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::4ba) To PAVPR03MB8969.eurprd03.prod.outlook.com
 (2603:10a6:102:32e::7)
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|DU0PR03MB9005:EE_
X-MS-Office365-Filtering-Correlation-Id: dd90ce37-7329-4936-0729-08df464b491b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|786006|1800799024|376014|7416014|10070799003|23010399003|261022075727099003|261102123227099003|4143699003|261026121527099003|5023799004|56012099006|11063799006|10067099003|261021121427099003|261022113327099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	LonT/t5q9jCtfYN449okZyfaKsboLnOke4WBBKLPjZV+wg/vVZToyYrfahd4nJPYvzyFAMR6i/hmCOtZ0RauHSyxxkac17SJxOgZ1CiHnaC232GhPeazjkgGKJd69A70UkLbubO1GyeBTszS7FxpTfMVTBALe1pu+sCgnC9Za4NFBk1M2ZIvOJhy7Y4tU8N1w+S+BUlJ6JgEaSv/FkCp/6ziGbyPHYEPj6n99V5Z7Vpszqn0bsJCC8CdmYbuBA3Irfw441PeYc4pWgofdQg7eCTBACDnLgVCeDa18i4YMLcV8etj273iSdWxmTtz9Vkl1RwnATZ2IRZOLnmr+ZAE48Nsf6ZGGfO0VqDcsPnQYK8wYkg9k0TU3KVK9VMQ/cElmCl+bXEy9IUTkEbMpMG3lRPo7mk/ZyP9V0UVi5piIh2eMyFydSZO1rMpuqczHay0lpRF4ICEEXmWhLYug3VU6wX2WW+4aGLpPyE/N19flWqZFbukkawyj9phVOAqFuwp091sSeemJbFozIrNfkwxZGiadD9I/ExI6R0khf9EfA32rTJ6GTHJSKiwdwB+zYvCtfPsuDTF+Iy3vR1XJ3m9k50yYb5R4nVuuSTJYDq1CS3K55LjZfz2/VceybgE8lxnCaWoH2Ub3JngLMPqu61SvwXxuk0TPSI9LLY/Wvih6hs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(786006)(1800799024)(376014)(7416014)(10070799003)(23010399003)(261022075727099003)(261102123227099003)(4143699003)(261026121527099003)(5023799004)(56012099006)(11063799006)(10067099003)(261021121427099003)(261022113327099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HR/MZxXpZixW61BXkWQ35RgM2WGs8qivUeSlEWSKFnhtP6bbvu9Hety6jwBk?=
 =?us-ascii?Q?uzhmAMcAwlEiGuAHgeGroU2Ti1HQdxBnJOhF6l03uxF4JSDHBtG+dBxgctdX?=
 =?us-ascii?Q?LSmDRC94MRWaMRUbVgEBepujDOg1hN+qin+kiQzVoXdFe4USID7yExUju6xN?=
 =?us-ascii?Q?o6nd+bWEO63/gHzCyeMZUSBdWgwbWH2PSYAlSEQugWM50xm9quJhIfV+vaav?=
 =?us-ascii?Q?KyEaf+AY4vwL2CoBZP6CtkjwhgvM4GPa5qMhzKkWHJMSWCEh1mV2v3eHCUcG?=
 =?us-ascii?Q?+3RRf9uZOtLQ07r+ZRi5lqPqOmjtMDNV1fjbqaOL8/BDtZF7sFkIG8w8A/gh?=
 =?us-ascii?Q?zwz427YZLN1Zhp2D6g0CJKw6hoH/D6SlpIGWxDh544HBLBJ3RybTDURYWPJw?=
 =?us-ascii?Q?UxVEmqBZYek3W7bbY27D9JKo1CP/gRk87zq8iWqwjEFFkwF2cycpQYxeX8Um?=
 =?us-ascii?Q?BaaE5g5iGKBzc3qG334s0OX7JA1zBJUZfL5GXMh3mFTuiEzMkdT6WTTa/sVH?=
 =?us-ascii?Q?sTpkw+RMj9Y6zmAz4De4Q7D/nWn4r57CXtvDOdsLD2kkwRkw4bv0ByBMCDki?=
 =?us-ascii?Q?k/KbHNir2i8jOOhfuXjy6549p3naYMCNrXD2xGIrG6xM4ZH5yL6umwQUL+LI?=
 =?us-ascii?Q?kcr9p/1/f0vdFTIisUbOlDAbFeE4K7phOL0UFd8mDQm4+rVudyCmxUw1rKVu?=
 =?us-ascii?Q?0a7iWWkPLXlpP/UniC0DesfkkH0CILxHef5UswUPVfA6RqmS/8hXFTID/xO6?=
 =?us-ascii?Q?i750eV9u2J3ZTfRzI/TvB4h3jWlN27EprAdcx1CmVMfbAPz34XtdPV9r9MXN?=
 =?us-ascii?Q?/M63fDeGjOZUJvtDHLiE3N8cSEuXC1bd7wZmnYgfOBL8aWYRWUNXKglOx5ip?=
 =?us-ascii?Q?od4wR+3jIszXxP3VbldxlSuG9huRh+tyxCIRk6ed8gROtwL8n7th1YngTP1M?=
 =?us-ascii?Q?STGU2MiGDcaUiSoc4MXJxu8DsQaf8M+UNsjbQdsgVxSmxrnlTnkcnQBUI3tp?=
 =?us-ascii?Q?UfKOdXQZu6KyMT35NK3YRcI9C9XTBZyfSRZG181VZAy69KoibkchoowqsJBD?=
 =?us-ascii?Q?5FeJGNzozpm/xrG+N1bc57P7F/J4zzqnd3mIDUVi9dFxnL9WHv2z22A/c3vg?=
 =?us-ascii?Q?wHBX2VcdhflMoNjXg5G6H4J3wklbiDX1epGKHldQKRUfmRgDrpD28Z8/WMkg?=
 =?us-ascii?Q?Z/tqi4IfbN73R6imTZDhs0Jn8fEwVaPDotTaCDhA4ymK7OmqRfMrcqrq56lc?=
 =?us-ascii?Q?v0hTUBDZyvbiOcbl4bYkJm61SBT+6leqIroIMobLRreAG8RVeNNx06H2r5T4?=
 =?us-ascii?Q?NMFK83hciUIbDqJbPNBAy/pb2WkCoW/BmLIMitLXp1LFEN4jyEU8UyX3GvrR?=
 =?us-ascii?Q?zmo2U+D4e7z+5fHDIpvLDw/TkiT2CkS7VGHMgmjQYO4Rh0stAJTQSzhRiANZ?=
 =?us-ascii?Q?YqolMbDW64jbetYiTP2DQzGjQ6ddOpOA8DdaccLl5aVvBje1gqLVcfJbkSCU?=
 =?us-ascii?Q?YD3krjcJP+mWecktBPM6euccZBLH2i25R7Q5jAh2XKFJ9e3eXxZ6lXU+CorN?=
 =?us-ascii?Q?8CGADTVOVgwRhXUifJ05Cv+tSF935tksnDu4mEOjpf/OFR4J12/rJO29NORS?=
 =?us-ascii?Q?MUueGyOaFEi4FXsoJmV1c6+mG59dkIZDbuj7TnmsYIm1NHuwdtnBAhi4yKOS?=
 =?us-ascii?Q?YgdZ/9EAm+6BopbMH8nrYdPpHztou6JTksbjPWdumCf3JRojl6OwlLYI5KO4?=
 =?us-ascii?Q?bU61Un4dGOWSC0S19YaVUSm6ZuqoUNeZMefiOrif1fohkhShPf00qCvn4nzD?=
X-MS-Exchange-AntiSpam-MessageData-1: yBa+q0ekNDgnebadAjXZvtEJrvKM9lD/8nc=
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: dd90ce37-7329-4936-0729-08df464b491b
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 14:42:07.4359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wj2ddUxJtqVzPMnxHwv4o1Hozdn5bPRFWCMDw/NVTCVrsPkOgf7J+JE7asqtLLVgT/RlP/Z1097U2TZZoXTzRWZpfxwgQdKdK7i+C8bnefc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9005

On Thu, 19 Nov 2026 15:36:01 +0100
Juri Lelli <juri.lelli@redhat.com> wrote:
> > > > The root has no ancestor to fall back to, so a missing entry
> > > > can't mean anything there. It has to always carry an entry for
> > > > every possible CPU, which defaults to zero, and reject "max":
> > > > 
> > > >   0-127 runtime=0 period=1000000    
> > > 
> > > Also, related to the above: on the root these numbers mean
> > > something else (how much DL bandwidth cgroups may reserve, not a
> > > server for the root's tasks), and showing them in the same file
> > > and format is part of what makes the example misleading. Would
> > > you be OK with dropping cpu.rt.max on the root and exposing the
> > > parameters through a separately named root-only file (or the
> > > existing sysctls)? That way, having no entry all the way up
> > > consistently means unmanaged FIFO/RR, and nothing on the root
> > > looks like a budget those tasks share.  
> > 
> > Regardless of the filenames we decide, the defaults for these
> > settings indicate the fraction of CPU time that can be consumed by
> > all real-time tasks that are not in the root cgroup, right?  
> 
> Not quite, I think? They cap the bandwidth that can be reserved for
> cgroup servers, so they only cover RT tasks that are served by one.
> RT tasks in a non-root "max" cgroup (with no configured ancestor) are
> not in the root cgroup, but run in the root runqueue

Ah, right, sorry about the confusion... I was counting them as
belonging to the root cgroup, but you are right, they are in different
cgroups.

So, yes, I was victim of the confusion you'd like to avoid :)



			Luca



> and aren't
> limited by those values at all (sched_rt_can_attach() lets them in
> unconditionally). Which is the kind of confusion I'd like the root
> interface to avoid.
> 
> Thanks,
> Juri
> 

