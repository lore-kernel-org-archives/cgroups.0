From: Nicholas Mc Guire <der.herr-kA1LtwSENNE@public.gmane.org>
Subject: Re: [PATCH] cgroup: add explicit cast and comment for return type
	conversion
Date: Mon, 25 May 2015 07:57:42 +0200
Message-ID: <20150525055742.GE1397@opentech.at>
References: <1432472872-3578-1-git-send-email-hofrat@osadl.org> <20150524203528.GB7099@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150524203528.GB7099-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 24 May 2015, Tejun Heo wrote:

> Hello,
> 
> On Sun, May 24, 2015 at 03:07:52PM +0200, Nicholas Mc Guire wrote:
> > Type-checking coccinelle spatches are being used to locate type mismatches
> > between function signatures and return values in this case this produced:
> > ./kernel/cgroup.c:2525 WARNING: return of wrong type
> > 	ssize_t != size_t, 
> > 
> > Returning unsigned types converted to a signed type can be problematic
> > but in this case the size_t is <= PATH_MAX which is less than ulong/2 so
> > the conversion is safe - to make static code checking happy this is 
> > resolved by an explicit cast and appropriate comment.
> > 
> > Patch was compile tested with x86_64_defconfig (implies CONFIG_CGROUPS=y)
> > 
> > Patch is against 4.1-rc4 (localversion-next is -next-20150522)
> > 
> > Signed-off-by: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
> > ---
> > 
> > Not sure if "cleanups" like this are acceptable - in this case I did not
> > find any better way to make static code checkers happy though.
> > 
> >  kernel/cgroup.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index b91177f..04de621 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -2523,7 +2523,11 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
> >  		sizeof(cgrp->root->release_agent_path));
> >  	spin_unlock(&release_agent_path_lock);
> >  	cgroup_kn_unlock(of->kn);
> > -	return nbytes;
> > +
> > +	/* the path of the release notifier is <= PATH_MAX
> > +	 * so "downsizing" to signed long is safe here
> > +	 */
> > +	return (ssize_t)nbytes;
> 
> idk, does this actually help anything?  This isn't different from any
> other implicit type casts.  Are we gonna convert all downward implicit
> casts to be explicit?
>
nop not downward but signed/unsigned  if it were down it would not be
a problem but signed/unsigned can be - for those cases where it can't
be fixed up by changing the declarations or return variable types 
explicit cast might make sense - as noted in the patch Im not sure either
if this form of cleanups is helpful. 

In the kernel core there are about 400 signed/unsigned implicit 
conversions (about 3k in the entire kernel) which is what Im trying to 
remove or if that is not possible in a resonable way mark as false positive.

thx!
hofrat
