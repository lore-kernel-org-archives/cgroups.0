From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Sat, 10 Sep 2016 18:12:28 +0200
Message-ID: <20160910161228.GB29259@lst.de>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com> <1472632647-1525-2-git-send-email-pandit.parav@gmail.com> <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com> <20160831211618.GA12660@htj.duckdns.org> <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com> <20160901084406.GA4115@lst.de> <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 07, 2016 at 01:25:13PM +0530, Parav Pandit wrote:
> >  a) delay cgroups support until the grand rewrite is done
> >  b) add it now and deal with the consequences later
> >
> Can we do (b) now and differ adding any HW resources to cgroup until
> they are clearly called out.
> Architecture and APIs are already in place to support this.

Sounds fine to me.  The only thing I want to avoid is pie in the
sky "future proofing" that leads to horrible architectures.  And I assume
that's what Matan proposed.
