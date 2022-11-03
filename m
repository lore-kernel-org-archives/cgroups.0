From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Simplify code in css_set_move_task
Date: Wed, 2 Nov 2022 16:31:33 -1000
Message-ID: <Y2MoBeJGU1Exg6cX@slm.duckdns.org>
References: <20221020074701.84326-1-haifeng.xu@shopee.com>
 <20221027080558.GA23269@blackbody.suse.cz>
 <adb7418c-39a2-6202-970a-a039ad8201dd@shopee.com>
 <20221031131140.GC27841@blackbody.suse.cz>
 <25f6a188-4cc6-dace-1468-fd5645711515@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cWur7HMVd8Ke8GikOufYnkHwwFXOwHuL2p1d2EaRZQ4=;
        b=LHg0QvuIyTZaP2L3VKH46Q9HpSocgocqW64wr5w9rN7A1/45tQRuzDepB3CuHT0ewX
         rf5d45xvbFIIurHHUmIN783brPGJl/6JAIj9Vqtmb+f/i+2TSwFnRwe6vvhdHvkdVDdg
         fsUyyhAM43SrXN5uTLLssApnXPbw+YhBQhSKdhD6faQG8mwhlJUNjvBjNXch7g0O3/yA
         W+EZ+Vu6dwPlKBhGkJDOidgUKpCnwNfuAp3Jgh35C6rCVO8NY4GW1PRi3dCgI39VP3DR
         OrFLnuaW1R2a24OoNBABG+uQqHtxZkBN6EwP0zq+SuvGQqgor/p446gJtzbBjOJCHVIs
         RdrQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <25f6a188-4cc6-dace-1468-fd5645711515-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 03, 2022 at 10:13:22AM +0800, Haifeng Xu wrote:
> I understand your worries. Can I just check the populated state of
> css_set in 'css_set_update_populated' and don't change the order any
> more? I think it can also streamline 'css_set_move_task' a bit.

FWIW, I don't see much value in the proposed change. The resulting code
isn't better in any noticeable way. Even if the change were straightforward,
the value of the patch would seem questionable. There's no point in creating
code churns like this. Nothing is improved in any material way while
creating completely unnecessary risk for subtle breakages.

Thanks.

-- 
tejun
