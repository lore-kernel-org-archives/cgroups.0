From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: legacy mode
Date: Mon, 31 Aug 2015 17:36:40 -0500
Message-ID: <87h9nf5blz.fsf@x220.int.ebiederm.org>
References: <20150827202137.GA4221@mail.hallyn.com>
	<20150827202722.GH26785@mtj.duckdns.org>
	<20150827204500.GA4447@mail.hallyn.com>
	<20150827204825.GI26785@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150827204825.GI26785-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org> (Tejun Heo's message of
	"Thu, 27 Aug 2015 16:48:25 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Hello, Serge.
>
> On Thu, Aug 27, 2015 at 03:45:00PM -0500, Serge E. Hallyn wrote:
>> > If the legacy userspace doesn't do any resource control, the leaf rule
>> > restriction doesn't apply anyway, so nothing to worry about.
>> 
>> My main use case is nested lxc, presumably with systemd inside some of
>> the nested containers, so this would definately be an issue.
>
> W/o controllers in the nested environment, it should be fine.  W/
> controllers, I don't think this is going to fly.  I don't think trying
> to bridge the two versions is a healthy direction in the long term.

Which strongly suggests that the unified hierarchy will never be
deployable as it breaks too much userspace.

Eric
