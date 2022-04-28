From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: add missing angle bracket in cgroup-v2
 doc Tejun Heo <tj@kernel.org>
Date: Thu, 28 Apr 2022 12:36:28 -0600
Message-ID: <87pml15a37.fsf@meer.lwn.net>
References: <20220422164526.3464306-1-jsavitz@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 01F0637A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1651170989; bh=XPxBsOv3MHPpWdaP+RHY5sGiWu6noKHQxvTjG9bbEUU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HuF2gwly9ra7GSKC9Ok41SvRF0iV8QH8/JUjflHrj+kqMK9VZwdzo0+t3SyEfpHMb
         cPEH44p+bF2X6bC9rawA95KHX/CqhKB8dB9wfmrDT43yfz1I1zvoWEh2aWzUXn/Arw
         PINF+cuEyRmWEVBKo1yXGPuArok+2NbIcNKjfIzWxjn3MAG6oXApAFQYQa5So7trI/
         YygHgHtWAHTioDUwJUOhwGHwFudxGmNvoRvIGPIvwYgYiluolilCNy9+xOBJYTk7Zq
         co9QBJqyr3X8DU4X7rIF0UTnTU/zna/VCGtdE35PjGLTO7+jG4KcWfKic123HpYIkF
         ryqIS9C7SZJcA==
In-Reply-To: <20220422164526.3464306-1-jsavitz@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Savitz <jsavitz@redhat.com>, linux-kernel@vger.kernel.org
Cc: Joel Savitz <jsavitz@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, trivial@kernel.org

Joel Savitz <jsavitz@redhat.com> writes:

> Trivial addition of missing closing angle backet.
>
> Signed-off-by: Joel Savitz <jsavitz@redhat.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 69d7a6983f78..38aa01939e1e 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1881,7 +1881,7 @@ IO Latency Interface Files
>    io.latency
>  	This takes a similar format as the other controllers.
>  
> -		"MAJOR:MINOR target=<target time in microseconds"
> +		"MAJOR:MINOR target=<target time in microseconds>"
>  
Applied, thanks.

jon
