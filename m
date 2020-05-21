From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v5 0/4] memcg: Slow down swap allocation as the
 available space gets depleted
Date: Wed, 20 May 2020 17:22:06 -0700
Message-ID: <20200520172206.4e55b66f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200521002010.3962544-1-kuba@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590020528;
        bh=VNT1XW0Hh5ozONz4ly7v1+37MuVVB4/dY6J8WDs59k8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fVcDR+ygrfYVVQ9LnCkI/9ox3ZHnXW8UYVQV3OFC9RZyQvgE2nFDnG1cxptt85e0X
         QjFs/LbptJMNlvxXW82HpSBAJVYCCHqH6VTjSFVMBxGE9mykhCIMrVG8s6utchYuun
         9GSOUw7zQAIvxKx11ame7WfNfMFykMArJ5iRrv4A=
In-Reply-To: <20200521002010.3962544-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, 20 May 2020 17:20:06 -0700 Jakub Kicinski wrote:
> Tejun describes the problem as follows:
> 
> When swap runs out, there's an abrupt change in system behavior -
> the anonymous memory suddenly becomes unmanageable which readily
> breaks any sort of memory isolation and can bring down the whole
> system. To avoid that, oomd [1] monitors free swap space and triggers
> kills when it drops below the specific threshold (e.g. 15%).
> 
> While this works, it's far from ideal:
>  - Depending on IO performance and total swap size, a given
>    headroom might not be enough or too much.
>  - oomd has to monitor swap depletion in addition to the usual
>    pressure metrics and it currently doesn't consider memory.swap.max.
> 
> Solve this by adapting parts of the approach that memory.high uses -
> slow down allocation as the resource gets depleted turning the
> depletion behavior from abrupt cliff one to gradual degradation
> observable through memory pressure metric.
> 
> [1] https://github.com/facebookincubator/oomd
> 
> v4: https://lore.kernel.org/linux-mm/20200519171938.3569605-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
> v3: https://lore.kernel.org/linux-mm/20200515202027.3217470-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
> v2: https://lore.kernel.org/linux-mm/20200511225516.2431921-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
> v1: https://lore.kernel.org/linux-mm/20200417010617.927266-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/

Ah, damn, I forgot to add Shakeel's review tags, let me resend.
