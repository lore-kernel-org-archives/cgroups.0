From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Tue, 22 Nov 2022 11:59:18 -0700
Message-ID: <CAOUHufbQ_JjW=zXEi10+=LQOREOPHrK66Rqayr=sFUH_tQbW1w@mail.gmail.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9DTsq3fTwNbT6i34craZmfTRExedmDHXASu4ap4JQWc=;
        b=euKH/+vJIk4jb5GYcwTIndpZtGrvZkOBeSQRk87xMjmZTH+RQ1pCNwnXJLB8r/oQO0
         x4NbvARykKT5UQRTYNFqc4c4y2HLtlQ0gwBrOUmgIYxYGKBvSsLiYFxxHey3fT3w/9Vj
         HOQ7Qj5hpRKUloDQyonDJ8F2dOblLZMmhxyUfbRFBcyPMZ2uFWy1Izg4UvFn7gsqx2n1
         ym1wloPvHbcVO13o21Vg+S93Kbo51YjBNfIYA2HBOkKEPJ/Z6SJ4/BP/QvHgGdHCxwvD
         QGOm47FEhjAWZAXMx2WhoKZKfiBjRMtZfj9QV6t+NhIB5xXw6qp1E8JC0TJGvherHUzh
         c4Uw==
In-Reply-To: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Mon, Nov 21, 2022 at 5:53 PM Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org> wrote:
>
> Hello,
>
> We have observed a negative TCP throughput behavior from the following commit:
>
> * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
>
> It landed back in 2016 in v4.5, so it's not exactly a new issue.
>
> The crux of the issue is that in some cases with swap present the
> workload can be unfairly throttled in terms of TCP throughput.
>
> I am able to reproduce this issue in a VM locally on v6.1-rc6 with 8
> GiB of RAM with zram enabled.

Hi Ivan,

If it's not too much trouble, could you try again with the following?
  CONFIG_LRU_GEN=y
  CONFIG_LRU_GEN_ENABLED=y

I haven't tried it myself. But I'll fix whatever doesn't work for you,
since your team is on the top of my customer list :)

Thanks.
