From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/7] sched: loadavg: make calc_load_n() public
Date: Wed, 9 May 2018 11:49:06 +0200
Message-ID: <20180509094906.GI12217@hirez.programming.kicks-ass.net>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-6-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zWG9IPm9IFMWB62eZxyspALqVLb6gPilyxYotQ540Rk=; b=J+bPqcmeG51gAAZ07qiXmUDid
        0aU0zhialh1RGsRYTvkv/QxONGGdeugJl07wAZ7ZxXsFytvdy1hh0jK3LWDnTJ4KZri1XySHoerji
        Mkg6F78cs3c412k3Cbmi/HBLN6RmuJNJCvqeR5ZnN/NcOpR/M/jnIrvCPCmTpqVKCqhXXYogTK2OT
        vUoEeI2C1ygqLDCDFcwbOVePisEtSuKI7vEiypFVQnZ+erF4n+9HFAaxftVmJGVkC4ZxWw8DMmUzx
        ML5XKIEo4wPRTwy/XHMR9fjMQdFlzS5KQ0CIC8VajiDvWvm8OEh732/BWU6jtuQu7hu78MG1rNhvG
    
Content-Disposition: inline
In-Reply-To: <20180507210135.1823-6-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On Mon, May 07, 2018 at 05:01:33PM -0400, Johannes Weiner wrote:
> +static inline unsigned long
> +fixed_power_int(unsigned long x, unsigned int frac_bits, unsigned int n)
> +{
> +	unsigned long result = 1UL << frac_bits;
> +
> +	if (n) {
> +		for (;;) {
> +			if (n & 1) {
> +				result *= x;
> +				result += 1UL << (frac_bits - 1);
> +				result >>= frac_bits;
> +			}
> +			n >>= 1;
> +			if (!n)
> +				break;
> +			x *= x;
> +			x += 1UL << (frac_bits - 1);
> +			x >>= frac_bits;
> +		}
> +	}
> +
> +	return result;
> +}

No real objection; but that does look a wee bit fat for an inline I
suppose.
