From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
Date: Wed, 22 May 2013 12:32:33 +0200
Message-ID: <20130522103233.GB19989@dhcp22.suse.cz>
References: <1368535118-27369-1-git-send-email-avagin@openvz.org>
 <20130514160859.GC5055@dhcp22.suse.cz>
 <20130522074055.GA16207@paralelels.com>
 <519C78C0.3050204@huawei.com>
 <20130522075638.GB16934@paralelels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130522075638.GB16934-yYYamFZzV1regbzhZkK2zA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Wed 22-05-13 11:56:38, Andrew Vagin wrote:
> On Wed, May 22, 2013 at 03:50:24PM +0800, Li Zefan wrote:
> > On 2013/5/22 15:40, Andrew Vagin wrote:
> > > On Tue, May 14, 2013 at 06:08:59PM +0200, Michal Hocko wrote:
> > >>
> > >> Forgot to add
> > >> Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > >> +
> > >> Cc: stable # 3.9
> > >>
> > >> Thanks
> > > 
> > > Who usually picks up such patches?
> > 
> > The famous AKPM.
> >
> 
> Thanks.
> 
> get_maintainer.pl doesn't show Andrew in the list of recipients.

Yes, but most of the mm patches fly via Andrew.

> $ perl scripts/get_maintainer.pl 0001-memcg-don-t-initialize-kmem-cache-destroying-work-fo.patch
> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> (maintainer:MEMORY RESOURCE C...)
> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> (maintainer:MEMORY RESOURCE C...)
> Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (maintainer:MEMORY RESOURCE C...)
> KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> (maintainer:MEMORY RESOURCE C...)
> cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:MEMORY RESOURCE C...)
> linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org (open list:MEMORY RESOURCE C...)
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list) 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
