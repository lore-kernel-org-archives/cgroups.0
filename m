From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH 3/5] mm, memcg: save some atomic ops when flush is already true
Date: Fri, 30 Jul 2021 10:37:55 +0800
Message-ID: <CAMZfGtVLd29_wmQ6iYky0WHrk+PO_AnwDBzf-bW4kMRCW=P4UQ@mail.gmail.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com> <20210729125755.16871-4-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x4WMMn3KZL/hzwCkedZqe/lll/VsdM4TyQkWpwv+pB0=;
        b=Ekx4RmWXZPFJE+OMq795Ky7l5Qiiu10/BdprEfuK7DG+c7bB5LrAOoxCfOq4LcZdVB
         yBREPZM20pqfvFU85pDqfCUKfxMy2RQvQJA1Oo9WdmQS1E3QhJLqVvKHd2W1lsTmaYFV
         IubFHVyVEUe+rkf/seQ+ZGzYLjQhZ8PdSvS2mB6lwN3aTJMTGelWDOqxJilxvC10Hyl3
         1pmNQgU/21cplXyhA7jnHCWRUeOai5mmHHhP6If+azneudn4hpuE3f5ZfN0ULd+XhatO
         PeLdmEC8sMTSch8HjtrbtNCKYJuDQ+p5Qhiwxn3ofBQmXx4KzMLaoFZSAZoDFOMBH4jD
         y7Mg==
In-Reply-To: <20210729125755.16871-4-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alex Shi <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 29, 2021 at 8:57 PM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> Add 'else' to save some atomic ops in obj_stock_flush_required() when
> flush is already true. No functional change intended here.
>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
