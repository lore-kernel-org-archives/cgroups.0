From: Tejun Heo <tj@kernel.org>
Subject: Re: Race condition between "read CFQ stats" and "block device
 shutdown"
Date: Thu, 26 Sep 2013 12:30:29 -0400
Message-ID: <20130926163029.GD32391@mtj.dyndns.org>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com>
 <5226D661.7070301@suse.de>
 <CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ@mail.gmail.com>
 <20130904160723.GC26609@mtj.dyndns.org>
 <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com>
 <20130926135443.GC2480@htj.dyndns.org>
 <5244423A.2050107@suse.de>
 <CAOMFOmX2f35qWyTr7=1HNu=RMB_LMAmpMbYxSEsX1xgURhx_mg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-scsi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oc1i5e8h+ACFx6XmuCSt/TzrY9ulqgISUyrFVNPqzFY=;
        b=OfiRrfv+6sUpj5P+Pz0zXab7sSz9Ws1ig91jY28wMvYt5nuPWnBFQguiHDrUXIz2Wb
         TKZueLdn1A/5IONsu8Mgmh0LBKseSKB9cG9eTQsmKuXuHPwXMFlZ4dtTbMf/sFL5mnGr
         YOJww/V+ANNk8BHQgkv8G9MFMrnY7IFmKIZuaRoIKGjKNQAhkC+yI0LNdiWHXzuZs103
         0QpeYC8rpao1S0EWN1pzd2o1u7ZKcc0Yp7TRvHJg55AzR4BmL0VGVLbHGSJikWaBc95P
         BLsC5il+3B9HKAMiuqkch7esrLIZDoChMoKv8wgr8Wrl///EMLZ6ehfCecmEAAsvYl+w
         FDRg==
Content-Disposition: inline
In-Reply-To: <CAOMFOmX2f35qWyTr7=1HNu=RMB_LMAmpMbYxSEsX1xgURhx_mg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Cgroups <cgroups@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

Hello,

On Thu, Sep 26, 2013 at 09:23:19AM -0700, Anatol Pomozov wrote:
> We use modified version of "sbull" block device driver from GKH book.
> We use it for testing block device startup/shutdown path + CFQ
> manipulation.
> 
> The sbull driver uses function
> blk_init_queue(..., &dev->qlock);
> 
> it passes lock as a second parameter and function makes the lock
> swapping. According to your information passing lock to
> blk_init_queue() considered as an "old non recommended way" so we
> should modify our driver and avoid doing this. I'll take a look.

I wonder whether we can make request_queue record the passed in lock
and grab it in addition to the queue lock instead of replacing it when
invoking the request function.  This would mean more overhead for the
broken drivers but given how legacy they are at this point, I don't
think that's gonna be a big problem.  if that's likely to work, we may
as well just push all the extra locking to the legacy drivers so that
their request functions take the extra lock and then we can remove the
spinlock argument completely.  I'm not sure whether the locking in
request path is the only thing necessary tho.

Thanks.

-- 
tejun
