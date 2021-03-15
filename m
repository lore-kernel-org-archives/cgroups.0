From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH] docs: admin-guide: cgroup-v1: Fix typos in the file
 memory.rst
Date: Mon, 15 Mar 2021 13:03:45 -0600
Message-ID: <87im5s2q9a.fsf@meer.lwn.net>
References: <20210313061029.28024-1-unixbhaskar@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 892742E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1615835025; bh=QypNFyeA1Y53RZBH32uQ1ZH1dtdi/T309FCBH6S4fH0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Wa25vhrYYTPme8v9i8z/h4H+WCw9Du519YF597ebySIFfUh6SJsVVzTxf2yyixL+B
         SsBN1xBVB7VCTQvowlwB1mMloRihUDmbX0OByHyHAkWBHzOQLPgILVHLvvlMNSRHkT
         mjGQ4cwNK04rRknRmNvMZeV5bHdTPtAJ+yjNH0h6JjhEOeyZxig6Cw8yIIfpK9I4MA
         EMvfb1uugVcskVKgEQcYvMsKrhfeqJg+O3HmagSX9TAuweeySVqGkX/GDyxeN1KDiI
         MbyxHuxQTi9BcUs/+0v8xmxITu54PKZmR0lGF1EtdzwidAfhlpR3t/cB/J+sq8Uj3H
         mhcweNPe30E1g==
In-Reply-To: <20210313061029.28024-1-unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> s/overcommited/overcommitted/
> s/Overcommiting/Overcommitting/
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/admin-guide/cgroup-v1/memory.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
> index 52688ae34461..0d574fd3f8e3 100644
> --- a/Documentation/admin-guide/cgroup-v1/memory.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memory.rst
> @@ -360,8 +360,8 @@ U != 0, K = unlimited:
>
>  U != 0, K < U:
>      Kernel memory is a subset of the user memory. This setup is useful in
> -    deployments where the total amount of memory per-cgroup is overcommited.
> -    Overcommiting kernel memory limits is definitely not recommended, since the
> +    deployments where the total amount of memory per-cgroup is overcommitted.
> +    Overcommitting kernel memory limits is definitely not recommended, since the
>      box can still run out of non-reclaimable memory.

Applied, thanks.

jon
