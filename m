From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-block v3 1/2] bdi, blk-cgroup: Fix potential UAF of blkcg
Date: Tue, 13 Dec 2022 14:53:52 -0500
Message-ID: <34a8c4a7-a58d-63fc-4599-accf1cbb6aae@redhat.com>
References: <20221213184446.50181-1-longman@redhat.com>
 <20221213184446.50181-2-longman@redhat.com>
 <Y5jSllwwBdmQ1jQz@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670961241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q04pXB0nuaw4NyeT98qJ4CK1uIQuz5FaT/xQVCDx6WM=;
        b=JCmwPGxirhGJYKpRyt1r9ZyNe7o0QqLX9XGScrZu9kV2Cc5LoKErZ+CCYtrUMVV4pb3rGs
        wjANjJq/x/oZDvTsqZ9PfvUV/FyWVhWLIXf0o2SbJGEb6XEekn7IX47FSlUOX/7wLpC6mI
        qxXx9AYuGe/bi1QoiXo8zJJ4CPvedkU=
Content-Language: en-US
In-Reply-To: <Y5jSllwwBdmQ1jQz-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On 12/13/22 14:29, Tejun Heo wrote:
> On Tue, Dec 13, 2022 at 01:44:45PM -0500, Waiman Long wrote:
>> Commit 59b57717fff8 ("blkcg: delay blkg destruction until after
>> writeback has finished") delayed call to blkcg_destroy_blkgs() to
>> cgwb_release_workfn(). However, it is done after a css_put() of blkcg
>> which may be the final put that causes the blkcg to be freed as RCU
>> read lock isn't held.
>>
>> Another place where blkcg_destroy_blkgs() can be called indirectly via
>> blkcg_unpin_online() is from the offline_css() function called from
>> css_killed_work_fn(). Over there, the potentially final css_put() call
>> is issued after offline_css().
>>
>> By adding a css_tryget() into blkcg_destroy_blkgs() and warning its
>> failure, the following stack trace was produced in a test system on
>> bootup.
> This doesn't agree with the code anymore. Otherwise
>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Sorry, I overlooked the commit log in my update. I will update it if I 
need another version, or Jens can make the following edit:

css_tryget() -> percpu_ref_is_zero().

Thanks,
Longman

