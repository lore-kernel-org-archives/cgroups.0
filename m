From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Track exported dma-buffers with memcg
Date: Mon, 9 Jan 2023 16:18:12 -0800
Message-ID: <CALvZod4ru7F38tAO-gM9ZFKaEhS0w3KqFbPwhwcTvgJs4xMUow@mail.gmail.com>
References: <20230109213809.418135-1-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sgQCt0va7Fj5/9fGcldqaAxXWYK8cBxGZmP9xyPfdn4=;
        b=CjxZ1mdpIhqu8VGPVCMoqsbsDlIhqCjEmsPqq5qkb1qszkge1Jm7eoOuPAcP/ZV3bk
         wPP+sf8id+ynxeTBPKOWQaibXFQF9VkirxIevCIzpGAQ21ueiyMyljdoDpqBwv6iADhp
         JWDpspg8gxuUz/g8o8f3Q/TpOZXD4wUkStfMnP3bNMTdaoT8E8PrN4XpF0W1y5T9lIyj
         m9H9otSUCpmNvNlNujrmOWTRlgks+Pwp+EXc1GX8tr1KUVIqmZXacuPH98ZfnNVZNFn8
         /a3FCftCVuu8stwkCKaAOtd2Rf8qgv7JUkOT3SOOPfRdmX4H3QpcqFd3fI60DVZdrWVr
         exyg==
In-Reply-To: <20230109213809.418135-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>

Hi T.J.,

On Mon, Jan 9, 2023 at 1:38 PM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Based on discussions at LPC, this series adds a memory.stat counter for
> exported dmabufs. This counter allows us to continue tracking
> system-wide total exported buffer sizes which there is no longer any
> way to get without DMABUF_SYSFS_STATS, and adds a new capability to
> track per-cgroup exported buffer sizes. The total (root counter) is
> helpful for accounting in-kernel dmabuf use (by comparing with the sum
> of child nodes or with the sum of sizes of mapped buffers or FD
> references in procfs) in addition to helping identify driver memory
> leaks when in-kernel use continually increases over time. With
> per-application cgroups, the per-cgroup counter allows us to quickly
> see how much dma-buf memory an application has caused to be allocated.
> This avoids the need to read through all of procfs which can be a
> lengthy process, and causes the charge to "stick" to the allocating
> process/cgroup as long as the buffer is alive, regardless of how the
> buffer is shared (unless the charge is transferred).
>
> The first patch adds the counter to memcg. The next two patches allow
> the charge for a buffer to be transferred across cgroups which is
> necessary because of the way most dmabufs are allocated from a central
> process on Android. The fourth patch adds a SELinux hook to binder in
> order to control who is allowed to transfer buffer charges.
>
> [1] https://lore.kernel.org/all/20220617085702.4298-1-christian.koenig-5C7GfCeVMHo@public.gmane.org/
>

I am a bit confused by the term "charge" used in this patch series.
From the patches, it seems like only a memcg stat is added and nothing
is charged to the memcg.

This leads me to the question: Why add this stat in memcg if the
underlying memory is not charged to the memcg and if we don't really
want to limit the usage?

I see two ways forward:

1. Instead of memcg, use bpf-rstat [1] infra to implement the
per-cgroup stat for dmabuf. (You may need an additional hook for the
stat transfer).

2. Charge the actual memory to the memcg. Since the size of dmabuf is
immutable across its lifetime, you will not need to do accounting at
page level and instead use something similar to the network memory
accounting interface/mechanism (or even more simple). However you
would need to handle the reclaim, OOM and charge context and failure
cases. However if you are not looking to limit the usage of dmabuf
then this option is an overkill.

Please let me know if I misunderstood something.

[1] https://lore.kernel.org/all/20220824233117.1312810-1-haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

thanks,
Shakeel
