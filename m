From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
Date: Tue, 5 Mar 2013 23:23:24 -0800
Message-ID: <CAOS58YOvVoe5KZXMB+mSF2OhXF9_eR+yipk96JW9Fenn2EJ1XA@mail.gmail.com>
References: <5136B7C1.6030403@huawei.com>
	<20130306062224.GJ1227@htj.dyndns.org>
	<5136E9A4.7000201@huawei.com>
	<CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ@mail.gmail.com>
	<5136ED2F.8080400@huawei.com>
	<CAOS58YNJd557hGDMGqavp8eq+B9x5WExCcpW+CwZ8dUainjUUw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=k5M45H88T/XRZRU0lOOTwU4yyY68NvjE0PRstAXw/uA=;
        b=lzfbaEGWum1gLUBd2zJQRV4juidDUniufgpi0pj1GkVx1rXujq2Hi019wB4JxWWZIp
         opzTjmdppXtJ6jAq0vBGsWYFRg0i++OXY7NUFoa6oCAlcoAlJ9WpFefbL3khLfPzCtcx
         JOsc2QKaLOlSGW5NS9Au02n9HPu2NopXiPWo6C4BSbcXsIeUihezd0OIP5M6OLTuiu0R
         OPpqyhN+XKMyWWQRpxwO7/DtQ3SnkRh4U7qX+H6+CFmDY1rZhiMAVF+DhkeG6h8WbDJK
         clm7y8g+2p/jRCiSnqzncxiFvdsrWtQ6Xc/0ak3TS5DAtfo9Br4SXPY84WyVuWzSFxmo
         D7Og==
In-Reply-To: <CAOS58YNJd557hGDMGqavp8eq+B9x5WExCcpW+CwZ8dUainjUUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 5, 2013 at 11:21 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> wake_up() is also allowed to be called from irq handler?
>
> Yeah, well, we don't consider everything which uses wake_up() to be
> irq-safe. I'm not necessarily against making the lock irq-safe but at

More precise way to think about it wiatqueue lock would be that it's
built in a way that also allows it to be used from irq context. It
doesn't *force* irq context on all its users.

-- 
tejun
