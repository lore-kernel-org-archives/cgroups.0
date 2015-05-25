From: Nicholas Mc Guire <der.herr-kA1LtwSENNE@public.gmane.org>
Subject: Re: [PATCH] cgroup: add explicit cast and comment for return type
	conversion
Date: Mon, 25 May 2015 13:50:47 +0200
Message-ID: <20150525115047.GA7413@opentech.at>
References: <1432472872-3578-1-git-send-email-hofrat@osadl.org> <20150524203528.GB7099@htj.duckdns.org> <20150525055742.GE1397@opentech.at> <20150525114045.GA526@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150525114045.GA526-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 25 May 2015, Tejun Heo wrote:

> Hello, Nicholas.
> 
> On Mon, May 25, 2015 at 07:57:42AM +0200, Nicholas Mc Guire wrote:
> > nop not downward but signed/unsigned  if it were down it would not be
> > a problem but signed/unsigned can be - for those cases where it can't
> > be fixed up by changing the declarations or return variable types 
> > explicit cast might make sense - as noted in the patch Im not sure either
> > if this form of cleanups is helpful. 
> > 
> > In the kernel core there are about 400 signed/unsigned implicit 
> > conversions (about 3k in the entire kernel) which is what Im trying to 
> > remove or if that is not possible in a resonable way mark as false positive.
> 
> I still don't get it.  What does this buy us actually?  If we continue
> to do this, people would just learn to add explicit cast when doing
> sign conversions.  We just converge to a different behavior without
> actually gaining any protection.  What's the benefit of doing this?
>
that would be no benefit of course - the goal is not to simply put casts
in but to use casts as last resort if type cleanups are not doable or if
the type missmatch is intended - the cast then should document that it
is intentional and comments explain why it is justified. If that were the
result of type cleanup I think it would benefit the kernel code as I 
suspect that quite a few of the type missmatches simply happened.

thx!
hofrat
