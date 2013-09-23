From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Date: Mon, 23 Sep 2013 09:12:15 -0400
Message-ID: <20130923131215.GI30946@htj.dyndns.org>
References: <524001F8.6070205@huawei.com>
 <20130923130816.GH30946@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Xi2Ux1gDgClkPcqr2vxy+Rl0YKFgrG3zdaS1x30J97g=;
        b=SamNTyqQ677mIFqcCUzimm+pQj++gO7chsbUQYK7FD4yb6Oh4cKUhWZ6SzyEaLT4E6
         cpve0jy3Ai544ViJe/9fF40i3XxBPYzeaMftyHJ5TzqIUVb0s2s5DDWsUaHLgNTzk7a5
         NBJWgedIE8Rda0K8Gkd0XtbUecBUFn157mLK5irVikOQ7+HwmVMSRJL2Ty2WiS8ypM9b
         xPz9gAWhnW9Nuhw3LfHsmz5JgDeM9FbIZg/am0O+md3Adhw8ljm93uZrJbwemtVaUfyO
         WVobNrNtfH6ssNvPW/fIU2WMEX0unYkrqdiEH+aQ0WcxHOrz9EpZOwm+uxLFKnpH6YSu
         +upA==
Content-Disposition: inline
In-Reply-To: <20130923130816.GH30946-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, Sep 23, 2013 at 09:08:16AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Sep 23, 2013 at 04:55:20PM +0800, Li Zefan wrote:
> > The whole patchset has been acked and reviewed by Michal and Tejun.
> > Could you merge it into mm tree?
> 
> Ah... I really hoped that this had been merged during -rc1 window.
> Andrew, would it be okay to carry this series through cgroup tree?  It
> doesn't really have much to do with mm proper and it's a PITA to have
> to keep updating css_id code from cgroup side when it's scheduled to
> go away.  If carried in -mm, it's likely to cause conflicts with
> ongoing cgroup changes too.

Also, wasn't this already in -mm during the last devel cycle?  ISTR
conflicts with it in -mm with other cgroup core changes.  Is there any
specific reason why this wasn't merged during the merge windw?

Thanks.

-- 
tejun
