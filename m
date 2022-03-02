From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Add a comment to cgroup_rstat_flush_locked().
Date: Wed, 2 Mar 2022 05:47:16 -1000
Message-ID: <Yh+RhFuPKGL+wpA0@slm.duckdns.org>
References: <[PATCH0/2]CorrectlockingassumptiononPREEMPT_RT>
 <20220301122143.1521823-1-bigeasy@linutronix.de>
 <20220301122143.1521823-2-bigeasy@linutronix.de>
 <Yh8Q+wjgk6dkDphR@slm.duckdns.org>
 <Yh+DOK73hfVV5ThX@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+TXEHf/Ffw9IRANu1j/U09cF+iyN1ryNSiaGmtROC/c=;
        b=E9TP1aQWp7/Dq8MS1gRXWqpotSaejMD0Vl/XuhfYiXbfMlpPINIjlSdESYNCIXZsUH
         iKLdYY+9gbkouxRibpbnlb/+rF4+t+FUMd4+3SR57L5gyqaWzlC6BfnDV0Krffq13wzI
         q3UChBYZk4RTPQao8TEy6OdZWUFWwUck+ou32qXsoJ/6bDf4XADKkTSCEvM+xSUhLYup
         sbApjAGmkm6UfcSLTDMfqsVToQ/zJMi1j5mAxsYFdRuMP+7Y2Li8GRp4qvsMRMIgDOOz
         3zC9BacGl7B5rjFLqmhtRsFcN/cU92MBf4/awNcFN0hWrYoUJX/+isEqApPRtxLDOuIu
         QiPw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Yh+DOK73hfVV5ThX-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On Wed, Mar 02, 2022 at 03:46:16PM +0100, Sebastian Andrzej Siewior wrote:
> Add a comment why spin_lock_irq() -> raw_spin_lock_irqsave() is needed.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> ---
> On 2022-03-01 20:38:51 [-1000], Tejun Heo wrote:
> > Hello,
> 
> Hello Tejun,
> 
> > Can you please add a comment explaining why irqsave is being used? As it
> > stands, it just looks spurious.
> 
> Something like this?

Yeah, looks good to me.

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
