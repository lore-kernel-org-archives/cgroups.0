From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-3.15-fixes] blkcg: use trylock on
 blkcg_pol_mutex in blkcg_reset_stats()
Date: Mon, 5 May 2014 13:48:07 -0400
Message-ID: <20140505174807.GO11231@htj.dyndns.org>
References: <5363C04B.4010400@oracle.com>
 <20140505163730.GL11231@htj.dyndns.org>
 <5367CE9E.5010208@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FAYIO3MWqojqh+N3p20rXAVD6sg+IAfmJAQtDtrCMHI=;
        b=kJb6pur4Hhk8M9QuvcJrZ9/BtoJ53lTnOuMeKm6DAtEwdTJgaGRSVruROdtsaTZif6
         /gGvARnMJF8QUu+ffE7sP17jEMPra2NsUOwGINXDO8RDNsG16ZkAWozfeoPWgh7HPJcW
         AKfSI0CbVO5KPQm4QplIzh2Ema3UTIeGwjnOkqzRJ+ZhElYRQHOXOgZkmZ0JIUXIDle4
         5JUxVpjXFaov+wK0Bn4BJuKabLn2iiuYHwqVXv7Rm1LNtmTcfOkBRYyZP0EewljDsndc
         7uRTQExauk8uRijUpi6tIl1q8pQpxtr7shMtDa7+GqyZ4tJdrYzGjfgXYA3OZ88+yQHK
         tVag==
Content-Disposition: inline
In-Reply-To: <5367CE9E.5010208@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Li Zefan <lizefan@huawei.com>, axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, cgroups@vger.kernel.org

On Mon, May 05, 2014 at 01:47:10PM -0400, Sasha Levin wrote:
> Hey Tejun,
> 
> On 05/05/2014 12:37 PM, Tejun Heo wrote:
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Li Zefan <lizefan@huawei.com>
> > References: http://lkml.kernel.org/g/5363C04B.4010400@oracle.com
> 
> I think that the Reported-by here should be me :)

Oops, how did that happen?  :)

Fixing up in the branch.

Thanks!

-- 
tejun
