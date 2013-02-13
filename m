From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: Add memory.pressure_level events
Date: Wed, 13 Feb 2013 11:55:38 +0400
Message-ID: <511B46FA.1090802@parallels.com>
References: <20130211000220.GA28247@lizard.gateway.2wire.net> <5118C522.3070905@parallels.com> <20130213071922.GB20543@lizard.gateway.2wire.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130213071922.GB20543-1CZZkhFgUWNRmOO2HpYVOJIbA5emDH3N@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Leonid Moiseichuk <leonid.moiseichuk-xNZwKgViW5gAvxtiuMwx3w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org


>>> +void __init enable_pressure_cgroup(void)
>>> +{
>>> +	WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
>>> +				   vmpressure_cgroup_files));
>>> +}
>>
>> There is no functionality discovery going on here, and this is
>> conditional on nothing. Isn't it better then to just add the register +
>> read functions to memcontrol.c and add the files in the memcontrol cftype ?
> 
> I was trying to make the stuff similar to the existing CONFIG_MEMCG_SWAP
> code, which does this kind of adding files to the cgroup. But I can surely
> place files into memcontrol cftype as you suggest.
> 
> Thanks a lot for the comments!
> 
Note that swap can be command line disabled, and in that case we won't
register the files.

Then it makes sense to do it in a separate helper. If I understand your
code correctly, once it is compiled in, it will always be enabled. So I
personally think it is clearer if you register it together with the rest
of the crew.


