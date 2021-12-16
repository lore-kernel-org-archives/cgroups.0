From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcg: Use struct_size() helper in kzalloc()
Date: Thu, 16 Dec 2021 17:44:38 +0800
Message-ID: <CAMZfGtUBSqgnHM+DSG7na=7tbNMyj_qS8pEOCn9nDdkPEzi-4g@mail.gmail.com>
References: <20211216022024.127375-1-wangweiyang2@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1MFole7nFko6XzmDNfgE5E+/1W8AedAM5ImSr4t3Mo=;
        b=nsmQ/apsKdQztyc0yc5tiUuptN+9XlsBEAr0qz+gI5SZ+IV3uSUUFj52fE9YbQVI8n
         SMbjtHrTJA6hukMVpoe9h0y6Rmfyrl+OHG/iOHic+VH5G02tOBfDdwGMpC7FfUrBGTu3
         8XpRGgzs7x86Dl8C0S2EHzI480i8bV0jQS8+RviV1BOSx6kp/P/aMy3Hx325lxQFnmHw
         X0cG1oWo6GktwZFd78AaZBgbbhnACTQenYXojWdQRhiJtzNFPn30D0eC0JI1ooH1p6wQ
         p1NWPJE7pjmTIGoCX0RY9/cuWQjZRO11Ex/D2pnSThLbuR6dO5PA2wjt+xORpiYjw6W8
         bveg==
In-Reply-To: <20211216022024.127375-1-wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Dec 16, 2021 at 10:21 AM Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> Make use of the struct_size() helper instead of an open-coded version, in
> order to avoid any potential type mistakes or integer overflows that, in
> the worst scenario, could lead to heap overflows.
>
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
