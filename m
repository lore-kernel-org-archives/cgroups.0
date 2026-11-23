Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.95
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795419838;
	b=Y8WPZydGNHDXyIyJoVv//6QanPTHxQdiC32NHCEwuradX/ImdzJTEOh96S4Jd8gy9Zmt
	 7pQl6rspKFhMgbghzPzYG/o0q1SNiUhrAHcbT2gZUCyAQOjqlXe49wrWm/1R9RlOZyC74
	 tLhwCFDKpbjly7gNxmLFsumOH3sGrckxefAP2gNPK81v/c/0ZfYIbLJK1JogREr2Kzseb
	 7WozbvGwlquqIvO2692xhfV2EYs9LvxN4O0rJNXUWQNSKZhyIQvQwqMHeqMSbaLKtVJZS
	 DM6pZuR69XdsO8stBRki2aBV2vW3X22+yabHMp4JLVOAtZ4G0aTGa48rQsfgQot80nQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795419838;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=h1BoqrFjK1VI3RsQzmaDKJYleWwkIud5GqFJuwXb27s=;
	b=4I7AWYdWAXW2YmxdFi4OYBxFixi2wqwasD9zQmymu+wdFGcfl1zy19qI93lM5e0PlzMF
	 j/xaKz/RYxBsG3cONuHXPAa4x/3wCkRmOaCAd3j26r2gjXy3Nc2A71elTOqhEYJp8Ichb
	 ApGGwed/PyZrzGpFVTyouxmMUW+ATng7XOB3RhtQ6VtNznEFNLF7JpC1aeiGxNLnrpj65
	 334at6cMNVUG33UTwcB0/LACRYNcnO9xTJ+Uzo0ufsu74fto+SUzA/PQnSwrsbwoXkQ6v
	 6RFfcALk4LkCyQXCy8HyZuQ6WdgRnqJsh5ytoA/2iotQUUtUtsj6ZHD3Ls0aa8KVDIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=GGlDINIg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.95
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020095.outbound.protection.outlook.com [52.101.84.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE94606A31A;
	Mon, 23 Nov 2026 07:43:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAE94606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=GGlDINIg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuC/wAYO0KkY5Rtinf4xRDIXKaMT4QNhxL2XyWTPuq59pSphJOrfoqRax7EWifXhCP91vxsbJKfmbTQTIlZWiXTU39wrF/qIlxe2hoG7uXXFwQTiThuRZQlljMcfibPJrg47m/FD2LFoFJOikFAJ9pyyoIlsmW2fxRdN7EOftwBpBJL9HcP19U3IlVjkw/T2LwzcW3ktS5fT0tJx8zKrDl6HMYTA5ncQzNfa7v8vJRHY1Ud1lMNqNVT1TISRCmrYyuN5lgKN419FYwTaIpNMM+DGxdY0wlXruNNYhZ7KD4XJ5FRcEz2j+JFw3htkX+sfk60XCzkUN4HZcnFlQBuo2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1BoqrFjK1VI3RsQzmaDKJYleWwkIud5GqFJuwXb27s=;
 b=a+DZGDdpoeQZFIJe3Te0RcilYVNyXKvQetahhywoEpHkGxUZ676Lvst0fCsi2xIZzNoGXWaKKJXr/kiHMQU7VC02tzuqnZAEZEDRFjMKfIUlr/XmLvSHNTp0I4iWOoXWhwWCqdnrI1YHyKYjI/S7qZGz14rh4iG+gfkU1fIx3wFhBWA2PbnO3inrTiHZZK+p/gr3U3vQPjFTLsazch4wN68TK9vMEhvh0ZHhf4WE1rvcFiY8Y9xnWwYFhM/m7AjrpV9Wd6fQqStrb11NdgZCzbuqeh+0oSMzwLMV/6O5j+Y7GyoFAYbJH9VNGqv+RPFlX2LuFKKYa2CQAk68vm1Pfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1BoqrFjK1VI3RsQzmaDKJYleWwkIud5GqFJuwXb27s=;
 b=GGlDINIgpgUCaUggK5fDSRYFtKUWT3Spt4rMNQLAsw9p8bJTcLBW5UkhpZoQLCgAqMNqid/Ucfik4GWueIExPMgJkUrc5JYOGWI5YqNesZl0ZUPmW78ccdwPz9j2ln5hLCS9nTKdRjgbG79vLRgJqFvCk419KtuGuLoBXmFCZsE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by VI2PR03MB10641.eurprd03.prod.outlook.com (2603:10a6:800:275::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 07:43:48 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 07:43:48 +0000
Date: Mon, 23 Nov 2026 08:43:45 +0100
From: luca abeni <luca.abeni@santannapisa.it>
To: Tejun Heo <tj@kernel.org>
Cc: Yuri Andriaccio <yurand2000@gmail.com>, bsegall@google.com,
 cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org,
 juri.lelli@redhat.com, kprateek.nayak@amd.com,
 linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@redhat.com,
 mkoutny@suse.com, peterz@infradead.org, rostedt@goodmis.org,
 vincent.guittot@linaro.org, vschneid@redhat.com,
 yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <20261123084345.4e24e3ca@luca64>
In-Reply-To: <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
References: <20261109163616.195264-1-yurand2000@gmail.com>
	<212c244d534ee1fdb0538a980789e16c@kernel.org>
	<20261111175657.250354-1-yurand2000@gmail.com>
	<58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
	<20261119151416.33f90a64@linux.fritz.box>
	<471bf8d446becabfca00041fb2a78067@kernel.org>
	<20261120120659.2e902463@linux.fritz.box>
	<6fef47e08a37079c08806b3c57994778@kernel.org>
	<20261120212418.10221f2e@linux.fritz.box>
	<06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
Organization: Scuola Superiore S. Anna
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.52; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MI3PEPF0000753B.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:298:1::4cd) To PAVPR03MB8969.eurprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|VI2PR03MB10641:EE_
X-MS-Office365-Filtering-Correlation-Id: 860a2762-f746-479d-5d40-08df49358294
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|786006|1800799024|23010399003|366016|7416014|376014|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	u4TwiAz259LlSY9NW48bhIwNfAcC/tg7UYQnm+EWFzMLQJf6R+hRCIylvmdPexevKuURika5MzOoRyJvPvEMQ3nyQ8LUagk4thoJC1mpm1d/AI+RD7nQRZWC5t9CmLHeq5aBzjNPteFO9NVUI51ScWytXBzXETfRZecADfzae+ehCTLbgLpnIlcNeQDxd4ss7jIHOVwpHMSjvj0RFoknVWPZop0Y4yF+GW152QOwhPuhThc6pNf2bkl9O641uSyRKbttu8kPXsGlB3wWAHC2o1GQlv6HxgXYhPmoXGlR72edB3n/t8rdyB8BFWvnhPtl9r6uCXovk78+7SLU57zI6/93ZfMDzf4yLX9TpR6NUcrhzI1w0T3vGcWKYXbhQY2jdD5q0PcUlKOWFub+SPJDhSAHP1pg04cTjh/wxd600PfIPhYxU5accGCZmA8zw/BzKPsuSBAHkbW+IZgbyMNs0bHBt434RYlLhdCpP9iB4rkatVN6lnT4fsKO95Mk6XxBDuAM7vjSUROP91aybR0kXyY+oufmbsqjHk9Zdq8dlR87LqImSR1wJyky1w8RIq4aRZze8m51e+OIHCZ4OuY1ORlzlLFkGcW9gP/bXI63MEw99zuvX73N1pbanwjqYMdPB7d8TyLofAhB3T2MUuo3oITkwxAj1z+W4YCvayfRWSc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(1800799024)(23010399003)(366016)(7416014)(376014)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pB6TpZiwjLc8WW5Qg6/1bDcSvWauiFSfnzAT0vsIQd8oFGgKA8qs98v3cKiY?=
 =?us-ascii?Q?94SMefCEuMybmNQaSEYIEEPVL46/pPjstlrlaXLkENWdvJThn4qXLouVLS9u?=
 =?us-ascii?Q?E+8DLwqiUUdJ+EDG4dOq/8FTz6OuHefVGa4R5L17VOME1DhOpc6v1u/31N5L?=
 =?us-ascii?Q?+c5ugf714E1OZSPoFgbjmg/CAJr3yzqoeRO1vlfUVnWw0lnmkdwVFmyrsqVh?=
 =?us-ascii?Q?phsXt5Hu0KLH80/nd6mvmRvbg9oea4Gp5v5PoaYGzSNXouPzMKppNFIJwBe3?=
 =?us-ascii?Q?UNhx0etACwyNmouxs/DMyNTfc62xgO0RPKQaj8qi08QKxcl/WYhfbiJJ6BJk?=
 =?us-ascii?Q?LU2zV1Qnw5e6lQ0J/iqjDL16hjM7VWrt8dSU7sB/+ZIjUGx0OYd2DifzJ+RY?=
 =?us-ascii?Q?pesupVb+VGm/0yC4KlRj/basxKcWUI69qXN2qtVwxcu6Ti7i4m3oeJEWeEsV?=
 =?us-ascii?Q?IznOid2E0ZotqUi0LzucKTnAnJWanZOqyMMD/87fJLjFTKCnLHACP0Ptryix?=
 =?us-ascii?Q?U0eccKCzJWYGlwlcw69bkq1T5B/JnavRAevCCBbTgxeR4rezlijD2pO5ijtr?=
 =?us-ascii?Q?i37ibqQukMoiJvS3xCXdYGNzgZ+d7GGFNlOZ7k7Us8/V0kBbj0Yl52mEsxHv?=
 =?us-ascii?Q?Am1Te5B6PFkkczPpqEnvrVvwmd92itzAIeEm/gIxYp1wVl8Lyi7JVwRhupke?=
 =?us-ascii?Q?9L3ti6HSnm1vvRZ1piTES7nNZgwBcJoWT38lIdjCiDFOKcrw54Ua49jBRDB/?=
 =?us-ascii?Q?S6/G6LbNCUxzHNi0Qf6wj2zJXAzJOhTgCI7nt7kqDfW+ZskXuvbnW3JnM1xC?=
 =?us-ascii?Q?3JEeHaIZo1hCES84N66XYgQlEddyC8u7U7SkCIRG9qm3LrOiNHkMwuocyzK1?=
 =?us-ascii?Q?YkGysFPJefmvehALJeHlg2Jd2N5O7wHuwZbFvfiLJzMzJNTn1nLZRvt+7XkY?=
 =?us-ascii?Q?ZUH9yKQPc6ahnDBMUFiThJFX66u6fjySJae68r7Uj1Z3TplaHvxPNeGh4Op9?=
 =?us-ascii?Q?ZRt6gZZ/+h8gBjScIKs0MsC1FjroWDjYS4PkX+nImaTHcLGEt2NnY79oggdZ?=
 =?us-ascii?Q?1H6Zz0WCgM48UpxM/oUZmED+akWZVCOmHp+JIWj5aeEJ0jmDI61H3RgqiP0W?=
 =?us-ascii?Q?voLdepJgrN3y+ZBPGWTQSbrAIxnpyP+f+42u4EnAf1cmXYyKKuO3ENw86KY+?=
 =?us-ascii?Q?JoH80NcW0R5YDsieJCStfNnjiMFMHsVt5GJ6CT8TqkwPNY1zj8zlLlx/MGZr?=
 =?us-ascii?Q?RcttqyIIPmjO66M25gBx7gXrde4n143/8Pdpks3CeXYB2qg7nHink8/kDyMZ?=
 =?us-ascii?Q?jFaxyKGSTSphyPEICZyHu8m/4KOfubQQeSmQJQIaYLQW5gKGoa6JHvUHeaML?=
 =?us-ascii?Q?grhD02SANsDd0VVYTDTp1kqH8PvImu0RCz/SjHKrXEWqpF/v6PosXd52Vhq2?=
 =?us-ascii?Q?b2vWIccJvc1bthvtVxk65WQmh2eZ7ImKX74oBogGWSb7R4nrmgHlb24A7kMV?=
 =?us-ascii?Q?sQGAjAl64USllw+eh1u8fxBD0s3RU0Ug5wp/+4Y75vdh/8bo01eUIq9N0ea5?=
 =?us-ascii?Q?AZRfD1O3aXfKwIzsSGY0Xevm3w8DYGTKZfPuiF2PHE3+SxMYjMYoMCM6/0CZ?=
 =?us-ascii?Q?J/a2ZCzs4IDFzW7A9gsuSAou0+xkIeZsrU3it3lf9zgq+ZqRDROWddfpHRgV?=
 =?us-ascii?Q?N/tdkgQDNlyUz1yDfrryLCk9xacahlGu/WrimeQSOFm4n/akFmDALCGu74OH?=
 =?us-ascii?Q?qGWFHzzO+HacPWrvUnYYDwpDiWTOSX8=3D?=
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: 860a2762-f746-479d-5d40-08df49358294
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 07:43:48.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5BiylOvtui2aAdaS9xOQATr0H/+o8kN2kl9qdkgCfbQt7nbthXX239S2q3p1ywaPb6JGnYT1YJ3E51aoM/1PZdLYl5wy2OohWBvQN3Yxqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR03MB10641

Hi Tejun,

On Sat, 21 Nov 2026 07:24:36 -1000
Tejun Heo <tj@kernel.org> wrote:

> Hello, Luca.
> 
> On Fri, Nov 20, 2026 at 09:24:18PM +0100, luca abeni wrote:
> > But the deadline entities serving the real-time tasks in a cgroup
> > are pinned to cores (one dl entity serves the cgroup's RT rq for a
> > core). So, they cannot just be added to the sum mentioned above
> > (which works for dl entities which are free to migrate).
> > This issue was solved by reserving a fraction of the CPU time (and
> > the root cgroup parameters indicated this fraction) to RT cgropus,
> > so that the SCHED_DEADLINE admission control is still the same (we
> > just decrease "limit" by the fraction reserved to RT cgroups).  
> 
> I see. Can the fraction be the maximum across the CPUs then? With the
> root at "max", the kernel knows how much the cgroup servers have
> reserved on each CPU. If "limit" is decreased by the largest of those
> on all CPUs, every CPU has at least what its servers need set aside
> and the admission control for tasks stays the same.
> 
> I'm not familiar with the admission test, so I may be missing
> something.

Uhm... I think this can increase the code complexity, but yes, I guess
it can work.



			Thanks,
				Luca
