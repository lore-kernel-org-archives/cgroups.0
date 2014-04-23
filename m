From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Wed, 23 Apr 2014 15:21:09 -0400
Message-ID: <20140423192108.GF22755@redhat.com>
References: <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
 <20140423171720.GF24651@redhat.com>
 <20140423185231.GA4163@mtj.dyndns.org>
 <20140423185835.GD22755@redhat.com>
 <20140423190043.GB4163@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140423190043.GB4163-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 23, 2014 at 03:00:43PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Apr 23, 2014 at 02:58:35PM -0400, Vivek Goyal wrote:
> > Oh, sorry, I had misunderstood your question.
> > 
> > - Number of IOs serviced will be different at throttling layer and
> >   CFQ layer as throttling accounts IO in terms of bios and CFQ
> >   accounts in terms of number of requests.
> 
> But shouldn't it be possible to determine that from merged count?  Or
> we can just expose both bio and request counts at block core layer.
> The point is that there's nothing controller specific about these
> stats.

In general this idea makes sense. Exporting both request and bio will
solve the problem of io accounting. Also that should allow us to
get rid of blkio.io_merged.

What about sync/async differentiation? Throttling layer seems to flag a request sync
only if bio->bi_rw flag has REQ_SYNC set. While CFQ seems to consider
request sync if bio is either read or bio->bi_rw has REQ_SYNC flag set.

So we need to make this definition uniform. Or I am wondering do we
really need to export sync/async data. (Again put in by google folks).
How useful this info really is. 

Thanks
Vivek
