From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [patch v11 0/6] support concurrent sync io for bfq on a specail
 occasion
Date: Tue, 25 Oct 2022 15:31:07 +0800
Message-ID: <69485939-d874-0201-e7ed-b3f49dbbb9c9@huaweicloud.com>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
 <29348B39-94AE-4D76-BD2E-B759056264B6@linaro.org>
 <011d479f-644f-0013-40bf-664b62f93bec@huaweicloud.com>
 <A9D22DB6-6481-46BA-9D4C-5A828D19CB61@linaro.org>
 <bcd07062-5a3b-563e-fb2d-2fa8e4c8bba5@huaweicloud.com>
 <82f1e969-742d-d3c3-63ca-961c755b5c35@huaweicloud.com>
 <A1E2F76F-2D27-4DCE-9B97-C8011CBE2A9E@unimore.it>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A1E2F76F-2D27-4DCE-9B97-C8011CBE2A9E-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Paolo VALENTE <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

在 2022/10/25 14:34, Paolo VALENTE 写道:

>>
>> I rerun the manually test for 5 times, here is the average result:
>>
>> without this patchset / with this patchset:
>>
>> | --------------- | ------------- | ------------ | -------------- | ------------- | -------------- |
>> | cg1 weight      | 10            | 20           | 30             | 40          | 50             |
>> | cg2 weight      | 90            | 80           | 70             | 60          | 50             |
>> | cg1 bw MiB/s    | 21.4 / 21.74  | 42.72 / 46.6 | 63.82 / 61.52  | 94.74 / 90.92 | 140 / 138.2    |
>> | cg2 bw MiB/s    | 197.2 / 197.4 | 182 / 181.2  | 171.2 / 173.44 | 162 / 156.8   | 138.6 / 137.04 |
>> | cg2 bw / cg1 bw | 9.22 / 9.08   | 4.26 / 3.89  | 2.68 / 2.82    | 1.71 / 1.72   | 0.99 / 0.99    |
> 
> Great!  Results are (statistically) the same, with and without your
> patchset.  For me your patches are ok.  Thank you very much for this
> contribution, and sorry again for my delay.
> 
> Acked-by: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks for the review, it's nice to get this done finally!
> 
> Thanks,
> Paolo

