From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Track exported dma-buffers with memcg
Date: Thu, 12 Jan 2023 07:56:31 +0000
Message-ID: <20230112075631.wc6fd54ci55drhkp__36350.5042785377$1673510211$gmane$org@google.com>
References: <20230109213809.418135-1-tjmercier@google.com> <CALvZod4ru7F38tAO-gM9ZFKaEhS0w3KqFbPwhwcTvgJs4xMUow@mail.gmail.com>
 <Y78+rfzXPq5XGs9O@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vg6nAgYjZ4wYYlTqMF3jbo791ipG8SuFLzs8v41dmTI=;
        b=kL0UvQite/urbN7Yp3NlzfzFTECRjRM1K7T5g4ZxG3zHylBlslAyzr6qxrAi9aysJM
         RDeACOZIgRrgriXoR4Pb3FUm6siAnl76A15BakL+7xmzzyJYvBrIKvFGmqzOdrHuLyHw
         eLCWL5a84U7mTNiiuZkhyyW//9BsTntHFbTMWG3xqNxmoxumrT4tac24HiqQmCacQxb7
         hWUb45XPnPy09DrO6jQeVMIxbVjfhO/QXKCL83ehtKjjTMjBps8fFK6gPa75SmpeTyw8
         vcf4DzdsP5Yv5ETLXzCGGp7Lotol2entUVESDqjWMyWKfU3XQsKSss8PleO3BkZomuWi
         ioIg==
In-Reply-To: <Y78+rfzXPq5XGs9O-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed, Jan 11, 2023 at 11:56:45PM +0100, Daniel Vetter wrote:
> 
[...]
> I think eventually, at least for other "account gpu stuff in cgroups" use
> case we do want to actually charge the memory.
> 
> The problem is a bit that with gpu allocations reclaim is essentially "we
> pass the error to userspace and they get to sort the mess out". There are
> some exceptions (some gpu drivers to have shrinkers) would we need to make
> sure these shrinkers are tied into the cgroup stuff before we could enable
> charging for them?
> 

No, there is no requirement to have shrinkers or making such memory
reclaimable before charging it. Though existing shrinkers and the
possible future shrinkers would need to be converted into memcg aware
shrinkers.

Though there will be a need to update user expectations that if they 
use memcgs with hard limits, they may start seeing memcg OOMs after the
charging of dmabuf.

> Also note that at least from the gpu driver side this is all a huge
> endeavour, so if we can split up the steps as much as possible (and get
> something interim useable that doesn't break stuff ofc), that is
> practically need to make headway here. 

This sounds reasonable to me.
