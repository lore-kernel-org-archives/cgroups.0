From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Thu, 12 Mar 2020 14:03:46 -0700
Message-ID: <CALvZod6TxCGiJbPo-4R_qXC7OqWS0LgRRWZwvbaPbWMDRyt0Zg@mail.gmail.com>
References: <20200312200317.31736-1-dxu@dxuuu.xyz> <20200312200317.31736-2-dxu@dxuuu.xyz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XGC2JJk9vuAk10qDqdB2GLLddE8al5n+2YMC135z7/8=;
        b=MFTyMtEC8VknjT1M8lTiyfKxTFtMZJGkKIC0Q3oqOBDGa3g7UxELEJgqZr7dTBhnIG
         ixxjSyj0q8phoYnlMZJjGME2GUQgh5pAAf63BjeJByJJ4nZMO2g6msnLMwkVnTSld628
         vXs1tw38JrliwAzoTQUwm3ZeVer/mVXmouFDIIUPlCeQb2Nnr2ECpnwVzd8Jffnq847L
         QiNrse6GGv2M8iuU1adL+6yqgUds3KlBE9zfU7rjhCZkAWZ684caGPSNeM+QM5CCAgI5
         LkUHNmV2YZhICiXf1Xvd3CowoD/bfyFvW7OM0jlAFTbwuSoxJyiwC8MhcFET48g1KhFy
         su1Q==
In-Reply-To: <20200312200317.31736-2-dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Thu, Mar 12, 2020 at 1:03 PM Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org> wrote:
>
> xattr values have a 64k maximum size. This can result in an order 4
> kmalloc request which can be difficult to fulfill. Since xattrs do not
> need physically contiguous memory, we can switch to kvmalloc and not
> have to worry about higher order allocations failing.
>
> Signed-off-by: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
