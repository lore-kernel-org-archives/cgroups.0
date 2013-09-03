From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/12] cgroup, memcg: move cgroup->event_list[_lock] and
 event callbacks into memcg
Date: Tue, 3 Sep 2013 17:56:46 -0400
Message-ID: <20130903215646.GA31091@mtj.dyndns.org>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
 <1376582550-12548-9-git-send-email-tj@kernel.org>
 <20130830110846.GB31605@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ehOkoEGXIGeohsEyAdY4ESdGYcs4uTgnscy8iVL0ZnU=;
        b=086G8T2Dl24wKxZxk25Dy9nQWRi/wf6ojgFrXJFMtSV/bmM9wzAEXkkSIxuP1K9zo/
         c3crDCmPJB2u88UJR+Bi4noTqvUCcAQZlVRsnCIH1auvjm7CSmWpwNhZcig8XhDutX3V
         y+hKXVJCu8MOD6GBmNvagUKx9MF3FQFtruT5ec7bnTWFBdwHAj2mnpsJD12kGAKIfdYs
         HyXL7hxSLRtmAOUgZtayDxHNury82b3qTSJfb+G/l0UKhkK7TIO0leCWL3VdSXg0BbMo
         uHL7zJt1XM0wNHmHvd4Q5qsYmbYNsI74OKT2iDX/iK4biuftuEKMiawpjYUMQlEYnDfQ
         FQjw==
Content-Disposition: inline
In-Reply-To: <20130830110846.GB31605-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Michal.

On Fri, Aug 30, 2013 at 01:08:46PM +0200, Michal Hocko wrote:
> On Thu 15-08-13 12:02:26, Tejun Heo wrote:
> [...]
> > @@ -6030,12 +6050,13 @@ static void cgroup_event_ptable_queue_proc(struct file *file,
> >  static int cgroup_write_event_control(struct cgroup_subsys_state *css,
> >  				      struct cftype *cft, const char *buffer)
> >  {
> > -	struct cgroup *cgrp = css->cgroup;
> > +	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> >  	struct cgroup_event *event;
> >  	struct cgroup_subsys_state *cfile_css;
> >  	unsigned int efd, cfd;
> >  	struct file *efile;
> >  	struct file *cfile;
> > +	const char *name;
> >  	char *endp;
> >  	int ret;
> 
> AFAICS nothing prevents from registering a new event after css_offline
> is done already which would lead to a mem leak. The we would need to do
> css_tryget somewhere in the beginning. Or is there anything that would
> prevent from that?

An earlier patch titled "cgroup: make cgroup_event hold onto
cgroup_subsys_state instead of cgroup" updates cgroup_event such that
each cgroup_event acquires a css reference using css_tryget(), so if a
css has already been offlined, no new event will be created.

Thanks.

-- 
tejun
