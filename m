From: Michal Hocko <mhocko@suse.com>
Subject: Re: [RFC] psi: Add additional PSI counters for each type of memory
 pressure
Date: Wed, 10 Nov 2021 17:07:33 +0100
Message-ID: <YYvuRUqcxW0Vu9vp@dhcp22.suse.cz>
References: <1636558597-248294-1-git-send-email-quic_c_gdjako@quicinc.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636560456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PPgM0a73dB6hv2TqWrr8loL+EBdXIVciUhuFI52YlVU=;
        b=iAOf10MqrIm8dgZM+vuAFKIjE3oK2/QoiLcGdc5XsjLsd4nz8xO8J3zbfu2E/jgvxLp4Na
        fkkVU4S1ihq0NU4n+RuuXoQQESskzFXJO/ooXfJMCuUnaThzsMy0/xnmrGMVEtbjvOGkNS
        eEOpjh+6wc74ogI0ZHE4HCbjrSrH/NU=
Content-Disposition: inline
In-Reply-To: <1636558597-248294-1-git-send-email-quic_c_gdjako@quicinc.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Georgi Djakov <quic_c_gdjako@quicinc.com>
Cc: hannes@cmpxchg.org, vincent.guittot@linaro.org, juri.lelli@redhat.com, peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vdavydov.dev@gmail.com, tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, djakov@kernel.org

On Wed 10-11-21 07:36:37, Georgi Djakov wrote:
> From: Carlos Ramirez <carlrami@codeaurora.org>
> 
> Calculates psi totals for memory pressure subevents:
> compaction, thrashing, direct compaction, direct reclaim, and kswapd0.
> Uses upper 16 bits of psi_flags to track memory subevents.

Could you elaborate on the definition of those events please? That
should also go to Documentation (Documentation/accounting/psi.rst)
-- 
Michal Hocko
SUSE Labs
