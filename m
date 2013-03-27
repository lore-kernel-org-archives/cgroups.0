From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Wed, 27 Mar 2013 17:27:07 +0100
Message-ID: <20130327162707.GO16579@dhcp22.suse.cz>
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz>
 <20130327161527.GA7395@htj.dyndns.org>
 <20130327161905.GN16579@dhcp22.suse.cz>
 <CAOS58YPsrZNU9qDeMgJG3-Hkn0cBaigz16eTS5M57G95E8fxUQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YPsrZNU9qDeMgJG3-Hkn0cBaigz16eTS5M57G95E8fxUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 27-03-13 09:21:02, Tejun Heo wrote:
> On Wed, Mar 27, 2013 at 9:19 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> >> Maybe the name could signify it's part of memcg?
> >
> > kmem_ prefix is used for all CONFIG_MEMCG_KMEM functions. I understand
> > it clashes with sl?b naming but this is out of scope of this patch IMO.
> 
> Oh, it's not using kmemcg? I see. Maybe we can rename later.

Some parts use memcg_kmem_* other kmem_. A cleanup would be nice.
Glauber?

-- 
Michal Hocko
SUSE Labs
