From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/3] blkcg: add blk-iotrack
Date: Tue, 31 Mar 2020 10:19:16 -0400
Message-ID: <20200331141916.GR162390@mtj.duckdns.org>
References: <cover.1584728740.git.zhangweiping@didiglobal.com>
 <20200324182725.GG162390@mtj.duckdns.org>
 <CAA70yB7a7VjgPLObe-rzfV0dLAumeUVy0Dps+dY5r-Guq2Susg@mail.gmail.com>
 <20200325141236.GJ162390@mtj.duckdns.org>
 <CAA70yB5yH9H6-gaKfRSTmgd6vvzP4T9N7v-NAD0MsRL+YTexHw@mail.gmail.com>
 <CAA70yB4e65nbV=ZA8OT-SUkq+ZQOGGB9e-3QKJ_PqXjVaXGvFA@mail.gmail.com>
 <20200326161328.GN162390@mtj.duckdns.org>
 <CAA70yB66fBdAOnv+8rXauwbuPu+UY+gr9ZKeSsQNgq+ZHhJn3Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vWkjn/y5z/dvwzoJa8fqZIHet243GVuFUj07PejuwaE=;
        b=T6T/0Cx78XqhWhUA60nml5Yrd74RnfM3vsZkhJ9RcOX3N2/3yw2IiD61b7qinK/6Mg
         u+f6SZWEH4A6U7ffH7NexMNDW84Kl4Yy2zNFuNZ9pvvTt2VGHMO0NYHkQNF1tR331Bkm
         E6MJYizuWuC1PU3HmLQr+cwhMgHCyQWGn4nIRkfhdlGUnuNYBPNahoIjZK1tYNklipdG
         qguOlG4bxfVxlKljm69N13GRRqBzZ9mAU3nKpQ5Qg0FfUhFOH8DKVQLwXtcwN+e4iAB6
         4zPr7BxxdiGlM9pgipr5clQLkJu0YN/2uyph8cTAWAcSJ4pWInpiufYuzws96hKDfLL7
         aXUg==
Content-Disposition: inline
In-Reply-To: <CAA70yB66fBdAOnv+8rXauwbuPu+UY+gr9ZKeSsQNgq+ZHhJn3Q@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Weiping Zhang <zwp10758@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

Hello, Weiping.

On Fri, Mar 27, 2020 at 12:27:11AM +0800, Weiping Zhang wrote:
> I really appreciate that if you help review blk-iotrack.c, or just
> drop io.iotrakc.stat
> and append these  statistics to the io.stat? I think these metrics is usefull,

So, the problem is that you can get the same exact and easily more information
using bpf. There definitely are benefits to baking in some stastics in terms of
overhead and accessbility but I'm not sure what's being proposed is generic
and/or flexible enough to bake into the interface at this point.

Something which can be immediately useful would be cgroup-aware bpf progs which
expose these statistics. Can you please take a look at the followings?

  https://github.com/iovisor/bcc/blob/master/tools/biolatency.py
  https://github.com/iovisor/bcc/blob/master/tools/biolatency_example.txt

They aren't cgroup aware but can be made so and can provide a lot more detailed
statistics than something we can hardcode into the kernel.

Thanks.

-- 
tejun
