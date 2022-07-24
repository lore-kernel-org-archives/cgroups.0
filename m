From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] selftests/cgroup: fix repeated words in comments
Date: Sun, 24 Jul 2022 08:52:45 -0700
Message-ID: <63f42f9440b9d6d2f3e70902764e7a0c36e2f822.camel@perches.com>
References: <20220724070435.7999-1-wangjianli@cdjrlc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20220724070435.7999-1-wangjianli@cdjrlc.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: wangjianli <wangjianli@cdjrlc.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, shuah@kernel.org
Cc: cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 2022-07-24 at 15:04 +0800, wangjianli wrote:
> Delete the redundant word 'in'.
[]
> diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
[]
> @@ -740,7 +740,7 @@ static int test_cgfreezer_ptraced(const char *root)
>  
>  	/*
>  	 * cg_check_frozen(cgroup, true) will fail here,
> -	 * because the task in in the TRACEd state.
> +	 * because the task in the TRACEd state.

presumably "is in"

>  	 */
>  	if (cg_freeze_wait(cgroup, false))
>  		goto cleanup;

