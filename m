From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH RFC 0/5] Virtual Memory Resource Controller for cgroups
Date: Thu, 10 Jul 2014 20:35:45 +0400
Message-ID: <20140710163545.GA835@esperanza>
References: <cover.1404383187.git.vdavydov@parallels.com>
 <20140709075252.GB31067@esperanza>
 <CAAAKZwsRDb6a062SFZYv-1SDYyD12uTzVMpdZt0CtdDjoddNVg@mail.gmail.com>
 <20140709163631.GG6685@esperanza>
 <CAHH2K0Y2OH9scJ8FGkL3M124RSfoUFiELNhGNTHJEsaCEm+hiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHH2K0Y2OH9scJ8FGkL3M124RSfoUFiELNhGNTHJEsaCEm+hiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Greg,

On Wed, Jul 09, 2014 at 10:04:21AM -0700, Greg Thelen wrote:
> On Wed, Jul 9, 2014 at 9:36 AM, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> > Hi Tim,
> >
> > On Wed, Jul 09, 2014 at 08:08:07AM -0700, Tim Hockin wrote:
> >> How is this different from RLIMIT_AS?  You specifically mentioned it
> >> earlier but you don't explain how this is different.
> >
> > The main difference is that RLIMIT_AS is per process while this
> > controller is per cgroup. RLIMIT_AS doesn't allow us to limit VSIZE for
> > a group of unrelated or cooperating through shmem processes.
> >
> > Also RLIMIT_AS accounts for total VM usage (including file mappings),
> > while this only charges private writable and shared mappings, whose
> > faulted-in pages always occupy mem+swap and therefore cannot be just
> > synced and dropped like file pages. In other words, this controller
> > works exactly as the global overcommit control.
> >
> >> From my perspective, this is pointless.  There's plenty of perfectly
> >> correct software that mmaps files without concern for VSIZE, because
> >> they never fault most of those pages in.
> >
> > But there's also software that correctly handles ENOMEM returned by
> > mmap. For example, mongodb keeps growing its buffers until mmap fails.
> > Therefore, if there's no overcommit control, it will be OOM-killed
> > sooner or later, which may be pretty annoying. And we did have customers
> > complaining about that.
> 
> Is mongodb's buffer growth causing the oom kills?

We saw this happened on our customer's node some time ago. A container
running mongodb and several other services got OOM-kills from time to
time, which made the customer unhappy. Limiting overcommit helped then.

> If yes, I wonder if apps, like mongodb, that want ENOMEM should (1)
> use MAP_POPULATE and (2) we change vm_map_pgoff() to propagate
> mm_populate() ENOMEM failures back to mmap()?

This way we may fault-in lots of pages, evicting someone's working set
along the way, only to get ENOMEM eventually. This doesn't look optimal.
Also, this requires modifications of userspace apps, which isn't always
possible.

Thanks.
