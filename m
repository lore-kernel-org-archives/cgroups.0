From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Wed, 13 May 2015 13:47:07 -0400
Message-ID: <20150513174707.GA11388@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-5-git-send-email-cyphar@cyphar.com>
 <20150422162954.GF10738@htj.duckdns.org>
 <CAOviyagHJhxD8E+CeEdy399ARPaNyyiSJSJjByK=5ALN5jxbJw@mail.gmail.com>
 <20150424153657.GC24029@htj.duckdns.org>
 <CAOviyah9yyXJG0eUeizpb5ZnzNUAKfxXGkXJw-5sNw7sQOAEuA@mail.gmail.com>
 <20150513172906.GY11388@htj.duckdns.org>
 <CAOviyaimfHD=Jg1+FEwyapwO=zdaL0bvq8YDA1Cnq90YbfGENQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=T4wQIIZpboxu8do4Mcg0Ri0gSsmNXx84u7Gbe+ATHLo=;
        b=A5lQJioA4i86GeXOHj70wuIVLTf/+nvu9WvYOzl4HlgictpdTYjnJ36hKY8UbWvHqv
         KLRTux1fVoJzUfEHczVxtnXTnJy+T3aiWZnBZreiQfwpiD7Kh05b7G6R8HcUpHooMm7t
         8fwH+Bhd0hmDVsGdZABmny2ji5x1ObIeCJKJGikeppicF8GRUAZk/W7/VzEYCRLJECBF
         e8cdIaLWDLiU/9ygfX/xYkm7NHQMASz5ewem9pEpaklrMW3I0oYrYYb27qZQS4Zku6XV
         VeFSZtD7I+BXZxIG69gFUS/Em3IY3yACVHCP9VegTmfSp+QNRgChUo28ZzAxGX2PNUbN
         qvsQ==
Content-Disposition: inline
In-Reply-To: <CAOviyaimfHD=Jg1+FEwyapwO=zdaL0bvq8YDA1Cnq90YbfGENQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 14, 2015 at 03:44:24AM +1000, Aleksa Sarai wrote:
> I think it's because we didn't want to expose PIDS_MAX to userspace.
> But we're not *really* exposing it, we're just enforcing the input
> limit for "max".

Ah, PIDS_MAX is fine then.

Thanks.

-- 
tejun
