From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Thu, 30 Apr 2020 13:23:19 -0700
Message-ID: <20200430202319.GF339283@carbon.dhcp.thefacebook.com>
References: <20200430182712.237526-1-shakeelb@google.com>
 <20200430190610.GD339283@carbon.dhcp.thefacebook.com>
 <20200430193049.GB2436@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=RCCXWDjVRlwpddUB4DfuXqXk65Tcvr+BQrgC6dU4n3Y=;
 b=DRHrq5ZeTcX9SCKsKRJolng7HMcc8vMJqdritvpAE4Iyvz36N8e2C6vBX+SixpmGqp/T
 0N3h1E+H6RkdJDhIYEka6xP9tWeeMK9/ri1lkv1bRuxGqPw68D5elzVf5rlx5sLE+1Li
 XBoJFG8uUTvTo16YKWayP8uFfL5e8ZADTdE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCCXWDjVRlwpddUB4DfuXqXk65Tcvr+BQrgC6dU4n3Y=;
 b=el021WNRoYt4oU9x6jdtZmIKUSwZCUJRGK5G8Af46n9hsXTc8NmVj4bkx1KWtdFY/KUzx3afaR+pffbFNbrwFt+gjtdHQGfejdKVx57GIZA08hKLlx/EqxucCbTWPC8AqT8N4vNvyhwQTOnMGJS4etKzIdgQ3C3WOiXRT22cKIU=
Content-Disposition: inline
In-Reply-To: <20200430193049.GB2436-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 30, 2020 at 03:30:49PM -0400, Johannes Weiner wrote:
> On Thu, Apr 30, 2020 at 12:06:10PM -0700, Roman Gushchin wrote:
> > On Thu, Apr 30, 2020 at 11:27:12AM -0700, Shakeel Butt wrote:
> > > @@ -6106,7 +6107,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
> > >  		}
> > >  
> > >  		memcg_memory_event(memcg, MEMCG_OOM);
> > > -		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
> > > +		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0, true))
> > 
> > I wonder if we can handle it automatically from the oom_killer side?
> > We can suppress warnings if oc->memcg is set and the cgroup scanning
> > showed that there are no belonging processes?
> 
> Note that we do remote charging for certain consumers, where memory
> gets charged from the outside of the cgroup.
> 
> We would want to know if these cause OOMs on an empty cgroup, rather
> than force-charge the allocations quietly.
> 

Yeah, good point.
