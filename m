From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to
	use freezable_schedule()
Date: Fri, 26 Oct 2012 20:01:49 +0200
Message-ID: <20121026180149.GA22421@redhat.com>
References: <20121023153919.GA16201@redhat.com> <20121024185710.GA12182@atj.dyndns.org> <20121025163941.GA3801@redhat.com> <20121025163959.GB3801@redhat.com> <20121025171812.GE11442@htj.dyndns.org> <20121025173433.GA7650@redhat.com> <20121025173632.GI11442@htj.dyndns.org> <20121026174545.GA21639@redhat.com> <20121026174606.GB21639@redhat.com> <20121026175258.GV11442@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121026175258.GV11442-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/26, Tejun Heo wrote:
>
>  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks!

> Rafael, sorry that this one doesn't have pm cc'd

Ah, sorry Rafael. Yes, I have read you email, and I was going to
add linux-pm but forgot.

> but can you please
> pick up this one too?

Please, and thanks.

Oleg.
