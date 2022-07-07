From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Date: Thu, 7 Jul 2022 21:11:26 +0000
Message-ID: <YsdL/mgrbCCM/mtr@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-4-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZTnfo6xRgRnDJAawujjn6RVFJwv9JbaWoUFvSQYT7gc=;
        b=b6mVfEU3B1Kz+nxNI3jjT4RpusLpAVsVtGCThcqz2WxsNk8Y3tI17P9xznRGksBAb+
         8GtcLKGD6SqLecoii/sJRZBzYe/oHHfCmBQ6KyjOUKEs9JbhsSO8LlGC7Gg3qZOKpu6t
         R+U7jZ4wKm/B+FwKq2Z/bXAYtTf5NK7zJgDRNJHgaUVfPSOGNvaRqHsaiOSfkPwSd99I
         8OUzNcHpzBwaMfSLWuFKpCaWhXyShGNvFjcSuQGRbO512wy3OM/j+/9PUvBMJJDZlQt4
         pVg+ex6bvlhCnCQYp6vGAzpwe0MyOM/LaQwAKdRF13SuWllj3O+oHHym/YUmAyOh3Fqs
         358g==
Content-Disposition: inline
In-Reply-To: <20220628220938.3657876-4-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Shaoqin <shaoqin.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWNGWvitb5QawA@public.gmane.org

On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 in memory stats under secondary
> pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
> visibility into the memory consumption of KVM mmu in a similar way to
> how normal user page tables are accounted.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---

Reviewed-by: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
