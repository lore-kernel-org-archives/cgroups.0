From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Wed, 13 May 2015 13:29:06 -0400
Message-ID: <20150513172906.GY11388@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-5-git-send-email-cyphar@cyphar.com>
 <20150422162954.GF10738@htj.duckdns.org>
 <CAOviyagHJhxD8E+CeEdy399ARPaNyyiSJSJjByK=5ALN5jxbJw@mail.gmail.com>
 <20150424153657.GC24029@htj.duckdns.org>
 <CAOviyah9yyXJG0eUeizpb5ZnzNUAKfxXGkXJw-5sNw7sQOAEuA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eBREm+SDdwE0EYdVjbrhTk2tYHlTPurG2U2muMZ2gFs=;
        b=YjtNRcjYlDQJO9eHYtMUPVt8z0fcnMmoRsEqwROgzTi+7vvHY4ejiP3uDBrtBop8QR
         TwZRhMGSDpiXUn+ThIR25puBaH4S2QWJNYoX8BzyE1VR4UR+B5VgWkPrX1gfyyOw/zAh
         zC46gPqVmf2g327RKTH1W6CpqW6JbwSdE6tmKJHIt2d8nqxdBplMbvCjx0d2cvNUwyWI
         al/PP3B51jlK9SqcQSpqq3DF/A40u5Qbweys+PeogGp7un8uE1N1GeLtPRyhyflJzbdy
         9DTVVUKakr59CUwB5eRGjAcBVjezSmfcZWFZN+Nhov7ISwBLhq13V7MoE6GR274b/WTP
         wswA==
Content-Disposition: inline
In-Reply-To: <CAOviyah9yyXJG0eUeizpb5ZnzNUAKfxXGkXJw-5sNw7sQOAEuA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, May 14, 2015 at 03:04:52AM +1000, Aleksa Sarai wrote:
> Would you be okay with this?
> 
>     if (limit < 0 || limit >= PIDS_MAX)
> 
> I'd prefer if we used PIDS_MAX as the maximum input value as well as
> being the internal representation of the maximum, rather than
> switching to something like INT_MAX.

Yeah, that sounds okay to me but I forgot why we went for INT_MAX in
the first place.  Do you remember why we tried INT_MAX at all?

Thanks.

-- 
tejun
