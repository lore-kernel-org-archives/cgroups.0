From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Sat, 10 Sep 2016 18:14:42 +0200
Message-ID: <20160910161442.GC29259@lst.de>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com> <1472632647-1525-2-git-send-email-pandit.parav@gmail.com> <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com> <20160831211618.GA12660@htj.duckdns.org> <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com> <20160901084406.GA4115@lst.de> <CAG53R5Ws4BJKqeEYfEoEx5kuaXUmhDKcXfH4Vx=LTMK6tKMG0A@mail.gmail.com> <ae3adcc4-253e-f87c-6ff6-202c91599f48@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ae3adcc4-253e-f87c-6ff6-202c91599f48-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 07, 2016 at 11:51:42AM +0300, Matan Barak wrote:
> All recent proposals of the new ABI schema deals with extending the 
> flexibility of the current schema by letting drivers define their specific 
> types, actions, attributes, etc. Even more than that, the dispatching 
> starts from the driver and it chooses if it wants to use the common RDMA 
> core layer or have it's own wise implementation instead.
> Some drivers might even prefer not to implement the current verbs types.
> These decisions were made in the OFVWG meetings.

OFVWG meetings have absolutely zero relevance for Linux development.
More "flexibility" for drivers just means giving up on designing a
coherent API and leaving it to drivers authors to add crap to their
own drivers.  That's a major step backwards.

> Sounds reasonable, but what about drivers which ignore the common code and 
> implement it in their own way? What about drivers which don't support the 
> standard RDMA types at all?

They should not be using the code in drivers/infiniband.  usnic is such
an example of a driver that should never have been added in it's current
form.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
