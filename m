From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 12/12] cpuset: export effective masks to userspace
Date: Wed, 9 Jul 2014 16:24:08 -0400
Message-ID: <20140709202408.GE21090@htj.dyndns.org>
References: <53BD0174.4060002@huawei.com>
 <53BD0215.8060305@huawei.com>
 <20140709201549.GD21090@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zviSMfA4CjztCxpuSRtqI1QVvO08BPs2cWk/GrA2Z1g=;
        b=LTvr6EErHK3h6HCvB1cjsaSvEgcqC9pDe4GTDWwGXrsaeuWHzywEaSgRaZ+dAGexTk
         ncVO0gntemV+mTeYPnTA3P6c56UTYKrKpP7JZqZKZZ7kmPa/NyTK+ctrHk7uBngnad9B
         bHSlCjqugMjLQ3EB6rqHb8QqjXfqoyKIowQ2bCOk9Ctz6AcTpGDRnswEp2EywfgwL8Ww
         DH9BI/7SA3pnnEa8M+JAiBDsxm9jnwGCgffqq4bXF5nURdxZD7dOsUiVNAIbY1Bv6SfT
         mzEPUysa5or0rN4Z+J4R815ZtAoh7bId2/SikoMXt9rg62nzfcW7t/52cTY8FhBL3UZs
         od5Q==
Content-Disposition: inline
In-Reply-To: <20140709201549.GD21090-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 09, 2014 at 04:15:49PM -0400, Tejun Heo wrote:
> On Wed, Jul 09, 2014 at 04:49:25PM +0800, Li Zefan wrote:
> > cpuset.cpus and cpuset.mems are the configured masks, and we need
> > to export effective masks to userspace, so users know the real
> > cpus_allowed and mems_allowed that apply to the tasks in a cpuset.
> > 
> > v2:
> > - export those masks unconditionally, suggested by Tejun.
> > 
> > Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> I applied this patch but there's a pending patchset to split legacy
> and dfl cftype arrays, so maybe doing it separately makes more sense
> now, I'm not sure.  Anyways, we need to review cpuset interface for
> the default hierarchy anyway.  At least the memory pressure knobs
> should go.  It's measuring something which is completely
> implementation dependent.

The exclusive knobs too.  These are purely to aid configuration.
memory_migrate is questionable too given that we're moving towards the
model where the controllers are set up before the cgroup gets
populated.  Also, if necessary, this should be implementable from
userland with migrate_pages(2).

Thanks.

-- 
tejun
