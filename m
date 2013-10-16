From: Hong zhi guo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Thu, 17 Oct 2013 00:22:11 +0800
Message-ID: <CAA7+ByWOzuE64G0g2kxwQ2Q5-Mx=Yd3t+ErhL8FDp66_UuAbTw@mail.gmail.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
	<1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
	<20131015173252.GM31215@redhat.com>
	<CAA7+ByWjdYTi5uXT6apLYkON1RnrFEGjHU318OD1VMen2YHKOA@mail.gmail.com>
	<20131016141405.GE17611@redhat.com>
	<20131016155344.GA10012@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=nIpV+Se0tgwun6A2ac9nw03N9YvhIZbnJf0BRiTd0Q8=;
        b=nQaQPY1QrVKPFQU2RcAcjSTAjNZAgX5WruT8Jl1fSiPImlSyluNmpj7jJJc4pe4Vh4
         kyqbb+Zvv6iyNjgMSjkyQ6mOxqiTtZ3IumeFZBzFvc70fjjS1XGAXQDI7fQg3svhPOnp
         OWHAFYxBYTf2eqDfC0L1adUWCTMNTdLEFyiIOmA/RawgiGzk0lK9fAxFSqA+yWYAsVIC
         PymvY8waA/15OPRu5gmkO90be5K90pV2tOUWTXODqXGMJExxA7DB3uj//HPHzReSqZ3G
         ruSxRAehet+yqG46Tg6PcJftUD6ZKgD8hiL416Y7Tyi32tpbIdKfPeMDxRtkqAGsgdTA
         u/MA==
In-Reply-To: <20131016155344.GA10012-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

How about take the basic token bucket algorithm first, and consider
optimize options later? Such as:
 - limit the idle reserve
 - change the static depth of token bucket
 - calculate the depth of token bucket according to configured bps rate
 - export the depth of token bucket to user space

On Wed, Oct 16, 2013 at 11:53 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Oct 16, 2013 at 10:14:06AM -0400, Vivek Goyal wrote:
>> - First of all, if you think that a group is entitiled for tokens even
>>   when it is not doing IO, then why are you truncating the tokens after
>>   dispatch of a BIO.
>>
>> - Second in general it does not seem right that a group is entitiled to
>>   tokens even when no IO is happening or group is not backlogged. That
>>   would mean a group will not do IO for 10 hours and then be entitiled
>>   to those tokens suddenly after 10 hours with a huge burst.
>>
>> So I think you also agree that a group should not be entitiled to
>> tokens when group is not backlogged and that's why you seem to be
>> truncating extra tokens after dispatch of a BIO. If that's the case,
>> then even for first BIO, ideally a group should not be given tokens
>> for idle time.
>
> Without going into details, having token reserve is an important part
> of token based implementation.  The large the reserve could be
> debatable but that's what provides "smoothing" of allocation.  e.g. if
> you trim bucket as soon as the queue becomes empty, a queue with
> sequential access pattern can easily get disadvantaged.  Another way
> to look at it is to consider as though the IO has been issued some
> time before than actual and waited for the token - it is the same to
> external observers.
>
> So, while how large the reserve should be is definitely debatable,
> bucket scheduling *needs* idle reserve.
>
> Thanks.
>
> --
> tejun



-- 
best regards
Hong Zhiguo
