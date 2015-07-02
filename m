From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: TrueCrypt hangs when unmounting disk partition
Date: Thu, 2 Jul 2015 09:19:10 -0400
Message-ID: <20150702131910.GA30677@mtj.duckdns.org>
References: <55950A31.10902@winsoft.pl>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7QEZsKQP/NV3KnRVB5WPdOyNqOVNetO+P2U0uamP2u8=;
        b=qcT8KWVnpg849pF/xd2tJGnRaaH3dUAdM5zqn2HeAyihS4BJJM4C4VGnlVYndXJ/Fb
         YfRZ2EM38EzI6AqUCVTChxU55crI1SKpQr3fOTtQbK2esK3F9CMJ1xUiQGpK63yrsl+m
         avbotf4YGUKTy1U4zwCpbBt3nDPKXQP1ok/fzAGL2Jup+Io4RvhXegdeUf3018NvO3JK
         9TqkHtEl9/RC9mu2yQAz4R47kLKbi8vUvTZ638PufPUlZFmUWIeez/dHjbcjMGuqPWtC
         pknD83JDJmH9lZTnbfg9nVoHiCHSazyJxnKSNbcRq5mAiDuNUuL8LRIPQ/bsMx+0sqdy
         LeGA==
Content-Disposition: inline
In-Reply-To: <55950A31.10902-T7i8u+qs0czVItvQsEIGlw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Krzysztof Kolasa <kkolasa-T7i8u+qs0czVItvQsEIGlw@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Krzysztof.

On Thu, Jul 02, 2015 at 11:53:53AM +0200, Krzysztof Kolasa wrote:
> Kernel next, this is the first bad commit ( after bisect ):
> 
> e4bc13adfd016fc1036838170288b5680d1a98b0
> 
> Merge branch 'for-4.2/writeback' of git://git.kernel.dk/linux-block
> 
> After the command to unmount, partition will be unmounted, truecrypt hangs

Yeah, there's a bug with bdi_writeback_congested handling.  There are
fix patches pending.

  http://lkml.kernel.org/g/20150702005253.GA26440-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org
  http://lkml.kernel.org/g/20150702005337.GB26440-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org

Thanks.

-- 
tejun
