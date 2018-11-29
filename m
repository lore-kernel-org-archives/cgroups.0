From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/13] blkcg: remove bio_disassociate_task()
Date: Thu, 29 Nov 2018 07:54:56 -0800
Message-ID: <20181129155456.GF2509588@devbig004.ftw2.facebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-12-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=04/qz8pdLsU4owCgN/+S4NzXW745Zs/GT+VihcKn1BQ=;
        b=CJY2VxSK69Lg9Fxe33/Pl6m98z94gClHNtHo3zML+d7D+WHR3JBPoca+2RE1SniLgc
         GFXFXftY39J0B2i5o7xanPFKCGwwHmyGnwtLBVr1iUDPP9aKOqX6trn+dHjVIJk8Lwf7
         M9l/DBz/LFKcvMrtjq/c4KMBgdUzfwd/K3MCG8PRWV5cCZZgRIEVOXFx/DAqxelqpiMv
         uQ1heHDh/155GWT8oN8ZK8pdWBQ957IdVyxn8+fZODsOGAoJBxjPv20If7s95a60PN8p
         KJVcFSicEDJK4NkGAwBpBwaUBrZ09gU/Qzi23EgUuiUUdIzADQcJK15dRNNp16Ope25A
         9aCQ==
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-12-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 04:19:44PM -0500, Dennis Zhou wrote:
> Now that a bio only holds a blkg reference, so clean up is simply
> putting back that reference. Remove bio_disassociate_task() as it just
> calls bio_disassociate_blkg() and call the latter directly.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
