From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcontrol: Export memcg->watermark via sysfs for
 v2 memcg
Date: Mon, 9 May 2022 09:44:58 -0400
Message-ID: <Ynka2s67yLpkOoE5@cmpxchg.org>
References: <20220507050916.GA13577@us192.sjc.aristanetworks.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fdtyY+76slzM1oP4DlLOabKhkAkAGRbXkU+vbbhXODI=;
        b=ASZyWPXF9PtMX10Dwd7rQieT8a3L+16a5mx52slrfszXDgs4xuzeCVGKZXDxgmFbvX
         xP8Vbz4n60V1G0p7lbKcmpOr4/RXMn39dp3bXXpKSMYf4xxmY0uZSFy29gmknYlOd0jg
         Q07UCLl/aYGd+vnRS+5snSd1jU/CVTUB+npodpUmxlyUNUOHNiXQYlVmhMDl5/P16ipN
         RtwacxeumcSaUs/89KM+tiMp2Dl6CLA67scGwmkttVV7Uvx40WybSXpAQ4p2AObPcwSX
         W5TkreCcvuX97pJ2o88fM8HYgmqNFB6TkunZhjoDyf5beCqpPZ24XAdhcOYGjMvDB57c
         khGg==
Content-Disposition: inline
In-Reply-To: <20220507050916.GA13577-pF7uKtACKh3GmWBmRUYTj5O0Dwfk+90YVpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, May 06, 2022 at 10:09:16PM -0700, Ganesan Rajagopal wrote:
> We run a lot of automated tests when building our software and run into
> OOM scenarios when the tests run unbounded. v1 memcg exports
> memcg->watermark as "memory.max_usage_in_bytes" in sysfs. We use this
> metric to heuristically limit the number of tests that can run in
> parallel based on per test historical data.
> 
> This metric is currently not exported for v2 memcg and there is no
> other easy way of getting this information. getrusage() syscall returns
> "ru_maxrss" which can be used as an approximation but that's the max
> RSS of a single child process across all children instead of the
> aggregated max for all child processes. The only work around is to
> periodically poll "memory.current" but that's not practical for
> short-lived one-off cgroups.
> 
> Hence, expose memcg->watermark as "memory.peak" for v2 memcg.
> 
> Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
