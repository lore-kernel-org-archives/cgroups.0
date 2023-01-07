From: hanjinke <hanjinke.666@bytedance.com>
Subject: Re: [External] Re: [PATCH v3] blk-throtl: Introduce sync and async
 queues for blk-throtl
Date: Sat, 7 Jan 2023 12:44:35 +0800
Message-ID: <e499f088-8ed9-2e19-b2e5-efaa4f9738f0@bytedance.com>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <20230106153813.4ttyuikzaagkk2sc@quack3> <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
 <c839ba6c-80ac-6d92-af64-5c0e1956ae93@bytedance.com>
 <Y7hlX4T1UOmQHiGf@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeUPS2iKNE5OrN4vW8ZJQleZwh3WJYgGdDBNvXHEJYc=;
        b=OGcIprLg/imeJCuDYwJBLKaKHytu+oosVJno5w7Yr3wgiFgmnzXnr1Nl+0w6dZkuyj
         bVWz/aMUwD5CuH5eRpIOyK9e60S5jbQ8rDUhqFOksAKbNucMI6FMlI6PuVkyS847mbQS
         lYrSoXAVHGN8q9pRHISuHJO2Dmf1gDsJ/8tILU2M10Jm3/73zvNFOJ61PUtHJX5c7tF7
         B6YLPAHPVtXAsti0eDHGXuyKa4kCHvyeoLqkTBM/b5YXCi+SMlSSvdIPh96dTo02SLVq
         hsWCrzmn0M0liCwxM2oJDLgOLTk9d0X2uG4kYtSCQftSFfueOy3Q65jwAGwlUV7sH4SP
         8LMw==
In-Reply-To: <Y7hlX4T1UOmQHiGf@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com



在 2023/1/7 上午2:15, Tejun Heo 写道:
> Hello,
> 
> On Sat, Jan 07, 2023 at 02:07:38AM +0800, hanjinke wrote:
>> In our internal scenario, iocost has been deployed as the main io isolation
>> method and is gradually spreading。
> 
> Ah, glad to hear. If you don't mind sharing, how are you configuring iocost
> currently? How do you derive the parameters?
> 

For cost.model setting, We first use the tools iocost provided to test 
the benchmark model parameters of different types of disks online, and 
then save these benchmark parameters to a parametric Model Table. During 
the deployment process, pull and set the corresponding model parameters 
according to the type of disk.

The setting of cost.qos should be considered slightly more，we need to 
make some compromises between overall disk throughput and io latency.
The average disk utilization of the entire disk on a specific business 
and the RLA（if it is io sensitive） of key businesses will be taken as 
important input considerations. The cost.qos will be dynamically 
fine-tuned according to the health status monitoring of key businesses.

For cost.weight setting, high-priority services  will gain greater 
advantages through weight settings to deal with a large number of io 
requests in a short period of time. It works fine as work-conservation
of iocost works well according to our observation.

These practices can be done better and I look forward to your better 
suggestions.


> blk-throttle has a lot of issues which may be difficult to address. Even the
> way it's configured is pretty difficult to scale across different hardware /
> application combinations and we've neglected its control performance and
> behavior (like handling of shared IOs) for quite a while.
> 
> While iocost's work-conserving control does address a lot of the use cases
> we see today, it's likely that we'll need hard limits more in the future
> too. I've been thinking about implementing io.max on top of iocost. There
> are some challenges around dynamic vrate adj semantics but it's kinda
> attractive because iocost already has the concept of total device capacity.

Indeed in our multi-tenancy scenario, the hard limits are necessary.

Jinke
Thanks.

