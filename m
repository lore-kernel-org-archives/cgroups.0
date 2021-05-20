From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: disable controllers at parse time
Date: Thu, 20 May 2021 12:30:18 -0400
Message-ID: <YKaOmmI8G4DPk+uo@slm.duckdns.org>
References: <20210512201946.2949351-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3W+WKCOZfAqXxcanQdJX+E4VIil1GeWKxxWHUOqsnD4=;
        b=HAbBW113TuLa9uF4nGtlHtdoyguK0a0XR8RiCgHJn6OOfAVrEndlerGb9lojxQQU46
         L+JMqEeBn3zvbZm1g3i1qMk6dF88k2K3E6YwAhiwWSxWq013UYHS81e566F87A6jm0rx
         WswXOtpOOkAqOcBcEbFJrkHq5CNCzz3oc9WcSnT6xfB+69zbr/as/cRSTLBjCRqARdwH
         b8MuzNtkv872KFOL3l/iZSxYhK7ZbCeb1gs2OE07mDuVVOtkBRsm6yENj/gm1zYhav2y
         YDsyfqXvkaPzhNMJ8Q2cKHPL6NsH2AklMxth7IQ0ZwikcS1FAOEJIjZXpUT+4BYm9Nbi
         1Q2A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210512201946.2949351-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, shy828301@gmail.com, junichi.nomura@nec.com, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, May 12, 2021 at 01:19:46PM -0700, Shakeel Butt wrote:
> This patch effectively reverts the commit a3e72739b7a7 ("cgroup: fix
> too early usage of static_branch_disable()"). The commit 6041186a3258
> ("init: initialize jump labels before command line option parsing") has
> moved the jump_label_init() before parse_args() which has made the
> commit a3e72739b7a7 unnecessary. On the other hand there are
> consequences of disabling the controllers later as there are subsystems
> doing the controller checks for different decisions. One such incident
> is reported [1] regarding the memory controller and its impact on memory
> reclaim code.
> 
> [1] https://lore.kernel.org/linux-mm/921e53f3-4b13-aab8-4a9e-e83ff15371e4@nec.com
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: NOMURA JUNICHI(野村　淳一) <junichi.nomura@nec.com>

Applied to cgroup/for-5.13-fixes.

Thanks.

-- 
tejun
