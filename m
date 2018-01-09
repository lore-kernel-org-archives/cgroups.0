From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] blk-throttle: dispatch more sync writes in block
 throttle layer
Date: Tue, 9 Jan 2018 06:56:59 -0800
Message-ID: <20180109145659.GG3668920@devbig577.frc2.facebook.com>
References: <f6f59e3c-456a-8275-8af0-32e4f2e5cdd6@gmail.com>
 <20180108120742.GJ3668920@devbig577.frc2.facebook.com>
 <5ff01c31-5277-909f-4c35-9b9be513d8e1@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=34E54VBw6rT9T9uuDq/vyos5Hr9IMy2SEbYXuzP4I7g=;
        b=RiRcdM//oQQLtvmRMSIDrOxGYGkuuOFjnpDPJRALixcuj3NhnrZWDwD9YimIgvKN/3
         87kbP+leYTfNlh6ilvMCPvnAHZjXe7WPbYR3j1sqhdmmcW+NcdrGXDeY6A177C+immC6
         8T+Kv+c4kVJIGWVGWcyC2HHKQ48bDkbR+yNgIpCnpssUe4yprj9LrA3+4xJB5bmgtqFs
         mv29Z1nzYNIalGtRBXx4WHpR8PlyzNJi24tkyI93bdaZYPC+GiECluG21h37lDRR8EiZ
         meZBLemUj8AtKoWLl4RK1OFS23NpCkM5thOAU5oyOxqAGUlc89SkcW32PHWmztTBz+f7
         O/5g==
Content-Disposition: inline
In-Reply-To: <5ff01c31-5277-909f-4c35-9b9be513d8e1@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xuejiufei <xuejiufei@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, Shaohua Li <shli@kernel.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, jinli.zjl@alibaba-inc.com, qijiang.qj@alibaba-inc.com

Hello,

On Tue, Jan 09, 2018 at 12:45:13PM +0800, xuejiufei wrote:
> 1. A bio is charged according to the direction, if we put the reads
> and sync writes together, we need to search the queue to pick a
> certain number of read and write IOs when the limit is not reached.

Ah, you're right.

> 2. I found that the multi-queue scheduler kyber also has three queues:
> one for read, one for sync write and one for others. This patch
> introduces another queue for async writes and others just like kyber.

Yeah, it'd make sense to make that a separate queue then.

Thanks.

-- 
tejun
