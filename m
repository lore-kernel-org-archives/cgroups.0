From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
Date: Tue, 5 Mar 2013 23:21:03 -0800
Message-ID: <CAOS58YNJd557hGDMGqavp8eq+B9x5WExCcpW+CwZ8dUainjUUw@mail.gmail.com>
References: <5136B7C1.6030403@huawei.com>
	<20130306062224.GJ1227@htj.dyndns.org>
	<5136E9A4.7000201@huawei.com>
	<CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ@mail.gmail.com>
	<5136ED2F.8080400@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=MsVVwx7SJo7TD7bO1S6co0HoCGOYjsTdwZysj/ldXlU=;
        b=ehP1g92eXfIGrsDazkGefKOD4PRLZrK8NW7tUZH1tqWPd4nleg1WOIR95Dnk7fZoUJ
         w3RSdcci3hJ+GQ8motGSv3O2xhUYiSIBKtXnOvhNn0a/V8ZLxZkFHVxDvqFu6otjkU5/
         DVSwa7lzfqSfj/SZgJtcf+4XQsQ3S0uDhc4EOmtPwGf4OeSRVpiqfKhQmeWYYOwqftsp
         375ouGTu0OL//CCN2YLR3VULFtbFAaKGEgovAA6+2L0yaWgdycAwbn247xeKd8g0bQif
         6H/m4gs4U7F40SsOaw7vPS/zga+o8eM0aVMXOCcQhPHR8Rv5iMCRTwOyW0BkSqnL9LYl
         dmbA==
In-Reply-To: <5136ED2F.8080400-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Tue, Mar 5, 2013 at 11:15 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> wqh->lock is used through out fs/eventfd.c. I don't know if currently there's
> any kernel user using eventfd APIs in an irq handler, but at least that should
> be allowed.
>
> wake_up() is also allowed to be called from irq handler?

Yeah, well, we don't consider everything which uses wake_up() to be
irq-safe. I'm not necessarily against making the lock irq-safe but at
least the commit message is misleading as currently posted. I'd
suggest looking at eventfd and see whether the wakeup could actually
happen from irq context. If not, I don't know, I don't think it
matters either way. It's not like it's a difficult one to detect with
lockdep.

-- 
tejun
