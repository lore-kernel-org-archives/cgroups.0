From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 block/for-linus] writeback: flush inode cgroup wb
 switches instead of pinning super_block
Date: Wed, 2 Mar 2016 11:29:41 +0100
Message-ID: <20160302102941.GC19633@quack.suse.cz>
References: <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160229204724.GV3965@htj.duckdns.org>
 <20160229232853.GD3965@htj.duckdns.org>
 <56D5D592.2020800@kernel.dk>
 <CAOS58YO5vTBnM561np7gpXKGQELrT169bYqmcfvAvsquBJK5yw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YO5vTBnM561np7gpXKGQELrT169bYqmcfvAvsquBJK5yw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

On Tue 01-03-16 12:50:19, Tejun Heo wrote:
> Hello, Jens.
> 
> On Tue, Mar 1, 2016 at 12:46 PM, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> > I queued this up for 4.5, but I'm feeling a bit uneasy about it. But it's
> > either that, or revert 5ff8eaac1636 and fix it for real in 4.6. Jan/Tejun,
> > what do you think?
> 
> Given that this only matters for cgroup writeback cases, this should
> still be fairly low impact, so I don't think it'd matter too much
> whether we fix this in this cycle or for 4.6. However, that also means
> that we're not risking much by doing it in this cycle, so I'd vote for
> doing it now.

Yeah, without CGROUP_WRITEBACK enabled this patch is NOP so I don't care
much when this gets merged.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
