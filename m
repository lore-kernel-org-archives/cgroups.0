From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Sun, 27 Feb 2022 14:51:46 -0700
Message-ID: <d7ed009d-09af-935b-f905-fef7d02f1649@kernel.dk>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
 <YhuyBgZSS6m/Mwu6@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T+bY3cSVQwU97rpm1PWOkOKMCijaJDttt0NtP9XMRUQ=;
        b=P5MaDUXk16z8/hpH693B2xHSHZo//ZReUYLWsO5WmQlLEtpjLdqZ3SxcShABucESWD
         gkUDZcqvtqrxzTL/HBznk0KrejYwIAj3HoxYQalVeG1HxDmq/YLbpu9NlB4P6TirmJj2
         tNdNIV6wYGqY82VLMA+Mw5GUbyS0jOd/itE8dHkrcVdM9Bb6L95gorWOa8zYmgsddC8h
         zwCoc5DjwY/j3Rg7vXTyev4iXasdo5AcMBQ1q6scfujWk+AKpoL3W0XrcjyD40Gt2MbI
         /8viux9vd/q2pOFj2lly3had36ZTNzGSAeWkdFCorEsxqkjHFwoed3w28lUUMVXaTzda
         BIcg==
Content-Language: en-US
In-Reply-To: <YhuyBgZSS6m/Mwu6-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2/27/22 10:16 AM, Christoph Hellwig wrote:
> On Thu, Feb 10, 2022 at 07:56:37PM +0800, Yu Kuai wrote:
>> Throttled bios can't be issued after del_gendisk() is done, thus
>> it's better to cancel them immediately rather than waiting for
>> throttle is done.
>>
>> For example, if user thread is throttled with low bps while it's
>> issuing large io, and the device is deleted. The user thread will
>> wait for a long time for io to return.
> 
> FYI, this crashed left rigt and center when running xfstests with
> traces pointing to throtl_pending_timer_fn.

Dropped for now.

-- 
Jens Axboe

