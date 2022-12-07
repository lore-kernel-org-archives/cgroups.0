From: "Li,Rongqing" <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] mm: memcontrol: speedup memory cgroup resize
Date: Wed, 7 Dec 2022 02:31:13 +0000
Message-ID: <cf7f485c3e7f4238b509d9dbbd084a2f@baidu.com>
References: <1670240992-28563-1-git-send-email-lirongqing@baidu.com>
 <CALvZod7_1oq1D73EKJHG1zQpeUp+QTPHmMRsL3Ka0f6XUfO4Eg@mail.gmail.com>
 <Y48aaCkgonOlMwNu@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y48aaCkgonOlMwNu-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: zh-CN
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>



> -----Original Message-----
> From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Sent: Tuesday, December 6, 2022 6:33 PM
> To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Li,Rongqing <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>; linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org;
> cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org; roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org;
> songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org; akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
> Subject: Re: [PATCH] mm: memcontrol: speedup memory cgroup resize
> 
> On Mon 05-12-22 08:32:41, Shakeel Butt wrote:
> > On Mon, Dec 5, 2022 at 3:49 AM <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > From: Li RongQing <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> > >
> > > when resize memory cgroup, avoid to free memory cgroup page one by
> > > one, and try to free needed number pages once
> > >
> >
> > It's not really one by one but SWAP_CLUSTER_MAX. Also can you share
> > some experiment results on how much this patch is improving setting
> > limits?
> 

If try to resize a cgroup to reclaim 50 Gb memory, and this cgroup has lots of children cgroups who are reading files and alloc memory,  this patch can speed 2 or more times.


> Besides a clear performance gain you should also think about a potential over
> reclaim when the limit is reduced by a lot (there might be parallel reclaimers
> competing with the limit resize).
> 

to avoid over claim,  how about to try to free half memory once?

@@ -3498,7 +3499,11 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
                        continue;
                }

-               if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
+               nr_pages = page_counter_read(counter);
+
+               nr_pages = nr_pages > (max + 1) ? (nr_pages - max) / 2 : 1;
+
+               if (!try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
                                        memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP)) {
                        ret = -EBUSY;
                        break; thanks

thanks

-Li

