From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup-v2: Add taskstats counters in cgroup.stat
Date: Thu, 11 Mar 2021 06:10:25 -0500
Message-ID: <YEn6od+CCVjNZIS9@slm.duckdns.org>
References: <20210311061752.310831-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4FDhkUkdj8fWqlipDBp6WuM7/UyISTb34fe+zJutuhk=;
        b=P849DNFgS5nte6HYXGD6ebAhhBZ3CyFnv9N3Sr2OhrHYwPjZon8k1Uf09nEsePPWI0
         H9dmyx+EEhFA/GBdul8L0iS9ImrDHwqzKxTUxo7LNAZ4EBKimkA8s4dQS0umgEhbgttx
         jRTxH4Wng6J+VJxQ4lnEAxHZe3iMCaQMx9n22CblexjSVPeCf+1Nl4XSIsdSbNdMbWdx
         i5ZhN1Ux4/9F8jxSWEX+T5YsVD+Y/92mIsKAy2YM0NsJSyw4CDCt1snVu0JcpbWQsBOc
         wvKxY6zBFQwDQAV1K40PCqBou18XW6/Fmbt1sZ4xYK0NirvYCvAJ0nxsL+CcWem4M5TY
         F93g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210311061752.310831-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On Thu, Mar 11, 2021 at 02:17:52PM +0800, Chengming Zhou wrote:
> We have the netlink CGROUPSTATS_CMD_GET interface to get taskstats
> of the cgroup on v1, but haven't the equivalent interface on v2,
> making it difficult to calculate the per-cgroup cpu load in cadvisor
> or implement the cgroup proc interface in lxcfs, like /proc/loadavg.

So, this is what the PSI metrics are for and we've been using it for that
for quite a while now. I'd much prefer not adding something duplicate (and
incomplete).

Thanks.

-- 
tejun
