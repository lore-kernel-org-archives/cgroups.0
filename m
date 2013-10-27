From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] percpu counter: cast this_cpu_sub() adjustment
Date: Sun, 27 Oct 2013 09:00:36 -0400
Message-ID: <20131027130036.GN14934@mtj.dyndns.org>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
 <1382859876-28196-3-git-send-email-gthelen@google.com>
 <20131027112255.GB14934@mtj.dyndns.org>
 <20131027050429.7fcc2ed5.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oim4OMcD4gA0IDKG6rn7XUs9CJhEkMk2ZmKGwln0WKI=;
        b=yCEkOHLa8u1iwzrx4DjNyAtvZRfJdG+0CT+fryy18orCXTjV5lcvLudLd4xh9umT4e
         YJ+qOlHTYfZwxyjzF9yDp+hRRw2VTyutRz/pREpWszCl2pHuPepBZx2Kv0UAHQgnnJ7e
         oYedxJNsTTg7LZ+siOWY2N4SYwZoA/lxHxn1hKroW3SQ1O+eeuwMm6toI/IgrPEKZTcM
         LS2WU0rJ/4r2/vYXJzy33/4/lE1vSUERAwbNn/T6EKM/fytgPc4zklwCulaiWGW5M2GE
         qxLHNMkrUhawd11GY4jNi55Z9nHoKkqeR9Q7Vj4Big1UP6vKPWC85c5hwmJ37oK3p7eb
         c9AA==
Content-Disposition: inline
In-Reply-To: <20131027050429.7fcc2ed5.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Oct 27, 2013 at 05:04:29AM -0700, Andrew Morton wrote:
> On Sun, 27 Oct 2013 07:22:55 -0400 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > We probably want to cc stable for this and the next one.  How should
> > these be routed?  I can take these through percpu tree or mm works
> > too.  Either way, it'd be best to route them together.
> 
> Yes, all three look like -stable material to me.  I'll grab them later
> in the week if you haven't ;)

Tried to apply to percpu but the third one is a fix for a patch which
was added to -mm during v3.12-rc1, so these are yours. :)

> The names of the first two patches distress me.  They rather clearly
> assert that the code affects percpu_counter.[ch], but that is not the case. 
> Massaging is needed to fix that up.

Yeah, something like the following would be better

 percpu: add test module for various percpu operations
 percpu: fix this_cpu_sub() subtrahend casting for unsigneds
 memcg: use __this_cpu_sub() to dec stats to avoid incorrect subtrahend casting

Thanks.

-- 
tejun
