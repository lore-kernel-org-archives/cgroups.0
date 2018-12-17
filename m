From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/6] psi: introduce psi monitor
Date: Mon, 17 Dec 2018 17:22:23 +0100
Message-ID: <20181217162223.GD2218@hirez.programming.kicks-ass.net>
References: <20181214171508.7791-1-surenb@google.com>
 <20181214171508.7791-7-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GzJw5OfqZmFeF3p28QfnsLekp01V+WlkztoA/o5MB54=; b=WYxsJrP404KuAZ2ACEgEdDK7l
        nkBSRImFxKA13t+MK5lTOYQiicpZuZKazn7bmwDj+2IlsDtct6CC1Uw6WDTGajnKe5y94U5mlc5op
        JB5tGoD4ja81ENX8kijklOQiBBew9EGn9tWwQH4/eh4vrLwfKl7UQX2NM92rUYee5AtGc7+UQbwfL
        2ViuXTBIbTq2flLaf1pz23VW7S8tAqbSk2oQIVIiaADY1FRuVqUPMslUQo7uYouhCVkKPxIWKf3QZ
        DOMqiWnScFsyY5gLOn1x4AtB1AMkSGsHZkPzq9fn/ETXvXZ5v/0mkje5LQSEN6aA7Qc4adrteE2di
    
Content-Disposition: inline
In-Reply-To: <20181214171508.7791-7-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Fri, Dec 14, 2018 at 09:15:08AM -0800, Suren Baghdasaryan wrote:
> +ssize_t psi_trigger_parse(char *buf, size_t nbytes, enum psi_res res,
> +	enum psi_states *state, u32 *threshold_us, u32 *win_sz_us)
> +{
> +	bool some;
> +	bool threshold_pct;
> +	u32 threshold;
> +	u32 win_sz;
> +	char *p;
> +
> +	p = strsep(&buf, " ");
> +	if (p == NULL)
> +		return -EINVAL;
> +
> +	/* parse type */
> +	if (!strcmp(p, "some"))
> +		some = true;
> +	else if (!strcmp(p, "full"))
> +		some = false;
> +	else
> +		return -EINVAL;
> +
> +	switch (res) {
> +	case (PSI_IO):
> +		*state = some ? PSI_IO_SOME : PSI_IO_FULL;
> +		break;
> +	case (PSI_MEM):
> +		*state = some ? PSI_MEM_SOME : PSI_MEM_FULL;
> +		break;
> +	case (PSI_CPU):
> +		if (!some)
> +			return -EINVAL;
> +		*state = PSI_CPU_SOME;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	while (isspace(*buf))
> +		buf++;
> +
> +	p = strsep(&buf, "%");
> +	if (p == NULL)
> +		return -EINVAL;
> +
> +	if (buf == NULL) {
> +		/* % sign was not found, threshold is specified in us */
> +		buf = p;
> +		p = strsep(&buf, " ");
> +		if (p == NULL)
> +			return -EINVAL;
> +
> +		threshold_pct = false;
> +	} else
> +		threshold_pct = true;
> +
> +	/* parse threshold */
> +	if (kstrtouint(p, 0, &threshold))
> +		return -EINVAL;
> +
> +	while (isspace(*buf))
> +		buf++;
> +
> +	p = strsep(&buf, " ");
> +	if (p == NULL)
> +		return -EINVAL;
> +
> +	/* Parse window size */
> +	if (kstrtouint(p, 0, &win_sz))
> +		return -EINVAL;
> +
> +	/* Check window size */
> +	if (win_sz < PSI_TRIG_MIN_WIN_US || win_sz > PSI_TRIG_MAX_WIN_US)
> +		return -EINVAL;
> +
> +	if (threshold_pct)
> +		threshold = (threshold * win_sz) / 100;
> +
> +	/* Check threshold */
> +	if (threshold == 0 || threshold > win_sz)
> +		return -EINVAL;
> +
> +	*threshold_us = threshold;
> +	*win_sz_us = win_sz;
> +
> +	return 0;
> +}

How well has this thing been fuzzed? Custom string parser, yay!
