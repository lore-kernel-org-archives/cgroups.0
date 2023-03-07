From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup/cpuset: Minor updates to test_cpuset_prs.sh
Date: Tue, 7 Mar 2023 21:46:43 +0530
Message-ID: <3a302f40-2c2c-daa2-4281-39b1ff7e90ea@oracle.com>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-6-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=e3pAQn8G/8o92/hXaSer4SORAE+oWEq8UvZOMfliD3c=;
 b=yWfAlil/ScUJlI0wC+Ch/gWSWl/xbOaUmjBzILVucRM24SLwNzczCOX6y5tEXcqlWlLS
 rE1ZzZSANkVQWqhUHcGZHYMfkHVllvL+L7w2/TX/6QeY33K2zYbt7zDdAiJEnWiyu+vA
 9i/YoV3zorO2Snu/e+pervEPKIxHFNQjYWneT6U56kIaxGq9k1tTIsJ0Dyiw6kHBePxa
 BPZ/A6JzOwttjenycnpRvmcvKeO5mk1eu8faToUzQZXTy6QZ8R8e5KW5+wBJNylS0tHo
 roP6nWAAJ0bfKuGbSS5wDeERXF9ivCFatdBRUorFTMcdKYAQbw0AbZnmYMx1v1OFIrdf zw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3pAQn8G/8o92/hXaSer4SORAE+oWEq8UvZOMfliD3c=;
 b=Vr3fsHqrQ8pMvs6LsNbnl324qbotY1Lwefp3Lm3f8+nRLmcRaEsclgOfI8/fKgmsq5wp9WSBgECX347QrEn2N+bSsqSlsDrl1JgarB8+MShhFqqV0BgLTIFwtfwiVzrAhpv1KMRDky3gdyLDiuwBokYwz7YFGhN+ksiy6v3qW0U=
Content-Language: en-US
In-Reply-To: <20230306200849.376804-6-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>


On 3/7/23 01:38, Waiman Long wrote:
> This patch makes the following minor updates to the cpuset partition
> testing script test_cpuset_prs.sh.
> 
>  - Remove online_cpus function call as it will be called anyway on exit
>    in cleanup.
>  - Make the enabling of sched/verbose debugfs flag conditional on the
>    "-v" verbose option and set DELAY_FACTOR to 2 in this case as cpuset
>    partition operations are likely to be slowed down by enabling that.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

