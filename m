From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH][trivial] memcg: Kconfig info update
Date: Mon, 27 May 2013 12:24:38 -0400
Message-ID: <CAHGf_=pyEP=zJ80HSKAojymSmW=S1s+1QFN663OXD8RtonLVmA@mail.gmail.com>
References: <1369668984-2787-1-git-send-email-dserrg@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=6U1QJScINd5C+reCKAoYJmERe64wy+5vaiw3ZkoLYd8=;
        b=KJCkAnGjh/kDsZacBMQu7LNlbq0fktosScExwb95V2F1q6KyMbAQBz8k0giILkpHnD
         SXibIFNDmbVibm4d3kXmdsMISNPSt1TEQxydWXoc/aE+bWbLyMbvXnCEdVHQhGsnEtXU
         pkR6IUvodq8j+Ag4knnuUNxcQpPLSAsbPGs9EokPg1zapdZxcwh9DhmxVSv8YK0QgxQd
         hT9NnN1LV8s5mxOl0AWbb2viu/iWZ5/oVsp6cds6RlppDtIjZyrYivEOq8vPhKMXl/v3
         bo0Ds/wd28J4y0jtU3cIDEgXyrn70MxT3gni1qtW6kW3dLulxGO96YlWUK6Z6YaeAhcA
         AnDg==
In-Reply-To: <1369668984-2787-1-git-send-email-dserrg@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sergey Dyasly <dserrg@gmail.com>
Cc: cgroups@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On Mon, May 27, 2013 at 11:36 AM, Sergey Dyasly <dserrg@gmail.com> wrote:
> Now there are only 2 members in struct page_cgroup.
> Update config MEMCG description accordingly.
>
> Signed-off-by: Sergey Dyasly <dserrg@gmail.com>
> ---
>  init/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3a788..16d1502 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -876,7 +876,7 @@ config MEMCG
>
>           Note that setting this option increases fixed memory overhead
>           associated with each page of memory in the system. By this,
> -         20(40)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
> +         8(16)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
>           usage tracking struct at boot. Total amount of this is printed out
>           at boot.

Yes, kernel developers often foget to update documentations. Nice catch!

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
