From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: drop duplicate header nsproxy.h
Date: Fri, 24 Mar 2017 11:36:57 -0400
Message-ID: <20170324153657.GC21525@htj.duckdns.org>
References: <622620bc9c85ce62cd7857e80acc2d0bcaff3aaf.1490342770.git.geliangtang@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1whdW5pjYgr/uNTb5HzadzgwFTn9CSLq1wUr6vZN1w8=;
        b=aKYKxmfe1fESshKcU9qmmgKHokrqOTpC3Sn7SGg6Fc42cmAjNRQXxpri0SrNfVZWfV
         Nt8+xC56NUg8f8ZKrFeTzQUV5WGXMOJztkMxWQqAm8RlnWYs5x2pQDxM33xinyWpMDdo
         DdKxFz5ZE9r+tyJGPwvZuOUyrZcoLmjkuv10RpILoRY7yoOTcV+TqL6iahT4xmBVYr+d
         r1Hp/Q//TOpAa9/uEgqLdsm6AAW8iIQeCIiPlCbeRszAniBMmBQT432YFE+GGm0pzCSu
         CzR2Nt3ibUJ5t3dfSDLmdwC5ycfIXzWfzjKuKGoxC8Tdp1Q5lDh1BVMH0ug/0ShKiCy7
         ujOQ==
Content-Disposition: inline
In-Reply-To: <622620bc9c85ce62cd7857e80acc2d0bcaff3aaf.1490342770.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Geliang Tang <geliangtang@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Mar 24, 2017 at 10:13:35PM +0800, Geliang Tang wrote:
> Drop duplicate header nsproxy.h from linux/cgroup.h.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Applied to cgroup/for-4.12.

Thanks.

-- 
tejun
