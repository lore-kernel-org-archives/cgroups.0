From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/10] cgroup: net_cls: Protect access to
 task_cls_classid() when built as module
Date: Fri, 24 Aug 2012 16:26:21 -0700
Message-ID: <20120824232621.GQ21325@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
 <1345816904-21745-4-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mNBWk0u8HCHiuPds0nzerjx/Y+TyypXGXjVAVg02Dvs=;
        b=CxgT9IsYQsKkUI6WG1ZLOO/2MlmIMk+iuGIBrgpoFIYd5pz371CT195KQyY8gCKBjw
         Re5uIvXedvDSSKMnMV18OG9MoDjwp0PQHd2SQSCLi1A4s5UGGXLvjx2mtT72jO5pzu5O
         OoV5eNeFMic4kjIla4F1SWtJ1zop6rBrbR2pENOGDc4wdSTg1QFddIembD/TVNXc1evX
         KDYo7J2W/jJOKxBxCS2pAkXlwkmXvBShLftanmRo+EESSOWhEtJqrK73rgoek37q8zEZ
         lnzLcv7Sp6H8QoDmmeCD54lrKCG3+8MSkjp05AzPfxjWPMXRxhdvAXMm6KOJ2prxxSph
         5s/g==
Content-Disposition: inline
In-Reply-To: <1345816904-21745-4-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Fri, Aug 24, 2012 at 04:01:37PM +0200, Daniel Wagner wrote:
> @@ -306,6 +312,11 @@ static void __exit exit_cgroup_cls(void)
>  	synchronize_rcu();
>  #endif
>  
> +#if IS_MODULE(CONFIG_NET_CLS_CGROUP)
> +	static_key_slow_dec(&cgroup_cls_enabled);
> +	rcu_barrier();

Why is this rcu_barrier() necessary?  In general, please explain what
synchronization is going on when using sync constructs which aren't
obvious - e.g. memory barriers, rcu barriers.

Thanks.

-- 
tejun
