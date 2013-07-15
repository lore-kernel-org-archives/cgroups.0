From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 5/6] memcg: patch
 mem_cgroup_{begin,end}_update_page_stat() out if only root memcg exists
Date: Mon, 15 Jul 2013 10:32:26 +0400
Message-ID: <20130715063224.GA3745@localhost.localdomain>
References: <1373044710-27371-1-git-send-email-handai.szj@taobao.com>
 <1373045623-27712-1-git-send-email-handai.szj@taobao.com>
 <20130711145625.GK21667@dhcp22.suse.cz>
 <CAFj3OHV=6YDcbKmSeuF3+oMv1HfZF1RxXHoiLgTk0wH5cJVsiQ@mail.gmail.com>
 <CAFj3OHXF+ZjnaDS2L6ZmuHPx20+7XC9r-s7Gh=_TYOr4Opr4Bw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oPzJ64pUGBnu7drQQ6988tzCpXSTnspocrpFC7h6f9I=;
        b=B0Z4fUGpF1pSkpIXQ/QfZx0yjAOQH5S6czpnC5Ink4VLcC9WkOns1WFkMQcIbZJ+1X
         x9x6MmE0Wswih2WtgRDqQGvNijFdWrgR8sdFuRYFz6T3ypd6ZcGHKyCy1ulUdM7nbbL5
         464faV7B7cgxjmps6//OiOfg8FA+S8OagSTs+LeTwHVq0TZ08qfZwytQ2uzBoZz1eo78
         OUMwQSw9bZToenbzYRnhKrPcUiJKNIMU2ZdXTKKCNwAF58gKqNWKUy/2rjUcxvgstkDz
         rEV6ot0g4N6Q2EqZImc9satykWLseCw3Ko+OjIxRBB0JZGT5VCKd2loFxLqSTuwKPabI
         8QQw==
Content-Disposition: inline
In-Reply-To: <CAFj3OHXF+ZjnaDS2L6ZmuHPx20+7XC9r-s7Gh=_TYOr4Opr4Bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Fri, Jul 12, 2013 at 09:13:56PM +0800, Sha Zhengju wrote:
> Ooops.... it seems unreachable, change Glauber's email...
> 
> 
> On Fri, Jul 12, 2013 at 8:59 PM, Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > Add cc to Glauber
> >
Thanks

> >
> > On Thu, Jul 11, 2013 at 10:56 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > > On Sat 06-07-13 01:33:43, Sha Zhengju wrote:
> > >> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> > >>
> > >> If memcg is enabled and no non-root memcg exists, all allocated
> > >> pages belongs to root_mem_cgroup and wil go through root memcg
> > >> statistics routines.  So in order to reduce overheads after adding
> > >> memcg dirty/writeback accounting in hot paths, we use jump label to
> > >> patch mem_cgroup_{begin,end}_update_page_stat() in or out when not
> > >> used.
> > >
> > > I do not think this is enough. How much do you save? One atomic read.
> > > This doesn't seem like a killer.
> > >
> > > I hoped we could simply not account at all and move counters to the root
> > > cgroup once the label gets enabled.
> >
> > I have thought of this approach before, but it would probably run into
> > another issue, e.g, each zone has a percpu stock named ->pageset to
> > optimize the increment and decrement operations, and I haven't figure out a
> > simpler and cheaper approach to handle that stock numbers if moving global
> > counters to root cgroup, maybe we can just leave them and can afford the
> > approximation?
> >
> > Glauber have already done lots of works here, in his previous patchset he
> > also tried to move some global stats to root (
> > http://comments.gmane.org/gmane.linux.kernel.cgroups/6291). May I steal
> > some of your ideas here, Glauber? :P
> >
Of course. Please go ahead and keep me posted in my new address.
