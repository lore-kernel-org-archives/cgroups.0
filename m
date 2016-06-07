From: Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] cgroup: disable irqs while holding css_set_lock
Date: Tue, 7 Jun 2016 17:11:34 +0100
Message-ID: <20160607161134.GU9340@e106622-lin>
References: <aa70cd2645974808785960bfb0ddfebdec6e3095.1465243518.git.bristot@redhat.com>
 <20160607101402.GP9340@e106622-lin>
 <bda9f957-6f4b-5b95-f752-1c6a9a26aa79@redhat.com>
 <20160607133009.GS9340@e106622-lin>
 <494c1f85-bbab-99f1-4095-914aaebdd708@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <494c1f85-bbab-99f1-4095-914aaebdd708-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Bristot de Oliveira <daolivei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis Claudio R. Goncalves" <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/06/16 12:26, Daniel Bristot de Oliveira wrote:
> Ciao Juri,
> 
> On 06/07/2016 10:30 AM, Juri Lelli wrote:
> > So, this and the partitioned one could actually overlap, since we don't
> > set cpu_exclusive. Is that right?
> > 
> > I guess affinity mask of both m processes gets set correclty, but I'm
> > not sure if we are missing one check in the admission control. Can you
> > actually create two overlapping sets and get DEADLINE tasks running in
> > them? For example, what happens if partitioned is [4] and clustered is
> > [4-7]? Does setattr() fail?
> 
> That is what I was trying to understand/break. Fortunately, I still
> can't break it! bravo! :-)
> 
> In the test you mentioned the task in the "clustered" fails to
> sched_setattr().
> 
> Test output example:
> + '[' '!' -d partitioned ']'
> + mkdir partitioned
> + echo 4
> + echo 0
> + echo 0
> + echo 1155
> + cat /proc/self/cpuset
> /partitioned
> + /root/m
> main thread [1162]
> deadline thread started [1164]

Mmm. The other one is good, but this one looks still suspect to me. We
shouldn't have created a new root domain at this point (since
cpu_exclusive is not set), so we shouldn't be able to admit DEADLINE
tasks with a smaller affinity mask than the full root domain mask (which
should still be 0-7 at this point), if I'm interpreting your script correctly
and I'm not wrong about root domains stuff.

Unfortunately I'm not able to test this myself right now. Hopefully next
week.

Thanks a lot for testing, though!

Best,

- Juri

> + '[' '!' -d clustered ']'
> + mkdir clustered
> + echo 4-7
> + echo 0
> + echo 0
> + echo 1
> + echo 1155
> + cat /proc/self/cpuset
> + /root/m
> /clustered
> + /root/m
> main thread [1166]
> sched_setattr: Operation not permitted
> 
> I will let you know if I find something odd.
> 
> -- Daniel
> 
