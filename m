From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix wrong unlock order when parse per blkg
 config
Date: Fri, 28 Apr 2017 17:22:33 -0400
Message-ID: <20170428212233.GE22354@htj.duckdns.org>
References: <be8d9709-84fe-d2df-f294-a12701675e27@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zOL4vghtrZRyI0a2sVomafH9e/Z4+DcqI5nmbxa1PAk=;
        b=fvIZWEn5NpoRx0I0Pp1hkFli4AYULA+nId+5H9c6bhuZHAzAz4IeFD0NT00T8P3Tw+
         9y79CYXg2Z2WMjrxvxMu43+P1LJdgU2V+ZKjyG63aj8u/kOJy49SfVZXexyrchT9SkCG
         jL0Ubzm5UZCP3oeJkpntwNMiRDWYwPMLRX3nXAWCD6l/QtRsCEy+tz3HT4X6T+4MroP0
         AkABg2eSpeYhnriBh7BwbKNF3BaSzzy24V5WFMMg4at3k1UooWVX4rhE/P/UAZWKC3Oh
         OD4jKvLw8B85D+76k3YunjJyLW2HSixoA0APkZ0IDbJfUw+Zl1jGpu2V90P7mChP1WWS
         I13Q==
Content-Disposition: inline
In-Reply-To: <be8d9709-84fe-d2df-f294-a12701675e27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <jiangqi903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wenqing.lz-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, boyu.mt-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, qijiang.qj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org

Hello,

On Mon, Apr 24, 2017 at 06:52:05PM +0800, Joseph Qi wrote:
> From: Joseph Qi <qijiang.qj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
> 
> In case of error blkg in blkg_conf_prep, we should unlock
> queue->queue_lock first and then rcu, just like blkg_conf_finish.

I get that this is inconsistent but why is this wrong?  If this is for
consistency, can you please explain so in the commit so that people
don't confuse it for an actual bug fix?

Thanks.

-- 
tejun
