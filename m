From: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Tue, 19 Nov 2013 12:16:56 +0100
Message-ID: <CAJ75kXYfN8RJaunrQd6cG8xZFO4Ny+f1uDPU5DaUUhmibp-vUA@mail.gmail.com>
References: <20131031130647.0ff6f2c7@gandalf.local.home> <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131031192732.2dbb14b3@gandalf.local.home> <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com> <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com> <20131107235301.GB1092@cmpxchg.org>
 <20131108001437.GC1092@cmpxchg.org> <CAJ75kXamrtQz5-cYS7tYtYeP1ZLf2pzSE7UnEPpyORzpG3BASg@mail.gmail.com>
 <20131118164308.GD3556@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=QwCwQAob7OefVGDWRr8k3vkDgqxU6TSO3NTwvMeA/Ro=;
        b=y3fIlD7Z6XctJzAbOw64D70NIC9eC5hEVAyTRmeCcWUvI6ybJfllOT2zyrF0MtwKkj
         iJm3xSSBVWd4oB2zUN9ptfGTkGFL1SFpFI/KFgH22y2lLqD33uTAPdlPUO2mwA4I5S3h
         RYauqFbYzf2/OOgT3w+BHZ3OzNgmLiieTjiKHHVOsrhN661elerRNe5M8wEkNStYVugW
         81zXULl2Hzmuxq+7ENOco9+M30IPI61mf1y3559cURhLUwoqoKZNmp1DQxIj98oHgw/L
         3hHyf70wY79/Bcqn70apet3KVWIPhuMbzBhF2/V/+QO6Q2hkcmvh2LQD9tetGCNA5SUm
         vCPg==
In-Reply-To: <20131118164308.GD3556-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Johannes,

On Mon, Nov 18, 2013 at 5:43 PM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> I would not have expected this.  Thank you very much for testing and
> confirming.  I'm going to go back to the emails you sent me and will
> try to make sense of this.

seems like I talked too fast. The issue is just much harder to trigger
(spent more than seven days testing).
I'm triggering my oom bug when memory+swap is full. I'll send you some
more info in a separate thread.
Sorry for the false report.

Regards,
-- 
William
