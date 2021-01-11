From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: Fix typos found in cgroup-v2.rst
Date: Mon, 11 Jan 2021 12:58:59 -0700
Message-ID: <20210111125859.392a5bba@lwn.net>
References: <20210107141118.9530-1-benbjiang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net CB4C39A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1610395141; bh=yf8HXOWRvdcuSnkyWSAQrcyC0WoHCnnhgqdxfI1KLHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o0Dwx6XAsQldlWrc8nl1E00cGU3JDMHBOz/DG7sQGIyNcvRvgPYmY2R77c7IxEOnN
         EruGAbSIBfDJLP5dxLtsQyQJBYRKwhhWcYcPfApEffams/+YCPWbVpNz9Y8otFQcVu
         6P6lj7F01H9EpiHey0/y4TgZCC9v+nPr+GQH4oz+dyFW32JFHAtmgHdFjQdVPUX5tl
         tIqw4M1DLaCf4N/FQw+Jz77up7FOQDZYrZDk0DEWfHB2bsKxPkk5JdqNnHka/DmqFa
         Pc5MnrelFPb9Jg6Yc5oV8YouOvIeORonfPysqbTVJ8HXPL/n3W4yHVy8X+C6tGVdud
         iuO5UMYPY8iRg==
In-Reply-To: <20210107141118.9530-1-benbjiang@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jiang Biao <benbjiang@gmail.com>
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>

On Thu,  7 Jan 2021 22:11:18 +0800
Jiang Biao <benbjiang@gmail.com> wrote:

> Fix typos found in Documentation/admin-guide/cgroup-v2.rst.
> 
> Signed-off-by: Jiang Biao <benbjiang@tencent.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 63521cd36ce5..e0f6ff7cfa93 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1558,7 +1558,7 @@ IO Interface Files
>  	  8:0 rbytes=90430464 wbytes=299008000 rios=8950 wios=1252 dbytes=50331648 dios=3021
>  
>    io.cost.qos
> -	A read-write nested-keyed file with exists only on the root
> +	A read-write nested-keyed file which exists only on the root
>  	cgroup.
>  
>  	This file configures the Quality of Service of the IO cost
> @@ -1613,7 +1613,7 @@ IO Interface Files
>  	automatic mode can be restored by setting "ctrl" to "auto".
>  
>    io.cost.model
> -	A read-write nested-keyed file with exists only on the root
> +	A read-write nested-keyed file which exists only on the root
>  	cgroup.

Applied, thanks.

jon
