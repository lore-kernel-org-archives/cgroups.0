From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-cgroup: Remove unnecessary rcu_read_lock/unlock()
Date: Tue, 17 May 2022 06:13:20 -0600
Message-ID: <165278960081.13853.15178111681664943346.b4-ty@kernel.dk>
References: <20220516173930.159535-1-bh1scw@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=0CFZi2WdHh+fWnk2m1bIXH7l+E5jrgN/oQfn0swAlk0=;
        b=J1JomReZIjMEXQobTzVFw7ummBWdomtyzdyFFet3/kcc/jM+gvVqVpq2Vc/6ULmkci
         TrdzxzJOgkhyPeKaEB8TyJ7GUYbqXaJZChg1Rzz1OPOY2zKD77e7B0Ud/Ct9XzPpczfQ
         yUdrdQGcMoQGHU1XbBhSp/qOlzwdGZgqOReniRcnAHlJWwroi239fLHrS611gIYdCqsQ
         s1AQKsJqLq7O3ZWsoslHYwzyf+cl8QKLKbhwG54yFd7Xi3PMk4WPr07FuzlA155FlJn/
         w1x8iegRjjG7bDocm0Y6wTLVG0E4NoUC9hTcL58Y6RzIYndo/yNAwrJ53a0ICDcGifsf
         mAVw==
In-Reply-To: <20220516173930.159535-1-bh1scw@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, bh1scw@gmail.com
Cc: songmuchun@bytedance.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 17 May 2022 01:39:30 +0800, bh1scw@gmail.com wrote:
> From: Fanjun Kong <bh1scw@gmail.com>
> 
> spin_lock_irq/spin_unlock_irq contains preempt_disable/enable().
> Which can serve as RCU read-side critical region, so remove
> rcu_read_lock/unlock().
> 
> 
> [...]

Applied, thanks!

[1/1] blk-cgroup: Remove unnecessary rcu_read_lock/unlock()
      commit: 77c570a1ea85ba4ab135c61a028420a6e9fe77f3

Best regards,
-- 
Jens Axboe


