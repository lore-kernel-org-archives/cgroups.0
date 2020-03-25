From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/3] blkcg: add blk-iotrack
Date: Wed, 25 Mar 2020 10:12:36 -0400
Message-ID: <20200325141236.GJ162390@mtj.duckdns.org>
References: <cover.1584728740.git.zhangweiping@didiglobal.com>
 <20200324182725.GG162390@mtj.duckdns.org>
 <CAA70yB7a7VjgPLObe-rzfV0dLAumeUVy0Dps+dY5r-Guq2Susg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N7nQ4ebz3lUmPEZItWMKhCh2iPFhfdeLlfUD+yoZmZE=;
        b=FXRWZ4idTS/9SmW/h6ukMHo4O1sk+A7oUGDB5LsZQ8TKlldyn0o8yk88kVp2+kcSJC
         lvfqLWPwknKK0boCQXOXvGH17M9KbmCpw+qMPU/AXfi4lJQSylRdzjjv1OKBrKM03K3L
         8LGV2prz6EVm47zu9u+8bJ7y/P8CJulaulx5BkB7mfTRcwa0cGi4R1/7u49roDrt2BU/
         VdLxEKJhSbSnALe6Vr1yEJRTQLxGWRICUVQOOfkQLA5ahpQka7smhjhAmLiB+I70lyZV
         Fob0h/ZhNg+DZx+y0rC801gEIeQArWhhCPUrPRd5QTlXXyfMhQYoi+AByvtSvPuVBd0B
         7eOA==
Content-Disposition: inline
In-Reply-To: <CAA70yB7a7VjgPLObe-rzfV0dLAumeUVy0Dps+dY5r-Guq2Susg@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Weiping Zhang <zwp10758@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Mar 25, 2020 at 08:49:24PM +0800, Weiping Zhang wrote:
> For this patchset, iotrack can work well, I'm using it to monitor
> block cgroup for
> selecting a proper io isolation policy.

Yeah, I get that but monitoring needs tend to diverge quite a bit
depending on the use cases making detailed monitoring often need fair
bit of flexibility, so I'm a bit skeptical about adding a fixed
controller for that. I think a better approach may be implementing
features which can make dynamic monitoring whether that's through bpf,
drgn or plain tracepoints easier and more efficient.

Thanks.

-- 
tejun
