From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/7] blk-throtl: don't throttle the same IO multiple times
Date: Mon, 13 Nov 2017 03:13:48 -0800
Message-ID: <20171113111348.GF983427@devbig577.frc2.facebook.com>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-8-tj@kernel.org>
 <20171113040716.kaheegc4qub42n6z@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FwfZE+a+7GeejoKdhEXJiuxfGRMoHHJwcYYdGnHzxtQ=;
        b=KwnFXUpTG5auFhqDoR5doerU4+jMMF24EmG3+lOTfBcSixcUPwoZdBjzjRiQKiyRB2
         kEIF8ZVm+8dBnlMApVcBpGmiaDjBZzenD4ViuNTNiZH0D/vwvfW5o1awYow1BgAxhK7h
         JkalzmxE92D/Ttrb+/A/V7k2sezoCzPYHbX44mvheOBcgG7hak8foOgYviZO1KbLMNXv
         J8PKUFEyzj1gBdxHBRaMFkSQNsMBz7+e32I6qW/3pOCM9Kgm6R7u6d1mZXTGxE2VWHRZ
         GVTz8ldEmuoaZhbVbtvb9w0dY+o9JxAF11Z0DqXvi4L/AInKzmh9KeJrF2JfOP3NYX3y
         pnJg==
Content-Disposition: inline
In-Reply-To: <20171113040716.kaheegc4qub42n6z-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello, Shaohua.

On Sun, Nov 12, 2017 at 08:07:16PM -0800, Shaohua Li wrote:
> Thanks for looking into this while I was absence. I don't understand how this
> works. Assume a bio will be splitted into 2 small bios. In
> generic_make_request, we charge the whole bio. 'q->make_request_fn' will
> dispatch the first small bio, and call generic_make_request for the second
> small bio. Then generic_make_request charge the second small bio and we add the
> second small bio to current->bio_list[0] (please check the order). In above

You're right.  If we wanna take this approach, we need to keep the
throttled flag while cloning.  The clearing part is still correct tho.
Without that, I get 1/4 bw limit enforced.  Hmm... I'm not quite sure
where that 1/4 is coming from tho.  Will investigate more.

> code the patch changed, we pop the second small bio and set BIO_THROTTLED for
> it. But this is already too late, because generic_make_request already charged
> the second small bio.
> 
> Did you look at my original patch
> (https://marc.info/?l=linux-block&m=150791825327628&w=2), anything wrong?

That should work too but if we have to modify clone path anyway and
clear the flag when the bio leaves the queue, we don't need to add a
dedicated field to bio, right?

Thanks.

-- 
tejun
