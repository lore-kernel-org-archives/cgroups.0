From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v5 3/8] blk-throttle: factor out code to calculate
 ios/bytes_allowed
Date: Thu, 23 Jun 2022 20:03:52 +0800
Message-ID: <21aabcb3-9801-f159-103c-9e1c35983237@huawei.com>
References: <20220528064330.3471000-1-yukuai3@huawei.com>
 <20220528064330.3471000-4-yukuai3@huawei.com>
 <20220622172706.GA28777@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220622172706.GA28777-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi，

在 2022/06/23 1:27, Michal Koutný 写道:
> On Sat, May 28, 2022 at 02:43:25PM +0800, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> +static u64 calculate_bytes_allowed(u64 bps_limit,
>> +				   unsigned long jiffy_elapsed_rnd)
> 
> Just noticed with all series applied this argument needn't be called
> _rnd. (It's a nit.)
> 

Yes, you're right. I'll change that in next version.

Thanks,
Kuai
