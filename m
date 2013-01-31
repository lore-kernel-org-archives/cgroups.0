From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 9/9] devcg: propagate local changes down the hierarchy
Date: Thu, 31 Jan 2013 17:03:47 -0500
Message-ID: <20130131220347.GO17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130131043839.GA14726-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hi Serge,
On Thu, Jan 31, 2013 at 04:38:39AM +0000, Serge E. Hallyn wrote:
> > @@ -610,9 +770,14 @@ 		case '\0':
> >  		 */
> >  		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
> >  			dev_exception_rm(devcgroup, &ex);
> > -			return 0;
> > +			rc = propagate_exception(devcgroup);
> 
> Let's say the default in both parent A and child B is ALLOW, and both
> have a blacklist entry for "b 8:* rwm".  Now I
> 
> 	echo "b 8:* rwm" > A/devices.allow
> 
> removing the blacklist entry.  Here you are propagating that to the
> child B, which I would argue is actually propagating a new allow to
> a child.  Which you said you wouldn't do.

yep, that's a bug. will fix it up

thanks!

-- 
Aristeu
