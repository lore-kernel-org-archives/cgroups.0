From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/9] sched/psi: save percpu memory when
 !psi_cgroups_enabled
Date: Mon, 25 Jul 2022 12:47:45 -0400
Message-ID: <Yt7JMfKHYFLGUGBb@cmpxchg.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-7-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ueOMTo6DsQCvnulLJ7Rsqpth0YKKV57efxM+awobwkc=;
        b=1SD4nF22NDrVthsvc/CcEaNX0GsOg8NrfWYQauQ6kZ74/Cf5YJX7Qk7C9QYuipn3dc
         /75txsFW7Y+hWMthAHT7xUpXGfNxA3+uwyKDdnPOvRjLAjoNosLPlXssiDxAdYS7n7Jg
         UwVDAE+eUF9u+ZhvysT3aXuegZZaQVBosX2fekmPN6pfxTmUviDaE/y1MZN7SG1p6PFN
         jrMEAAfWkhyrGkTrkhwlrN4NgjBSnR+iOqCXqUKe4nW4/ddOFDf7L7MeHWR36Gz2bm0w
         HWRIuOJKtD/Ge3FM/1ggPWvXsLLCav4plXeFanzurA9vEmbG5hSVzxuFIwafwUgVAol0
         YdxQ==
Content-Disposition: inline
In-Reply-To: <20220721040439.2651-7-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On Thu, Jul 21, 2022 at 12:04:36PM +0800, Chengming Zhou wrote:
> We won't use cgroup psi_group when !psi_cgroups_enabled, so don't
> bother to alloc percpu memory and init for it.
> 
> Also don't need to migrate task PSI stats between cgroups in
> cgroup_move_task().
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
