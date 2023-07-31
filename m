From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] docs: cgroup-v1: replace dead CONFIG_MEM_RES_CTRL_SWAP
 symbol
Date: Mon, 31 Jul 2023 09:55:22 -0600
Message-ID: <87o7jsdqj9.fsf@meer.lwn.net>
References: <20230728105723.251892-1-krzpaw@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 164D92C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1690818923; bh=dtzt/1jmMl4ga6TG3AzFsLIjNNRRFlSVYKzq/KA6aHE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=nYMA56oTwm5Bop7XCKDoHg3GVBw08llGFlzSEtzk9O36IZtYIWDQF3rDAQWBxAGKk
         +MNlYbRw4GXjnCCwATwkmhuZMXdvWVobLuVXevNhMBR7rjZvA1M3zwtI3irCuvrs30
         qFeeWxSyqBA4FV1tas9lcBbGpYmTwwz+aNz2y0NR6G+633oKRy1fjjSAXoVIIH+QoU
         hgWWrfgkLtupN2uI7StwPwS3Ky8Bnyuf//DDOG25UwepaDM36UD9HwedPppDML2OTk
         uGKQRJqCxAKGuszQtHIs73dcyJ4lgk2YOp9ZctnuMUthsWHWgPv5vCKdwbayRdaKE1
         fP0MMfyiZzOxw==
In-Reply-To: <20230728105723.251892-1-krzpaw@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Krzysztof Pawlaczyk <krzpaw@gmail.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, lukas.bulwahn@gmail.com
Cc: Krzysztof Pawlaczyk <krzpaw@gmail.com>

Krzysztof Pawlaczyk <krzpaw@gmail.com> writes:

> Commit e55b9f96860f ("mm: memcontrol: drop dead CONFIG_MEMCG_SWAP
> config symbol") removed MEMCG_SWAP as it was just a shorthand for
> CONFIG_MEMCG && CONFIG_SWAP.
>
> The commit also adjusted the documentation but missed reference to
> CONFIG_MEM_RES_CTRL_SWAP, which was the previous name of
> CONFIG_MEMCG_SWAP before renaming in commit c255a458055e ("memcg: rename
> config variables").
>
> Update the reference to the current state.
>
> Signed-off-by: Krzysztof Pawlaczyk <krzpaw@gmail.com>
> ---
>  Documentation/admin-guide/cgroup-v1/memcg_test.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v1/memcg_test.rst b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
> index a402359abb99..1f128458ddea 100644
> --- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
> @@ -62,7 +62,7 @@ Please note that implementation details can be changed.
>  
>  	At cancel(), simply usage -= PAGE_SIZE.
>  
> -Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
> +Under below explanation, we assume CONFIG_SWAP=y.
>  

Applied, thanks.

jon
