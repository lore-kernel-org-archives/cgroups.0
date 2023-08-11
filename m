From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Fri, 11 Aug 2023 16:53:44 +0800
Message-ID: <60dbff4b-d823-5dc9-ff8e-36648ddf7207@huaweicloud.com>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
 <6637e6cd-20aa-110a-40ae-53ecd6eb4184@huaweicloud.com>
 <d4050f7e-d491-c111-3e26-160e7d5a4208@huaweicloud.com>
 <dtobag743cbzb3rxzldu36wszqtnbayz2grpyj2cctptfybtt3@66ico6n2clrr>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dtobag743cbzb3rxzldu36wszqtnbayz2grpyj2cctptfybtt3@66ico6n2clrr>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>



在 2023/08/11 16:23, Michal Koutný 写道:
> On Fri, Aug 11, 2023 at 09:44:55AM +0800, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org> wrote:
>> Now that this problem doesn't exist, I think it's ok just to remove this
>> comment.
> 
> Why doesn't the problem exist now?
> IIUC, it does but it's prevented thanks to outer synchronization via
> rq_qos_mutex. Hence the comment clarifies why is the lockdep_assert
> placed here.
> 

Yes, it'm implemented in the upper layer that rq_qos_add() and
blkcg_activate_policy() should be atmoic, and currently there is no
comments for that.

Perhaps it's better to add some comments like following in rq_qos_add()
instead?

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 167be74df4ee..8e8c597ea01b 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -302,6 +302,11 @@ int rq_qos_add(struct rq_qos *rqos, struct gendisk 
*disk, enum rq_qos_id id,
  {
         struct request_queue *q = disk->queue;

+       /*
+        * If rq_qos is used with cgroup policy, and cgroup policy can be
+        * initialized through cgroupfs, 'rq_qos_mutex' should be held
+        * untill blkcg_activate_policy() is done after this function 
return.
+        */
         lockdep_assert_held(&q->rq_qos_mutex);

         rqos->disk = disk;

> 
> Michal
> 

