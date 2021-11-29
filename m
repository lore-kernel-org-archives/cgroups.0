From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] blk-throtl: introduce blk_throtl_cancel_bios()
Date: Mon, 29 Nov 2021 21:58:23 +0800
Message-ID: <6085a86d-ddc8-8d06-e6d6-cee15fb962bc@huawei.com>
References: <20211127101059.477405-1-yukuai3@huawei.com>
 <20211127101059.477405-4-yukuai3@huawei.com> <YaS9v+x2ofp+9jQn@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YaS9v+x2ofp+9jQn-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2021/11/29 19:47, Christoph Hellwig wrote:
> On Sat, Nov 27, 2021 at 06:10:58PM +0800, Yu Kuai wrote:
>> This function is used to cancel all throttled bios. Noted this
>> modification is mainly from revertion of commit b77412372b68
>> ("blk-throttle: remove blk_throtl_drain").
> 
> This should also go into the last patch.
> .
> 

I'll merge patch 1,3,4 into one patch,

Thanks,
Kuai
