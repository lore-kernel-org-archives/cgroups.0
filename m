From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
Date: Wed, 30 May 2012 10:29:55 +0900
Message-ID: <20120530012955.GA4854@google.com>
References: <alpine.DEB.2.00.1205291101580.6723@router.home>
 <4FC501E9.60607@parallels.com>
 <alpine.DEB.2.00.1205291222360.8495@router.home>
 <4FC506E6.8030108@parallels.com>
 <alpine.DEB.2.00.1205291424130.8495@router.home>
 <4FC52612.5060006@parallels.com>
 <alpine.DEB.2.00.1205291454030.2504@router.home>
 <4FC52CC6.7020109@parallels.com>
 <alpine.DEB.2.00.1205291514090.2504@router.home>
 <4FC530C0.30509@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dlGnKVi2Bq7oINFfcnsF0WuIXjBrXe7XckaYWvilAA0=;
        b=fGEFmfFFNMNKqIvFjdPpxHDwimxEB5MbF4SnY9Y8WTnVw60MM+RR6+1Ri2ZrDcWXsU
         1lAZ0FGcuaptWRKDJJMFufHvM6NNVk5siT6ShW9vX2KGfZipD6I3JhP3cB6/J5TtG96D
         QzqvTsM4LXWOqzf/6Jz+njh8gyXIYi4JitALMZlEkUo97f7PxwnHTnV0IUFRKz4QrrD3
         rXVTpf6FXU8sSaJLPb0ClwyMmCOLF3Bf1xm9U/Ay2rJj20TnyCD6p5YnMmma/dNfgp24
         ScKyZPC/9E+C3QlgYY1Wr9IGdAvkr25bZ1yYR2jgk5tWkzAzAMTxBMu2OtYey4MqhzKu
         HlTQ==
Content-Disposition: inline
In-Reply-To: <4FC530C0.30509-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

Hello, Christoph, Glauber.

On Wed, May 30, 2012 at 12:25:36AM +0400, Glauber Costa wrote:
> >We have never worked container like logic like that in the kernel due to
> >the complicated logic you would have to put in. The requirement that all
> >objects in a page come from the same container is not necessary. If you
> >drop this notion then things become very easy and the patches will become
> >simple.
> 
> I promise to look at that in more detail and get back to it. In the
> meantime, I think it would be enlightening to hear from other
> parties as well, specially the ones also directly interested in
> using the technology.

I don't think I'm too interested in using the technology ;) and
haven't read the code (just glanced through the descriptions and
discussions), but, in general, I think the approach of duplicating
memory allocator per-memcg is a sane approach.  It isn't the most
efficient one with the possibility of wasting considerable amount of
caching area per memcg but it is something which can mostly stay out
of the way if done right and that's how I want cgroup implementations
to be.

The two goals for cgroup controllers that I think are important are
proper (no, not crazy perfect but good enough) isolation and an
implementation which doesn't impact !cg path in an intrusive manner -
if someone who doesn't care about cgroup but knows and wants to work
on the subsystem should be able to mostly ignore cgroup support.  If
that means overhead for cgroup users, so be it.

Without looking at the actual code, my rainbow-farting unicorn here
would be having a common slXb interface layer which handles
interfacing with memory allocator users and cgroup and let slXb
implement the same backend interface which doesn't care / know about
cgroup at all (other than using the correct allocation context, that
is).  Glauber, would something like that be possible?

Thanks.

-- 
tejun
