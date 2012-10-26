From: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to use freezable_schedule()
Date: Fri, 26 Oct 2012 23:14:17 +0200
Message-ID: <2566006.UzAQbpOjNQ@vostro.rjw.lan>
References: <20121023153919.GA16201@redhat.com> <20121026175258.GV11442@htj.dyndns.org> <20121026180149.GA22421@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7Bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121026180149.GA22421-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Friday, October 26, 2012 08:01:49 PM Oleg Nesterov wrote:
> On 10/26, Tejun Heo wrote:
> >
> >  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Thanks!
> 
> > Rafael, sorry that this one doesn't have pm cc'd
> 
> Ah, sorry Rafael. Yes, I have read you email, and I was going to
> add linux-pm but forgot.
> 
> > but can you please
> > pick up this one too?
> 
> Please, and thanks.

OK, but that will go to Linus in the next batch.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
