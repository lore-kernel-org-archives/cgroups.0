From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Wed, 9 May 2018 12:05:51 +0200
Message-ID: <20180509100551.GL12217@hirez.programming.kicks-ass.net>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=STaWK4Mzm+EngNJGYDAB3IhvQYYqDDq33lph42W7BQ0=; b=lsTjblK7/H7ro6++rn2SYFMEX
        rwf5yUvb7kwiJn0gjpYvH51iGR5PH+Iliw8yTPTCmEunP47BR+N+QH9TjLlMQhNJBka9+BK7CdzFR
        sg1RskCx+VGQKhvGpybARjSfMN8emWckQN4fYeOEWrBzlKSV9u/HcoVaEFWyhjvJyiLK/uKgzJ9UG
        D4ACVNv2tMhnxKUw5sq4eVijX9wDg9U0kFiAgujoiHVnaD+9b94r1bYd7AbK45MKusVYJoSvoK0oP
        FOtpuT62vG+uDTqHkLpwAA5UbyLEzEprmOI5qWc2XLApPey3vcdmcoblkJGHbytsftT9ceO9E2RI8
      
Content-Disposition: inline
In-Reply-To: <20180507210135.1823-7-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon, May 07, 2018 at 05:01:34PM -0400, Johannes Weiner wrote:
> +	u64 some[NR_PSI_RESOURCES] = { 0, };
> +	u64 full[NR_PSI_RESOURCES] = { 0, };

> +		some[r] /= max(nonidle_total, 1UL);
> +		full[r] /= max(nonidle_total, 1UL);

That's a bare 64bit divide.. that typically failed to build on 32bit
archs.
