From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v5 0/4] Add support Weighted Round Robin for blkcg and
 nvme
Date: Tue, 31 Mar 2020 17:52:57 +0200
Message-ID: <20200331155257.GA22994@lst.de>
References: <cover.1580786525.git.zhangweiping@didiglobal.com> <20200204154200.GA5831@redsun51.ssa.fujisawa.hgst.com> <CAA70yB5qAj8YnNiPVD5zmPrrTr0A0F3v2cC6t2S1Fb0kiECLfw@mail.gmail.com> <CAA70yB62_6JD_8dJTGPjnjJfyJSa1xqiCVwwNYtsTCUXQR5uCA@mail.gmail.com> <20200331143635.GS162390@mtj.duckdns.org> <CAA70yB51=VQrL+2wC+DL8cYmGVACb2_w5UHc4XFn7MgZjUJaeg@mail.gmail.com> <20200331155139.GT162390@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200331155139.GT162390-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Keith Busch <kbusch-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Minwoo Im <minwoo.im.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nadolski, Edmund" <edmund.nadolski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

On Tue, Mar 31, 2020 at 11:51:39AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Mar 31, 2020 at 11:47:41PM +0800, Weiping Zhang wrote:
> > Do you means drop the "io.wrr" or "blkio.wrr" in cgroup, and use a
> > dedicated interface
> > like /dev/xxx or /proc/xxx?
> 
> Yes, something along that line. Given that it's nvme specific, it'd be best if
> the interface reflects that too - e.g. through a file under
> /sys/block/nvme*/device/. Jens, Christoph, what do you guys think?

I'm pretty sure I voiced my opinion before - I think the NVMe WRR
queueing concept is completely broken and I do not thing we should
support it at all.
