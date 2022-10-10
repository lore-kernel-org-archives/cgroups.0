From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] perf stat: Support old kernels for bperf cgroup counting
Date: Mon, 10 Oct 2022 13:59:20 -1000
Message-ID: <Y0Sx2KWX4gPlLytq@slm.duckdns.org>
References: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com>
 <20220922041435.709119-1-namhyung@kernel.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XATmXDDouGmZ8eVmg2gOICME3agw6HNrb3TQMDuvm/4=;
        b=AS5j0WakWcXloGTMkDVqd2Cneha7BIrjvG2XXT41mxwinS7nhAdmQDYDl1IzutSN7N
         GtfRRcfzd/xXbKbIdHhfHCn7qpzNdjU25NUUUIt8Lj2MXVutYNCUSLZczrKNSg7HShqK
         G+LNdMzkSzzqM2Tl1x5FWduRvauGP8dZvRrRveXpg9Iv9KPDRJID+v0C8uufmRDysenO
         7AB7VUpvwZQibh3eFsy3F4vSq9HU8M+WE4BnUTlc/ZJpGSmRtHMdsfNXIFkmygCi03+G
         UlASbuOBE7FXyQhJNlcCOZIYSvSritHqCB5kuLO4I2L4te6Ox7aSJyuxic4Kwee29AwF
         Qfsg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220922041435.709119-1-namhyung@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org, Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org

On Wed, Sep 21, 2022 at 09:14:35PM -0700, Namhyung Kim wrote:
> The recent change in the cgroup will break the backward compatiblity in
> the BPF program.  It should support both old and new kernels using BPF
> CO-RE technique.
> 
> Like the task_struct->__state handling in the offcpu analysis, we can
> check the field name in the cgroup struct.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Looks like it's acked enough but the patch doesn't apply anymore. Namhyung,
can you please refresh the patch? I'll route this through
cgroup/for-6.1-fixes unless somebody objects.

Thanks.

-- 
tejun
