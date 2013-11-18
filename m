From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 18 Nov 2013 10:45:54 +0100
Message-ID: <20131118094554.GA32623@dhcp22.suse.cz>
References: <5277932C.40400@huawei.com>
 <CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
 <5278B3F1.9040502@huawei.com>
 <20131107235301.GB1092@cmpxchg.org>
 <20131108001437.GC1092@cmpxchg.org>
 <CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com>
 <20131111153943.GA22384@dhcp22.suse.cz>
 <CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg@mail.gmail.com>
 <20131112135844.GA6049@dhcp22.suse.cz>
 <CA+SBX_O4oK1H7Gtb5OFYSn_W3Gz+d-YqF7OmM3mOrRTp6x3pvw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+SBX_O4oK1H7Gtb5OFYSn_W3Gz+d-YqF7OmM3mOrRTp6x3pvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

[restoring CC list]

On Wed 13-11-13 17:29:15, Markus Blank-Burian wrote:
> >> I have compiled my kernel with CONFIG_MEMCG_SWAP,
> >> CONFIG_MEMCG_SWAP_ENABLED, CONFIG_MEMCG_KMEM and CONFIG_CGROUP_HUGETLB
> >> options, although our machines have no active swap space at the
> >> moment.
> >
> > No swap means that no charges are done by a group non-member. So the
> > race Johannes was describing shouldn't be the problem in your case.
> >
> 
> Disabling CONFIG_MEMCG_SWAP and CONFIG_MEMCG_KMEM had no effect.
> 
> >> memory.use_hierarchy support is enabled and memory is limited from the
> >> job directory. I have mounted the cgroup to /var/slurm/cgroup/memory
> >> in addition to the normal directory at /sys/fs/cgroup/memory.
> >
> > How exactly have you mounted it there?
> 
> Mounted now at the correct position.
> 
> > Btw. how reproducible is this? Do you think you could try to bisect
> > it down? Reducing bisection to mm/ and kernel/ diretories should be
> > sufficient I guess.
> 
> I tried the one-liner from Johannes, but this also showed no effect.

There is one more issue which is discussed in another thread
(https://lkml.org/lkml/2013/11/15/31) and Tejun has posted a patch (and
Hugh followed up on it https://lkml.org/lkml/2013/11/17/166) to fix
the cgroup destruction path which may get stuck.

> Bisectioning is still on my todo list, as git does not stay on the
> aufs branch and i have to manually merge the aufs patch each step.


-- 
Michal Hocko
SUSE Labs
