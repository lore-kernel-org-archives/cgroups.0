From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Tue, 15 Apr 2014 10:18:26 -0400
Message-ID: <20140415141826.GB17018@redhat.com>
References: <20140413013209.GC26252@mtj.dyndns.org>
 <20140414180824.GB9552@redhat.com>
 <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140415140650.GI1863@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

On Tue, Apr 15, 2014 at 10:06:50AM -0400, Tejun Heo wrote:

[..]
> But then do we name other stat knobs similarly too?
> 
>  blkio.cfq.io_service_sectors
>  blkio.cfq.io_service_bytes
>  blkio.cfq.io_serviced
>  blkio.cfq.io_merged
> 
> I don't know.  The names look outright stupid to me.  If we don't do
> the above, then we have internal inconsistencies among cfq knob names
> which gotta be worse then cfq / throttl inconsistency.  It's not a
> perfect situation no matter what we do.  As long as each knob is
> clearly documented, I don't think these inconsistencies are big deal,
> so let's just clean up cfq names as we need to add prefix anyway.

Ok, that's fine. Let us just document the knobs well so that people can
find which knob is giving what information and make cfq names better at
the expense of inconsistency of names with throttling layer.

Thanks
Vivek
