From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unused mem_cgroup_from_obj()
Date: Mon, 29 May 2023 18:53:37 +0000
Message-ID: <20230529185337.3gk3ww76sdxdgv6o@google.com>
References: <20230527103126.398267-1-linmiaohe@huawei.com> <ZHGAcaqOx/e8lqwV@casper.infradead.org>
 <CAJD7tkYSrVkAONXko0eE6LWS__kK_Xeto9MVGwTxuqT5j6N8RQ@mail.gmail.com>
 <ZHIcnOV/mrkcerlG@casper.infradead.org> <CAJD7tkZ2Q1ZCqNchpiiC6FCE08dYH6tzANA=VqujeDgT8YhRUA@mail.gmail.com>
 <D2B59104-B602-45A3-B938-AE5DC67BAC98@linux.dev> <ZHOtS67ZtMPsyNVk@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685386419; x=1687978419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fb+xGJEzAuTS5TrIgTU4fcvFK43ao8HwfzBYRc52TTY=;
        b=S5vwol9vE0JkslbkyRPxKAkNViXqytiqtwh4nsd9eEgwmZ719gWuFJVhrVRcYMhMhH
         I47+gsK59+oMFCcm/r1itjNdraOXhmYJZhEWSuRWoUYXc7Dp070Pa2Yyvj4dEuYLGKoh
         AVGVBgumYkPyDju0i+9bhA5sVMRSAbgmt/bo08Ofp93ulaxvSQqkzkIXUIKt60Qxt7aS
         ckbLK5h8mRGy+3ePq+B0w88MS07aczR+7j5ah1Mo10ytZ913dDcxeiCeTs6HWF478yhB
         CJ70hGrv1bkk+tSU6BqdFxjeOmCN1out6pHgQpdSrk/bLD1zCrblrtDWLbN3YGdezv4T
         flqw==
In-Reply-To: <ZHOtS67ZtMPsyNVk-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, May 28, 2023 at 08:36:43PM +0100, Matthew Wilcox wrote:
> On Sun, May 28, 2023 at 09:01:37PM +0800, Muchun Song wrote:
> > with *init_net*. If Vasily does not want to bring commit 1d0403d20f6c back,
> > this patch LGTM. Otherwise, let's wait for Vasily.
> 
> If we're not going to bring back 1d0403d20f6c then we should
> simply revert fc4db90fe71e instead of applying this patch.

Initially I was thinking of adding virt_addr_valid() check in the
mem_cgroup_from_obj() but it seems like that check is not cheap on
arm64. I don't have any quick solutions other than adding a check
against init_net in __register_pernet_operations(). I will wait for
couple of days for Vasily otherwise I will retry 1d0403d20f6c with the
init_net check in __register_pernet_operations().
