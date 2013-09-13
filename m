From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cfq: explicitly use 64bit divide operation for 64bit arguments
Date: Fri, 13 Sep 2013 09:20:45 -0700
Message-ID: <CAOMFOmV-MxF5vQqL1y4yY45LebFXA2DP7fsJx5CZcF+SSe6f7w@mail.gmail.com>
References: <1377883916-8957-1-git-send-email-anatol.pomozov@gmail.com>
	<1377885149-28208-1-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=9gXHqt/0J5Jgr+iHoLpYWkXnQQ8W/yCnTuC6sbjUrwE=;
        b=nlET7toFetXFtwsB6V16EY53Yh5nJU5pyC9VIVBB3YQJlW8SGMw0lxeaLn5fZdiH+Z
         xu/MdukZZckUck6rI+d9Rnv8OeuY7gPAbwkPirrlzzTKszQ5diLRdaYx3Z53XWYfFZOm
         pjhlI/dqYffDQAnqnYvwrc9uJuwt+1UxnV6pADSgL8lVh3hl0KJEkCYMKwgCJGlheVcb
         Kqux0bnKXdLMPWrKd2BZ7WmBzmQlapq2U/TLqDpNG5/G9yzaMr7p+/iRIezMYiP9pOhn
         pyQzCTuQVPofpT7VU7nCA7BTdtKC/6Xyu3zyIPxRpUgOkncJavBEeS8b7U2kTajwtdAT
         wzlw==
In-Reply-To: <1377885149-28208-1-git-send-email-anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi, Tejun

On Fri, Aug 30, 2013 at 10:52 AM, Anatol Pomozov
<anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 'samples' is 64bit operant, but do_div() second parameter is 32.
> do_div silently truncates high 32 bits and calculated result
> is invalid.
>
> In case if low 32bit of 'samples' are zeros then do_div() produces
> kernel crash.
>
> Signed-off-by: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  block/cfq-iosched.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d5bbdcf..c410752 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1803,7 +1803,7 @@ static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
>
>         if (samples) {
>                 v = blkg_stat_read(&cfqg->stats.avg_queue_size_sum);
> -               do_div(v, samples);
> +               v = div64_u64(v, samples);
>         }
>         __blkg_prfill_u64(sf, pd, v);
>         return 0;

what do you think about this patch?
