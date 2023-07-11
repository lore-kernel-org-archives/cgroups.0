From: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Subject: Re: [PATCH] cgroup: put cgroup_tryget_css() inside
 CONFIG_CGROUP_SCHED
Date: Tue, 11 Jul 2023 12:50:15 +0530
Message-ID: <eafa31d1-9ead-75eb-a715-9012c233daa9@oracle.com>
References: <20230711023820.3854596-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ebLVeOUlpytLFAmzJ5EjQmskib1IpMrPVPaYwst7VIg=;
 b=xCgkVOpu6rMN/02MbTltLES360G2ZbnGLXv7rCutZiAwRRmLGQVinuvZdKoc6M3WdHh3
 s793kQtFbO/CM5eF/02Yd7zWCkAlO4bzZBy+AQ9dK+VcK+CmaSsb/2EZGkHjEtUBHyXS
 lbKh7M7kUOd9oaflMx5On0oklJO/lGoQPqOdM0U9yBuwZV3ZcM7eCRGSIKFFzWSFt6NY
 pmOfGV1/hkL628DpAyFitowzGM/SF0ZaW2GiJdW2F2NjxfrnOdVQvMnd0NUrpudJXDZh
 Tc+XbdDEFUbvltB2k3JF4CF0f0BpeNPJqnzI0rZCjnsDQ0cXHbxf6yd3ZOMUS5eKZTlF pg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebLVeOUlpytLFAmzJ5EjQmskib1IpMrPVPaYwst7VIg=;
 b=g62R17IMMVaoCGVN1cdF6ck8gm50qb7Sj9dlNChq6/R0s3QQjoRau0WhiR4RSS/dmYhvbDfAPiutdGX8Qqpx9lXnuHHcNtsmX1ObURR+Z63YcUQw6m6KbAGFsZ51VfcZlLk3v25HBSz5VIIvzJfCz5ARzHlBAFZp/AtgFDITWZo=
Content-Language: en-US
In-Reply-To: <20230711023820.3854596-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Miaohe Lin <linmiaohe@huawei.com>, tj@kernel.org, hannes@cmpxchg.org, sfr@canb.auug.org.au, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org



On 7/11/23 08:08, Miaohe Lin wrote:
> Put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED to fix the warning
> of 'cgroup_tryget_css' defined but not used [-Wunused-function] when
> CONFIG_CGROUP_SCHED is disabled.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  kernel/cgroup/cgroup.c | 44 +++++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)

Looks good to me, given that the only caller cgroup_extra_stat_show() is
guarded within CONFIG_CGROUP_SCHED (linux-next tree), it makes sense to,
also move cgroup_tryget_css() within the same ifdef block.

Reviewed-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>
