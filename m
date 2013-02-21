From: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] memcg: Add memory.pressure_level events
Date: Thu, 21 Feb 2013 15:04:26 -0800
Message-ID: <20130221230425.GA22792@lizard.fhda.edu>
References: <20130219044012.GA23356@lizard.sbx00618.mountca.wayport.net>
 <20130220001743.GE16950@blaptop>
 <CAOS58YOPjcH_pFFhPLJEAdaLkm5FoOy9mG2i-PkWAcb7O6V_Kw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YOPjcH_pFFhPLJEAdaLkm5FoOy9mG2i-PkWAcb7O6V_Kw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Leonid Moiseichuk <leonid.moiseichuk-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Tue, Feb 19, 2013 at 04:21:28PM -0800, Tejun Heo wrote:
> On Tue, Feb 19, 2013 at 4:17 PM, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > Should we really enable memcg for just pressure notificaion in embedded side?
> > I didn't check the size(cgroup + memcg) and performance penalty but I don't want
> > to add unnecessary overhead if it is possible.
> > Do you have a plan to support it via global knob(ie, /proc/mempressure), NOT memcg?
> 
> That should be handled by mempressure at the root cgroup. If that adds
> significant amount of overhead code or memory-wise, we just need to
> fix root cgroup handling in memcg. No reason to further complicate the
> interface which already is pretty complex.

For what it worth, I agree here. Even if we decide to make another
interface to vmpressure (which, say, would not require memcg), then it is
better to keep the API the same: eventfd + control file. That way,
API/ABI-wise there will be no differnce between memcg and non-memcg
kernels, which is cool.

Thanks,
Anton
