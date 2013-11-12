From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Tue, 12 Nov 2013 14:58:44 +0100
Message-ID: <20131112135844.GA6049@dhcp22.suse.cz>
References: <20131031192732.2dbb14b3@gandalf.local.home>
 <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
 <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131108001437.GC1092@cmpxchg.org>
 <CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com>
 <20131111153943.GA22384@dhcp22.suse.cz>
 <CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 11-11-13 17:11:04, Markus Blank-Burian wrote:
> >
> > Out of curiosity, do you have memcg swap accounting enabled? Or do you
> > use kmem accounting? How does your cgroup tree look like?
> 
> I have compiled my kernel with CONFIG_MEMCG_SWAP,
> CONFIG_MEMCG_SWAP_ENABLED, CONFIG_MEMCG_KMEM and CONFIG_CGROUP_HUGETLB
> options, although our machines have no active swap space at the
> moment.

No swap means that no charges are done by a group non-member. So the
race Johannes was describing shouldn't be the problem in your case.

Out of curiosity, do you set any limit for kmem?

[...]
> memory.use_hierarchy support is enabled and memory is limited from the
> job directory. I have mounted the cgroup to /var/slurm/cgroup/memory
> in addition to the normal directory at /sys/fs/cgroup/memory.

How exactly have you mounted it there?
[...]

Btw. how reproducible is this? Do you think you could try to bisect
it down? Reducing bisection to mm/ and kernel/ diretories should be
sufficient I guess.
-- 
Michal Hocko
SUSE Labs
