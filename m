From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 4/8] mm: memcg: lookup_page_cgroup (almost) never returns
 NULL
Date: Mon, 28 Nov 2011 10:17:03 +0100
Message-ID: <20111128091703.GB9356@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-5-git-send-email-hannes@cmpxchg.org>
 <CAKTCnz=CObdw0z4Qf36=afwwApuTer5C4Jp21QUko-H__q-+aA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKTCnz=CObdw0z4Qf36=afwwApuTer5C4Jp21QUko-H__q-+aA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 28, 2011 at 12:33:31PM +0530, Balbir Singh wrote:
> On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > Pages have their corresponding page_cgroup descriptors set up before
> > they are used in userspace, and thus managed by a memory cgroup.
> >
> > The only time where lookup_page_cgroup() can return NULL is in the
> > page sanity checking code that executes while feeding pages into the
> > page allocator for the first time.
> >
> 
> This is a legacy check from the days when we allocated PC during fault
> time on demand. It might make sense to assert on !pc in DEBUG_VM mode
> at some point in the future

I don't think a BUG_ON bears more information than a null-pointer
dereference.
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
