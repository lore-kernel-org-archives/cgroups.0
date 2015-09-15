From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] memcg: ratify and consolidate over-charge handling
Date: Tue, 15 Sep 2015 11:50:02 -0400
Message-ID: <20150915155002.GF2905@mtj.duckdns.org>
References: <20150913201416.GC25369@htj.duckdns.org>
 <20150913201442.GD25369@htj.duckdns.org>
 <20150914193225.GA26273@dhcp22.suse.cz>
 <20150914195608.GF25369@htj.duckdns.org>
 <20150915080110.GA14532@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rLl4g514Bt5NQqHeOkqKHZKhH6VvtqKP9l5y2Trmj6o=;
        b=mEX2/QhKjUP9NXCab78I41drbAyHJ/hlM2kwT6UgG+3j1BtUB/wHPDxlBdpUwBo6My
         9+UcitnIttzL67MVmn+OOwrHqKSAYKEDPzsvqNOqd9yPvgh+RLQRjKc4zOFwss1xPYfY
         La43KPUHMrrUO/gBYyDUXbpMCjQxWrdguH3WhgRrD+Y6Y8DJ/JWyGEz6R0fePGbAmqhK
         cfdS+duWwD7LiOXT8ud2oTLm4fYOcliU9QFr/NmVMK9oFuyJkGbg79NvJ2BS99+CKh/x
         Cm6IpoweDhToVi5SzMqVJaSk7NuAjbroj4l9snoLbGrCtKZ/T6xCZvmf5mCGLlhkS/q5
         ftvg==
Content-Disposition: inline
In-Reply-To: <20150915080110.GA14532@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, vdavydov@parallels.com, kernel-team@fb.com

Hello, Michal.

On Tue, Sep 15, 2015 at 10:01:10AM +0200, Michal Hocko wrote:
> > > OK the code is easier in the end, although I would argue that try_charge
> > > could return ENOMEM for GFP_NOWAIT instead of overcharging (this would
> > > e.g. allow precharge to bail out earlier). Something for a separate patch I
> > > guess.
> > 
> > Hmm... GFP_NOWAIT is failed unless it also has __GFP_NOFAIL.
> 
> Yes I wasn't clear, sorry, it fails but TIF_MEMDIE or killed/exiting
> context would still overcharge GFP_NOWAIT requests rather than failing
> them. Something for a separate patch though.

Ah, I see.  I'm not sure that'd matter one way or the other tho.

> > I don't even think this is an implementation detail.
> 
> I really think this is an implementation detail because we can force
> the implementation to never overcharge. Just retry indefinitely for

But we actively choose not to and I think that's an architectural
decision.

> I am not sure I understand here. High and max are basically resembling
> watermarks for the global case. Sure max/high can be set independently
> which is not the case for the global case which calculates them from
> min_free_kbytes but why would that matter and make them different?

Yes, there are similarities but if we really wanted to emulate global
case, we'd just have the hardlimit and then have async reclaim to keep
certain level of reserves and so on.

I don't think it'd be meaningful to try to follow the limit strictly
under all circumstances.  It's not like we can track all memory
consumption to begin with.  There always is common consumption which
can't clearly be distributed to specific cgroups which makes literal
strictness rather pointless.  Also, I'm pretty sure there will always
be enough cases where it is saner to temporarily breach the limit in
small scale just because exhaustion of memory inside a cgroup doesn't
mean global exhaustion and that's an inherent characteristic of what
memcg does.

Anyways, I don't think this difference in viewpoints matters that
much.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
