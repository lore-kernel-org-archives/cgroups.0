From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Tue, 11 Feb 2020 15:19:06 -0800
Message-ID: <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
References: <20200211213128.73302-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581463147;
        bh=0TVKSVRJRv/z3S7kxpkrJCMjT/X+SvLuGM2qOdND2sw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cu3jAtewRRDlmCAw+wkXwFQAflXIRX/nRaeTMPRBLFRtS7HfQmFogOcd+JSX1pXmr
         o4zDJhRMBWqCseqvBTHft9sdTDjPjqye7WP/eoKKRudXmhnqi/G3pDQuYo4BuRJ3eq
         VIyVuHqInOEuCzLbUH7F3jI64oVXTL59gXIYLT3s=
In-Reply-To: <20200211213128.73302-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 11 Feb 2020 13:31:20 -0800 Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> These counters will track hugetlb reservations rather than hugetlb
> memory faulted in. This patch only adds the counter, following patches
> add the charging and uncharging of the counter.

We're still pretty thin on review here, but as it's v12 and Mike
appears to be signed up to look at this work, I'll add them to -next to
help move things forward.

