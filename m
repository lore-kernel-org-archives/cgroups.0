From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH 04/10] docs/scheduler/sched-bwc: add proper ref
Date: Wed, 20 Jan 2021 10:43:01 -0700
Message-ID: <20210120104301.2aeda8f9@lwn.net>
References: <20210120001824.385168-1-kolyshkin@gmail.com>
        <20210120001824.385168-5-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 041346133
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1611164583; bh=t10z/9IsGKuL0EHjMm0YRCyX2MRbbRcllIYkA3Oblow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=InB65MkkxlBevNgPOKeV8RBG//YJUhsA2r8PVWvyNp2Mw5g/HNf5JeJ4xBBrfpNeo
         YLiRFHpJjNRbBK2QfAcWa0TIPN6QdapdsXeur7r+4kbN9572oTXcIUFMchzrhQsGEU
         JQ1/Xhp0vafrkWbJZg2tqjanqpyh6jlrzQXz480/KsYbpLwDrlNOinLdq7MVyCC2sO
         8vlZ/cJNL19q9y6bW+1P8ey8JE8ZPHBiVKBXNc2+JUKEG9gqrvg5s0gaAO/SNyorrS
         OPybZ7wtWIQwUAJWcusMDEVgpkFhNQLzeCkxX9k36h+d2ob6LB/VVKBYBykRWTRHsk
         1ynMQWpV/glHg==
In-Reply-To: <20210120001824.385168-5-kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 19 Jan 2021 16:18:18 -0800
Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Add a proper reference instead of just using the file name.
> 
> Signed-off-by: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/scheduler/sched-bwc.rst      | 3 ++-
>  Documentation/scheduler/sched-rt-group.rst | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/scheduler/sched-bwc.rst b/Documentation/scheduler/sched-bwc.rst
> index a44860d33ffc..dcec7440c222 100644
> --- a/Documentation/scheduler/sched-bwc.rst
> +++ b/Documentation/scheduler/sched-bwc.rst
> @@ -4,7 +4,8 @@ CFS Bandwidth Control
>  
>  .. note::
>     This document only discusses CPU bandwidth control for SCHED_NORMAL.
> -   The SCHED_RT case is covered in Documentation/scheduler/sched-rt-group.rst
> +   The SCHED_RT case is covered in
> +   :ref:`Documentation/scheduler/sched-rt-group.rst <sched-rt-group>`.
>  
>  CFS bandwidth control is a CONFIG_FAIR_GROUP_SCHED extension which allows the
>  specification of the maximum CPU bandwidth available to a group or hierarchy.
> diff --git a/Documentation/scheduler/sched-rt-group.rst b/Documentation/scheduler/sched-rt-group.rst
> index 655a096ec8fb..a3b4aa51c271 100644
> --- a/Documentation/scheduler/sched-rt-group.rst
> +++ b/Documentation/scheduler/sched-rt-group.rst
> @@ -1,3 +1,5 @@
> +.. _sched-rt-group:
> +

So why do you need to do this?  The build system in recent kernels will
generate that reference automatically without the extra markup.

Thanks,

jon
