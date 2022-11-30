From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH-block v2] bdi, blk-cgroup: Fix potential UAF of blkcg
Date: Wed, 30 Nov 2022 10:44:36 -0500
Message-ID: <d689d6d9-9206-028e-1363-8d7d77d55e79@redhat.com>
References: <20221129203400.1456100-1-longman@redhat.com>
 <20221130151639.GE27838@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669823084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lHWzy0FM79r3PLFfRwF2L7xXZGTYCWGH6Me/ph3/zE0=;
        b=f3+8D26UfBV/qh3C1IDF4Xsb/KrmQ1goY32XuHC3xAzc9XnlCJN+vFooThJy+YEv+0L/FR
        DrImlRLRMmk86tuSf57Ypec2K13R296YIAxYqMGWYdB5Fljg5DC/IleQvkJjSkJxnIS8da
        3Falher+ZJja3uiZJDnil0gFPJ0Axuc=
Content-Language: en-US
In-Reply-To: <20221130151639.GE27838@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Hillf Danton <hdanton@sina.com>, Chaitanya Kulkarni <chaitanyak@nvidia.com>, Bart Van Assche <bvanassche@acm.org>, Josef Bacik <josef@toxicpanda.com>, Yi Zhang <yi.zhang@redhat.com>


On 11/30/22 10:16, Michal Koutn=C3=BD wrote:
> On Tue, Nov 29, 2022 at 03:34:00PM -0500, Waiman Long <longman@redhat.com=
> wrote:
>> The reproducing system can no longer produce a warning with this patch.
>> All the runnable block/0* tests including block/027 were run successfully
>> without failure.
> Thanks for the test!
>
>> @@ -1088,7 +1088,15 @@ static void blkcg_destroy_blkgs(struct blkcg *blk=
cg)
>>  =20
>>   	might_sleep();
>>  =20
>> -	css_get(&blkcg->css);
>> +	/*
>> +	 * blkcg_destroy_blkgs() shouldn't be called with all the blkcg
>> +	 * references gone and rcu_read_lock not held.
>> +	 */
>> +	if (!css_tryget(&blkcg->css)) {
>> +		WARN_ON_ONCE(!rcu_read_lock_held());
>> +		return;
>> +	}
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

You are right. I should have pushed the might_sleep down(). Will post a=20
new version to fix that.

Thanks,
Longman

