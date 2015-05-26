From: Nicholas Mc Guire <der.herr-kA1LtwSENNE@public.gmane.org>
Subject: Re: [PATCH] cgroup: add explicit cast and comment for return type
	conversion
Date: Tue, 26 May 2015 06:52:05 +0200
Message-ID: <20150526045205.GA13387@opentech.at>
References: <1432472872-3578-1-git-send-email-hofrat@osadl.org> <20150524203528.GB7099@htj.duckdns.org> <20150525055742.GE1397@opentech.at> <20150525114045.GA526@htj.duckdns.org> <20150525115047.GA7413@opentech.at> <20150526000538.GH7099@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150526000538.GH7099-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 25 May 2015, Tejun Heo wrote:

> Hello, Nicholas.
> 
> On Mon, May 25, 2015 at 01:50:47PM +0200, Nicholas Mc Guire wrote:
> > that would be no benefit of course - the goal is not to simply put casts
> > in but to use casts as last resort if type cleanups are not doable or if
> > the type missmatch is intended - the cast then should document that it
> > is intentional and comments explain why it is justified. If that were the
> > result of type cleanup I think it would benefit the kernel code as I 
> > suspect that quite a few of the type missmatches simply happened.
> 
> I'm having a bit of hard time agreeing with the utility of this.  If
> you can fix up the variable type to go away, sure, but adding
> unnecessary explicit cast and comment for something this trivial?  I'm
> not sure.  I mean, C is not a language which can propagate param
> constraints to the return types.  e.g. strnlen() will happily return
> size_t even when the maximum length is e.g. int.  We simply aren't
> writing in a language where these things are easily distinguished and
> I'm not sure shoehorning explicit constraints all over the source code
> brings enough benefit to justify the added noise.
> 
> If you can identify actual problem cases, awesome.  If some can easily
> be removed by tweaking types to match the actual usage, great too, but
> let's please not do this explicit version of implicit casts and
> pointless comments.
>
got it - not an issue for me - as noted I was not that sure how 
sensible it is either the point of this RFC was precisely to 
clarify this. Will mark those safe conversions as false-postives
then and leave it as is.

Thanks for the clarification!

thx!
hofrat
