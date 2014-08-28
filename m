From: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 RESEND] cfq-iosched: Fix wrong children_weight calculation
Date: Thu, 28 Aug 2014 11:20:54 +0900
Message-ID: <53FE9206.4060605@lab.ntt.co.jp>
References: <1409128352.11712.2.camel@ubuntu-vm-makita> <20140827141505.GA12537@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140827141505.GA12537-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ruki Sekiya <sekiya.ruki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

(2014/08/27 23:15), Tejun Heo wrote:
> As it looks like the patch needs to be respun anyway.
> 
> On Wed, Aug 27, 2014 at 05:32:32PM +0900, Toshiaki Makita wrote:
>> +	/*
>> +	 * Update leaf_weight.  We cannot update weight at this point
>> +	 * because cfqg might already have been activated by its child.
> 
> Maybe something like the following is better?
> 
>  because cfqg might already have been activated and is contributing
>  its current weight to the parent's child_weight.
> 

Thank you for your comment.
It looks better.
I'll reword it.

Thanks,
Toshiaki Makita
