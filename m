From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 21/23] cgroup: make cftype->[un]register_event() deal
 with cgroup_subsys_state instead of cgroup
Date: Fri, 2 Aug 2013 15:44:51 -0400
Message-ID: <20130802194451.GF29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-22-git-send-email-tj@kernel.org>
 <51FB30D3.9030900@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=a74wRzDbhyP5A6mTCQSmzNTpMWz+QQmM0O4ypp7uGi0=;
        b=V89oafBkSBNiBwjR9aecK90sSgD+M8j65H0l5XwL1VS7jjUakWLGBxAONwel0zM+0x
         f5KPHwQ8pjyvSa8pN1XnD9GbdAylaMCKvjaG4jZoCKJqF/jKU5H/igUxiycRQOqHBSZr
         wzE/0G+W9/kzBkI0PSdYsJWY0ZoSB5sqwKdfFZAaBjVwrMc3nxttouNCPyoD2H8sEHXX
         7hbwEbkw3kayY40G8Mm/ae3uRS6DuYoK9ydsvhOpMg56PyEygsmp2DR2XyHzdsSxa9Lc
         SbQltysJn9E6DJzuek1eJL+k3RBypsNvkCou4KGF7XkmdRpwSWZVrccoXR7xcm4tKCyb
         BHlw==
Content-Disposition: inline
In-Reply-To: <51FB30D3.9030900-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Aug 02, 2013 at 12:08:51PM +0800, Li Zefan wrote:
> > @@ -506,15 +506,17 @@ struct cftype {
> >  	 * you want to provide this functionality. Use eventfd_signal()
> >  	 * on eventfd to send notification to userspace.
> >  	 */
> > -	int (*register_event)(struct cgroup *cgrp, struct cftype *cft,
> > -			struct eventfd_ctx *eventfd, const char *args);
> > +	int (*register_event)(struct cgroup_subsys_state *css,
> > +			      struct cftype *cft, struct eventfd_ctx *eventfd,
> > +			      const char *args);
> >  	/*
> >  	 * unregister_event() callback will be called when userspace
> >  	 * closes the eventfd or on cgroup removing.
> >  	 * This callback must be implemented, if you want provide
> >  	 * notification functionality.
> >  	 */
> > -	void (*unregister_event)(struct cgroup *cgrp, struct cftype *cft,
> > +	void (*unregister_event)(struct cgroup_subsys_state *css,
> > +				 struct cftype *cft,
> >  			struct eventfd_ctx *eventfd);
> 
> align this line?

Done.

-- 
tejun
