From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC][PATCH 0/7] memcg: make memcg's life cycle the same as cgroup
Date: Mon, 8 Apr 2013 11:18:40 +0400
Message-ID: <51626F50.6090204@parallels.com>
References: <515BF233.6070308@huawei.com> <516131D7.8030004@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <516131D7.8030004-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 04/07/2013 12:44 PM, Li Zefan wrote:
> Hi,
> 
> I'm rebasing this patchset against latest linux-next, and it conflicts with
> "[PATCH v2] memcg: debugging facility to access dangling memcgs." slightly.
> 
> That is a debugging patch and will never be pushed into mainline, so should I
> still base this patchset on that debugging patch?
> 
It will conflict as well with my shrinking patches: I will still keep
the memcgs in the dangling list, but that will have nothing to do with
debugging. So I will split that patch in a list management part, which
will be used, and a debugging part (with the file + the debugging
information).

I will be happy to rebase it ontop of your series.

> Also that patch needs update (and can be simplified) after this patchset:
> - move memcg_dangling_add() to mem_cgroup_css_offline()
> - remove memcg->memcg_name, and use cgroup_path() in mem_cgroup_dangling_read()?
> 

Don't worry about it. If this is just this one patch conflicting, I
would avise Andrew to remove it, and I will provide another (maybe two,
already splitted up) version.
