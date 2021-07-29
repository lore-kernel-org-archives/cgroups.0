From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] mm, memcg: save some atomic ops when flush is already true
Date: Thu, 29 Jul 2021 07:40:34 -0700
Message-ID: <CALvZod4MpcxzZ59hTX72g7F26Kmb=hfBCGNUGq41MgRfTvuEsQ@mail.gmail.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com> <20210729125755.16871-4-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g5bAj8ty5oGdKwNlb8K8CLCbwch75jyi8lukuavge1w=;
        b=Pt/myiUcp/HcWkRJqwMsshxtVCmbTMQkOHiiYTWtRrlpIQtfIwP/TshXg/Sv8sShX9
         o2MFa/ULWHD9UC3jmOcqn1lmGxaT4wKLBTj9EmJNBAHOi7Q8KcOqOF0BKQN7ZPWxNCSJ
         XetW0whmTlm+G5aufSYRe0G9VUSjiNZ+WQeflOuu8nWflrnK9K1ff6Rd2RAu58nxE+Y6
         7qbJdt29eO3qn86prpYrCpSIiyM4hC29igxet+IGxGq7kaFkObrd4BxwXuAznFdcDM9l
         95jP6Xt6Saju2kAdhuCdAVe/F79H2aNR8AMySTMNEDU2FRE0HLzx6Q07o0jseAYwQdQb
         9Rcw==
In-Reply-To: <20210729125755.16871-4-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 29, 2021 at 5:58 AM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> Add 'else' to save some atomic ops in obj_stock_flush_required() when
> flush is already true. No functional change intended here.
>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
