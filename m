From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 10:38:44 -0500
Message-ID: <b9018641-d39f-ff74-8cfb-ba597f5ee0c2@redhat.com>
References: <20221128033057.1279383-1-longman@redhat.com>
 <427068db-6695-a1e2-4aa2-033220680eb9@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669649932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4r34gL/zLUGsXD6KoTRJJSoISJJekVdoxgz5n6tlG2k=;
        b=G5/t9+EYBksbzkLhMS3wm2ua+N9vqJbzfZaggpHpYdnTGfnFrCoVppwUa2epNfxEYqd4e4
        +4tazdLmk9SpK873rTPAnxKPfLeeYYl+ZAXgOEX3EA1MMjz4KrQG9j3jTRBc+amAxtFQdK
        JMA7lWJqHumZO25WcVzc0LlPwK8VLT4=
Content-Language: en-US
In-Reply-To: <427068db-6695-a1e2-4aa2-033220680eb9@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Yi Zhang <yi.zhang@redhat.com>

On 11/28/22 09:14, Jens Axboe wrote:
> On 11/27/22 8:30=E2=80=AFPM, Waiman Long wrote:
>> Commit 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction
>> path") incorrectly assumes that css_get() will always succeed. That may
>> not be true if there is no blkg associated with the blkcg. If css_get()
>> fails, the subsequent css_put() call may lead to data corruption as
>> was illustrated in a test system that it crashed on bootup when that
>> commit was included. Also blkcg may be freed at any time leading to
>> use-after-free. Fix it by using css_tryget() instead and bail out if
>> the tryget fails.
>>
>> Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")
>> Reported-by: Yi Zhang <yi.zhang@redhat.com>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   block/blk-cgroup.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 57941d2a8ba3..74fefc8cbcdf 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -1088,7 +1088,12 @@ static void blkcg_destroy_blkgs(struct blkcg *blk=
cg)
>>  =20
>>   	might_sleep();
>>  =20
>> -	css_get(&blkcg->css);
>> +	/*
>> +	 * If css_tryget() fails, there is no blkg to destroy.
>> +	 */
>> +	if (!css_tryget(&blkcg->css))
>> +		return;
>> +
>>   	spin_lock_irq(&blkcg->lock);
>>   	while (!hlist_empty(&blkcg->blkg_list)) {
>>   		struct blkcg_gq *blkg =3D hlist_entry(blkcg->blkg_list.first,
> This doesn't seem safe to me, but maybe I'm missing something. A tryget
> operation can be fine if we're under RCU lock and the entity is freed
> appropriately, but what makes it safe here? Could blkcg already be gone
> at this point?

The actual freeing of the blkcg structure is under RCU protection. So=20
the structure won't be freed immediately even if css_tryget() fails. I=20
suspect what Michal found may be the root cause of this problem. If so,=20
this is an existing bug which gets exposed by my patch.

Cheers,
Longman

