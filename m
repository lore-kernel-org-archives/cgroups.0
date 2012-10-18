From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memory cgroup: update root memory cgroup when node is
 onlined
Date: Thu, 18 Oct 2012 18:03:06 -0400
Message-ID: <20121018220306.GA1739@cmpxchg.org>
References: <505187D4.7070404@cn.fujitsu.com>
 <20120913205935.GK1560@cmpxchg.org>
 <alpine.LSU.2.00.1209131816070.1908@eggly.anvils>
 <507CF789.6050307@cn.fujitsu.com>
 <alpine.LSU.2.00.1210181129180.2137@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1210181129180.2137-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Wen Congyang <wency-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jiang Liu <liuj97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org

On Thu, Oct 18, 2012 at 12:03:44PM -0700, Hugh Dickins wrote:
> On Tue, 16 Oct 2012, Wen Congyang wrote:
> > At 09/14/2012 09:36 AM, Hugh Dickins Wrote:
> > > 
> > > Description to be filled in later: would it be needed for -stable,
> > > or is onlining already broken in other ways that you're now fixing up?
> > > 
> > > Reported-by: Tang Chen <tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> > > Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > Hi, all:
> > 
> > What about the status of this patch?
> 
> Sorry I'm being so unresponsive at the moment (or, as usual).
> 
> When I sent the fixed version afterwards (minus mistaken VM_BUG_ON,
> plus safer mem_cgroup_force_empty_list), I expected you or Konstantin
> to respond with a patch to fix it as you preferred (at offline/online);
> so this was on hold until we could compare and decide between them.
> 
> In the meantime, I assume, we've all come to feel that this way is
> simple, and probably the best way for now; or at least good enough,
> and we all have better things to do than play with alternatives.
> 
> I'll write up the description of the fixed version, and post it for
> 3.7, including the Acks from Hannes and KAMEZAWA (assuming they carry
> forward to the second version) - but probably not today or tomorrow.

Mine does, thanks for asking :-)
