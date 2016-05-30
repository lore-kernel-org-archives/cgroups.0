From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol.c: add memory allocation result check
Date: Mon, 30 May 2016 13:22:18 +0200
Message-ID: <20160530112218.GS22928@dhcp22.suse.cz>
References: <1464597951-2976-1-git-send-email-wwtao0320@163.com>
 <20160530085311.GM22928@dhcp22.suse.cz>
 <CACygaLCupPNRMWUpRe3WSCHWtAFH3MYKzppbjaX3As6EKKnVQQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACygaLCupPNRMWUpRe3WSCHWtAFH3MYKzppbjaX3As6EKKnVQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wenwei Tao <ww.tao0320-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Wenwei Tao <wwtao0320-9Onoh4P/yGk@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 30-05-16 17:28:40, Wenwei Tao wrote:
> I think explicit BUG_ON may make the debug easier, since it can point
> out the wrong line.

Does it? NULL ptr dereferencec 6 lines below sounds pretty close to me.
I am not nacking this patch I just think it doesn't add much. If others
think it will be useful I will not object.

> 2016-05-30 16:53 GMT+08:00 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > On Mon 30-05-16 16:45:51, Wenwei Tao wrote:
> >> From: Wenwei Tao <ww.tao0320-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> The mem_cgroup_tree_per_node allocation might fail,
> >> check that before continue the memcg init. Since it
> >> is in the init phase, trigger the panic if that failure
> >> happens.
> >
> > We would blow up in the very same function so what is the point of the
> > explicit BUG_ON?
> >
> >> Signed-off-by: Wenwei Tao <ww.tao0320-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >>  mm/memcontrol.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 925b431..6385c62 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -5712,6 +5712,7 @@ static int __init mem_cgroup_init(void)
> >>
> >>               rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
> >>                                   node_online(node) ? node : NUMA_NO_NODE);
> >> +             BUG_ON(!rtpn);
> >>
> >>               for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> >>                       struct mem_cgroup_tree_per_zone *rtpz;
> >> --
> >> 1.8.3.1
> >>
> >>
> >> --
> >> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> >> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> >> see: http://www.linux-mm.org/ .
> >> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> >
> > --
> > Michal Hocko
> > SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
