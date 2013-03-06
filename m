From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
Date: Tue, 5 Mar 2013 23:02:53 -0800
Message-ID: <CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ@mail.gmail.com>
References: <5136B7C1.6030403@huawei.com>
	<20130306062224.GJ1227@htj.dyndns.org>
	<5136E9A4.7000201@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=KttBfkCSQGqpoVxWMGdhbuCkd3/HnNefqPwauUNYYiM=;
        b=tce05qbjpEmW5d4s5YgdedwR1rIorTZCW751qmsmszt6Fmwvwi+q1K9Zc8SMxn8UZh
         M9SajrTC9wxdJOR4eiurPNGb+HKqEJu++mD9/dOHldruvg3j6xCZX3VOFGaPkyMDR8of
         eFAgyv9YpdvlIMFHLsTdV/UyAVuW18NhvIUClkcZ/mbWW/EV1rYGG6hgPcsYx2oxQ80U
         eMWV2/7k9KnNNOcqTruO3SE1eyQpocjtFjKsqiu7ywJm5gECZRxipTlaavCQHjFRVLew
         zgrYydsM+a8Gsyy4r986fsSZ6Fgy72PhP4di+a959L2Yj3ls+bq7iVThagyN1ngR+Z9i
         TWCg==
In-Reply-To: <5136E9A4.7000201-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 5, 2013 at 11:00 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> Why should wqh->lock be hard-irq-safe?  Is it actually grabbed from
>> irq context?
>
> becase cgroup_event_wake() is a callback to a wait queue, and it's wake_up()
> that acquires wqh->lock with irq disabled.

So, acquiring a lock with irq disabled doesn't make it a irq lock.
Being grabbed *from* irq handler makes it a irq lock. Would the
wake_up() happen from irq handler?

Thanks.

-- 
tejun
