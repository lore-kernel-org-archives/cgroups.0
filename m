From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blkcg: have bh disable for 32bit UP system reading 64bit
 stats
Date: Wed, 20 Nov 2013 12:24:13 -0500
Message-ID: <20131120172413.GN28946@htj.dyndns.org>
References: <1383736484-393-1-git-send-email-zhiguohong@tencent.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Wyz4Va25NvHstaXMBDINeIjOwV7a54J1U7p+wgBxqdI=;
        b=EO+GNT+mbTz1yEPjUo88H6KqowhflGyTPNKu++DRW7vzzE+a6nn9kRnMMnn3q/y6ep
         sGgCNhboq2lbTM8c4Lvj+Yib3g8ZB8C8OUOoRIDDNf4KMUKEfP7mQHTX3Jo6mmF5vZua
         rx011VqWuhP1p9I4m8VBHtfNHnuUvQihrEI3eqFo2Kki3b9zA3uNMqWcxFx/qCpMDfji
         so8Umk+TGdY15EtCK0WQVbGI3qSVVIQ9RCBZ7i8WLr8ikrGZTnfMZpD+HL7JiAelHHOk
         GJWKwm3SJQKQkRlAFI0BTykrAZ58J4ukvvSadVqI9Hw8hYJ4pFEfti7aECmk61dtnpgU
         IHHA==
Content-Disposition: inline
In-Reply-To: <1383736484-393-1-git-send-email-zhiguohong@tencent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong Zhiguo <honkiko@gmail.com>
Cc: vgoyal@redhat.com, cgroups@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>

On Wed, Nov 06, 2013 at 07:14:44PM +0800, Hong Zhiguo wrote:
> From: Hong Zhiguo <zhiguohong@tencent.com>
> 
> Update of blkg_stat and blkg_rwstat may happen in bh context.
> While u64_stats_fetch_retry is only preempt_disable on 32bit
> UP system. This is not enough to avoid preemption by bh and
> may read strange 64 bit value.
> 
> Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>

Acked-by: Tejun Heo <tj@kernel.org>

Jens, can you please pick this one up?  This probably needs to be
tagged for stable too.

Thanks!

-- 
tejun
