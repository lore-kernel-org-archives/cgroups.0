From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 3/6] memcg: Simplify mem_cgroup_force_empty_list
 error handling
Date: Wed, 31 Oct 2012 14:30:47 -0700
Message-ID: <20121031143047.95587bff.akpm@linux-foundation.org>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
	<1351251453-6140-4-git-send-email-mhocko@suse.cz>
	<508E8B95.406@parallels.com>
	<20121029150022.a595b866.akpm@linux-foundation.org>
	<20121030103559.GA7394@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121030103559.GA7394-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, 30 Oct 2012 11:35:59 +0100
Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:

> > If the kernel is uniprocessor and the caller is SCHED_FIFO: ad infinitum!
>
> ...
>
> Can we consider this as a corner case (it is much easier to kill a
> machine with SCHED_FIFO than this anyway) or the concern is really
> strong and we should come with a solution before this can get merged?

Sure.  SCHED_FIFO can be used to permanently block all kernel threads
which pretty quickly results in a very sick kernel.  My observation was
just a general moan about the SCHED_FIFO wontfix problem :)
