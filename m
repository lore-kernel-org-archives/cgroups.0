From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Zero sized write should be no-op
Date: Wed, 30 Sep 2020 13:49:52 -0400
Message-ID: <20200930174952.GG4441@mtj.duckdns.org>
References: <20200928131013.3816044-1-jouni.roivas@tuxera.com>
 <20200930160357.GA25838@blackbody.suse.cz>
 <20200930160619.GE4441@mtj.duckdns.org>
 <20200930163435.GB304403@tuxera.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vyr+bGNQ+ADwyxSKdcsVjSMXuNPRYBC2cBmRunOjdbs=;
        b=dnsurlXcEPeVFg0ocM0daUICy4W99fJqZzyAjbhM4+EC7IJsPDhfZo/+7MbO6qdKHk
         TaRoaPtLNOWRr/HDuktJDe7ldBOJk8BCSuHDsU4ggHkKu8aj7KKJvYU2q9fHICAItYh7
         4zEN8xGnWOeSAbHWWNW2OpJ/B4ZsDT/RV73sZNfW8IUwm8bpac4W6+gEOilF025egx76
         XbWleLvZ23pPyJaBoGv3pASIiz6fu5+XxxCZ2WJpbkvw5ZqpVs3iBrw16BOW8rO8PM5g
         ctbBu3DLCBnBkihzduZNHpSVZ/y6STrzqVIxKy2RtLoJUe+WoxqOjiuRbIRKt9BGLrBU
         OPaA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200930163435.GB304403-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Sep 30, 2020 at 07:34:35PM +0300, Jouni Roivas wrote:
> > So, I'm not necessarily against the change, mostly in the spirit of "why
> > not?".
> 
> There's actual user space application failing because of this. Of course
> can to fix the app, but think it's better to fix kernel as well. At
> least prevents possible similar failures in future.

Just for the record, none of these pseudo interface files are expected to
behave like real files. The supported usage pattern is - open, read with
sufficentily large buffer till EOF and then close, or open, write the
content in one go and close. There are some exceptions and we add
convenience features when the cost is low enough but beyond the core usage
pattern the boundary between what's supported and not is pretty mushy.

Thanks.

-- 
tejun
