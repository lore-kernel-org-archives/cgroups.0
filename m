From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 8/9] devcg: refactor dev_exception_clean()
Date: Wed, 30 Jan 2013 15:49:18 -0500
Message-ID: <20130130204917.GL17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.253395279@napanee.usersys.redhat.com>
 <20130130204730.GF8507@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130130204730.GF8507-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, Jan 30, 2013 at 08:47:30PM +0000, Serge E. Hallyn wrote:
> Quoting aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> > -
> > -			if (rc)
> > -				return rc;
> 
> Was this intentional?
> 
> I see that you next add
> 
> 	rc = propagate_behavior(devcgroup);
> 
> right here, but this means you're ignoring failure in the
> dev_exceptions_copy() call above.

that's not intentional. thanks for catching this

Tejun, you want me to resubmit the whole series or just the next patch
(where I was supposed to move that chunk)?

-- 
Aristeu
