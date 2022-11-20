From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix typo in comment
Date: Sun, 20 Nov 2022 22:08:59 +0530
Message-ID: <819bdb10-2569-b7b1-b75b-168b77d1959f@oracle.com>
References: <20221120155134.57193-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BwPMjvgEKJvf5iL/jRJ8hetzGrMpHPjuJ1RcuDoeJvg=;
 b=FXEkXI9mAmHjxlturQUELOjDAmimbCBIfiIHvgRDODA05HrI1d7i3iyxStvAw9duFJkn
 vfRRQCTVsXv5fJQA2ZPhyBGKyqDyw7q1IrWOKGLsABRGSWmlR3LgLCvRT+c9Zw4COJQs
 Ur0423mN/zYe8EfL2+hLwjtNlpU1UH3Mr9M3bsTuDz7rBEScGffGSlG9XEjBl0N1scM/
 pVypb7K1vsZqt1/Jl21DEf4w120Ew6TEGNe2yayQmDddq4UjjqIXvPIp/8550AZVveBr
 /qGS5rlxWURM/5O7B2GtzMTT2HLRCRyIAUJnJagDUNB1+8tKdcwhLUAvaH9zUm37pv6I vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwPMjvgEKJvf5iL/jRJ8hetzGrMpHPjuJ1RcuDoeJvg=;
 b=0TDvinETzLHq7vG+XxN9wtGP4HN65Br3bWdGyXHXbwr04jtK3F/GdotxD6XVoIRTKzIF10J8farF6YaZJZSWibrdhEx5rlyGLq/0J9a4XGOFN7KS/dbbMQhmFHXhd5ruGF4WxcnpCRDKC/fZyUQXQM9VrF34bEcoqcd5Xmz16Ok=
Content-Language: en-US
In-Reply-To: <20221120155134.57193-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 11/20/22 21:21, haifeng.xu wrote:
> Replace iff with if.
> 
> Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index f2743a476190..93c5e50b1392 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -814,7 +814,7 @@ static bool css_set_populated(struct css_set *cset)
>   * One of the css_sets associated with @cgrp is either getting its first
>   * task or losing the last.  Update @cgrp->nr_populated_* accordingly.  The
>   * count is propagated towards root so that a given cgroup's
> - * nr_populated_children is zero iff none of its descendants contain any
> + * nr_populated_children is zero if none of its descendants contain any
>   * tasks.
>   *
>   * @cgrp's interface file "cgroup.populated" is zero if both

iff abbreviates to if and only if and it's a valid usage.

-- 
Thanks,
Kamalesh
