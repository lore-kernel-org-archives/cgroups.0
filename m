From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Wed, 23 Apr 2014 14:58:35 -0400
Message-ID: <20140423185835.GD22755@redhat.com>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
 <20140423171720.GF24651@redhat.com>
 <20140423185231.GA4163@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140423185231.GA4163-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 23, 2014 at 02:52:31PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Apr 23, 2014 at 01:17:20PM -0400, Vivek Goyal wrote:
> > I think we should just require two. One for measuring rate in terms
> > of IOPS and other for measuring rate in terms of [kMG]B/sec.
> 
> I meant between cfq and blk-throttle.  Why do we have separate stats
> for them to present ultimately the same numbers?

Oh, sorry, I had misunderstood your question.

- Number of IOs serviced will be different at throttling layer and
  CFQ layer as throttling accounts IO in terms of bios and CFQ
  accounts in terms of number of requests.

- CFQ might not be operational on a device while throttling might be
  on and one needs bytes stats.

- In a custom kernel throttling might not be on and CFQ is on and
  one needs the stats.

So I think we do require duplication of some stats across throttling
and CFQ, isn't it?

Thanks
Vivek
