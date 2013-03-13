From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/4] devcg: propagate local changes down the hierarchy
Date: Wed, 13 Mar 2013 09:56:32 -0400
Message-ID: <20130313135632.GA4417@redhat.com>
References: <20130215165543.131282532@napanee.usersys.redhat.com>
 <20130215165543.733711059@napanee.usersys.redhat.com>
 <20130219211208.GC5399@mail.hallyn.com>
 <20130219212015.GF11173@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130219212015.GF11173-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hi Tejun,
On Tue, Feb 19, 2013 at 04:20:16PM -0500, Aristeu Rozanski wrote:
> On Tue, Feb 19, 2013 at 09:12:08PM +0000, Serge E. Hallyn wrote:
> > Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> > > +		} else {
> > > +			/*
> > > +			 * in the other possible cases:
> > > +			 * root's behavior: allow, devcg's: deny
> > > +			 * root's behavior: deny, devcg's: deny
> > > +			 * the exception will be removed
> > > +			 */
> > 
> > Technically this case isn't needed, right?  Will the dev_exception_rm()
> > also be done by revalidate_active_exceptions()?  So it's safe (but
> > not necessary) to drop the else here.  Though the comment is very
> > informative, and it might be worth keeping the code as is for clarity.
> 
> that's correct, it'll end up being removed by
> revalidate_active_exceptions(). if others have no objection, I'll keep
> it
> 
> Thanks for the reviews Serge, much appreciated

did you pick this series up for 3.10 or you want me to resubmit?

-- 
Aristeu
