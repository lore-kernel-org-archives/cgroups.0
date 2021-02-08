From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] mm: memcontrol: consolidate lruvec stat flushing
Date: Mon, 8 Feb 2021 11:02:55 -0500
Message-ID: <YCFgr300eRiEZwpL@slm.duckdns.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
 <20210205182806.17220-8-hannes@cmpxchg.org>
 <CALvZod4ex5V2Xs_6YHmmLJw91rjKTSZ9XobXiRx4ftj=L=A6MA@mail.gmail.com>
 <YCGk9ksAU8+tBv5y@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yTVAlNOZNa/h2RjRt2M5Ou305u4ysb6/0EoJiOGY+8o=;
        b=op/01oUWlbCNAjdOj9gvkl0CtDftRT2/UisLx184sVL4C3qbV910sFUhFliXU6Xlr/
         99ybdviATLOoTaI2/HYBZButNPjGV/7zorb0GMeWgiKyQCCNkj/HwJl9JHnbjKWnEj8D
         fEHHfrkI/p5qlxaAUU/ye6S37z0eYy/2Kvi2PEXrrM/zFjaUMfBGPziYIqwl/jDYqdtj
         FtBAda3OmOQA5IYdGqZeZS4wCT3ONWsDMmCeWaPAjqSYgC+uUynQ8i7cBx2LaW0E35nc
         7OmFZLGKQsjphqv+IpuHlIcDsqHmDGh+M12+y2W/WeO8vruOOpJRz3A5YrAJP09kxKJA
         +XmA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YCGk9ksAU8+tBv5y-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

Hello,

On Mon, Feb 08, 2021 at 03:54:14PM -0500, Johannes Weiner wrote:
> We probably do need a better solution for the lruvecs as well, but in
> this case it just started holding up fixing the memory.stat issue for
> no reason and so I tabled it for another patch series.

rstat doesn't currently have a flush throttling mechanism cuz it doens't
expect readers to be super hot but adding one should be pretty easy - e.g.
it can just keep track of the number of updates on this cpu since the last
flush and then flush iff the it's above a certain threshold. Shouldn't be
too difficult to match or exceed the performance and error characteristics
of the existing code.

Thanks.

-- 
tejun
