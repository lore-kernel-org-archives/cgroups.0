From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH-block v2] bdi, blk-cgroup: Fix potential UAF of blkcg
Date: Wed, 30 Nov 2022 08:23:44 -0700
Message-ID: <34932e06-7336-3f17-9bc4-0fc67130d561@kernel.dk>
References: <20221129203400.1456100-1-longman@redhat.com>
 <20221130151639.GE27838@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MVSvVeCDGQ1o47gYLtN8R+awQ9lS7VAhyH71o2xLC54=;
        b=ctCk0Dd6GzAls1JzBIxBk3DiSB9qYtO/HUeatCrvfQP+Kd/x38VyYHbGjvMu21RNH2
         XPVqP5WnCYBDrtJRf6yQdJbQHyHzCF4Ilyg0ou4AXQ5x0ECKWT6hs7QGdFhwGfbL8S89
         VaN2X8kSnHxYl7xt0FZDyKaa6axIjIyEf3yudcU3GmWc1Qi/bO/hxPxUSPvwEYL25zgN
         fYSc2O894eFB+ql7gLFD9tLcPNV1OFNOAqFeiQdH7ZvkijH5E64ZuBq9KV7B7zNIsASP
         6lyHiU4g+neMI8hcv1LCpJeDlMuLgkhZZCTfWAsosdJTAC5CVztGGjtJtILnLXvg5uCj
         MKXQ==
Content-Language: en-US
In-Reply-To: <20221130151639.GE27838-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 11/30/22 8:16?AM, Michal Koutn? wrote:
> On Tue, Nov 29, 2022 at 03:34:00PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> The reproducing system can no longer produce a warning with this patch.
>> All the runnable block/0* tests including block/027 were run successfully
>> without failure.
> 
> Thanks for the test!
> 
>> @@ -1088,7 +1088,15 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
>>  
>>  	might_sleep();
>>  
>> -	css_get(&blkcg->css);
>> +	/*
>> +	 * blkcg_destroy_blkgs() shouldn't be called with all the blkcg
>> +	 * references gone and rcu_read_lock not held.
>> +	 */
>> +	if (!css_tryget(&blkcg->css)) {
>> +		WARN_ON_ONCE(!rcu_read_lock_held());
>> +		return;
>> +	}
> 
> As I followed the previous discussion, the principle is that obtaining a
> reference or being inside an RCU read section is sufficient.
> 
> Consequently, I'd expect the two situations handled equally but here the
> no-ref but RCU bails out. (Which is OK because blkg_list must be empty?)
> 
> However, the might_sleep() in (non-sleepable) RCU reader section combo
> makes me wary anyway (not with the early return but tools would likely
> complain).
> 
> All in all, can't the contract of blkcg_destroy_blkgs() declare that
> a caller must pass blkcg with a valid reference? (The body of
> blkcg_destroy_blkgs then wouldn't need to get neither put the inner
> reference).

Totally agree, the proposed patch feels more like a hacky workaround
rather than a true solution. Either the contract should be that it's
ALWAYS entered with RCU lock held and hence the tryget is fine, OR that
a reference always is held when entered.

I'm going to revert the offending patch for now, and then we can queue
up a proper patch when that exists.

-- 
Jens Axboe
