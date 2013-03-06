From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
Date: Tue, 5 Mar 2013 22:22:24 -0800
Message-ID: <20130306062224.GJ1227@htj.dyndns.org>
References: <5136B7C1.6030403@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=3eVhUaP6US2Km2ULjUC+jljAdwoM9xReffzRQr0dx4A=;
        b=fxLsO0Ujzgxp5GSfby8q42YvAqixjzzOSo1bo7YRme3JHsKIfb88GIVAvwSqa6OUgB
         tElA5B9ZrKyHTiwtMafh+q2srbBS2SJn2c5ksmS4UcU/CAQAYAApcqRCzWZdYRzPAGjk
         FB0oOapJYdFPfQ20iGxxQjRK0qakXzSHIL/ykI7HIvf3ru8pYPIIfi/3kfL766Qb70PH
         qXzFYOjdphnKZKksBVDdZw14B3+y3OS9Bzgf1W8QmKIU4JxFm2iXUWOGMI17Bl8kuviN
         7zr5JFZVYbxFtUawXoi7NmyoCiGV2Fu+IlApvk+k3l9UHBJc0uWGaN6hSm9JqUTHe/qB
         Hwug==
Content-Disposition: inline
In-Reply-To: <5136B7C1.6030403@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hello, Li.

On Wed, Mar 06, 2013 at 11:28:01AM +0800, Li Zefan wrote:
> cgroup_event_wake() is called with hardirq-safe wqh->lock held, so
> the nested cgrp->event_list_lock should also be hardirq-safe.
> 
> Fortunately I don't think the deadlock can happen in real life.
> 
> Lockdep never complained, maybe because it never found wqh->lock was
> held in irq context?

Why should wqh->lock be hard-irq-safe?  Is it actually grabbed from
irq context?  Locks which are grabbed with irq disabled aren't
necessarily irq context locks as that doesn't lead to deadlocks.  They
need to be actually grabbed from irq context.

Thanks.

-- 
tejun
