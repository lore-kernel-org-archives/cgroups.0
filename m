From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 1 Jun 2022 17:32:11 -0400
Message-ID: <6734ae25-27eb-0024-8524-ab8885a5fae0@redhat.com>
References: <20220601165324.60892-1-longman@redhat.com>
 <20220601165324.60892-2-longman@redhat.com>
 <YpemVpvaPomwH7mt@slm.duckdns.org>
 <ca091a5c-4ae1-e973-403e-4086d4527102@redhat.com>
 <YpexWFptr/l2Y0rU@slm.duckdns.org>
 <bca31669-7107-ebe4-7fbf-2449940a5cc8@redhat.com>
 <c26f153c-304c-e109-6626-bb8b79a2e2ad@redhat.com>
 <YpfaC+wB5Th4tLDY@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654119136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kydqna2S/fNnNfFhR9vYtc6J6licD3U6v9tlZqx3JCg=;
        b=a+efBeisOk2PtK/1YBzjumzGv5OCY7WfaKoc7B/7JOEEInZzfBZZ4idk7e2iaDH3Fx7qFR
        JPaUhfKw6b307CvJpacPnHlYemEPC7YfuNglOEJp7zsSkmPhg72vQquzs1yYhhI28bL9c7
        E2gzpIJzRmTx5vTxT1Sx7S5QX1VpVoM=
Content-Language: en-US
In-Reply-To: <YpfaC+wB5Th4tLDY@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>


On 6/1/22 17:28, Tejun Heo wrote:
> On Wed, Jun 01, 2022 at 05:25:53PM -0400, Waiman Long wrote:
>> I think the best way to protect against blkg destruction is to get a percpu
>> reference when put into lockless list and put it back when removed.
>>
>> BTW, when I ran a test that continuously create and destroy containers, the
>> total number of blkcg's kept on increasing. There are some freeing of
>> blkcg's but no freeing of blkg's at all. Maybe we have a similar dying
>> blkcg's problem here. I will take a further look at that when I have time.
> They get pinned by per-cgroup writebacks which gets pinned by lingering page
> cache and other remaining accounted memory areas, so I think they can hang
> around if there's no memory pressure. But, yeah, it'd be great to verify
> that they actually go away under memory pressure.
>
> Thanks.
>
Thanks for the explanation. It makes sense to me.

Cheers,
Longman

