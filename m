From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/3] blkcg: add blk-iotrack
Date: Tue, 24 Mar 2020 14:27:25 -0400
Message-ID: <20200324182725.GG162390@mtj.duckdns.org>
References: <cover.1584728740.git.zhangweiping@didiglobal.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x+AJ73g67Lv+1tYqp3JK2cKPMpi2aKN3Up6Cs52zqao=;
        b=vPcBHMCUcEGWwF6ReF3V5Oj14G9fzThxHKTmhQWjdrqvvIU9w3190k+I52sQr16+Ij
         oLI36ieeOKdcMESeKCP0s24tJvKWfCQUYwfrD41UAeIb0gw84GL36gxKS0INNJBA5pzu
         y5iXEEJRgq7+T+bK1a76JZ/eLF7uVGK7Be8OZlrMhcSQ28zyswt2Lwj3o3NDu8M04eBq
         jbpWIyfyWojPE0y1UPULVXZCGWsxOa4n1gQa07TQR0uAgB2ZDs+J/hPstNCRW6pycLVy
         VbFTImV9nQ8yIf6tFuqUAFcBDKV2V3X9WYdzJ7gF4668/MFNL0sPsMeCdVxmyPlTzz/Q
         qdMA==
Content-Disposition: inline
In-Reply-To: <cover.1584728740.git.zhangweiping-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Mar 21, 2020 at 09:20:36AM +0800, Weiping Zhang wrote:
> The user space tool, which called iotrack, used to collect these basic
> io statistics and then generate more valuable metrics at cgroup level.
> From iotrack, you can get a cgroup's percentile for io, bytes,
> total_time and disk_time of the whole disk. It can easily to evaluate
> the real weight of the weight based policy(bfq, blk-iocost).
> There are lots of metrics for read and write generate by iotrack,
> for more details, please visit: https://github.com/dublio/iotrack.
> 
> Test result for two fio with randread 4K,
> test1 cgroup bfq weight = 800
> test2 cgroup bfq weight = 100
> 
> Device      io/s   MB/s    %io    %MB    %tm   %dtm  %d2c %hit0 %hit1 %hit2 %hit3 %hit4 %hit5  %hit6  %hit7 cgroup
> nvme1n1 44588.00 174.17 100.00 100.00 100.00 100.00 38.46  0.25 45.27 95.90 98.33 99.47 99.85  99.92  99.95 /
> nvme1n1 30206.00 117.99  67.74  67.74  29.44  67.29 87.90  0.35 47.82 99.22 99.98 99.99 99.99 100.00 100.00 /test1
> nvme1n1 14370.00  56.13  32.23  32.23  70.55  32.69 17.82  0.03 39.89 88.92 94.88 98.37 99.53  99.77  99.85 /test2

Maybe this'd be better done with bpf?

-- 
tejun
