From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Fri, 25 Feb 2022 07:27:11 -0700
Message-ID: <6db54b86-4f25-af15-692b-af067823d77e@kernel.dk>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CueWZXVwpZqdL5pKcLH+mDQMXSj/tgq8h6dqyMSiTWc=;
        b=PfpjwGmuxVMO98b9FDuDLsLE9btC0WBH7LhsJ8t4TpjmMe2OedybHGRFlbaMxvYueI
         GLqc6LyVGQuJqh2jy8NIWPv0N0tKhYKhSghFrdptUgkE7MxEqeWrePJD0232xturOP2i
         df8DJgH6f6Jr0nFGXKB7PXidirxCjRPva+wV9HkYaIj524bMF5Slt5aPVJh4G/B9xohN
         yS6/VWCFrOF0R5IASe5MFC60DxuRiDjAhaKPiK2d+udCx4FGyiMGBw5knhW0hY8Cx1j7
         tRFkY6hwSHgmjZy1IprRmpUfS8AE64hOqjHRilR3OGHIem0SxKWFJIyhdmRxNcjZ094D
         FUmQ==
Content-Language: en-US
In-Reply-To: <20220210115637.1074927-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2/10/22 4:56 AM, Yu Kuai wrote:
> Throttled bios can't be issued after del_gendisk() is done, thus
> it's better to cancel them immediately rather than waiting for
> throttle is done.
> 
> For example, if user thread is throttled with low bps while it's
> issuing large io, and the device is deleted. The user thread will
> wait for a long time for io to return.

I hand applied this for 5.18 as it's conflicting with other
changes. Please double check the end result.

-- 
Jens Axboe

