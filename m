From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Wed, 23 Apr 2014 13:17:20 -0400
Message-ID: <20140423171720.GF24651@redhat.com>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140423170141.GJ4781-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 23, 2014 at 01:01:41PM -0400, Tejun Heo wrote:
> On Tue, Apr 15, 2014 at 10:18:26AM -0400, Vivek Goyal wrote:
> > Ok, that's fine. Let us just document the knobs well so that people can
> > find which knob is giving what information and make cfq names better at
> > the expense of inconsistency of names with throttling layer.
> 
> I've been thinking about it more.  Why do we even have separate stats
> for common things like bytes transferred?  It doesn't serve any
> purpose to do double accounting and reporting on everything, does it?
> Shouldn't we just have single set of common stats for things like
> requests / bytes serviced?

I think we should just require two. One for measuring rate in terms
of IOPS and other for measuring rate in terms of [kMG]B/sec.

So exporting both sector and bytes seems redundant. May be exporting
bytes and dropping sector interface will do. Is size of sector exported
somewhere so that user space can easily convert bytes to sector if needed.

Number of bio/requests also will need to be exported so that one can come
up with IOPS.

Thanks
Vivek
