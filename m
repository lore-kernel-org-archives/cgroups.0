From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Wed, 28 Jul 2021 10:33:20 +0800
Message-ID: <fab343e8-5929-fb30-90e3-b5b6bd34702a@gmail.com>
References: <1626416569-30907-1-git-send-email-brookxu.cn@gmail.com>
 <YPGvIzZUI+QxP1js@mtj.duckdns.org>
 <957ab14d-c4bc-32f0-3f7d-af98832ab955@gmail.com>
 <YP8tPwkJNMAcjDqk@mtj.duckdns.org>
 <34a6f4b5-9055-e519-5693-068f8dcb169c@gmail.com>
 <YQAydzEhZfPUpzWI@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D45lrolxqJIjPPb8I/48vYfzy0j0FugUdvX8Qruvv54=;
        b=pQfJFQ+eTwlrNYDdbzs2U9jeZ0E/c0YUPgCYHaq+gBlpkgqxicfU9PnwGI0BrE3/lT
         tt2V1uJZiKWoQ5kUXBGAXbePZTKTjE2YexRN9Gnmkix3BF4KxE0qYyjh69qdQS6o7EQL
         6Ax5YEkduRwRULXud/4EmTwFUKwWcNR/GIADiNZrQely2ESBEN3UVhZKwnFKd1dji3dF
         rDbXmtNZs3qHjiJ9GuBK7FAoljylKQlQVdzjarnbpEyV09wdSSVF+tiU9f+xKKz+IaLF
         S9MODWQ4I2U2Q1M7emhDGag6v8H0L8j6jGp5S2APB42m9ppQ5Sw6JhXkmb1Tdaq0tVb1
         YeLw==
In-Reply-To: <YQAydzEhZfPUpzWI-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for your time.

Tejun Heo wrote on 2021/7/28 12:21 上午:
> Hello,
> 
> On Tue, Jul 27, 2021 at 11:06:18AM +0800, brookxu wrote:
>> Make blk-throttle use rq-qos may be more elegant. But I found that there may be at least
>> one problem that is difficult to solve. blk-throttle supports separate throttle for read
>> and write IOs, which means that we cannot suspend tasks during throttle, but rq-qos
>> throttle IOs by suspending tasks.
> 
> Ah, right, I forgot about that.
> 
>> We may be able to relocate the blk-throttle hooks to the rq-qos hooks. Since we may not
>> be able to replace the throttle hook, in this case, if we register a rq-qos to the system,
>> part of the blk-throttle hooks is in rq-qos and part hooks not, which feels a bit confusing.
>> In addition, we may need to implement more hooks, such as IO merge hook.
> 
> Would it be possible to just move the blk-throtl throttling hook right next
> to the rq-qos hook so that it gets throttled after splitting?

If we do this, I think we will encounter some problems, as follows:
1. blk-throttle is now at the top of the IO stack. Changing the position of the throttle hook
   will make this mechanism invalid for some devices.
2. We may also need to add a new hook to handle back-merge, otherwise I think the isolation
   effect will be worse in the sequential IO scene.
3. Since bio has entered the IO stack, if it is suspended and resubmitted by blk-throttle,
   then there is an IO stack reentry problem, which I think may cause many small problems.

> Thanks.
> 
