From: Hong zhi guo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Mon, 14 Oct 2013 21:53:54 +0800
Message-ID: <CAA7+ByWPM2Pizm+dP1AxPM7Ut-w=AtRfD2GkCK-0OVh+C2Twkg@mail.gmail.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
	<1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
	<20131014133620.GF4722@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=0jwMFJanRLp8iPvNcsZ77Ys4bxXuz8HY2OzjjUIPSxM=;
        b=KZ+zbVa7g+qsS8u5npDhahcvM3fitCUOtoM0V1uRvpQQF3jsYBdoI8I1Y9Ury0GQPP
         3tU9N3G2hCpj+6h/RpQKYSf1xa8KCaKKNvxe2AjyXAwPUL1HEfYoDx3WK/iUUZTmeKUI
         j9PbuGdT7ZRVxWiGzv11/wxJK0rI9VFKJY4/LbZAea1cOY6WRQSnVPxqI+XLDli7a/D6
         7Cuf+iQlqtzx/4Hzl9AvY3JkbDs4QI5ux46BI7Odv1uxD4AEpFL0oeu+wXR76iyAHZwz
         iGMbHNfRjcxskBaepZkzgyDl3twVaCzo5iP5mTRL94PS97UR9VoLiLVaY9CnbsvIypRo
         j05Q==
In-Reply-To: <20131014133620.GF4722-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Hi, Tejun,

I've not tested hierarchical setup yet. I'll do it tomorrow.
BTW, what kind of setup do you expect? Is hierarchy of 2 levels enough?

Zhiguo

On Mon, Oct 14, 2013 at 9:36 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> Yes, this definitely is the direction we wanna take it.  I'll wait for
> Vivek to chime in but have you also tested hierarchical setup?
>
> Thanks.
>
> --
> tejun



-- 
best regards
Hong Zhiguo
