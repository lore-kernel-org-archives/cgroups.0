From: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: lock assert fails in dev_exception_clean()
Date: Thu, 17 Jan 2013 15:13:42 -0800 (PST)
Message-ID: <20130117231341.GA14588@cantor.us.oracle.com>
References: <1358460018-14717-1-git-send-email-jerry.snitselaar@oracle.com>
 <1358460018-14717-2-git-send-email-jerry.snitselaar@oracle.com>
 <20130117220642.GE16568@mtj.dyndns.org>
Reply-To: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130117220642.GE16568-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Thu Jan 17 13, Tejun Heo wrote:
> Hello, Jerry.
> 
> Can you please also cc cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org and Aristeu Rozanski
> <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>?
> 
> On Thu, Jan 17, 2013 at 03:00:18PM -0700, Jerry Snitselaar wrote:
> > devcgroup_css_free() calls dev_exception_clean() without the
> > devcgroup_mutex being held.
> > 
> > Shutting down a kvm virt was giving me the following trace:
> 
> Hmm...
> 
> > Signed-off-by: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  security/device_cgroup.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> > index 19ecc8d..d794abc 100644
> > --- a/security/device_cgroup.c
> > +++ b/security/device_cgroup.c
> > @@ -215,7 +215,9 @@ static void devcgroup_css_free(struct cgroup *cgroup)
> >  	struct dev_cgroup *dev_cgroup;
> >  
> >  	dev_cgroup = cgroup_to_devcgroup(cgroup);
> > +	mutex_lock(&devcgroup_mutex);
> 
> You can't grab mutex from rcu callback.  It seems like the lockdep
> assertion isn't necessary in this case as the free callback should be
> the last remaining user of the dev_cgroup.  Maybe factor out
> __devcgroup_css_free() which doesn't have lockdep assertion?
> 

Ok. I was wondering if it was really needed since it was freeing
dev_cgroup right after that. I probably would have never noticed the
trace if hadn't been checking to see if a fix for ttm stopped it from
spamming me with them for trying to sleep in an invalid context.

Jerry

> >  	dev_exception_clean(dev_cgroup);
> > +	mutex_unlock(&devcgroup_mutex);
> >  	kfree(dev_cgroup);
> 
> Thanks.
> 
> -- 
> tejun
