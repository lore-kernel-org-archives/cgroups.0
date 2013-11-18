From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 18 Nov 2013 11:43:08 -0500
Message-ID: <20131118164308.GD3556@cmpxchg.org>
References: <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131031192732.2dbb14b3@gandalf.local.home>
 <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131108001437.GC1092@cmpxchg.org>
 <CAJ75kXamrtQz5-cYS7tYtYeP1ZLf2pzSE7UnEPpyORzpG3BASg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=LXgAJIn6oi2s8Zr8qdNPZvYuReG3mFDgySWqJA03PVs=;
	b=E8gn7+cbPISEG6IAp3mpWpyBPWPC4ydTbSV4JsQAq/W9km9hRPGDjX5MGzS3/9RXPFyPq0gIkMcfN27/JlI/TXOki79uauSlg7Q3kZd4UsKpHeSkHbwkPHeAuLnOVdS19Jasb/3tSL2bDOS1E8JOxDxwWOtEQICUFxuOBs+7bpQ=;
Content-Disposition: inline
In-Reply-To: <CAJ75kXamrtQz5-cYS7tYtYeP1ZLf2pzSE7UnEPpyORzpG3BASg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 18, 2013 at 11:30:56AM +0100, William Dauchy wrote:
> Hi Johannes,
> 
> On Fri, Nov 8, 2013 at 1:14 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > So how about this?
> 
> this patch seems to fix my issue I reported you some weeks ago with a
> oom looping issue.
> Tested on a 3.10.x

I would not have expected this.  Thank you very much for testing and
confirming.  I'm going to go back to the emails you sent me and will
try to make sense of this.

Thanks, William!
