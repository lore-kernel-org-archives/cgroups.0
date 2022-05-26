From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] psi: dont alloc memory for psi by default
Date: Thu, 26 May 2022 08:54:59 -1000
Message-ID: <Yo/NAytP6mnmeW2M@slm.duckdns.org>
References: <20220526122656.256274-1-chenwandun@huawei.com>
 <Yo+mXVefsRSxjTMY@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JdImCzgSPz0H+mIzVDv7OFJ66SmMuOrOg3W+mTgl2b8=;
        b=iyo4DkmN0bT2b6K66vlwNX8B0+jYAq4KpN+s1rvNcR6rzI68koNDIx7pAfkXhb9yPp
         TBZ3zkWl4mgRPOi7Cqc7gKvXu/8HNeQpxnxnY+mjwWqbFI+B/mV8WKWDWdNPLe1xNzix
         ZQNTk2uaN+a4ZPNPSH3SOmTbm6OJTOK24u1x+/0alfhkxLHzOXWZrDf+yrltDPwhayMu
         y5vrXBezGsB26WB2ivlwNSuXP08LsF7yTLW9+zxXlJ0MbwOVY+H3LyPuf+VF/4POoHRu
         8OMZpNMvCITCIJ3qV1bIMAZCUY8O2eSx5+NlqQNqjkmMM+1wmGOMiUVNZk7hJYFKV5iQ
         fJtA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Yo+mXVefsRSxjTMY-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 26, 2022 at 12:10:05PM -0400, Johannes Weiner wrote:
> On Thu, May 26, 2022 at 08:26:56PM +0800, Chen Wandun wrote:
> > Memory about struct psi_group is allocated by default for
> > each cgroup even if psi_disabled is true, in this case, these
> > allocated memory is waste, so alloc memory for struct psi_group
> > only when psi_disabled is false.
> > 
> > Signed-off-by: Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Looks good to me,
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Tejun, would you mind taking this through the cgroup tree?

Will do once rc1 drops.

Thanks.

-- 
tejun
