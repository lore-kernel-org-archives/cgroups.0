From: Christoph Hellwig <hch@lst.de>
Subject: Re: move bio cgroup punting into btrfs
Date: Thu, 30 Mar 2023 02:15:52 +0200
Message-ID: <20230330001552.GA2381@lst.de>
References: <20230327004954.728797-1-hch@lst.de> <512eaacf-3ff6-f4f9-c856-a0e03c027501@meta.com> <20230328233448.GA5486@lst.de> <ZCSOgoe84BhiUZcn@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ZCSOgoe84BhiUZcn@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Chris Mason <clm@meta.com>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org

On Wed, Mar 29, 2023 at 09:16:18AM -1000, Tejun Heo wrote:
> We didn't really look deep into adding the support but Chris mentioned that
> raid5/6 are likely to need something similar. Maybe this is because my grasp
> of filesytsems is pretty weak but the pattern doesn't seem unreasonable to
> me. There's some work to be done by a shread kthread and that sometimes can
> fork out IOs which belong to specific cgroups.

Well, in a cgroup aware writeback path we'd always be off much better
to just do the work from a cgroup specific thread instead of bouncing
it around.

> At least in the IO control and direct issue path, punting to just one thread
> hasn't been a practical problem given that when the issuing thread needs to
> be blocked, either the whole device or the cgroup needs to be throttled
> anyway.

I don't think it is a problem per see.  But it is: a) inefficient and
b) complex in terms of code.  So why bounce around between 2, or in case
of writeback 3 threads for a single I/O, instead of making sure your
offload threads are simplify cgroup specific to start with?
