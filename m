From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 12/14] blkcg: remove bio_disassociate_task()
Date: Tue, 4 Dec 2018 14:53:28 -0500
Message-ID: <20181204195327.upryhcrqaxjxgrzd@MacBook-Pro-91.local>
References: <20181204183600.99746-1-dennis@kernel.org>
 <20181204183600.99746-13-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eibZSqqt2fdedYCZEqGEWncABakoTV+JJrqQAPkEo70=;
        b=e9VoNikxb1yKN7yTDxfP/PRQF4kY+TdUAo3Dd3k5vpDc+QARcG7zgJemnx15g8VY6p
         6bhUEmuGlIKOXF6xLNjIU9HGHXoFIl/oquJXyBoaUJGHBARVys3B7pUpNG0nJEjZAcrD
         UN6f0n0A4jCJqVCJWi1bVL82RRNES0O87NRcvQmIY3KHj0i7zeq0eBGVxHhv/eFwMnzb
         5hGdgwIZERYn9tAsQJ94snlf4ajwSFw28zvESwq1SMlEyNamlKEsca0TfjfvDUgkn/Ys
         wRXMuqUEWrew3IgJ7OppvojSxbs0mvrHT9hAT5LDNh21RKViLdkpnnV3JvU3uXNOav3v
         yV2w==
Content-Disposition: inline
In-Reply-To: <20181204183600.99746-13-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 04, 2018 at 01:35:58PM -0500, Dennis Zhou wrote:
> Now that a bio only holds a blkg reference, so clean up is simply
> putting back that reference. Remove bio_disassociate_task() as it just
> calls bio_disassociate_blkg() and call the latter directly.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
