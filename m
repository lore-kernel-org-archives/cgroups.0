From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Tue, 15 Apr 2014 10:06:50 -0400
Message-ID: <20140415140650.GI1863@htj.dyndns.org>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EiH/aiwSBSuC+8ojlszaGM4wfCCRololsrwP6CJjnoc=;
        b=F56stMq0lix1TGR10gtaKjnnjtdquQfKaYD1hDckJgHgMICNrQxUb31navaezanIfH
         fOKfp6ME9lDuALxBHySVQC9/6x/A+x+4M4xQixx1Ajyev4sHDY2kdNASi2PhcUWB+2ql
         2mWb7N6m4G5nHSfuWJTtKqQXRHysJTzCCyLQmFNvYdDG2waC2nKnLFdgQ8VFWFnY4VzP
         fVRadpvgMtZI2rauf9MH3MEDU3Hiq95UkxcNAU7Mg3gxpG2t2bel2JT/t46Xz9944s0t
         FoU3mIHAwXTkSyh0hoN26gU09LTEyWEBea9IZEr2Yu/oVKftxVDjb9z3WAOrcZCyzsYw
         0Lag==
Content-Disposition: inline
In-Reply-To: <20140415135359.GA13033-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Apr 15, 2014 at 09:53:59AM -0400, Vivek Goyal wrote:
> But looks like that you are targetting that one can have multiple
> hierarchies. One of those will be unified hierarchy with new contstraints.
> Other hierarchies can be old type hierarchies. Do I understand it right?

Yeap, for backward compatibility.

> So you want all the debug knobs to be enabled by  DEBUG_BLK_CGROUP option as
> well as using a kernel command line? But I thought that in general
> people are not supposed to set CONFIG_DEBUG_BLK_CGROUP=y. It brings in
> unnecessary overhead. Those who are doing development and trying to debug
> things only those can enable above config option.
> 
> But anyway, I am fine with hiding these files behind a command line
> parameter too.

It's easy to enable the config option and there's nothing clearly
indicating those knobs expose internal details and volatile in nature.
Once userland develops dependency on them, we get locked into it
whether we intended or not.  Debug features should be very clearly
marked as such.

> > Yeah, thought about keeping them consistent but would that really
> > matter?  Having internal consistency in cfq seems more important to
> > me.
> 
> I think from a user's perspective it really matters. If I see two knobs
> in a cgroup, say throttle.io_service_bytes and cfq.io_service_bytes, it
> is much more intuitive.
>
> So I feel that we should aim for having consistent names in CFQ and
> throttling. If one understands one knob at one layer, it is intuitive
> to figure out what same knob means at other layer.
> 
> And, thankfully, we have only two stats at throttling layer.
> 
> blkio.throttle.io_serviced
> blkio.throttle.io_service_bytes
> 
> Though names are little longer, but they look fine to me. They are
> intuitive. So I can't see a strong reason to change those names
> at CFQ layer.
> 
> blkio.cfq.io_serviced
> blkio.cfq.io_service_bytes

But then do we name other stat knobs similarly too?

 blkio.cfq.io_service_sectors
 blkio.cfq.io_service_bytes
 blkio.cfq.io_serviced
 blkio.cfq.io_merged

I don't know.  The names look outright stupid to me.  If we don't do
the above, then we have internal inconsistencies among cfq knob names
which gotta be worse then cfq / throttl inconsistency.  It's not a
perfect situation no matter what we do.  As long as each knob is
clearly documented, I don't think these inconsistencies are big deal,
so let's just clean up cfq names as we need to add prefix anyway.

Thanks.

-- 
tejun
