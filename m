From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcg: Use struct_size() helper in kzalloc()
Date: Thu, 16 Dec 2021 12:26:36 +0100
Message-ID: <YbsibBdUFhWGzojj@cmpxchg.org>
References: <20211216022024.127375-1-wangweiyang2@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/iZFXBIyAByjsB3GJFOohpxukrwP21FfjWMfhDCvudw=;
        b=HIFde9vm8ylWeo3wONyehTRk81AyUekFbi0/8yqHcpmod9HnZdEpAT/FBJji59SFX8
         5e5GEUQIRNkhnazvrypRzsK+RAOoeiQYmhp+ZiYTpV6w0LIr1Gcs3NeFUMauAIoclYzv
         deXwqUJdxLOXuo37MFxpUrmTvJPXXTDL0fZgUCsuH65oYC86R7pgwBYiPjFO6Y9gw8eI
         9y5cgTai9OwH3lIO6k/EF/2XTRAmgcmilhvufm946Kc6Fasc5pFO2BvILQg8+S0qdzqg
         dt1J8hEqCz4JyKOrCeWbn3lBgdW3asfPdLB21m5bzScu4ne46qzh+tnIFaVLsSUyUh6X
         HPKw==
Content-Disposition: inline
In-Reply-To: <20211216022024.127375-1-wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Dec 16, 2021 at 10:20:24AM +0800, Wang Weiyang wrote:
> Make use of the struct_size() helper instead of an open-coded version, in
> order to avoid any potential type mistakes or integer overflows that, in
> the worst scenario, could lead to heap overflows.
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
