Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.136
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795172833;
	b=4u12eB17j3lCNmmT7ftt1HBHv0++PUIAwajkdbPrlBIkqK0c2izh/+fdoztiOlIwT5EX
	 t8Rh1RxEaZIFaG6rCMnCF1J2R7HP7QsOlr0GqZwCtoXnLaL1we3Sw5Rj+ogqzj8/R6KhJ
	 PixRylRQU3ltgQHgIAWVlmp4VIyFseMkb8zWMiGu2KXEAUMaAWf9ARBTd2LywLl8BJES/
	 R6eb4Vw6KhUhPHTThmwHALPrW8dTaoE0eQ83QQEfoAZdMCDNcG7+ayhE8zB53zF4r++fM
	 MUfru7HLS3ZG8gbsdX0q7USY8vMKjZzB6N1Ee5UcZNNF2c34LIl3wuwh2QHLIy4Y4SQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172833;
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
	bh=CVztUUQ44kRXTSspzeUOVgl3OokIZ+nfNXEFu5fkhYI=;
	b=wTgWQ6O0dCVeyduqtHFOi6ap6xBhXgdsy55BCStKfWhLCV2jcHpl0hzP1Y/hs09EXm9V
	 PzdgTPN/tUbMGzbKRf7DGASc4GySJ+n1P4+8W08j3ji7yc4Z8ZTg3cf7bVFGwhKChjKCb
	 JbWQaMmMBeIYuo78TzvcZrn96LBkxwr5oBK8C/aZc1ZzUZ2gJZtHAUVkGYbJ25rSxvn50
	 /zSNhgZ4FHzgCxjlWFWQXdHz6raM5O8oL4UnY1cWuK5ZW+lIL+KFy4fnRJtJM92DVuB9a
	 Z7mpKpwIuU6tjK17Xm58FTOoGe4iIAYffSEughXwL/1kIVtvDhmZvF6a7jb5lQcXyjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=santannapisa.it;
	spf=pass smtp.mailfrom=santannapisa.it;
	dkim=pass header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=wA2Q9YLS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.136
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023136.outbound.protection.outlook.com [52.101.72.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BE260A261A;
	Fri, 20 Nov 2026 11:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2BE260A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=santannapisa.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=santannapisa.it header.i=@santannapisa.it header.a=rsa-sha256 header.s=selector1 header.b=wA2Q9YLS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gt5PO6J7OokeoY9WvVnqiSwLm4eYjsdYLg1q+s0l0a4Kvjk94SEYsej3shz6NhLHxovM56nE268Ab6gAATRsim9zc21YoMvNtaHTGQyUafJUdigCiEzvr/hoJx/6oMOc+hKr0UQEz9w/KHjKTjI4YYtlyAC00nsx+qGiYN36VcdOrABjBD0JZA2NsYykvRFdy3Nu5YEAUByy8b75cNjwrNIC6j0w6/zwUVAYLMG+mr/QQ2VV5C88Rd7kVjbOQC/JJLhDdz23jh18j42y8EBvY0h15ElPNYvwDhxgmRE/jXSs+BdMfFUU2rL18pHdN7vRHlf8e11Po+KON622Mh/woQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVztUUQ44kRXTSspzeUOVgl3OokIZ+nfNXEFu5fkhYI=;
 b=CnYa8xDbg6inKt8rzUQrvL6SZvHY/tJnwwsNMMq+soc0CvnPRQeMMNyYpma9sFwHLW0K9hUAYlqre3rBGD+cdJJX9XBlo/0xVkXAJGMEBSQ6CtGz6zC7ZUC+eAdd2uuJEymaEUEw2hK9Td2rQxWIxFb1liSgHr1GELpcBdW047FyoUQwsusvWTG8qMXE2mvySc/pYrOcdw6kG1y5HKDfqqSh8QYARKGRzOtAysrlOoEKvl/cx5yVRj9nRuyj3lW9xLU31KhJPlco0PgUfN6V7NdRTSplujZEYGsut/Utn2wdY8Ut5dQO3pOtOc27CJCUJtue5cFOIa9DVvdlFJ0O/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=santannapisa.it; dmarc=pass action=none
 header.from=santannapisa.it; dkim=pass header.d=santannapisa.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=santannapisa.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVztUUQ44kRXTSspzeUOVgl3OokIZ+nfNXEFu5fkhYI=;
 b=wA2Q9YLSlQ2oQsLpU20F6ZKIzz9tsPDTW6BhMeR/CEda7mYyN/r6qRFxBiSGCteC7e/abgg+XarZPYyCQLWXtijsZ7k1ZbBTtad9U6SZv8je5QN8T+9z27ek5ElHHEoNtpBCDMmXmiP9XwynjrFogG2uwetdyJHpvq9pGIUcqe4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=santannapisa.it;
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com (2603:10a6:102:32e::7)
 by GV1PR03MB10254.eurprd03.prod.outlook.com (2603:10a6:150:165::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 11:07:02 +0000
Received: from PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9]) by PAVPR03MB8969.eurprd03.prod.outlook.com
 ([fe80::26c1:111c:f60d:f9b9%7]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 11:07:02 +0000
Date: Fri, 20 Nov 2026 12:06:59 +0100
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
Message-ID: <20261120120659.2e902463@linux.fritz.box>
In-Reply-To: <471bf8d446becabfca00041fb2a78067@kernel.org>
References: <20261109163616.195264-1-yurand2000@gmail.com>
	<212c244d534ee1fdb0538a980789e16c@kernel.org>
	<20261111175657.250354-1-yurand2000@gmail.com>
	<58cb2cbaf82c0f671213eaca46465cd5@kernel.org>
	<20261119151416.33f90a64@linux.fritz.box>
	<471bf8d446becabfca00041fb2a78067@kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.53; x86_64-suse-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0043.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::17) To PAVPR03MB8969.eurprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: PAVPR03MB8969:EE_|GV1PR03MB10254:EE_
X-MS-Office365-Filtering-Correlation-Id: b894ebb1-237f-479d-d342-08df46f66749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|786006|10070799003|1800799024|23010399003|10067099003|4143699003|11063799006|5023799004|56012099006|261022113327099003|261021121427099003|261022105027099003|261022075727099003|261102123227099003|261026140227099003|261028144727099003|261026121527099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	iJEF9uitlbcBPnSolPstoNIgA5owBqbgmHHb8VFbScP2ZdCjn7uCshDMtQafAATSQzAPmOqMlb6mT6WihfhEcWLP8RVOatuGZdGDnS/DcnarpSIUsMX66gaYCjCIdWJWNYLUkN/1kSidfolpXZE/3RdgyFmVKNZ7hLdROQNWiFQw7QhR5SLxu7Wz6sQVETaHiBI0LdIDc2JVbhBxuC99ChxX3mqAl6YxWZcC7uaHbYaDtcWA/tUotlsb5rnoIcrVduHEtfU6qaUcxfBrZO+R+UrQLDBzRLhhSOknfo/3wD70rzmHg4PICj5HlbEA0phGiVLqq2QY3iFuqHRP1Jrz/L9lymQWoQmge+Jyd+BNjiBT9+TnTz6Lgtygjods5HgdOqnhMtmIsI5d7XwJS3AV4Y1/bE1d0ftLSbAUj4bz3kMKsyQqJpZHSeNUTc7i5ankQ2SyeU7WQMw1T2SaVcmmz/mVaM3HvXSDHyjyk7AfgTjUQKbIB0uzUCOzvHX3h4chfzTsm1lEEy01nOKQTeCoF2G7OHuZ5sojoCPKU+wa3uusPip9rGlBCMPoZN5ZEARYFl47Z5OUCoszZLjkMbGZ3BXqYDeF6u7AOsa/qTiSyJDrKlFwJP7OSKZ+jU0YqMee9zq5uBJdvDfI+iCu7oR1ArNvhIRIYDH4L3UMKYEMU3w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR03MB8969.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(786006)(10070799003)(1800799024)(23010399003)(10067099003)(4143699003)(11063799006)(5023799004)(56012099006)(261022113327099003)(261021121427099003)(261022105027099003)(261022075727099003)(261102123227099003)(261026140227099003)(261028144727099003)(261026121527099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y50uiO0AuPJOhrZ3ejF7R3uAdanB+jPOukS78s4mLTiwUibTr7DSsMRV/x2d?=
 =?us-ascii?Q?q53C7JJfLNTG6PQyv6riaeO4KmwLv3xHRoeD4bvCqjAFcd4UeNWLO17gCJB2?=
 =?us-ascii?Q?IYdJv40cyIpEbvCg5mQpr/sp/uWYjOYg/5i+Q+DmAWYAufB8Sj/G3pVDZliC?=
 =?us-ascii?Q?sJAZPbKsQHkA2pGNCXovM1niuhT1SdT1QSOx490mmhE66ZCUV9eAki0CdkPf?=
 =?us-ascii?Q?ISS5TfREcLymTROcydv4UDDyqxFrSiOZbOmrRRSfMfS1JC3Z4FHW+3/sIyQw?=
 =?us-ascii?Q?dNkBhQmVpaZM5StaaVoSW+pA3tXbaGpoDGpJi/ZWdlf9hc4Tb2AdMURGfw3e?=
 =?us-ascii?Q?V4IQvMhN1Iu1mcWrQo9PaUDKieUCVQ838C04Ouoi0qcpWKbXg4YGNfuAX18e?=
 =?us-ascii?Q?oI6IWzTC7ChHl/mJO8JmpFjUOQlms/LRkBUl7VOEiJstsN86oeOteYEyF+ey?=
 =?us-ascii?Q?23/g5ROl6rO5k3jhSDxyR8K0TJigizqHGrEeKIy9AC4Ii8SGRTo+YUH6RNCC?=
 =?us-ascii?Q?RuogfdE3/9vXWeUSEqPwSGTZOrvqeJ02jztQ1olDJBbNYDHqLVvPJDJsXXea?=
 =?us-ascii?Q?CzzZuKGIdRUmU/PqnU49DWkDADZI+GmDAP6owe+A5BQfZPbpZea4vJPWHqSL?=
 =?us-ascii?Q?5lx8HpI2hDyCTvcjIlX4pAX/ZdgX8O5fr37IlAHiic9XMtGaoiXuU7ZLCTCa?=
 =?us-ascii?Q?Ez4nCHTjCODsLXYtQt+zGpIahqeU+XxZCeSoV0qr3CwIkYV7CMETzfbVudVk?=
 =?us-ascii?Q?9RcZdE9TUnM18ZO812eslqa0WHNuqAbQNjOZa/e1geR6QvkaWfIag01kFEel?=
 =?us-ascii?Q?s2zn2M7QXqXSx9aUhZvx6EGJpPWuivQb/Bt92X0z4vGpyqamxQuGSIxJhYO7?=
 =?us-ascii?Q?dimU8nCD9a2JCXv2+WmYKyw0FNjvZL/dTGK3b6jdi7REwDYWL8jygT+LhxcQ?=
 =?us-ascii?Q?RJoMOJdouOGY1j5pbjNHDdvebX3isRmxr8dX44bFxFuDQ6aK4cjksWWwzBZd?=
 =?us-ascii?Q?P1MoNi9rPRAf/EKugQBT2QYY8W1kxKcx0TAR9Md26WoUw8TBo8Do+QTyhwxh?=
 =?us-ascii?Q?RhhahTFO+J9WNTI56OGrDw0rZsyNwqEGtIU7/6ulugC0/E9xYWbeYonqMPW1?=
 =?us-ascii?Q?PtNcJGwT0ADj+1+wmaQyk5pCkIebD+uVtn5KmOSfMg1O8rZ02x85UtggbgBv?=
 =?us-ascii?Q?gAb0soPXJMBQfG4LDvt+MKxo3CS7FsnwaeZYNAMfIsKgblasKk7iv1yQfsew?=
 =?us-ascii?Q?AvOmsP3UULq1ipb2UZLj1h3+XoMR5/eExuH/p+oDLfFGc3m2E53BJnkS6bgg?=
 =?us-ascii?Q?4+DHsVzaAv0U92bXKdnHFzjie/Snt6cgr1vCFrxFQ7TffhYj3Lw/QHS86DV6?=
 =?us-ascii?Q?/oagpgRKQPfWypCymbDJ9UTmTlqCQEnAwgWwu92dOVVGB6hopZ2Vj3dkT3GP?=
 =?us-ascii?Q?NL1G66gtgm3rIpQJC/v3uMGVFQbqco2CArCCFbFePvU2EktVEPnNm/BvW8Bb?=
 =?us-ascii?Q?iXox4Ii+2h8o26Ylw9bQ+m+6YAUZs4iK8gEOMdexvHb7xWTZJudgJob2gqmD?=
 =?us-ascii?Q?qPXYkj+9H78pG38jvkPZcAEWNIpYSZXSR8DCeVedyFYrMybLyuQfmWO9i45w?=
 =?us-ascii?Q?rYWbtsNuBZd6vpekKBuLnk2fD5WyUR5qu3WLwDct6DsND/CPmzp1ArFlsSzl?=
 =?us-ascii?Q?ev7gqKwYfh+/RINOD3Zo/CUyvWVMfteAmJ7Uudooc3+cg6AMkU/UDcirXoA9?=
 =?us-ascii?Q?4uiVDApwGFX5p4/GP4U0doADJ70lrNwcjdgTvjdLm7j+ZC/81y4TIo9kKnhA?=
X-MS-Exchange-AntiSpam-MessageData-1: wTwg90dqSwbFFy3YQsnyG7iXjaicd3OjV/E=
X-OriginatorOrg: santannapisa.it
X-MS-Exchange-CrossTenant-Network-Message-Id: b894ebb1-237f-479d-d342-08df46f66749
X-MS-Exchange-CrossTenant-AuthSource: PAVPR03MB8969.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 11:07:02.0367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d97360e3-138d-4b5f-956f-a646c364a01e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hRDVyIh4yaiCmgC6IemKeF8vPewPDE+qN/MoLpslM0B2JCBwNfuTVcnJTKiZmP40OpbBs8Kc13bd0QdLHmNvAJ7ibClmrU0iNW2XwdcOXZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB10254

Hi Tejun,

On Thu, 19 Nov 2026 20:46:18 -1000
Tejun Heo <tj@kernel.org> wrote:

> Hello, Luca.
> 
> I'm only thinking about this from the interface POV, so please read
> the following with that in mind.

I understand (I hope :) the interface issue, and I'd like to find a
compromise that works from both an interface and a "performance
evaluation" perspective.
So below I'm trying to clarify the performance evaluation issues with an
example (maybe I am just repeating myself; if so, I am sorry... but I
hope discussing this example leads to a solution that works from every
perspective).


[...]
> > So, what about a different idea: a cgroup can be "max" or have
> > (runtime,period); when we set (runtime,period), this is set for all
> > the CPU cores, but then we can override (with runtime 0, or
> > different runtime/period) some cores (but we cannot override with
> > "max").  
> 
> If the interface is per-CPU, I think it should be per-CPU all the way.
> What a cgroup has on one CPU shouldn't say anything about what it has
> on another. That seems the most consistent in itself and with the
> other controllers.

Well, my "mixing" of per-CPU and per-cgroup interfaces is mainly due to
the fact that the tasks in the cgroup can be "global" (allowed to
migrate on all the cgroup's cores) or pinned to a CPU core... I
try to explain with an example, based on a cgroup with 2 cores,
core0 and core1:

- If both core0 and core1 are configured with runtime 10ms and period
100ms, then the real-time tasks running in the cgroup are guaranteed to
execute for 20ms every 100ms. Based on this, some theoretical analysis
can be used to check if the tasks will respect their deadlines, etc

- If both core0 and core1 are configured as "max", then the real-time
tasks contained in the cgroup will always execute with the parent
cgroup's deadline entities. Knowing the parameters of such deadline
entities, and knowing the tasks running in both cgroups, it is again
possible to provide some performance guarantees

- if core0 is configured with runtime 10ms and period 100ms and core1
is configured as "max", then real-time tasks migrating to core1 will
execute with the parent's deadline entity... But that deadline entity
is also shared with other real-time tasks. So, it is unclear how much
CPU time the cgroup's real-time tasks are expected to receive. Also,
the tasks migrating from core0 to core1 will consume the parent's
runtime on core1 (but not on core0), making it difficult to provide
performance guarantees for the parent cgroup too.

In other words, if tasks can migrate between cores, performance
guarantees should be "per-cgroup", not per-CPU, which makes it
difficult to mix "(runtime, period)" and "max" in the same cgroup.
If, on the other hand, tasks were pinned to cores or migrations were
disabled, the mix wouldn't be an issue.


> Take Juri's example of a top-level group which has an entry only for
> CPU0. Its tasks are limited on CPU0 and not on CPU1, which is what the
> config says.

I understand this if tasks are pinned, but I still fail to reason about
performance when tasks can freely migrate between CPU0 and CPU1 (I can
only think about a very pessimistic evaluation: assuming that all the
tasks execute on CPU0 when we evaluate this cgroup's performance, and
assuming that they all execute on CPU1 when evaluate the interference
on the parent's workload).


> io.max works the same way. A limit on one device says
> nothing about the other devices, and a device without an entry is at
> "max". If the group shouldn't run RT tasks on CPU1, it can be given
> runtime=0 there.

I do not know much about IO device and io.max, sorry... But maybe the
difference is that tasks do not "migrate" between different devices?


> Tasks moving across CPUs doesn't change how the resources are
> allocated. A task consumes from whatever serves its cgroup on the CPU
> it's running on.
> 
> I'm not too familiar with the schedulability analysis side, so please
> correct me if I'm missing something. Wouldn't it work if the setups
> which need the analysis configure the group on all CPUs? That seems
> like something which can be a convention in how groups are configured
> rather than forced through the interface, which looks like it'd get
> clunky whichever shape we pick.

Something like leaving the "all-configured or all-max" as a system
administrator responsibility, instead of enforcing it, right?
I guess this can work, but I had no time to discuss this with Yuri, so
I do not know how difficult this can be from the implementation's
perspective.
I also fear this kind of solution can increase the probability of
misconfiguring the system (ending up with the feature not being used).


> > We think 0 as a default would be problematic, as it means "no
> > real-time tasks", and 0 in the root means "no real-time tasks in
> > all the cgroups"... Or am I missing your point?  
> 
> Yeah, zero doesn't work there. How about defaulting the root to "max"
> like the other cgroups? "max" on the root would mean that nothing is
> set aside for cgroups. RT tasks which aren't under any entry run
> without a server as they do now, and the budgets of top-level cgroups
> are admitted against the DL bandwidth directly. An entry on the root
> would be the total that cgroup servers can reserve on that CPU, and
> writing one fails if what's already reserved doesn't fit. RT tasks in
> the root itself keep running without a server either way.

Yes, I think this is OK. It means that hierarchical scheduling is
disabled by default, and the administrator has to write something in
the root cgroup to enable it.


			Thanks,
				Luca
