From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/10] blkcg: implement blk-ioweight
Date: Fri, 14 Jun 2019 08:09:24 -0700
Message-ID: <20190614150924.GB538958@devbig004.ftw2.facebook.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614015620.1587672-9-tj@kernel.org>
 <87pnngbbti.fsf@toke.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=+I9U1GODgSkyxPAIv5uSBlih1n/pRySECC43JZGkdsQ=;
        b=iGhc4xzitJMk67sXbQMyBo8eYE8TxhKJEDf+KuuPxlnOLUZFysidCzwr54Kzzy0K2J
         D+GJRX71MpXYgXx2M6apuBILbtB+nlVv2HxnXhyaQJh8VlGfzYaUAn2jZSunbRUcJP+x
         iOB3D7jvu5eEN6YbwgH60SuKTejWz4B6PizS20cko5zfs7ZiBvyTkCfK/CSqY5Bns3l8
         Ro6EsJZk30weiEJY/Uk5TEteCCGXB8XYvuQXqPh/3FoevGvIok7Er3BS5HLnUo9gdnw3
         FP2pyydyRWD6S3lNwlB6S79WFXpwubyELDGZOmGBXGY7MLSjmvWneimvwEkDnHpcmFWV
         0G/g==
Content-Disposition: inline
In-Reply-To: <87pnngbbti.fsf@toke.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org, Josef Bacik <jbacik@fb.com>

Hello, Toke.

On Fri, Jun 14, 2019 at 02:17:45PM +0200, Toke H=F8iland-J=F8rgensen wrote:
> One question: How are equal-weight cgroups scheduled relative to each
> other? Or requests from different processes within a single cgroup for
> that matter? FIFO? Round-robin? Something else?

Once each cgroup got their hierarchical weight and current vtime for
the period, they don't talk to each other.  Each is expected to do the
right thing on their own.  When the period ends, the timer looks at
how the device is performing, how much each used and so on and then
make necessary adjustments.  So, there's no direct cross-cgroup
synchronization.  Each is throttled to their target level
independently.

Within a single cgroup, the IOs are FIFO.  When an IO has enough vtime
credit, it just passes through.  When it doesn't, it always waits
behind any other IOs which are already waiting.

Thanks.

--=20
tejun
