From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 02/18] cgroup_pids: track maximum pids
Date: Mon, 18 Jul 2016 21:09:31 -0400
Message-ID: <20160719010931.GG3078@mtj.duckdns.org>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-3-git-send-email-toiwoton@gmail.com>
 <20160613211227.GG31708@htj.duckdns.org>
 <17cb1a37-47b1-dbd4-6835-efad3cf6c12f@gmail.com>
 <20160613213354.GH31708@htj.duckdns.org>
 <3b03822f-c5d0-5b84-79c3-edeb8e78e2dd@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FnwqBWlsldw4SMmyLSDfrUDaGu6Fu3SabTR6+yAsuwA=;
        b=iViQH8KjlTkoxlL/Asp+/xM8Rci9NNhG4yI4TMIOwkgq/zdDTLGDsHyQi72XidSFlS
         QWaRg9qj1qCZHKDg/DPaOD3QR5gE3HPpHjwWC/Oa06XEKq0f/WpvdGU5V5KfTSEf2KVX
         jfdiMxH1s069+wgLlITih5ImniCkk/ulSy8iu0YNApGpocbVJS+KYmPrBc3GM6HvMMeP
         tKSpGH28elyqJMtI4Q2bZSKLNRbYC7orq22/jVvya+YEOPdMz5tQTzr86vW/svYfyc+1
         +4c94EZHVWWfA3Yva1OyRUzwHekbLS0jRE9DchdbbaFQH4nZBQ3Wnvt0wYuUAP8Dtvdj
         TaEg==
Content-Disposition: inline
In-Reply-To: <3b03822f-c5d0-5b84-79c3-edeb8e78e2dd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Jul 17, 2016 at 08:11:31PM +0000, Topi Miettinen wrote:
> On 06/13/16 21:33, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Jun 13, 2016 at 09:29:32PM +0000, Topi Miettinen wrote:
> >> I used fork callback as I don't want to lower the watermark in all cases
> >> where the charge can be lowered, so I'd update the watermark only when
> >> the fork really happens.
> > 
> > I don't think that would make a noticeable difference.  That's where
> > we decide whether to grant fork or not after all and thus where the
> > actual usage is.
> 
> I tried using only charge functions, but then the result was too low.
> With fork callback, the result was as expected.

Can you please elaborate in more details?

Thanks.

-- 
tejun
