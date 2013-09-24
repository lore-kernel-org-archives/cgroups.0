From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Date: Mon, 23 Sep 2013 17:52:47 -0700
Message-ID: <20130923175247.ea5156de.akpm@linux-foundation.org>
References: <524001F8.6070205@huawei.com>
	<20130923130816.GH30946@htj.dyndns.org>
	<20130923131215.GI30946@htj.dyndns.org>
	<5240DD83.1070509@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5240DD83.1070509-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, 24 Sep 2013 08:32:03 +0800 Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:

> On 2013/9/23 21:12, Tejun Heo wrote:
> > On Mon, Sep 23, 2013 at 09:08:16AM -0400, Tejun Heo wrote:
> >> Hello,
> >>
> >> On Mon, Sep 23, 2013 at 04:55:20PM +0800, Li Zefan wrote:
> >>> The whole patchset has been acked and reviewed by Michal and Tejun.
> >>> Could you merge it into mm tree?
> >>
> >> Ah... I really hoped that this had been merged during -rc1 window.
> >> Andrew, would it be okay to carry this series through cgroup tree?  It
> >> doesn't really have much to do with mm proper and it's a PITA to have
> >> to keep updating css_id code from cgroup side when it's scheduled to
> >> go away.  If carried in -mm, it's likely to cause conflicts with
> >> ongoing cgroup changes too.
> 
> I would love to see this patchset go through cgroup tree. The changes to
> memcg is quite small,

It seems logical to put this in the cgroup tree as that's where most of
the impact occurs.

> and as -mm tree is based on -next it won't cause
> future conflicts.

That's no longer the case - I'm staging -mm patches ahead of linux-next
now.  Except in cases where that's impractical, such as the 3.12 memcg
changes which were pretty heavily impacted by cgroups tree changes.

> > 
> > Also, wasn't this already in -mm during the last devel cycle?  ISTR
> > conflicts with it in -mm with other cgroup core changes.  Is there any
> > specific reason why this wasn't merged during the merge windw?
> > 
> 
> No, it never went into -mm tree... I guess it's because Andrew was too
> busy and overlooked this patchset?

I'm not sure what happened to the August 7 patchset, actually.  I don't
often overlook stuff - I'll skip things if the timing is terrible or if
the review comments indicate that another version is coming.  But none
of that seems to be the case here.  hmm...
