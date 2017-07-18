From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Tue, 18 Jul 2017 13:54:56 -0400
Message-ID: <20170718175456.GH585283@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <20170717141409.sqafufjupsiffnri@hirez.programming.kicks-ass.net>
 <20170717142609.GC3519177@devbig577.frc2.facebook.com>
 <20170718172801.f56273tzgzn3xkne@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YdzUiGLFuCIMtmsFwXYxfYa26v5ognERungovzXxWr4=;
        b=pBeT/Ox3lzRCmSQlu7lqL8RD7DGZgMZ7mllYRP2HSQjxatLvftFsmjlBprzkLOdMFE
         NXfhBz8foHfJ+8nIejV2BgzD2lKo5LqTdhxtNlKVFgLGHwD48VtyAVaHRuzHAfuTy80/
         kuYGX4t8HURqj99ru7PeP6oUEyN3uN4588m+ZfkTYaghq0xkD/CPX2VexOdYwMLZvRvF
         Kwy4KHvQorrrVBz9moDVxd3htE8X+Uo0GPjRvSSSaVDVoG3x8aj6z79lerwI3W/2o4+g
         9ap2mV50DsQYYvDFZ/qp9FvJ0uHrvs78Qq0icKBWg3Bb/WGMakU87rRdFt/6e7hYBppY
         MF7Q==
Content-Disposition: inline
In-Reply-To: <20170718172801.f56273tzgzn3xkne-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Peter.

On Tue, Jul 18, 2017 at 07:28:01PM +0200, Peter Zijlstra wrote:
> > And now try to create another child C, should that be a domain or
> > threaded?
> 
> Domain of course, as R must be a domain, and hence all its children
> start out as such.

I don't think it's a matter of course as R also is the root of a
threaded subtree, but this is more or less bikeshedding.

> > If we only inherit from the second level on, which is in itself
> > already confusing, that still leads to invalid configs for non-root
> > thread roots.
> 
> I don't see how. I don't get the example Waiman gave, what is wrong
> with:
> 
> 	R (D)
> 	|
> 	A (D)
>        / \
>      C(D) B(T) 
> 
> ? Afaict that's a perfectly valid configuration.

Okay, we're kinda off the rails now.  Just to verify that we're on the
same page, are you also saying that the following should be a valid
configuration?

	R (D)
        |
	A (D and has processes in it and controllers enabled)
        |
        C (D and has processes in it) 

Thanks.

-- 
tejun
