From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.8] cgroup: allow NULL return from
 ss->css_alloc()
Date: Tue, 21 Jun 2016 14:57:40 -0400
Message-ID: <20160621185740.GR3262@mtj.duckdns.org>
References: <20160621170624.GK3262@mtj.duckdns.org>
 <20160621181404.GB4501@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dh9PdorzZzI1ykWPga6mhdeiybTdX7Kb8h+n77qU7+k=;
        b=dyn0qaxUX7jPoYerJ06MWpOOCoP5Isa/b/stekwEC5hiNHbWgiYTbSOs/WUalDd+FF
         qKNe87/tBJPAoAI4NhUaNwf51vlWtIUKW1tnnwzri9tkVQfEBgQ9RTtqp3lQZ3tTj6o0
         hAsB+eo87jZW+kiRRY5bsv7VbfttH1E+UtLr3bhlOLylxYwrnAoWAXs2SUblDwbwVnYn
         hnlAnmPq4i2OPttx5tHLxleSWw8KZ1PGNfYO63zuWFBPGNYDC+Gx5FSvO20mMQY8wcbo
         LiOoveqJtpBw2lGr8RNGZq54H9B1EiiTreaPTtxrVukDbhXZLRk9hgtRxruwVfn6J0Ic
         78Lg==
Content-Disposition: inline
In-Reply-To: <20160621181404.GB4501-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Tue, Jun 21, 2016 at 02:14:04PM -0400, Johannes Weiner wrote:
> Would it be better to remove the error code instead and have everybody
> return NULL? AFAICS, everybody is returning either the object or the
> -ENOMEM error code right now.
> 
> What error condition is there for an allocation function?

I already changed cgroup core to interpret NULL return as -ENOMEM.
Maybe we can drop ERR_PTR handling altogether in the future but I'm
not sure.  e.g. memcg's id allocation and -ENOSPC check could be in
css_alloc.  The thing is css_online is only necessary if there are
requirements around css id or iteration, so css_alloc can easily be
the only alloc / init point and thus should be able to indicate
different failure conditions.

Thanks.

-- 
tejun
