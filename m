From: Hao Lee <haolee.swjtu@gmail.com>
Subject: Re: [PATCH] cgroup: Remove unnecessary call to strstrip()
Date: Thu, 1 Oct 2020 14:46:41 +0000
Message-ID: <20201001144641.GB8928@haolee.github.io>
References: <20200908133350.GA22979@haolee.github.io>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/bvJaeIsvnVRyggeVeOl1YTR4So/Xa/e8HzZoos6sug=;
        b=hDzu1IyME39GYnbjWw4BBFlrkMJP7fdud853cSG9GTOcrxENdsTmlATM/v3JjnXH18
         2lRsNhTDtVgJhpdW/8YJUjxcHjjYAXk1NTLmmLIdzwl4j4cYpliXjmioKmRhlfVCuxDv
         V5lwQY7ec1dESimJTLFfCdPeAqAK860WhBRTdW7/7elmIOQiI2E3FbwM1UrP8SE/2/4h
         0dabI25Qy31pPdCq4JYI3wzHjAZwMBI5J4p69B/1ohk/ng5x9ltM1Yrxhdf24f4lXQJk
         bZk85kzBw1MpgsjimKsu6RrMlZGSakjQ7iujFCd4sgxiVlFoeLYuCgq7nNXEQmgeVqZ2
         syNA==
Content-Disposition: inline
In-Reply-To: <20200908133350.GA22979@haolee.github.io>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Ping. Thanks.

On Tue, Sep 08, 2020 at 01:33:50PM +0000, Hao Lee wrote:
> The string buf will be stripped in cgroup_procs_write_start() before it
> is converted to int, so remove this unnecessary call to strstrip().
> 
> Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
> ---
>  kernel/cgroup/cgroup.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index b6714166106d..90ee7e73eb2e 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -4772,14 +4772,12 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
>  {
>  	struct cgroup *src_cgrp, *dst_cgrp;
>  	struct task_struct *task;
>  	ssize_t ret;
>  	bool locked;
>  
> -	buf = strstrip(buf);
> -
>  	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
>  	if (!dst_cgrp)
>  		return -ENODEV;
>  
>  	task = cgroup_procs_write_start(buf, false, &locked);
>  	ret = PTR_ERR_OR_ZERO(task);
> -- 
> 2.24.1
> 
