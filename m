From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Wed, 19 Jul 2017 11:40:46 -0400
Message-ID: <20170719154046.GN3365493@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
 <199bfed8-de84-da6d-6623-c45524443aaa@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WbLzWDULQifs+OeMGmK8N2EY6CKPS0RHCgcRC5GlLZU=;
        b=fmAYZFvYbJSg80nb22wSiJpBsOh7VKXKlwFl668FlvpCgEM/6Ms/tO77IkfGeJXVGU
         JkpxBFqYu2uOc8+Up4DKr7lVmaAd+B5sQl0MaxCQKUB3E2JGPHjjp7uZLK7NMZ7UzU+t
         99DhfKq4UVr54RG5xgGIkMj5O0quC4UxPGwk+7IBOnIN2ELAzniNP7ywKLDfT5MdMgMt
         c/fSAX1+izHqoSrMIR8desZNSo2o4XIX18kZbCaKTUwURVBjAfgG7iHKANr+TjR6jYek
         Wg61JJ4XUJu3r45bvDeBWuCzb32pdDh75VRHV9Pd9dlRl8I/eh0wRZwV+iMN/EVAMNRk
         EZ4w==
Content-Disposition: inline
In-Reply-To: <199bfed8-de84-da6d-6623-c45524443aaa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Waiman.

On Mon, Jul 17, 2017 at 05:12:31PM -0400, Waiman Long wrote:
> > +Marking a cgroup threaded makes it join the resource domain of its
> > +parent as a threaded cgroup.  The parent may be another threaded
> > +cgroup whose resource domain is further up in the hierarchy.  The root
> > +of a threaded subtree, that is, the nearest ancestor which is not
> > +threaded, is called threaded domain and serves as the resource domain
> > +for the entire subtree.
> 
> The cgroup code uses the term "thread root" in quite a number of places.
> So a developer may be confused when comparing the code and the
> documentation. I would recommend either introducing "thread root" as an
> alias for threaded domain here in the documentation or documenting that
> "threaded domain = thread root" in the code.

Yeah, I was a bit hesitant to introduce an extra term for it, but both
terms make sense and thread root is less cumbersome.  I'll incorporate
it into the doc.

> >    cgroup.procs
> >  	A read-write new-line separated values file which exists on
> >  	all cgroups.
> 
> Do we need to document that cgroup.procs isn't writable in a threaded
> cgroup?

Yeah, will update.

> > @@ -4301,6 +4606,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
> >  	cgrp->self.parent = &parent->self;
> >  	cgrp->root = root;
> >  	cgrp->level = level;
> > +	cgrp->dom_cgrp = cgrp->dom_cgrp;
> 
> It is a no-op. I think it is better to modify it to
> 
> +    cgrp->dom_cgrp = cgroup_is_threaded(parent) ? parent->dom_cgrp : cgrp;
> 
> Then we won't have an invalid domain state.

I'll respond to this on the other sub-thread.

Thanks.

-- 
tejun
