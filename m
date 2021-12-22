From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Use after free with BFQ and cgroups
Date: Wed, 22 Dec 2021 16:21:03 +0100
Message-ID: <20211222152103.GF685@quack2.suse.cz>
References: <20211125172809.GC19572@quack2.suse.cz>
 <20211126144724.GA31093@blackbody.suse.cz>
 <20211129171115.GC29512@quack2.suse.cz>
 <f03b2b1c-808a-c657-327d-03165b988e7d@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640186464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R2sITC9btmJiDozWSszdfDjZ963CmDEzfUkTeAu2sDA=;
        b=lSydeBHpVZNddXzbAHVcSnrorz4RUGeFU9TcqTystRoY8fF+TifMIFhPIbsaOAgxucV4jH
        zByyb3oanWZ2gfcPt92euWMf29KSEzeuCqXI6nDgizZMzcW4ceOYs5GsEQ0DzspIlFnyqf
        n4sZ65IcXVyMyQKC/vMKEDCme6BoN5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640186464;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R2sITC9btmJiDozWSszdfDjZ963CmDEzfUkTeAu2sDA=;
        b=xhFZ8ktwWymeyjzUUyYj7R5bM5dB3ZApam1ek0CcfrhdfzMc9J977sTd3qNZWCMtqfvUsi
        irLLy6oQ51UHRECQ==
Content-Disposition: inline
In-Reply-To: <f03b2b1c-808a-c657-327d-03165b988e7d-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fvogt-l3A5Bk7waGM@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 09-12-21 10:23:33, yukuai (C) wrote:
> We confirmed this by our reproducer through a simple patch:
> stop merging bfq_queues if their parents are different.

Can you please share your reproducer? I have prepared some patches which
I'd like to verify before posting... Thanks!

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
