From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] Revert "net: set proper memcg for net_init hooks allocations"
Date: Wed, 28 Sep 2022 09:22:26 -0700
Message-ID: <CAHk-=wj2DnK9RAJXJnrSa7WQdKhTXiHNoawCUcxGjk8TdCtJcw@mail.gmail.com>
References: <20220926195931.2497968-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=RNYkwlzjSBs38E+/5XUZn4xEpIcCbwJSOmIImzP0KC4=;
        b=dog9Z6dDOTNjNFT3nVOx9AVPuy15Elp3ZH1zdCjCde6M2ULSae/opQ9DTfOXDMmbAa
         P+6LBTDdLGVRv5jOg/iz4bxV7IlENeLPwn7ylPWsm51mAwmjnoIsREm8CaqozryOClR0
         KNJ4Xcyi+JNTc4nXU8Coc6tODlMLmMSrhyKFU=
In-Reply-To: <20220926195931.2497968-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 26, 2022 at 1:00 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> This reverts commit 1d0403d20f6c281cb3d14c5f1db5317caeec48e9.
>
> Anatoly Pugachev reported that the commit 1d0403d20f6c ("net: set proper
> memcg for net_init hooks allocations") is somehow causing the sparc64
> VMs failed to boot and the VMs boot fine with that patch reverted. So,
> revert the patch for now and later we can debug the issue.

Just FYI for the involved people - I've noq applied this directly to my tree.

                 Linus
