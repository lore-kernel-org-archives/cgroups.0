From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Date: Fri, 27 Jun 2014 11:00:21 -0400
Message-ID: <20140627150021.GA4044@htj.dyndns.org>
References: <53994943.60703@huawei.com>
 <539949A1.90301@huawei.com>
 <20140620193521.GB28324@mtj.dyndns.org>
 <53A8D2B8.4080107@huawei.com>
 <20140624210119.GC14909@htj.dyndns.org>
 <53AA2C4F.30808@huawei.com>
 <20140625150053.GE26883@htj.dyndns.org>
 <53AD1001.4090405@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=x50rG8if1ZINufIcQS+ydQeHJtA80g10nJNbr4OQM0U=;
        b=0NeLubgDenM2dosbAkF83SkcTdEz33aodQaC3RVKZIGmqhgTzvT5B9bZeM8lKFn7DP
         FTbCkLGgxib33dXqHUKu9qKjWt7FJxYzsEOrsH7Ylx7Y2DotTNHvGDlhr4WciHJ8nVKE
         cAr4QYV+HUmk2Q3Lv/nUedHJLEQnPcZ5YDWLAOWP+9pMspyxt3+dOKWWQ9NzbLlUbS0t
         KYFlJ0hKKbKNqzirYz/OnqXlOGmOwtYeXIshku8ru88HkzFmoFWX8Hip17dF3tiZASwi
         2jcpgPguIDT1azCQ2eb57Ggui0dSrSiThHlQx8qNWdQYH0RrB01pkuLfWGuCahgFTYJ1
         qfvA==
Content-Disposition: inline
In-Reply-To: <53AD1001.4090405-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jun 27, 2014 at 02:32:33PM +0800, Li Zefan wrote:
> > cgroup_mount()
> > {
> > 	mutex_lock();
> > 	lookup_cgroup_root();
> > 	if (root isn't killed yet)
> > 		root->this_better_stay_alive++;
> > 	mutex_unlock();
> > 	kernfs_mount();
> > }
> > 
> > cgroup_kill_sb()
> > {
> > 	mutex_lock();
> > 	if (check whether root can be killed)
> > 		percpu_ref_kill();
> > 	mutex_unlock();
> > 	if (the above condition was true)
> > 		kernfs_kill_sb();
> > }
> > 
> 
> This looks nasty, and I don't think it's correct. If we skip the call
> to kernfs_kill_sb(), kernfs_super_info won't be freed but super_block
> will, so we will end up either leaking memory or accessing invalid
> memory. There are other problems like returning with sb->s_umount still
> held.

Yeah, right, the conditional shouldn't be on kernfs_kill_sb().  It
should only be on percpu_ref_kill().  kernfs mount code will wait out
the dead sb and create a new one; however, this is still not feasible
because we don't have a place to dec ->this_better_stay_alive as
there's no umount callback.  :(

Thanks.

-- 
tejun
