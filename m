From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: clean up if condition in cgroup_pidlist_start()
Date: Mon, 7 Aug 2023 08:30:41 -1000
Message-ID: <ZNE4Ubk44PY14Q6Z@slm.duckdns.org>
References: <20230807115831.3590631-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691433044; x=1692037844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HiHJQXFkmzKNYWpMVVoAzoC6rE61mLRbYTj0PtJL+pQ=;
        b=cuAvFn4RSNs15+vau2intXEcihC436GMRBGQTLwyeQ4LIRe1x1WJQ/ScHRiO6oE1ZR
         n0I0GkqIoFYHyBiiKKlxY3xfxtYcOES418LUmkTy8nom8MHp/NO8HgGPljBH/4ALZXdU
         zDy/pgyvU9SPF5f4GTXElkMV3rgZx4FvE6r06Jl9nBgBCBxMk7gEyv10x4k6j7ckgKQK
         Tz2p8w8Zix44AR/ISXFArXnVged/js6oleSs6o5iEo4on7TIg0YzazRVI9bpYTxJPsJo
         IO7NkJZaHQyAKpH0D8FPMnwgq57w2XlMuv1/ONdMvBAxi7/YebFN3YFpzdyCyaNNzZGv
         1upA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230807115831.3590631-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 07, 2023 at 07:58:31PM +0800, Miaohe Lin wrote:
> There's no need to use '<=' when knowing 'l->list[mid] != pid' already.
> No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
