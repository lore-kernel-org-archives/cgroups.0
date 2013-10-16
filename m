From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Wed, 16 Oct 2013 11:53:44 -0400
Message-ID: <20131016155344.GA10012@htj.dyndns.org>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
 <20131015173252.GM31215@redhat.com>
 <CAA7+ByWjdYTi5uXT6apLYkON1RnrFEGjHU318OD1VMen2YHKOA@mail.gmail.com>
 <20131016141405.GE17611@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=AbpzDxG2wdILh5i9jKIukGgfBWFghhP0P0urfweALto=;
        b=MC8qyC82nE9vI8CxzorfWp/WAtALYxQpF7YRSvArMR5ulJonb9X2Y+xVUSGKxCY8hl
         SR4wwau2D62n6x+H8bYVcvDchyBPkq0F7VZeTr9TzKcJA+Tn4iJ1DJ6RXnxkcdvUDhCz
         I+UjIyK+imxfvM2eXUJAL+PYJyuWjMpL50rHbqb/WxVcf+V8TIEGEOoRDJp1/RYJ/pkH
         5ZWsif3fIRwrFaPP4VcYAEJ6cKoJtjVwY32/5U9Ftg6qagNQUUjSr3KCnt0o+WJsxpss
         9bPLovTdmUktPzwJ1UNiCZHshw6tbHpGooEjRA7z0Z8nETrtnzfDjeTdSPGWN8EQ2hwA
         g0Pw==
Content-Disposition: inline
In-Reply-To: <20131016141405.GE17611@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Hong zhi guo <honkiko@gmail.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>

Hello,

On Wed, Oct 16, 2013 at 10:14:06AM -0400, Vivek Goyal wrote:
> - First of all, if you think that a group is entitiled for tokens even
>   when it is not doing IO, then why are you truncating the tokens after
>   dispatch of a BIO.
> 
> - Second in general it does not seem right that a group is entitiled to
>   tokens even when no IO is happening or group is not backlogged. That
>   would mean a group will not do IO for 10 hours and then be entitiled
>   to those tokens suddenly after 10 hours with a huge burst.
> 
> So I think you also agree that a group should not be entitiled to
> tokens when group is not backlogged and that's why you seem to be
> truncating extra tokens after dispatch of a BIO. If that's the case,
> then even for first BIO, ideally a group should not be given tokens
> for idle time.

Without going into details, having token reserve is an important part
of token based implementation.  The large the reserve could be
debatable but that's what provides "smoothing" of allocation.  e.g. if
you trim bucket as soon as the queue becomes empty, a queue with
sequential access pattern can easily get disadvantaged.  Another way
to look at it is to consider as though the IO has been issued some
time before than actual and waited for the token - it is the same to
external observers.

So, while how large the reserve should be is definitely debatable,
bucket scheduling *needs* idle reserve.

Thanks.

-- 
tejun
