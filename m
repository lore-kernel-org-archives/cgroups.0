From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH V2 3/3] memcg: simplify lock of memcg page stat account
Date: Tue, 14 May 2013 11:28:50 +0200
Message-ID: <20130514092850.GK5198@dhcp22.suse.cz>
References: <1368421410-4795-1-git-send-email-handai.szj@taobao.com>
 <1368421545-4974-1-git-send-email-handai.szj@taobao.com>
 <20130513131251.GB5246@dhcp22.suse.cz>
 <20130513133809.GC5246@dhcp22.suse.cz>
 <CAFj3OHW=FCGu6rhChLV2HgUFSRxDur4e8bmugXnq++c-P8mNRg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFj3OHW=FCGu6rhChLV2HgUFSRxDur4e8bmugXnq++c-P8mNRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue 14-05-13 17:13:07, Sha Zhengju wrote:
> On Mon, May 13, 2013 at 9:38 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> >
> > On Mon 13-05-13 15:12:51, Michal Hocko wrote:
> > [...]
> > > I am sorry but I do not think this is the right approach. IMO we should
> > > focus on mem_cgroup_begin_update_page_stat and make it really recursive
> > > safe - ideally without any additional overhead (which sounds like a real
> > > challenge)
> >
> > Or maybe we should just not over complicate this and simply consider
> > recursivness when it starts being an issue. It is not a problem for
> > rmap accounting anymore and dirty pages accounting seems to be safe as
> > well and pages under writeback accounting was OK even previously.
> > It doesn't make much sense to block dirty pages accounting by a
> > non-existing problem.
> >
> 
> Yes, the dirty/writeback accounting seems okay now. I sent this patch
> out to see if I can do something to simplify the locks but this
> approach seems to have its own drawbacks. Since you and Kame are NAK
> to this, in the order of importance I'll put the patch aside and
> continue the work of dirty page accounting. :)

Thanks for your work!

> Thanks for the teaching!

-- 
Michal Hocko
SUSE Labs
