From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Tue, 27 Jul 2021 11:06:18 +0800
Message-ID: <34a6f4b5-9055-e519-5693-068f8dcb169c@gmail.com>
References: <1626416569-30907-1-git-send-email-brookxu.cn@gmail.com>
 <YPGvIzZUI+QxP1js@mtj.duckdns.org>
 <957ab14d-c4bc-32f0-3f7d-af98832ab955@gmail.com>
 <YP8tPwkJNMAcjDqk@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ChIcbIgLJX/+eQRpKvWif40abxApwvOjyIFA0z+RMsM=;
        b=MU3drwGpgkx0vfwBNTNFP3MytUOGuJQ3j50dvYOId0AswZfumYMStyl+z6WjZn8xss
         wI9eMWl1JEQ+vqomHrTtUT/LVF3rDed6w82f5LQfMDYZSoekPsqtQzVGOYDovAlJE/TC
         VmCmyIum9y/x/IVwYRAdiqmJLu3EsPtXbTxre38qt9Ba5523aYlhBBqBbuqnNS9dl9WU
         0qAJP+FHqHlfzwOWW5nLyuWaDTso5jq165pKxv+ahBbkeq34+qjQdiCu8UtMRhU80vmt
         IsXYvdC6U0ZF0PIu/yOZitNgkmXGyW1foxBDYZ2E01JWlM+Hf4G/MzKs0AKlOj/msRsB
         gpEA==
In-Reply-To: <YP8tPwkJNMAcjDqk-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



Tejun Heo wrote on 2021/7/27 5:46:
> Hello,
> 
> On Tue, Jul 20, 2021 at 12:35:54AM +0800, brookxu wrote:
>> In order to avoid code duplication and IOPS stability problems caused by estimating
>> the equivalent number of IOs, and to avoid potential deadlock problems caused by
>> synchronization through queue_lock. I tried to count the number of splited IOs in
>> the current window through two atomic counters. Add the value of the atomic variable
>> when calculating io_disp[rw], which can also avoid the problem of inaccurate IOPS in
>> large IO scenarios. How do you think of this approach? Thanks for your time.
> 
> I guess it's okay but am still not a big fan of adding another hook. This is
> primarily because blk-throtl is sitting too early in the stack - e.g. rq_qos
> is doing the same thing but sits after the split path - and it's a bit nasty
> to add an additional hook for it.
> 
> Do you think it can be an option to relocate the blk-throtl hooks to the
> same spots as rq-qos or, even better, make it use rq-qos?

Make blk-throttle use rq-qos may be more elegant. But I found that there may be at least
one problem that is difficult to solve. blk-throttle supports separate throttle for read
and write IOs, which means that we cannot suspend tasks during throttle, but rq-qos
throttle IOs by suspending tasks.

We may be able to relocate the blk-throttle hooks to the rq-qos hooks. Since we may not
be able to replace the throttle hook, in this case, if we register a rq-qos to the system,
part of the blk-throttle hooks is in rq-qos and part hooks not, which feels a bit confusing.
In addition, we may need to implement more hooks, such as IO merge hook.

Thanks for you time.

> Thanks.
> 
