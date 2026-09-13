Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B442323643F;
	Sun, 13 Sep 2026 13:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789306272; cv=none; b=HrScdIgwF4foVC8YvuXVHFJKi/xHPmG2xaSxnIAODlcRP5N7Mf3VZANYiiJQ0xytf1mqB9CIw9C3+lwAB3ZQcT19jJiRkjdcrNp15fv4/p3jJ+aN97fbmo/YDj95I57SWD1D0CwkU1hOFIr7hy22QKbK4MFE+A5s+bwC3ORYcp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789306272; c=relaxed/simple;
	bh=J9hiblMOx3XvVdaM9J2BbPYlG8NGFT52bvA4fXddIg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yld4bCohB47ly/cU08aUT29Tx1teds9M8rYAjU6HvuqmqrVJ4fgllTMZsqz5v0xFPkley0JmPd9LE9uQ7WRQcCvVUXv6nX9njLaoVAQiqFy+T/5gtGyED6PTY2r3GpODqkPjyAZWi+m5rruJSWjd8Hmz9I/onOl7lLdj/v9fqTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kkCdYWnG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kkCdYWnG"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DAVQkF1255664;
	Sun, 13 Sep 2026 13:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+V/HIm
	HSDz8kfFeEdbya+rI2+T3XQl9CUl1CtP6MnQY=; b=kkCdYWnGsL4dS89b7MgWSi
	8GJVjDvIQ9h+M7k9j8tNkW942RE2zvWfRXzQr0qjMV4dHnmHq99pw1YTz+UTXy9/
	/S2UyPagSL+3Nq+IIu97ne4NbyZ+AqdmWBXCba6AGvFf2ejDRurwYcHXw8QeTIyj
	EyRPmRrcXkc6VeiZi55r7/FCsKGoutX6JFwfOme2x/bVj5SFDoAQSDC1qKdcXczB
	FvcLTPegwmnY5jKb1mHlYiiwwO05cS1/iUHz1TjmycNOCk0ATqbKujf4ylqluy5c
	liEEExomDNrLDNESynCU303UKrXLt/cSpMWD8aQW8BOy49f/6vTzDaCITCiAvP2Q
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxdpvp3k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 13 Sep 2026 13:29:42 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68DAZ4oB544502;
	Sun, 13 Sep 2026 13:29:41 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gnh2psqu1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 13 Sep 2026 13:29:41 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68DDTf2U23134818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 13 Sep 2026 13:29:41 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 445F958055;
	Sun, 13 Sep 2026 13:29:41 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A64B58043;
	Sun, 13 Sep 2026 13:29:27 +0000 (GMT)
Received: from [9.61.162.129] (unknown [9.61.162.129])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 13 Sep 2026 13:29:26 +0000 (GMT)
Message-ID: <f27ee89f-5a52-4cfc-a14a-e5019ae61d89@linux.ibm.com>
Date: Sun, 13 Sep 2026 18:59:25 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] blk-cgroup: move async bio punt state to blkcg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap
 <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
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
Cc: Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
        Tao Cui <cuitao@kylinos.cn>, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, llvm@lists.linux.dev
References: <cover.1789237876.git.yukuai@fygo.io>
 <326e4904402440323532168095f2eb0c6f697836.1789237877.git.yukuai@fygo.io>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <326e4904402440323532168095f2eb0c6f697836.1789237877.git.yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDE4NiBTYWx0ZWRfXwV/0FqNA71UW
 0pSFlqnYwSqWUYI6LgVLyKbNtIbqAXpKwLtlpplrS30cUDQsW2lRrlESKbbUK1oSAm5xS8Ylm55
 VNl+w9i9HLWFGn8vh9aZHnh6SAqmPz13WVaI6pKqA55iJdy5LNt9R1Wi94ijn02bhHTHKAe0eRP
 mp1vNvMZ7l2UiHUt58ZXQBMVs6hQdaaQ3nChJkoptBrQFIPGEirAwojONs4lZ6aHCKdNxRtzvJA
 VEaSWJbv7lVRD5sIfTWnm9jjRqkJZ32e7oiPfEo9MnPFWhdGetfmkOqDaQekF77ovy5LJRxmJm4
 GHgK/ALXAeVLOEPIBjf+qhG5iy+5XWRhZiTObq8UQ+HqyRjSELagks36ThrVEyBiln9x1oyRA3K
 6RWEEkijXp9Vg20WYSpU+aj5P1ynIjIW9tHl7ChXZlM42/wLY0H0BiuqAYnMqScT+rA1lzv4TAc
 lKGFPo2jxo7pOUNxhDA==
X-Proofpoint-GUID: jqEO1yjE93QiEpR2tJ-y2Cj8IdEumaS9
X-Authority-Analysis: v=2.4 cv=DobDa2/+ c=1 sm=1 tr=0 ts=6aa6a547 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=DV5896PDfqYWo4ufmHUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: vL8PPh6d47DxNDz6NH1gi_sDy5Mchg5w
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDE4NiBTYWx0ZWRfX+u9bu0oOeNVm
 0mm11mtP4XmiNfvfkDWefm6R0Hke5V/MZntTFgts27Fvw05oL4zedqtiD/PrbwZHmnddXxuaxEY
 eyOP6ZBuPFe31aD3IKoBDNy2zMXtA+0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-13_04,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130186

On 9/13/26 12:24 PM, Yu Kuai wrote:
> From: Yu Kuai <yukuai@fygo.io>
> 
> blkcg_punt_bio_submit() currently queues punted bios on blkg->async_bios,
> so it has to call bio_blkg() to find or create a queue-local blkg.  Bios
> now carry and pin the blkcg css, so punted bio lifetime no longer needs to
> be anchored by a blkg.
> 
> Keeping the punt state in blkg can instantiate a blkg even when no blkcg
> policy is enabled, just to bounce submission from a shared kthread.  Move
> async_bio_lock, async_bios and async_bio_work to struct blkcg, and queue
> punted bios on bio_blkcg() for non-root cgroups.  Root or unassociated bios
> are submitted directly.
> 
> This preserves the priority-inversion avoidance while preventing
> blkcg_punt_bio_submit() from creating blkgs that are not needed by any
> policy.
> 
> Signed-off-by: Yu Kuai <yukuai@fygo.io>
> ---
>   block/blk-cgroup.c | 52 ++++++++++++++++++++++++++--------------------
>   block/blk-cgroup.h | 14 ++++++-------
>   2 files changed, 35 insertions(+), 31 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 59ccfefe16a8..aa3cee107ebe 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -180,14 +180,10 @@ static void blkg_free(struct blkcg_gq *blkg)
>   
>   static void __blkg_release(struct rcu_head *rcu)
>   {
>   	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
>   
> -#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
> -	WARN_ON(!bio_list_empty(&blkg->async_bios));
> -#endif
> -
>   	blkg_free(blkg);
>   }
>   
>   /*
>    * A group is RCU protected, but having an rcu lock does not mean that one
> @@ -226,23 +222,23 @@ static void blkg_release(struct percpu_ref *ref)
>   }
>   
>   #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
>   static struct workqueue_struct *blkcg_punt_bio_wq;
>   
> -static void blkg_async_bio_workfn(struct work_struct *work)
> +static void blkcg_async_bio_workfn(struct work_struct *work)
>   {
> -	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
> -					     async_bio_work);
> +	struct blkcg *blkcg = container_of(work, struct blkcg, async_bio_work);
>   	struct bio_list bios = BIO_EMPTY_LIST;
>   	struct bio *bio;
>   	struct blk_plug plug;
>   	bool need_plug = false;
>   
> -	/* as long as there are pending bios, @blkg can't go away */
> -	spin_lock(&blkg->async_bio_lock);
> -	bio_list_merge_init(&bios, &blkg->async_bios);
> -	spin_unlock(&blkg->async_bio_lock);
> +	/* as long as there are pending bios, @blkcg can't go away */
> +	{
> +		guard(spinlock)(&blkcg->async_bio_lock);
> +		bio_list_merge_init(&bios, &blkcg->async_bios);
> +	}
>
Instead of using guard(spinlock)(...) here, I think we could use the
simpler spin_lock()/spin_unlock() helpers. IMO, they are easier
to read and reason about for these short critical sections.

>   	/* start plug only when bio_list contains at least 2 bios */
>   	if (bios.head && bios.head->bi_next) {
>   		need_plug = true;
>   		blk_start_plug(&plug);
> @@ -259,19 +255,20 @@ static void blkg_async_bio_workfn(struct work_struct *work)
>    * cgroup.  Use this helper instead of submit_bio to punt the actual issuing to
>    * a dedicated per-blkcg work item to avoid such priority inversions.
>    */
>   void blkcg_punt_bio_submit(struct bio *bio)
>   {
> -	struct blkcg_gq *blkg = bio_blkg(bio);
> +	struct blkcg *blkcg = bio_blkcg(bio);
>   
> -	if (blkg && blkg->parent) {
> -		spin_lock(&blkg->async_bio_lock);
> -		bio_list_add(&blkg->async_bios, bio);
> -		spin_unlock(&blkg->async_bio_lock);
> -		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
> +	if (blkcg && cgroup_parent(blkcg->css.cgroup)) {
> +		{
> +			guard(spinlock)(&blkcg->async_bio_lock);
> +			bio_list_add(&blkcg->async_bios, bio);
> +		}
> +		queue_work(blkcg_punt_bio_wq, &blkcg->async_bio_work);

Again same here, replace guard() with spin_lock() and spin_unlock()
helpers.

>   	} else {
> -		/* Never bounce if there is no non-root blkg to queue on. */
> +		/* Never bounce if there is no non-root blkcg to queue on. */
>   		submit_bio(bio);
>   	}
>   }
>   EXPORT_SYMBOL_GPL(blkcg_punt_bio_submit);
>   
> @@ -350,15 +347,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
>   	blkg->q = disk->queue;
>   	INIT_LIST_HEAD(&blkg->q_node);
>   	blkg->blkcg = blkcg;
>   	blkg->blkcg_id = blkcg->css.id;
>   	blkg->iostat.blkg = blkg;
> -#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
> -	spin_lock_init(&blkg->async_bio_lock);
> -	bio_list_init(&blkg->async_bios);
> -	INIT_WORK(&blkg->async_bio_work, blkg_async_bio_workfn);
> -#endif
>   
>   	u64_stats_init(&blkg->iostat.sync);
>   	for_each_possible_cpu(cpu) {
>   		u64_stats_init(&per_cpu_ptr(blkg->iostat_cpu, cpu)->sync);
>   		per_cpu_ptr(blkg->iostat_cpu, cpu)->blkg = blkg;
> @@ -1399,10 +1391,16 @@ static void blkcg_css_free(struct cgroup_subsys_state *css)
>   		if (blkcg->cpd[i])
>   			blkcg_policy[i]->cpd_free_fn(blkcg->cpd[i]);
>   
>   	mutex_unlock(&blkcg_pol_mutex);
>   
> +#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
> +	{
> +		guard(spinlock)(&blkcg->async_bio_lock);
> +		WARN_ON(!bio_list_empty(&blkcg->async_bios));
> +	}
> +#endif

This is a slightly different case. At this point blkcg_css_free() is
freeing the blkcg object after its final reference has gone away, so
there should be no concurrent context accessing blkcg->async_bios.
Therefore, I don't think we need to acquire async_bio_lock here just
to perform the WARN_ON() check.
The clang context annotation cannot infer this object-lifetime property
and will therefore report an unprotected access. I think we should
explicitly mark this access as context-unsafe.

But wait, even better, we could introduce a bio_list_empty_careful() helper,
similar to list_empty_careful(), for this purpose:

static inline bool bio_list_empty_careful(const struct bio_list *bl)
	__context_unsafe(/* intentional lockless access to @bl->head */)
{
	return bl->head == NULL;
}

Then this could simply become:

WARN_ON(!bio_list_empty_careful(&blkcg->async_bios));

>   	free_percpu(blkcg->lhead);
>   	kfree(blkcg);
>   }
>   
>   static struct cgroup_subsys_state *
> @@ -1447,10 +1445,18 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
>   	}
>   
>   	spin_lock_init(&blkcg->lock);
>   	refcount_set(&blkcg->online_pin, 1);
>   	INIT_HLIST_HEAD(&blkcg->blkg_list);
> +#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
> +	spin_lock_init(&blkcg->async_bio_lock);
> +	{
> +		guard(spinlock)(&blkcg->async_bio_lock);
> +		bio_list_init(&blkcg->async_bios);
> +	}
> +	INIT_WORK(&blkcg->async_bio_work, blkcg_async_bio_workfn);
> +#endif

This is interesting. As you know, while an object is being allocated
and before it is published, it can't be accessed concurrently. So
guarding blkcg->async_bios with blkcg->async_bio_lock is not necessary
here. Moreover, since blkcg is zero-initialized, we could simply remove
both the guard(...) and the bio_list_init() call above.

Thanks,
--Nilay

