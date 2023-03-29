From: Tejun Heo <tj@kernel.org>
Subject: Re: move bio cgroup punting into btrfs
Date: Wed, 29 Mar 2023 09:16:18 -1000
Message-ID: <ZCSOgoe84BhiUZcn@slm.duckdns.org>
References: <20230327004954.728797-1-hch@lst.de>
 <512eaacf-3ff6-f4f9-c856-a0e03c027501@meta.com>
 <20230328233448.GA5486@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680117381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v2qh7XjFgypAL2kgZ/c2uWUMXWM5l/TX2xEZm0UsPCQ=;
        b=PcfWqe2OVHMzdKmVVolkt0xO/9xOIN5oG2Aa+RSisB/oeLmGNhZLLHQE/Wb7ysSRhR
         y3ZlqH6B9dg6vwwtugRcsZew8lhi8F+BsxM6CcXAyKBf0xagM/NfJ32XaHx84DRlGwnC
         vCq+66s1Pvf3QsCu9ST3TcNfx2EykErfC/N/QxJgZQNVTCyoEHZMC6uHMhy6SAPTDO3N
         MloXRtpwimLR4K8A72rz5peMu8rcArfukBvaSj4O1f9zAf/SY81Ne+T3VtgFg9Lps3xz
         11jVxauVOaLa1HMJ/keFmmqpliwQTNfYs8JBR4QnRmAZUEALbVI9VuqEPiv1KsZgECUd
         /+pA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230328233448.GA5486@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <clm@meta.com>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org

Hello, Christoph.

I'm semi-offline for a few weeks, so please pardon the tardiness and
brevity.

On Wed, Mar 29, 2023 at 01:34:48AM +0200, Christoph Hellwig wrote:
> On Tue, Mar 28, 2023 at 05:18:43PM -0400, Chris Mason wrote:
> btrfs is the only place offloading writes from the per-cgroup writeback
> to it's own not cgroup aware workqueues.
>
> Offloading from one writeback thread to another threadpool to just
> offload back to another thread to not deadlock is obviously not
> an actual smart thing to do, and fortunately no one else is doing
> this.

We didn't really look deep into adding the support but Chris mentioned that
raid5/6 are likely to need something similar. Maybe this is because my grasp
of filesytsems is pretty weak but the pattern doesn't seem unreasonable to
me. There's some work to be done by a shread kthread and that sometimes can
fork out IOs which belong to specific cgroups.

> For btrfs it is on it's way out by not doing the offload just for
> checksumming in a little bit, and even for compression the right fix
> is just to allow more than one thread per device and cgroup.  I plan
> to look into that, but there's plenty higher priority work right now.

At least in the IO control and direct issue path, punting to just one thread
hasn't been a practical problem given that when the issuing thread needs to
be blocked, either the whole device or the cgroup needs to be throttled
anyway. Are you thinking about scenarios where substantial CPU cycles are
consumed for IOs (e.g. dm-crypt)?

Thanks.

-- 
tejun
