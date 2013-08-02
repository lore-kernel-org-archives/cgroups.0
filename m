From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/23] cgroup: pass around cgroup_subsys_state instead of
 cgroup in subsystem methods
Date: Fri, 2 Aug 2013 15:36:43 -0400
Message-ID: <20130802193643.GC29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-9-git-send-email-tj@kernel.org>
 <51FB2D70.3040208@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TdnFlhH4A1uz8M0V8dsjDwW8Z7cCKx+TvnZbRAzYUdk=;
        b=P8DxIdr1cEzgv3cm/CkcuOR0Um30vFRl+wCU5L/fJchiyOD/8fB+hKutkTGY8uBA8b
         481c53GmPTJp7/QQKQFVkvLAsdQ4E6toMPJsivHJMLu1nYheUPhoPL3qjguPUzPAI726
         04DrLXEcC1nSjZm3VZ1HwMe3ctpywPCdxjs32bL6IRKiUCyfQfbavVfh22j96xJzm7+r
         aepDdrTB8pULitXCZFOynRUJZAUOj32T4bxVS/r1WnciYUM83ObzbY7Yl9Hmktauhu2A
         +NwxIPIH2aGO8xee9NdkZKT5DDkdBy5gfPss26OHNAX2zi3OLDqe25TqQQr7TLQf7WyK
         MVjw==
Content-Disposition: inline
In-Reply-To: <51FB2D70.3040208-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>

On Fri, Aug 02, 2013 at 11:54:24AM +0800, Li Zefan wrote:
> > @@ -4298,7 +4308,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
> >  	for_each_root_subsys(root, ss) {
> >  		struct cgroup_subsys_state *css;
> >  
> > -		css = ss->css_alloc(cgrp);
> > +		css = ss->css_alloc(parent->subsys[ss->subsys_id]);
> 
> As this patchset is based on for-3.12 branch, which lacks the fix in for-3.11,
> so the css_alloc() in that bug fix is not converted.

Hmm... I'll pull for-3.11-fixes into for-3.12 and rebase this series
on top of it.

Thanks.

-- 
tejun
