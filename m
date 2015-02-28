From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Sat, 28 Feb 2015 17:50:36 -0500
Message-ID: <20150228225036.GA4597@htj.duckdns.org>
References: <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
 <20150227174503.GM3964@htj.duckdns.org>
 <CAAAKZwvuR2X7EEZz+UWRCGYajaJQ+VzXYfDEq6EQnssv9+6FJQ@mail.gmail.com>
 <20150227214904.GQ3964@htj.duckdns.org>
 <CAAAKZwsCc8BtFx58KMFpRTohU81oCBeGVOPGMJrjJt9q5upKfQ@mail.gmail.com>
 <20150228165706.GS3964@htj.duckdns.org>
 <CAAAKZwv=idxvrffHx2QyW=PGH4k42ckq-VLJGQrXkeQ6NmByRQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=J/TEm8J4R1MAJrlKzd0ucb4HJGRk9ZtPdnureVroJUA=;
        b=IamFTwC+pSnhglbf1oKpLd13wHqk+CkDI0A5V7URmswRAGLrdI1D5NZVjvejkZejb1
         BRKry2Vo7UQ5IkxD06oDgpav2Y7Y2TZdcPs4KdxSNfJaTxA3VqztwtyXSCPogcsdqsAj
         BkGDVw3S9RnyAVEDomtmoraxGVLe4ZQM+WTyMx7SFbLLIaNvQeGc/76fQRWY+xG+IVLR
         xeMXy247qm1soU6YRuwtLdz0MzTgzF2A49mIpblPyVmCuWKqiAbz4RI5+hgIuqysoSuL
         rYwnELvIe7ypyQNIJ/wEJiH+e157n0J702fdX6cgaLrRVQKPb+c1McHvwJ1dxWnaOEsl
         C0ng==
Content-Disposition: inline
In-Reply-To: <CAAAKZwv=idxvrffHx2QyW=PGH4k42ckq-VLJGQrXkeQ6NmByRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, richard <richard-/L3Ra7n9ekc@public.gmane.org>, mingo <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sat, Feb 28, 2015 at 02:26:58PM -0800, Tim Hockin wrote:
> Wow, so much anger.  I'm not even sure how to respond, so I'll just
> say this and sign off.  All I want is a better, friendlier, more
> useful system overall.  We clearly have different ways of looking at
> the problem.

Can you communicate anything w/o passive aggression?  If you have a
technical point, just state that.  Can you at least agree that we
shouldn't be making design decisions based on 16bit pid_t?

-- 
tejun
