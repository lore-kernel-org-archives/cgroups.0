From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-5.5-fixes] iocost: over-budget forced IOs should
 schedule async delay
Date: Mon, 16 Dec 2019 16:10:32 -0700
Message-ID: <fc474a2f-4e1b-8c9f-06bf-b479f7455c77@kernel.dk>
References: <20191216213400.GA2914998@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dCnC/jfvEWt+z7fAdBW+xSdl7SEaUneQSHaq+EB0tW8=;
        b=A860KQ4K3o5h8+6NmyV0mWqxB7G9iucprwDUlid50DJIt930o0EdvyrIQmDddU8BU/
         bII7+rThzGEDdo1NoanT+8dfcEbll4RsPU/2r2erpSocVBIUD8HBJv/ZJ1ydcHCtI1Np
         V5hqkNOaMZx3TmRNaZ1sCyvu6URHi990RaWsTjZd+axtL0dF6DkRNbqZoRcqmNkY3QEg
         /8Ycnsxw0i50SdGvYuPFBq+MGZ3yMfzTwU5bQEeG8LS4MaZ+3mbDQgvVmTM7dSPBmjhD
         lNQlUwedlAFoXrSrY7l3oXi86KE2p/ZLiYZxfh48oTu9MZ9P07dNtHABxC7j6VZJvVAt
         3M8g==
In-Reply-To: <20191216213400.GA2914998@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-block@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>

On 12/16/19 2:34 PM, Tejun Heo wrote:
> When over-budget IOs are force-issued through root cgroup,
> iocg_kick_delay() adjusts the async delay accordingly but doesn't
> actually schedule async throttle for the issuing task.  This bug is
> pretty well masked because sooner or later the offending threads are
> gonna get directly throttled on regular IOs or have async delay
> scheduled by mem_cgroup_throttle_swaprate().
> 
> However, it can affect control quality on filesystem metadata heavy
> operations.  Let's fix it by invoking blkcg_schedule_throttle() when
> iocg_kick_delay() says async delay is needed.

Applied, thanks Tejun.

-- 
Jens Axboe

