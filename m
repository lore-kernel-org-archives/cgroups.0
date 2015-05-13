From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 1/4] cgroups: use bitmask to filter for_each_subsys
Date: Wed, 13 May 2015 09:50:00 -0400
Message-ID: <20150513135000.GP11388@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-2-git-send-email-cyphar@cyphar.com>
 <20150422152551.GA10738@htj.duckdns.org>
 <20150422154212.GE3007@worktop.Skamania.guest>
 <20150422160258.GE10738@htj.duckdns.org>
 <CAOviyagvVTKjRp4wxyNo4Oke-w=Wbda+UyHAN-ih9yFX-8jqmw@mail.gmail.com>
 <20150426160909.GC1499@htj.duckdns.org>
 <CAOviyah2kjtaRBFRcd3cAb1DeYX11Ks_KVfwXPMXK5BENSqOiA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NFDSs8CjUOMsGoYP42zs6jl8wvWS/53nnysFH4HCYoQ=;
        b=qGBMAIQBSeE0Bw05tQ8s+nJdcEMkRdUZrJVf85TxYi7ts2JymWK9CAFk7DaL4aHGJT
         HTTgWLKe4YEBgF8sm/lLqx6kk91aVv8DE0FnnzsLDvPGwu8BY8k6xOXAtXvPa/YoOnAj
         DGImk+ldF8DSayi5gFB6Evxwdo8qtU3rzjOGRld2Q3DqgQqmrB6Mqob6ZGkAjYxtHtSP
         l+vIJDow+wijls4sYCeNVe7FcykVZIiT+AaX7g8a5IEfOrxLWf2tsJPf6bDNa++uo5oA
         3Gav1ZM66gh+1v5+WCfALtF3qo670U4IAYy9cF6KMmNUw192fkK2jkxbLGq139yd4lG/
         wXXA==
Content-Disposition: inline
In-Reply-To: <CAOviyah2kjtaRBFRcd3cAb1DeYX11Ks_KVfwXPMXK5BENSqOiA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hello, Aleksa.

On Wed, May 13, 2015 at 03:44:51PM +1000, Aleksa Sarai wrote:
> I think I'll just do casting and manually make new variables where
> required. The above (and similar) doesn't work very well, generates
> warnings like crazy and breaks stuff like:
>
>     if (...)
>         for_each_subsys_which(...)

Ah, right, and we can't wrap the declaration in a new block.  I'm okay
with converting ss_masks to unsigned longs if necessary.  Just do a
wholesale conversion.

Thanks.

-- 
tejun
