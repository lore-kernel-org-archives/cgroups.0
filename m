From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH-block v3 2/2] blk-cgroup: Flush stats at blkgs destruction
 path
Date: Tue, 13 Dec 2022 20:58:53 -0500
Message-ID: <72fa1665-966a-76e6-be0c-e7fb288b1610@redhat.com>
References: <20221213184446.50181-1-longman@redhat.com>
 <20221213184446.50181-3-longman@redhat.com>
 <Y5jS825K7ej0jEV+@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670983141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w8Ekv64Hnz3Pzaf7wbnhuAkFb+qhBlnUSB0ADt/wreE=;
        b=bfT8ZQLvTgEoiUjCtA0VnFahrWK27w21V5hchMvghaesHrUQ6qvXGA1Z5K3BXTbwz0DuFH
        cEmXHp8CsyvFIktt8AwQcAXvsnEFymuCnmFvC9eailZENQLiCNhwlf3GX6tLFSWqdIs/Cx
        zmlrk/fgSPbCqZJHVczizf2ICk15Bz4=
Content-Language: en-US
In-Reply-To: <Y5jS825K7ej0jEV+@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>


On 12/13/22 14:30, Tejun Heo wrote:
> On Tue, Dec 13, 2022 at 01:44:46PM -0500, Waiman Long wrote:
>> +	/*
>> +	 * Flush all the non-empty percpu lockless lists so as to release
>> +	 * the blkg references held by those lists which, in turn, may
>> +	 * allow the blkgs to be freed and release their references to
>> +	 * blkcg speeding up its freeing.
>> +	 */
> Can you mention the possible deadlock explicitly? This sounds more like an
> optimization.

I am mostly thinking about the optimization aspect. Yes, deadlock in the 
sense that both blkgs and blkcg remained offline but not freed is 
possible because of the references hold in those lockless list. It is a 
problem if blkcg is the only controller in a cgroup. For cgroup that has 
both the blkcg and memory controllers, it shouldn't be a problem as the 
cgroup_rstat_flush() call in the release of memory cgroup will clear up 
blkcg too. Right, I will update the comment to mention that.

Cheers,
Longman

