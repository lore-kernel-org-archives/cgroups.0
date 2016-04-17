From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Sun, 17 Apr 2016 08:00:55 -0400
Message-ID: <20160417120053.GB21757@dhcp22.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415070601.GA32377@dhcp22.suse.cz>
 <20160415143815.GH12583@htj.duckdns.org>
 <20160415150815.GM32377@dhcp22.suse.cz>
 <20160415152526.GJ12583@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160415152526.GJ12583-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 15-04-16 11:25:26, Tejun Heo wrote:
> Hello,

Hi,

> On Fri, Apr 15, 2016 at 05:08:15PM +0200, Michal Hocko wrote:
[...]
> > Well it certainly is not that trivial because it relies on being
> > exclusive with global context. I will have to look closer of course but
> > I cannot guarantee I will get to it before I get back from LSF. We can
> > certainly discuss that at the conference. Johannes will be there as
> > well.
> 
> I see.  For cpuset, it didn't really matter but what we can do is
> creating a mechanism on cgroup core side which is called after a
> migration operation is done after dropping the usual locks and
> guarantees that no new migration will be started before the callbacks
> finish.  If we have that, relocating charge moving outside the attach
> path should be pretty trivial, right?

Yeah, I guess this should work as well. I would have to double check the
code, I cannot say it would be my favorite so I might have forgot some
subtle details.
-- 
Michal Hocko
SUSE Labs
