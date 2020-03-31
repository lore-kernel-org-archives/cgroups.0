From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 0/4] Add support Weighted Round Robin for blkcg and
 nvme
Date: Tue, 31 Mar 2020 11:51:39 -0400
Message-ID: <20200331155139.GT162390@mtj.duckdns.org>
References: <cover.1580786525.git.zhangweiping@didiglobal.com>
 <20200204154200.GA5831@redsun51.ssa.fujisawa.hgst.com>
 <CAA70yB5qAj8YnNiPVD5zmPrrTr0A0F3v2cC6t2S1Fb0kiECLfw@mail.gmail.com>
 <CAA70yB62_6JD_8dJTGPjnjJfyJSa1xqiCVwwNYtsTCUXQR5uCA@mail.gmail.com>
 <20200331143635.GS162390@mtj.duckdns.org>
 <CAA70yB51=VQrL+2wC+DL8cYmGVACb2_w5UHc4XFn7MgZjUJaeg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cw3Eh01JFPi8BMIikV3NbP3KCc0IWLFrVC/r+JOBGd8=;
        b=qr5/dccWdp9TcfXD7AQm7YO7pfp2jr9W5meVcYfS3ee7ORl14fhtMqp24mEz3V//yV
         oCvp/JGHSpVTWxB15h0c4Tw4O8c1eid8vCrasK7pLmAxllaXl7JMxoiUl1ZOaAqtK57r
         UMthNrTT0vql6RAOKLEgwD7eh66Fi4BszDDk6REcQ0sqcE7dN72eZLVR7G7/5UzmKZba
         OmLFFwYl+GFCNz04bRJLRvd1MTzSsngAaRY0p5NnLVAkllK4quqmspn/6m+08ObMrl/E
         W3tgCwzmxzN6zKhpLMiWVQkk5u4DBqjeRqjREusjH7t5/6gJ0PyqmnXM9Cg8igKeYqAI
         odmw==
Content-Disposition: inline
In-Reply-To: <CAA70yB51=VQrL+2wC+DL8cYmGVACb2_w5UHc4XFn7MgZjUJaeg@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Weiping Zhang <zwp10758@gmail.com>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>, Minwoo Im <minwoo.im.dev@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ming Lei <ming.lei@redhat.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org

Hello,

On Tue, Mar 31, 2020 at 11:47:41PM +0800, Weiping Zhang wrote:
> Do you means drop the "io.wrr" or "blkio.wrr" in cgroup, and use a
> dedicated interface
> like /dev/xxx or /proc/xxx?

Yes, something along that line. Given that it's nvme specific, it'd be best if
the interface reflects that too - e.g. through a file under
/sys/block/nvme*/device/. Jens, Christoph, what do you guys think?

> I see the perf code:
> struct fd f = fdget(fd)
> struct cgroup_subsys_state *css =
> css_tryget_online_from_dir(f.file->f_path.dentry,
>         &perf_event_cgrp_subsys);
> 
> Looks can be applied to block cgroup in same way.

Yeah, either fd or ino can be used to identify a cgroup.

Thanks.

-- 
tejun
