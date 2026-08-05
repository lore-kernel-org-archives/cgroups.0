Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021128.outbound.protection.outlook.com [52.101.100.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C2C2F39B5;
	Wed,  5 Aug 2026 12:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.128
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785933134; cv=fail; b=u62cpa1qy5peK19k1rx7Xn1MJolYkfuMShVgu8z5GnSVraXWLfW+a94VlaWo/gK8NatM9k+PArvIZDlvwaRb+tqKva3loVytbS33anXKq9IrgB3hEitYRdkK7t1COVNJChb0+vNPLPKLLohJCQ0MG/eZFFtzg41uvelsIPvxm5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785933134; c=relaxed/simple;
	bh=oUq+bo+cs5nh7XvIKF0gJdaniJsgBr3JU+NswiA19GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ybgo1/j1DZIUN0y60Txq0QEtOql9rnx6FaFK+whJ7NIIw5xVsOuwuAY9vQ91EHK6Aa73jj0CiEcvgWgd+kIt2OCzHPMXdt7wn9cE7KIqyUc1SuvBB8IOIdtveb4U69OqRPNm55bWXcb4mqxAy2leGXszWwG3C+CPwogk/Q8dc4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.100.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QdksIoxjvH39qgBejqG6FIeuN6heUkewsTn/E/nonKL4JsUml5HD/OoPyBBlHii2gAwWmWSbkjnywCJNtmciHfdb/9f43G2MlbAdsrvNRBuOJPgYu5apWNi25l3dTwr55Lv3kzxU4c8xCSx/RtZfrlk/DW9C81Y0wMEmox0OG5/L6cMbLRc/YRn3AVet8jJDvwi+VVHl/soxPn14Lsp1ZyTUQgoFPSHUX0NUlWa0/NG4DTm71QpipcUZaxiu7hFyphy6LfbkucmGcou+DxQY5YlWP3NfRILOGHERtHpX38jkegqRYzxhwFC9rmd9FJA/BvdZZMtUjbTWAGQjfmyYTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=yi7HyvGfE3jXsYrDAwrDvO8o6eCMyOMk/u1PCKznEyc=;
 b=GPluhXoG9M0+73DSajGjutw1rMDfumquYJXQgK9DZpj/vMHxkYYDrzJNeDEdrIEnr/77Sdfe3O+LyQyUGvOdth/WEtYX0dZZeM+19U3yUM05GOeu8C0IVsm/Va8YRLJHWf1y6Yf1w96bDu1mKkWpnex7nrReRf4yF1lUH1qF3mDidvSZp2tNHH3lMrTCXaLaAgnhQK17d8x+ya/PrP6Ydge9ucga+L0eMUvc50ehncthapFy1KUJcKGwaJwRNVrMGKmNn7pBW1S4h0YeY/74tq8+MkBMcttangNdBlXn4TLFjB/zqAnDVd/CIScgeQPyScTuQMCoZ/3yaPM9Fp1vPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CWLP123MB5915.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1c3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.19; Wed, 5 Aug
 2026 12:32:07 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 12:32:07 +0000
Date: Wed, 5 Aug 2026 08:32:03 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: tsbogend@alpha.franken.de, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, stephen.smalley.work@gmail.com, longman@redhat.com, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, chenridong@huaweicloud.com, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, omosnace@redhat.com, kees@kernel.org, 
	neelx@suse.com, sean@ashe.io, chjohnst@gmail.com, steve@abita.co, 
	mproche@gmail.com, nick.lange@gmail.com, cgroups@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] security: Expand task_setscheduler LSM hook
Message-ID: <j3ybir7lqphxvep2tvmgqhmb6hzufmat7lcxonwkamagpjiwdc@n4cpxxdhqxm6>
References: <20260720014156.459386-1-atomlin@atomlin.com>
 <31679bf5-a0cb-41b6-bc1d-7833c4fc9744@schaufler-ca.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="figpxhk5rpxgi2te"
Content-Disposition: inline
In-Reply-To: <31679bf5-a0cb-41b6-bc1d-7833c4fc9744@schaufler-ca.com>
X-ClientProxiedBy: BL1P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::6) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CWLP123MB5915:EE_
X-MS-Office365-Filtering-Correlation-Id: faa1beb8-e12a-45ac-16ee-08def2ed8fed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|6133799003|56012099006|4143699003|5023799004|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	IE3IahC04rIuNVLX62AWipifIFCfd55uDKMgEQqZsn1H06BWRZyjB4k2g1RhdK54QB48fLL65vHa+R4wJd0RtqEIfR+MM2uZQsbSMnmKvrch+yM9rJqzQUyoYZAS3NMfEn6rDrnmH732Wu62I/ndF7ZzRYLOdJiyVfW4bFaCjDV1uyMebc9Cy9/DR92LzSEY8iJ3RhkQvBP31DyL1I3kXg3vvENbAZ3pZV5HW53decJ2x1Px8W3XQale0YjHRiAH2k/zvM/bqjXE6sFTliInNVHNWlEmEweOmuOezo/mThPz0KV43me9Ga9c3pMimLFqesUhwS8ThRD8NKdBRk6AplX1wj1WTPfQaRaNr0FiAy5NAFPfme+P9gdh10zBunBmL3SsPLHrDEhXrzNf+XuUnR4eAxstC9c/qiy3QtcgAdV/wKUHDIpacRWqx5975sOPQLu0y6BlTaygykLFZ4PlRJEdF5oZS+Ugk/2eIzNL9eDjf4gcaJFQZetE2Nii7ap3aW+T0jR6N8Tl1AeZJ0+zg2V0uFFAVTkZww9QuYZK30f8xtYIKejkzjQe9lVWiNLVG4K9ao7rwL58uS9L8esSG2hSK0B8x4up9MtdrO1jnxNdNZb91lcJEAkzXAGDszTFszN5osfQFZiwXn78Ww3IWTZmOx+MYvlHvWJAjqUM40w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(6133799003)(56012099006)(4143699003)(5023799004)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUtqQXNlNlFvTi8xWERqK21TbXkwTllCeTIwTnY2b0FwK1ByNE9idGdQU2gz?=
 =?utf-8?B?dHkxUmFVWEpQOFBLRldMRUxxY0lsQUNwSkZHbzZDenlZTjRBNUVQNTQ4MDA3?=
 =?utf-8?B?RGdGVGZNK1UwbTVTaTU2TTNkbUoxYmttWmhSQlkrejVGOHhyYVJhUDlJRU5I?=
 =?utf-8?B?dHVVcDBkUDFKRWhrRVlwMDcxN0FHTFFQUE5WdEh2cUVTZkduSU5qVm1qb2Mw?=
 =?utf-8?B?amZXYzJGMGZ0ZE5aMGVVQ0JGdVd1RGdDMzdDMHhDMSt4ZDlVdm9VU2VsTVFB?=
 =?utf-8?B?aWxwQVZ0SUl1UGZmM05PT21FeVMxQnAvcC9uUlZ6dlBBTWZTZTZ4dFloZnk0?=
 =?utf-8?B?RTVFdElKRVZzYzFVeVFSRjZzK1pMT2RhVXZpTUJDWTk2cGM1WTRRcEcrcXJy?=
 =?utf-8?B?UEVFbkNUZTZ1a055WHFlTS9GUnVrallLdVNFQjFJLyt4SkkzUkxVMldZM3BH?=
 =?utf-8?B?VFoweWcyVGhaSU5VS1orUHVQNmU0QUlSeWhWVWNMSVJXZDAvZjdFc0ZpZDVs?=
 =?utf-8?B?ZXlTWnRnb3EySTBQUFMwSEpvK1B6UElvbnoyTTVCYkQ3YXFac3czVDJ1QzUz?=
 =?utf-8?B?YTNGcDVEWnk2RklRQ09qVldCY1lDOENlSkx3L3UwbmV2eTBEeWNMQm5kMWZO?=
 =?utf-8?B?K3NOcEsvQ1Y4NnpnTExtZ2JraUgxall0WjAvRk9tUjdaSUdWWklRUktPQU9m?=
 =?utf-8?B?Qm11NzYxZ0Z2dDAwMDBZNnllWEhZOUFiOU1iOFRtWkNNcktqblRUMlYrbk5J?=
 =?utf-8?B?MVhtSUhQcURncThCQnlhSm5JVEp1dXZQbUJ6V2o3MTNYTkJsS3Q2Tk9jSStS?=
 =?utf-8?B?Z21Wbm1qdGxnQVU2VCtSbEJWZ20rV1FQdmpEbTdSb1h4YytJMkdqbTdTQjlB?=
 =?utf-8?B?bnlLRWRvRzRsVmlLUGpuYWdMTmxGNkQ2Sko1WFdwVU9Qc3ErS0NWK0dwQlpF?=
 =?utf-8?B?R3hEcjVlMTkzUVpHUGM2dnU5Zkx6MExKclpIVFh6djRrNW45eVdxZGJqcFJr?=
 =?utf-8?B?ZGUrdmgyR1Z3ZGZIVnpRdUpwcTQvRDRBdzNJVlVWR1lwSDEvZFIrRzZWYXI2?=
 =?utf-8?B?eWJMOVJpMmxQb1Q1eDRsVGRmMGQ2UEF1SGo4OW9CTityanpndU04cWVSdnV1?=
 =?utf-8?B?N1NQYU9HaXNUQmRWcmtlV1k5NUp0N2lKVXJhSGU2bWVuRjVoN0huaHlVdlQ3?=
 =?utf-8?B?YVdRclozY3lSL2xTeEd3azRodVZ4NWE3cXVlNVhMbHpaZ0VFMG5GWEhMRGJq?=
 =?utf-8?B?WlhnOVFtaHViVEgwOTV6TnZnR29RRkdOMFZpS1dRdVB2VGxJL2RBVXdETFJ6?=
 =?utf-8?B?QjRKalc1YUs4dmtnMTlZems0VlNxRXYvWk1QaDlMR1NuclltZTkvc1NmUmVq?=
 =?utf-8?B?dlVsZlo2ekk0WnpnTFhOa1F6S1R1dzZjdGUzZExadzFqOEhmTms2UVVISlcx?=
 =?utf-8?B?dysvQ1FvZFo4bGlWU2NiQUUyMDVrRDhCQzhJWi9RUi8yTVRDSmpDVHFWQ2xS?=
 =?utf-8?B?TFh0R055b0dVaFluSFRzNmt1WUhiVFk4aGxEcm9DSXBLeGIydlJCZ2hiNHlh?=
 =?utf-8?B?M2VUTWJFTkVSbllQSzZhYXFpdXdrTm40NlUwaGxwTnBNWEZhZTNVbG9WVmdE?=
 =?utf-8?B?STJzVmZOS0VtTm9qQVdTL29ZYmw5NUpncnlIUHBYZVZIbUdTRHlBbFhhTEkz?=
 =?utf-8?B?SjI0YmxJRGJzUHI3eGxuV2kxejV0TWo0Mms4OFZPSWpaRVlBMjZNVjdsakJE?=
 =?utf-8?B?VXpUUUNLY0N1bytEUXFYdFBtYllHeWthS2tWQmdRSjMrc3ptd2JqbGJ5cTZF?=
 =?utf-8?B?Mm1sZ3c0Q0h2cWVZbHJNTTNLUHU5ZUt1cmdHMEZZeVFjbmlVREkrajhVeEF2?=
 =?utf-8?B?RWVzSFFQbHpvY0dkZFozL3ZwN0cxVU9FOVdBUHBUK2J4UG1vWUVWcmlZd1NF?=
 =?utf-8?B?UE4vZlJ0bWd2Y3ZoNzNoS1VsV0hkb2FqdzhMdWtLcWhycW91UXVhd0pvQlNI?=
 =?utf-8?B?TUlheWYzY1lCS3RLc0pGZm9ibXhERDlCNXBYUzFYdjVqcXdnSmUxQisvdzZm?=
 =?utf-8?B?UXhqK3BuZDRJbDJ5UWVqWDZGUVVrcy8xTTE3eVNmRExySXloZE5rdE1HRitY?=
 =?utf-8?B?Sml5Tmk0NjhKUTdUSmgrd1JJU1NjdTV4Q0JYcHZMYmJFSEovUkxnM0YvaG00?=
 =?utf-8?B?elNTZ3hLWnRYV1BWSXUvSFFTbFlRZmxacGZYZ2x2VS9abEFkcGlvTWF2QWZw?=
 =?utf-8?B?bEdVSGtFbnJaeFR6cGYyQjVhR1JCK1FDcjJsYTRZUlNDSllZWXdpWGNWODBq?=
 =?utf-8?B?T2VZeGtWL09nSWM2Ti9QSitQUUtXeUUvWFhsenQwdnNENXFwL2Fldz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa1beb8-e12a-45ac-16ee-08def2ed8fed
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 12:32:07.1801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xTxb2UpkJOECGwikZz1vQ8loFPYMHqpNLNih2VJeWj5vN0/0tNFVusoLAnheJqtdwrlceqOghKHCDMHfqO4WWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB5915

--figpxhk5rpxgi2te
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v4] security: Expand task_setscheduler LSM hook
MIME-Version: 1.0

On Tue, Jul 21, 2026 at 07:45:41AM -0700, Casey Schaufler wrote:
> On 7/19/2026 6:41 PM, Aaron Tomlin wrote:
> > At present, the task_setscheduler LSM hook provides security modules
> > with the opportunity to mediate changes to a task's scheduling policy by
> > inspecting the requested sched_attr. However, when invoked via
> > sched_setaffinity(), the hook lacks visibility into the actual CPU
> > affinity mask being requested. Consequently, security modules are
> > entirely blind to the target CPUs and cannot make granular access
> > control decisions based on spatial isolation.
> >
> > In modern multi-tenant and real-time environments, CPU isolation is a
> > critical boundary. The inability to audit or restrict specific CPU
> > pinning requests limits the effectiveness of security policies,
> > particularly when attempting to shield isolated or cryptographic cores
> > from unprivileged or compromised tasks.
> >
> > This patch expands the security_task_setscheduler() hook signature to
> > include a pointer to the requested cpumask alongside the existing
> > sched_attr. Because this is a shared hook used for multiple scheduling
> > attribute changes, call sites that do not modify CPU affinity are
> > updated to safely pass NULL for the mask. To protect against unverified
> > dereferences, the parameter is annotated with __nullable in the LSM hook
> > definition, ensuring the BPF verifier mandates explicit NULL checks for
> > attached eBPF programs.
> >
> > Historically, SELinux has governed all scheduling alterations under a
> > single, monolithic PROCESS__SETSCHED access vector. However, by
> > inspecting fields such as attr->sched_policy or attr->sched_priority, a
> > security module can introduce granular access controls. For instance,
> > differentiating between standard time-sharing policies and
> > latency-sensitive real-time policies.
> >
> > This change updates all in-tree security modules (SELinux and Smack) to
> > accommodate the new parameter mechanically, while providing LSMs with
> > the necessary context to enforce strict affinity policies.
> >
> > Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> > ---
> > Changes since v3:
> >
> >  - Expanded the task_setscheduler LSM hook to accept the 'sched_attr'
> >    payload, enabling BPF and other LSMs to inspect scheduling attributes
> >    (Peter Zijlstra)
> >
> >  - Updated all call sites for security_task_setscheduler() to correctly
> >    pass the attr structure when available, or NULL otherwise
> >    (Peter Zijlstra)
> >
> >  - Added the necessary forward declaration for struct sched_attr to
> >    include/linux/security.h
> >
> >  - Linked to v3: https://lore.kernel.org/lkml/20260526142838.774711-1-a=
tomlin@atomlin.com/
> >
> > Changes since v2:
> >
> >  - Dropped patch 1. This is to be addressed by the cgroup cpuset
> >    maintainer (Waiman Long)
> >
> >  - Dropped patch 3. Will be submitted as a separate patch (Paul Moore)
> >
> >  - Linked to v2: https://lore.kernel.org/lkml/20260509213803.968464-1-a=
tomlin@atomlin.com/
> >
> > Changes since v1:
> >
> >  - Reordered the allocation and user-copy of new_mask in the MIPS
> >    architecture's mipsmt_sys_sched_setaffinity() to occur before the
> >    LSM hook is invoked. This ensures the security modules evaluate a fu=
lly
> >    populated mask rather than uninitialised memory, while cleanly handl=
ing
> >    error unwinding
> >
> >  - Updated cpuset_can_fork() to pass the destination cpuset's effective=
 CPU
> >    mask instead of NULL
> >
> >  - Linked to v1: https://lore.kernel.org/lkml/20260509164847.939294-1-a=
tomlin@atomlin.com/
> >
> > Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
>=20
> For the (trivial) Smack changes:
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

Thank you Casey.

--=20
Aaron Tomlin

--figpxhk5rpxgi2te
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmpzLUMACgkQ4t6WWBnM
d9Zf+w/+ILuBMrjK1tRpjLojddWCTDkzwwS7/zPizufqmhj4yGKKUfg1/af/xh3d
pGG58y3DqEkHldjWX4JzlKCkH6B2mZUpOLF84Kj+XHNF5e9RhVaRAalmW9sS26X+
9L10XGY1hMNOp88fZl6Az3w+4n89d0C0XRkTsU5mL4sdKQPflwMDFiy9mcEAxs8T
qYzYFAuc5y7QLCSUPrUefi1nbHXDDtorDt+ohFCwhjxSZvcNJiXSVGMJPWCI9iNZ
FotLk4J/my7TKxsoQJxyFIp3A+OkNHgwrPp/usmEREtk7qq1nvvYGLB5PpjBdWw1
OuGJu9vwTK8Qvcn3pGHOGO2MG21p6PFdGQjg6f2gtD2bjxte/aom6sRHq3W3BXbm
kTuljDJJKdSWskU7WCw2XncO6h+qThorjAC9BGOntHZG1qJLOl0UYP5CK8rulJD4
cQYmKQATuLp64Ehs+KmGJ6i79j01+hq0BOhd3GMrkjm6FAb0UXJqyWjoGcrNdKmO
z860bY85hm9RN1LdVxcPg0YjGRaSocRxQYdkqkBsTrFwO9TErS/GGwkf/XoIPjOY
K9Qmxn7ZeS3cMrwY+2kmR6xnz9AY55uvNRqgIvM2tDjYyjzRoZrPUUOZjFb5JjDj
U81XsUl1bYnlu6YxMR5jWL/FAtcKYV996Wst/szmmeGtJZwIPI8=
=ghWr
-----END PGP SIGNATURE-----

--figpxhk5rpxgi2te--
