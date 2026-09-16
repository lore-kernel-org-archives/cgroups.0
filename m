Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C037D374E40;
	Wed, 16 Sep 2026 05:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789537708; cv=none; b=RW4dvMrjvsSXNm1b338Ajd8PiXPKhsE+5z7Aeeri1xUoyWvYkAtOJMGqsZuDSOodI6mqSBtiKnJRYznY9P6WdqNWTDEJAs/f1/1Ffo8bG/CNY6xzwvMBhC7DkrnjzrMdqc28BCrGlvrd8mpIJz1QWAZndn9sGGoNn4wgt4cqZD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789537708; c=relaxed/simple;
	bh=njcNesu0T2wlf680w7LVVN2Ev1fYXdOMmrZOnhfUu7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHGbbmZBB54/QxFxTuuasgwZ/um4X+vvKaACq3gXcp3imbiF3r7je2NhjHoXrY+7R/vLZxXuSVROZxLRRCW7Tzl3yoD71xzd4cNk3N3ETBaukxhbdbiEzxgUKY48Po5v8wdQP40Xs+7GJt8EvpwOhd/95OeHSyi2CnlI0JqGtYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lx12HJfL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lx12HJfL"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLVo181805238;
	Wed, 16 Sep 2026 05:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LIabAc
	JQ4SujGOG0uLelxBeziOrGyHi5lo2W+7zfeTE=; b=lx12HJfLZS91YM5KIhWYZ9
	hDsxiLfBZdoX31K0/DytlhbwZEBHDky5J3S6a2bv1wyEH1AYLkSaG4lQuvSTEdUu
	V7cXD8RKC8CpmxwYqHX6puNGwT5EPDlf1E+Oj7GhouPgT5MmqIbwyQwIUdPo53Wx
	QKtzzjoYmJEEzPx04t87vjSqNrKvYIuDl8UHvrf0OK3f+KrZ+gm6EU2w/qAKWrXZ
	rL33NwZbqi7VhQTP6DJgP8v6KHrWeZ0aJ31AI7AEhoBv0SuiQ+ffDehVa6hg2xZn
	HhT2Zi6A3zsa1AtXdXD2Oxx+07DqgTuLSy7utHIhzAqbUetGjLdot7Lt4PkhQ9yw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmv5htw82-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 05:46:45 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68G2qVLt464070;
	Wed, 16 Sep 2026 05:46:44 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gq03vcvf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 05:46:44 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68G5khN328312216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 05:46:43 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 96B2558059;
	Wed, 16 Sep 2026 05:46:43 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 72C9258053;
	Wed, 16 Sep 2026 05:46:29 +0000 (GMT)
Received: from [9.61.52.228] (unknown [9.61.52.228])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 05:46:29 +0000 (GMT)
Message-ID: <d0dbf12d-b358-4164-b865-0e44c7163b7d@linux.ibm.com>
Date: Wed, 16 Sep 2026 11:16:27 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] blk-cgroup: move async bio punt state to blkcg
To: yukuai@fygo.io, Yu Kuai <yukuai@kernel.org>, Jens Axboe
 <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling
 <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
Cc: Christoph Hellwig <hch@lst.de>, Tao Cui <cuitao@kylinos.cn>,
        linux-block@vger.kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-raid@vger.kernel.org, gfs2@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        llvm@lists.linux.dev
References: <cover.1789237876.git.yukuai@fygo.io>
 <326e4904402440323532168095f2eb0c6f697836.1789237877.git.yukuai@fygo.io>
 <f27ee89f-5a52-4cfc-a14a-e5019ae61d89@linux.ibm.com>
 <52df0198-9949-4801-ac0f-c86935d1aceb@fygo.io>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <52df0198-9949-4801-ac0f-c86935d1aceb@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA2OSBTYWx0ZWRfX1gy6KzyZTO/l
 rL51RO0W701nRkcEHte/j9aRVxrfkRfJ+Jtis/WO9hc0tXlk424evaovVJRGnJvNjQ8gKGI8ddp
 A8scu8xfT/rVabl6n18riuCnKxgx1mjW8Pz2ohY0V3KxlY0zRQriM7EqDUvASE6rleZb9BxerXk
 MBWdtRatkDryBNFQmS2OfTrlu+shK/KU+pEOtyA0pT8bLU2KDiwDQEW/j+Dv4spAcF8nPVmPGHl
 AQzKnyUhbKqIy8tKmVx8QomvhHB68zeGZFudR9r5BoOtp05hHacxNcVgJWQC97OqrLe+XY28ZuI
 sG6otgW8E9sxOuxfYt4yCthjMiTmvN60SWfrZWqZWIuDquyvMpdUtxNKl3FoLWF78V6PSY/IXWB
 l5ZNRQDl9/BaeIKV0WM9zLbULJDQpiqbNdWBnzo8msr++EdqT32Rs46nmVeEUO7HQL2/tDdPsBu
 Ss8GhgqqHuM1Ilj9/Qg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA2OSBTYWx0ZWRfXw5nEcY0jQeuZ
 tax0LoWnDAcmk4cbc2FCdT8zX9xVz7SxmWGxfp7CNjY7iP8psVX/aHLR9njmVbGNHuMSUuDjhxs
 jV4mV1YYN5V3CY+DGkFm4LkU9uZLAbk=
X-Authority-Analysis: v=2.4 cv=Zsx4uN7G c=1 sm=1 tr=0 ts=6aaa2d46 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=EVVczme9KZ5WO4Hfbr4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 37_berB40VslJIQLTEVE8C2V_Rtd3Cmf
X-Proofpoint-GUID: dUuyNwdiGQH56_Z-inY37SOtflE__LN5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160069

On 9/15/26 9:24 PM, yu kuai wrote:
> Hi,
> 
> 在 2026/9/13 21:29, Nilay Shroff 写道:
>> On 9/13/26 12:24 PM, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai@fygo.io>
>>>
>>> blkcg_punt_bio_submit() currently queues punted bios on
>>> blkg->async_bios,
>>> so it has to call bio_blkg() to find or create a queue-local blkg.  Bios
>>> now carry and pin the blkcg css, so punted bio lifetime no longer
>>> needs to
>>> be anchored by a blkg.
>>>
>>> Keeping the punt state in blkg can instantiate a blkg even when no blkcg
>>> policy is enabled, just to bounce submission from a shared kthread.
>>> Move
>>> async_bio_lock, async_bios and async_bio_work to struct blkcg, and queue
>>> punted bios on bio_blkcg() for non-root cgroups.  Root or
>>> unassociated bios
>>> are submitted directly.
>>>
>>> This preserves the priority-inversion avoidance while preventing
>>> blkcg_punt_bio_submit() from creating blkgs that are not needed by any
>>> policy.
>>>
>>> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>>> ---
>>>    block/blk-cgroup.c | 52 ++++++++++++++++++++++++++--------------------
>>>    block/blk-cgroup.h | 14 ++++++-------
>>>    2 files changed, 35 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>>> index 59ccfefe16a8..aa3cee107ebe 100644
>>> --- a/block/blk-cgroup.c
>>> +++ b/block/blk-cgroup.c
>>> @@ -180,14 +180,10 @@ static void blkg_free(struct blkcg_gq *blkg)
>>>      static void __blkg_release(struct rcu_head *rcu)
>>>    {
>>>        struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq,
>>> rcu_head);
>>>    -#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>>> -    WARN_ON(!bio_list_empty(&blkg->async_bios));
>>> -#endif
>>> -
>>>        blkg_free(blkg);
>>>    }
>>>      /*
>>>     * A group is RCU protected, but having an rcu lock does not mean
>>> that one
>>> @@ -226,23 +222,23 @@ static void blkg_release(struct percpu_ref *ref)
>>>    }
>>>      #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>>>    static struct workqueue_struct *blkcg_punt_bio_wq;
>>>    -static void blkg_async_bio_workfn(struct work_struct *work)
>>> +static void blkcg_async_bio_workfn(struct work_struct *work)
>>>    {
>>> -    struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
>>> -                         async_bio_work);
>>> +    struct blkcg *blkcg = container_of(work, struct blkcg,
>>> async_bio_work);
>>>        struct bio_list bios = BIO_EMPTY_LIST;
>>>        struct bio *bio;
>>>        struct blk_plug plug;
>>>        bool need_plug = false;
>>>    -    /* as long as there are pending bios, @blkg can't go away */
>>> -    spin_lock(&blkg->async_bio_lock);
>>> -    bio_list_merge_init(&bios, &blkg->async_bios);
>>> -    spin_unlock(&blkg->async_bio_lock);
>>> +    /* as long as there are pending bios, @blkcg can't go away */
>>> +    {
>>> +        guard(spinlock)(&blkcg->async_bio_lock);
>>> +        bio_list_merge_init(&bios, &blkcg->async_bios);
>>> +    }
>>>
>> Instead of using guard(spinlock)(...) here, I think we could use the
>> simpler spin_lock()/spin_unlock() helpers. IMO, they are easier
>> to read and reason about for these short critical sections.
> Ok.
>>
>>>        /* start plug only when bio_list contains at least 2 bios */
>>>        if (bios.head && bios.head->bi_next) {
>>>            need_plug = true;
>>>            blk_start_plug(&plug);
>>> @@ -259,19 +255,20 @@ static void blkg_async_bio_workfn(struct
>>> work_struct *work)
>>>     * cgroup.  Use this helper instead of submit_bio to punt the
>>> actual issuing to
>>>     * a dedicated per-blkcg work item to avoid such priority inversions.
>>>     */
>>>    void blkcg_punt_bio_submit(struct bio *bio)
>>>    {
>>> -    struct blkcg_gq *blkg = bio_blkg(bio);
>>> +    struct blkcg *blkcg = bio_blkcg(bio);
>>>    -    if (blkg && blkg->parent) {
>>> -        spin_lock(&blkg->async_bio_lock);
>>> -        bio_list_add(&blkg->async_bios, bio);
>>> -        spin_unlock(&blkg->async_bio_lock);
>>> -        queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
>>> +    if (blkcg && cgroup_parent(blkcg->css.cgroup)) {
>>> +        {
>>> +            guard(spinlock)(&blkcg->async_bio_lock);
>>> +            bio_list_add(&blkcg->async_bios, bio);
>>> +        }
>>> +        queue_work(blkcg_punt_bio_wq, &blkcg->async_bio_work);
>>
>> Again same here, replace guard() with spin_lock() and spin_unlock()
>> helpers.
>>
>>>        } else {
>>> -        /* Never bounce if there is no non-root blkg to queue on. */
>>> +        /* Never bounce if there is no non-root blkcg to queue on. */
>>>            submit_bio(bio);
>>>        }
>>>    }
>>>    EXPORT_SYMBOL_GPL(blkcg_punt_bio_submit);
>>>    @@ -350,15 +347,10 @@ static struct blkcg_gq *blkg_alloc(struct
>>> blkcg *blkcg, struct gendisk *disk,
>>>        blkg->q = disk->queue;
>>>        INIT_LIST_HEAD(&blkg->q_node);
>>>        blkg->blkcg = blkcg;
>>>        blkg->blkcg_id = blkcg->css.id;
>>>        blkg->iostat.blkg = blkg;
>>> -#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>>> -    spin_lock_init(&blkg->async_bio_lock);
>>> -    bio_list_init(&blkg->async_bios);
>>> -    INIT_WORK(&blkg->async_bio_work, blkg_async_bio_workfn);
>>> -#endif
>>>          u64_stats_init(&blkg->iostat.sync);
>>>        for_each_possible_cpu(cpu) {
>>>            u64_stats_init(&per_cpu_ptr(blkg->iostat_cpu, cpu)->sync);
>>>            per_cpu_ptr(blkg->iostat_cpu, cpu)->blkg = blkg;
>>> @@ -1399,10 +1391,16 @@ static void blkcg_css_free(struct
>>> cgroup_subsys_state *css)
>>>            if (blkcg->cpd[i])
>>>                blkcg_policy[i]->cpd_free_fn(blkcg->cpd[i]);
>>>          mutex_unlock(&blkcg_pol_mutex);
>>>    +#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>>> +    {
>>> +        guard(spinlock)(&blkcg->async_bio_lock);
>>> +        WARN_ON(!bio_list_empty(&blkcg->async_bios));
>>> +    }
>>> +#endif
>>
>> This is a slightly different case. At this point blkcg_css_free() is
>> freeing the blkcg object after its final reference has gone away, so
>> there should be no concurrent context accessing blkcg->async_bios.
>> Therefore, I don't think we need to acquire async_bio_lock here just
>> to perform the WARN_ON() check.
> 
> Perhaps is it better just to remove the check? blkcg will be pinned
> by any bio inside the list, so I believe this is safe.
> 
Ideally yes we would not enter into blkcg_css_free() until all
references to blkcg are dropped. So the WARN_ON() appears to be
used just as a paranoia check. I'm okay either to drop it or
if you want to keep it then I suggest replacing bio_list_empty()
with bio_list_empty_careful(), so that the check explicitly allows
lockless inspection during teardown.

Thanks,
--Nilay

