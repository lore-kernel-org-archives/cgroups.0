From: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Sat, 28 Feb 2015 20:46:13 -0800
Message-ID: <CAAAKZws=k20ibx-EHumTyRwJ3TbpzeKwUNqWTAP5d+W1-mx-kw@mail.gmail.com>
References: <20150227114940.GB3964@htj.duckdns.org> <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org> <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
 <20150227174503.GM3964@htj.duckdns.org> <CAAAKZwvuR2X7EEZz+UWRCGYajaJQ+VzXYfDEq6EQnssv9+6FJQ@mail.gmail.com>
 <20150227214904.GQ3964@htj.duckdns.org> <CAAAKZwsCc8BtFx58KMFpRTohU81oCBeGVOPGMJrjJt9q5upKfQ@mail.gmail.com>
 <20150228165706.GS3964@htj.duckdns.org> <CAAAKZwv=idxvrffHx2QyW=PGH4k42ckq-VLJGQrXkeQ6NmByRQ@mail.gmail.com>
 <20150228225036.GA4597@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        bh=YIKmyASdvsiFnOUnPFED0rcZRimpCwy+rtq8feZWQMo=;
        b=Pm+wSx1EjHPAj6QV3y3mIs8QLATvZlKcZemyhoH9dnNK3Z4jyUXIp0qzOxuVfXEhxS
         gWtlJuhE4CU5v2wZvMwbrQXXyt+ViDGUpZrDdkomB9GPBSZJsUYl03VjOR0EZMW5gco9
         R8XqH3sGrRVS95rbCQqdFdA/kjb8/9ckJRYNluC0MN+jo2gCziC71u/rLMk3lFf1XbtY
         W8prvbFTHs+ePBM6O0VHd4qO71RTGn8pm6Pcc1gwZNTxwwtFX3rzkM3sGypMTqmfLnf1
         N1Ks7bYmsd0wmSD4YeNfzrVeFi9tiWpPcZQ20isHoyTMcXf58kuDMy6wami8Wm4N2QoU
         lz8g==
In-Reply-To: <20150228225036.GA4597-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mingo <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, richard <richard-/L3Ra7n9ekc@public.gmane.org>

On Feb 28, 2015 2:50 PM, "Tejun Heo" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Sat, Feb 28, 2015 at 02:26:58PM -0800, Tim Hockin wrote:
> > Wow, so much anger.  I'm not even sure how to respond, so I'll just
> > say this and sign off.  All I want is a better, friendlier, more
> > useful system overall.  We clearly have different ways of looking at
> > the problem.
>
> Can you communicate anything w/o passive aggression?  If you have a
> technical point, just state that.  Can you at least agree that we
> shouldn't be making design decisions based on 16bit pid_t?

Hmm, I have screwed this thread up, I think.  I've made some remarks
that did not come through with the proper tongue-in-cheek slant.  I'm
not being passive aggressive - we DO look at this problem differently.
OF COURSE we should not make decisions based on ancient artifacts of
history.  My point was that there are secondary considerations here -
PIDs are more than just the memory that backs them.  They _ARE_ a
constrained resource, and you shouldn't assume the constraint is just
physical memory.  It is a piece of policy that is outside the control
of the kernel proper - we handed those keys to userspace along time
ago.

Given that, I believe and have believed that the solution should model
the problem as the user perceives it - limiting PIDs - rather than
attaching to a solution-by-proxy.

Yes a solution here partially overlaps with kmemcg, but I don't think
that is a significant problem.  They are different policies governing
behavior that may result in the same condition, but for very different
reasons.  I do not think that is particularly bad for overall
comprehension, and I think the fact that this popped up yet again
indicates the existence of some nugget of user experience that is
worth paying consideration to.

I appreciate your promised consideration through a slightly refocused
lens.  I will go back to my cave and do something I hope is more
productive and less antagonistic.  I did not mean to bring out so much
vitriol.

Tim
