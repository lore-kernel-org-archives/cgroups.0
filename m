Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.196.100
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793994643;
	b=gqdzSLFwVeILgVSAsCpfqzCAumIw60jE0ktK90QES5Q6bVCdqdETeVwlCgTgXd/KZlsu
	 7tGlKLvcjF/M5F4exyNbEnDGndbsHcc1e+eKAQMCOwVODVV73hHazZXOLDHzkhuBLyz94
	 E7x8s6TqB/7O1CR3OU38I3GS/CM83+mp95MBLNwmduZhzhVQUPK0FmzCtEO2rFfNvbvz8
	 79mPWitlKxvwKbU9QiOt5gWT9ogl6OwaIhThvsmtaQFQwcwVlM9sxCTrxiaWPEcICN82d
	 V6Z4VHRUEDZXrbtk1vbMGhp9YShDla55CXLKjASmUyT6CFNxrkJn8NJPZhF8VI9tYlA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793994643;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=XdqUy+kIm/KZy3eRVsBAKzygA1Nq4sT2mmNVYGTM+5A=;
	b=BJBmrVhrKXC5s0jVCa2g7euCV06dsY2WLK6kokfVEtBEg5XLNEyQkGxxGSpIjqAhDzDo
	 JI048vGvp+4lZDcK32QSaT4vpihRryMiXvxFw92j1CobM3zHZIKVSw+BcyG+MwLd/F1z7
	 fKYJyeUJj6VqSVisMFMQhdCDMkMIncKEzMgEThjW6/t7OmUbtp1BEM6tz2pd3NOECwrgS
	 3BTXmoVzYmAcCGRLAlJzugXlFdumVJU2Vn7I4Weu34hjtBxcW9oDRCL635xubUfmdElU1
	 oZLa9ee3tPsqmtM2U3qOPuwGJsou95hX+o/guVwdljP9KZ79H8qEvzn8n1jNXyeGnng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=atomlin.com;
	spf=pass smtp.mailfrom=atomlin.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.196.100
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020100.outbound.protection.outlook.com [52.101.196.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2BF606A326;
	Fri,  6 Nov 2026 19:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF2BF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vK2ktZUBpPPLbEIgCJRqRUZR5CPLZEX77bKCATkVacQj39T5tDdhqfVav+GR7kXn2lROSANYxuTtgz2/mrolGKynS0AHdK0KD4wZ97PFYB1IQPEYkH7ThgrDGpcPCGhZeT/LXug+tHifOfosPsh9xD4fZYpjuh2+wIeNg7k2T2RBUoAl3AbNUR1jL74jBQB6kM84QSp68XARi5zZQ++qkiC6XJFwkJg7aWsNGi+K1jWDT93N7nY/B42kQ01nbKnVvbZrS4Co6hXK9bFrV4qQdjlopNUVbIBvbfqpDXcXVmjlxi6odokrp+AbSGNlo1888wacJdpCS8aPBL/e8ZnhoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=XdqUy+kIm/KZy3eRVsBAKzygA1Nq4sT2mmNVYGTM+5A=;
 b=nrngPp1Ha+aieIftNrApeoG/35lnq+1oWI+lZFEWANr//2pi7nAfnrpX0y/u78+eV38LBxOK3Prn6XIqasFJnjxqIlx6h9t7ejEziRSyQT5UrqguqKOtsdCWH9SVHaOvHAjbDamYAs9GDmw0qJPkXFPis36DwGEdaSUHtRlusTsYF/RWeKW1Bizkd2gsKJsEemNAyrdKtsVL7LK393Wf5cnqz52MuYqbzXEDg/D2SQz3jFwI/P5yIaexZLyhhcpCzk3+MA4FNg6pRY15o3njiD6QUUJGf8tXFyXQAjR7dnkrJMWYoRgk6V2qkuFS21AG4ZvIPC9w/lQcT3aT9jM9Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by CWLP123MB3091.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:5a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 19:50:38 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 19:50:38 +0000
Date: Fri, 6 Nov 2026 14:50:34 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: tsbogend@alpha.franken.de, paul@paul-moore.com, jmorris@namei.org, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, 
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	chenridong@huaweicloud.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	omosnace@redhat.com, kees@kernel.org, neelx@suse.com, sean@ashe.io, 
	chjohnst@gmail.com, steve@abita.co, mproche@gmail.com, nick.lange@gmail.com, 
	cgroups@vger.kernel.org, linux-mips@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] security: Expand task_setscheduler LSM hook
Message-ID: <kn57okulm7cmodzdzvzqqswzafu3vopsatfcsptyrz5ztknx4w@ngwh6si3zgpo>
References: <20261105172210.76706-1-atomlin@atomlin.com>
 <au4ovp/Ghd25rtfZ@hallyn.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <au4ovp/Ghd25rtfZ@hallyn.com>
X-ClientProxiedBy: BN0PR07CA0029.namprd07.prod.outlook.com
 (2603:10b6:408:141::11) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:163::8)
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
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|CWLP123MB3091:EE_
X-MS-Office365-Filtering-Correlation-Id: 44c810e9-fe9d-4fcb-7924-08df3c3f3b0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|18002099003|22082099003|4133799003|6133799003|3023799007|10067099003|5023799004|56012099006|4143699003|261026140227099003|261102125427099003|261102123227099003|261028144727099003|261022105027099003|261021135927099003|261021121427099003|261022113327099003|261009223027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	O9qUIO8mXjnknrjKj26aWl+I8n0k4g4sdAu4wsmG1BA3QF/4j5hgJJ8PGFXyw8xD6Txr4zgYYlNA8iJq31GnRhylU82ELTy+X5ORFCWa7HWtitYr8p9VcWFHXbWdTLgjBi4d4w6QgrzVMayzq9YssjYHAfSfjb6M/wmLSpsyLrBYKZkk52WTI2y2xkIR6b1AcHYIjSbHCl//GLG/LuXxe0n5kmBLAw8wXHWI4gN+K9XjVKQzo2dBP+XcLwSDA5dSXHpUvDgnYK6QPxT7q3xd/N2kphIYUN3lzCSvR5JdlAJS8CmjPra3Bscpb3ykXhZidvAAqwfPL0UjJyrxE/k8g9TD4IFHLpD1tEFcu1qe3wioJ1BfUasHyJfIKIkwHSX9Mlzr9uJ3w74SIvA4MJ03lPfszgDvvmggvV0Sae5BKrowTpNQTotNOzVE3AaiinykH+asvX5HSeB3gZLu4jcZ5Pna0jmCWyaFQwqRfw7oEelVfNezSSJq86JeV3PUaHDIxzw9tkKLncUTcFS8e+gsq4lbH6G71z0EoN6iuNvLwpOWTkwDOJpGGeGx8C7Rfd7ESKEZM1aXXNpIaYOjPDc9LMwiBFpTVmCtUmki+aHRE61BTIektovT8YhoLyI/n+hC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(18002099003)(22082099003)(4133799003)(6133799003)(3023799007)(10067099003)(5023799004)(56012099006)(4143699003)(261026140227099003)(261102125427099003)(261102123227099003)(261028144727099003)(261022105027099003)(261021135927099003)(261021121427099003)(261022113327099003)(261009223027099003)(261022075727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTUzdk9WdElpL0F1T0dwWm5SNHFjbHByQ29nNVFvOVhJaVAwaWNjWE9mYWZo?=
 =?utf-8?B?NmxINjZYS2pPZTV5dGY4Ym0veXRYOHdMdmYzdlBTWkZSTjJhMTZDWElHLzQz?=
 =?utf-8?B?Y2xVWG9rSHBYcGdOdHdSRFBzMkNDdlRuaVVUa3FXZmRtaXVGTVJlWFkyRzRj?=
 =?utf-8?B?bC96d0NaSHZ4eXdwTlNzQmt3OGk1YUZ5WkpsaEZac29veVlqUFlsVVJrK1p5?=
 =?utf-8?B?VjdISXF5NWE2OC9lZUxleXlpVHRTN0hpRkRoSW0zUWFCMkZjSUMxZzlpaS9J?=
 =?utf-8?B?a0xwYXB2OWYvUWY5UHBUbThnYWk2N1NxSGtWZWZDNXRvRWVKS2ZFQjJNZm0r?=
 =?utf-8?B?cFpEUEszS2tVQ2xQTE9DQWo5T2NJMHl5cFUrcklUY0Q0TWJMQTBpV0tQd1A2?=
 =?utf-8?B?TVAwVGQzZ2lUZ0QrV1FCRXNLKzlFVVppRUNad05ONHZXSmMwdi9saWlBQXU4?=
 =?utf-8?B?TGFJd2RTQkJIRTFRK2FPWE91d0hweTZIQk1pdzYxZkxKQ0o0YVVtc3VZREJi?=
 =?utf-8?B?eDU0SDZNNXZCMTh2RGRvK0JSZ1lDNm5aMEI5Mkkva20reStRUktKM2tGRlVC?=
 =?utf-8?B?alFTWUdVQnJxcFRtMUJONXQvQ1gwK29pUEx0RWRGNE9VWEtVRmFzYWdnbEF1?=
 =?utf-8?B?WmdxY1RUZURsQjVuU2FMVzk3L1dCcDJwcFZFaVdvWHAvTjczUm9YNEtrV2ZW?=
 =?utf-8?B?c0srM2tLd3lybUJFVk5hM0lib1B0ZWNhZ3dEQTNWblloNkFuZ1FBYjVCeGVx?=
 =?utf-8?B?QktoUjd0dlJPMWNrTXM5bXRMajBRNmRwNklydDRzTUEvUFoxbnpIYmtjaVdV?=
 =?utf-8?B?ZXZocFhhSDlPekN0aVpSRFEwTFZmZDVzMXYwbHRiNW4xdmRqaDhIRkc1c1Q0?=
 =?utf-8?B?QjBZenNxbTJETHFPY2J3NXZTUitnVGo4Q2pnN0ZRQUdLMzhXZ1JVcy85YW5B?=
 =?utf-8?B?L1lLR0xjR0J0RStiODVlQmh1WVltdWFJL1RsVUlOMUxBbGJxRTBjTXh4Y2sy?=
 =?utf-8?B?WHNtSUlyR3JhQjhqVUVuL2lvd0l5OUpScVVwd2krRDl1Zks5ZVg3YnYwVHZW?=
 =?utf-8?B?MjFKbm5nUXE3eWVwZklBRmpselRXdlRzMkVJMHM1K1lWUVNzUU1YUXpGU0JG?=
 =?utf-8?B?clJ2bmxTT2w2bmZMRDg0NTd4WW05UUo5SEg2bklzZ01jRXd6UVNld214Tmtl?=
 =?utf-8?B?cjFDSHMrSUR3S3dyVHdVU3h1b09KdFJLa1h1QVhrR0Uwci9hYi9IeTFyaXVS?=
 =?utf-8?B?eTB3aGJtUTd6c2cvUGs0bzJFZlgrZVR3WDkyNDViSnptaUxXS29kays4Qy9U?=
 =?utf-8?B?WkMvSjlCNnJLRi9Ka1FiUjMxNEdBVnNqRXJqMS85OG90Y3hUekNtQWFwWHRz?=
 =?utf-8?B?SW90ZXg1ZXNtd3FKQU1oa25FK21sWEJXYzg3cjVFS3E4c3V2aThvcWM3VzM4?=
 =?utf-8?B?bzdhWEFIc1lkSDFUMjRRS2ZZWVlybU5Cek1BWVFqdkVCUnFMZUE5dWczVXZI?=
 =?utf-8?B?cXVBUGxNRS9zc29zOFhRQ1FrVDRSeFJSNFNvQ3daSmtqd0FkMTZrYlA3aTNj?=
 =?utf-8?B?TWRxVGV6RVZuZDlabXRQcm1hT3p0V0ZiRmcwaUd4cDFObWZHMFRHUXBHSzlm?=
 =?utf-8?B?NnFHNkUrVnhKZHdOd0NBNlFUYXNPd0U4WVYyNkdvNzBMV0F3a3hBVjRnTHYx?=
 =?utf-8?B?TnU1b0NMbTdrMDJUSXdrbHl4RU1WWUpSZnNmZGZFNG9HYWdQNnF6eDZmaDVT?=
 =?utf-8?B?VXlrdHNaeitJL3NoNDJ0THVzRlBRTGRCZDE1YUM3R2VhL3JVdWtjQWpMeml1?=
 =?utf-8?B?bitPalRKN01zeXkvRVJ4dXo2R2dCalBHQStWSTIxRFg1Z0M3TUozR0oxZ0E3?=
 =?utf-8?B?QzFhZnFkelRIRFhvSktaZmdWb2w3Q3BNSTJvN25UZmxVaXlSdmFpYmdLQ3RX?=
 =?utf-8?B?T3hhWS96ZzJsaFBjSE4zM3R1RndrdnNubkhMbmpzK0tjWDhhRHpJYzlMc0xE?=
 =?utf-8?B?V0pENVpZWk9hNG1TUkVscXAxN1ltc1lqUk5OVHlnRHlmSTRrZzRWMHFhMjVU?=
 =?utf-8?B?Tm1uUTRMNjc5M0YrNldNYUVCWXgwS25vc3hWNjEwZnBQc3VYaFEyWUxDeWdD?=
 =?utf-8?B?N0FIYU40NlNCRXdvT29aS3NqZHVBQmxxQjBIQWNqRDBDRWQ2TmNUaXpSa1Rp?=
 =?utf-8?B?eW9JeEtOdlZYWUhKbmZ5SG9JWjZKdHdUaFczenpTSjdQa3pkMkVFRStrUGkx?=
 =?utf-8?B?WFFPRXYreG92WXhoZUsyTWZObUx1N0VoV1I0ZloyYjRxVmFQcWpzY2o0UFN6?=
 =?utf-8?B?R0QxY3RwM1Myc3czTjc3NHR5d1IyN1pITjFoYzdBZnMwM2dhVzZZQT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c810e9-fe9d-4fcb-7924-08df3c3f3b0c
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 19:50:38.3631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0UQZ3U8WS4iNUQpzi97UdHy3Rq0LwAxHOIrxDUtHNzaMDY0h4Znn45FWcU1dirHO+9LCIV8bQDG39CPB3UZHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3091

On Fri, Nov 06, 2026 at 01:21:34PM -0600, Serge E. Hallyn wrote:
> > This change updates all in-tree security modules (capabilities, SELinux,
> > and Smack) to accommodate the new parameters mechanically, while
> > providing LSMs with the necessary context to enforce strict scheduling
> > and affinity policies.
> > 
> > Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> This seems misleading - Casey explicitly said "for the smack bits".  This
> makes it seem like he reviewed and approved of the whole set.

Hi Serge,

Apologies for that, it was not my intention to misrepresent the scope of
Casey's review. The qualifier line was dropped when collecting the trailer.
I will update the tag in the next revision to explicitly scope it:

    Reviewed-by: Casey Schaufler <casey@schaufler-ca.com> # Smack

> I see no issues with the commoncap.c and security.c changes, but as
> Paul said two versions ago in
> https://lore.kernel.org/lkml/CAHC9VhSROg6RGUN4_ZVBoEwYjRnKvyjnkbx2D88c09KiTgY3KQ@mail.gmail.com/
> nothing appaers to be using these.  Where is the user?

The intended consumer is the BPF LSM (via the generated
bpf_lsm_task_setscheduler() hook and the __nullable BTF annotations in
include/linux/lsm_hook_defs.h). As discussed with Peter and Paul in the v3
thread [1], when sched_setaffinity() is called, the cpuset controller
silently intersects and truncates the requested mask without surfacing the
original request, and seccomp cannot safely dereference the __user cpumask
or sched_attr pointers without TOCTOU races. Exposing the copied-in
sched_attr and cpumask to task_setscheduler allows BPF LSM programs to
audit or mediate the actual userspace request before it is sanitised or
applied.

In my reply to Paul on v3 [1], I mentioned that once the MIPS prerequisite
landed, I would include a concrete in-tree demonstration alongside the hook
expansion, which I neglected to include in v4 and v5.

Would adding a BPF LSM selftest (under tools/testing/selftests/bpf/) that
attaches to lsm/task_setscheduler and exercises both the sched_attr and
cpumask parameters (including NULL and non-NULL paths) be sufficient as an
in-tree user/test?

[1]: https://lore.kernel.org/lkml/ozsngetxq44lahategdi43sqrwdnpotsrebssczymqtkbh7snl@u6ytkznmpne5/

Kind regards,
-- 
Aaron Tomlin
