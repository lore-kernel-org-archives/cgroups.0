From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH RESEND v6 4/8] blk-throttle: fix io hung due to config
 updates
Date: Thu, 28 Jul 2022 18:34:44 +0800
Message-ID: <0bbf3d0c-88c4-8120-3df3-960dda041864@huaweicloud.com>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-5-yukuai1@huaweicloud.com>
 <YuGGVxdlOVk/eF2l@slm.duckdns.org> <20220728093346.GA2281@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220728093346.GA2281-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi

在 2022/07/28 17:33, Michal Koutný 写道:
> On Wed, Jul 27, 2022 at 08:39:19AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> I'm not quiet sure this is correct. What if the limit keeps changing across
>> different values? Then we'd be calculating the skipped amount based on the
>> last configuration only which would be incorrect.
> 
> When one change of configuration is correct, then all changes must be
> correct by induction. It's sufficient to take into account only the one
> old config and the new one.
> 
> This __tg_update_skipped() calculates bytes_skipped with the limit
> before the change and bytes_skipped are used (divided by) the new limit
> in tg_with_in_bps_limit().
> The accumulation of bytes_skipped across multiple changes (until slice
> properly ends) is proportional to how bytes_allowed would grow over
> time.
> That's why I find this correct (I admit I had to look back into my
> notes when this was first discussed).
> 
> HTH,
> Michal
> 

Hi, Tejun

Michal already explain it very well, please let me know if you still
thinks there are better ways.

Thanks,
Kuai

