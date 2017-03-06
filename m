From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/19] kernel: convert css_set.refcount from atomic_t to
 refcount_t
Date: Mon, 6 Mar 2017 14:54:39 -0500
Message-ID: <20170306195439.GD19696@htj.duckdns.org>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
 <1487585948-6401-13-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F1g2fMyimtsXk6PNJmfgJthPg1xJ5V5ZBWSwpsZ90Vo=;
        b=j7HNjaRqyOI0c07uHhdRV5RXKSilT0mHdzFx/8BnNX+GTnX/vz9AOXL7FsP8kpapsE
         GMSC2txZ4omDvKdGCWHLxHjGimhx1VtoEXf82SXqdaphNPFxH8Zk98FXEqITsVgoHclt
         eqdF7AdC+j8bsPYmRjfkUHS9fwJGYiZmow5vu0V/17pCs01LT855+POeJedpjVg84cfg
         XKJil1XjR88xN1Sz3zNPy2wdi+Oz5i5ryFfyAtSkSiNK7oaO8VdIw5bOJU9wg/viyrcl
         2r6UW4QkqCy3xCykjLvhZmpKJ4WXdSynU14DQBEHtdcX9FOgHTiuUdLmMU1c8E66Rlm5
         ovVw==
Content-Disposition: inline
In-Reply-To: <1487585948-6401-13-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello,

On Mon, Feb 20, 2017 at 12:19:01PM +0200, Elena Reshetova wrote:
> @@ -134,10 +135,13 @@ static inline void put_css_set(struct css_set *cset)
>  	 * can see it. Similar to atomic_dec_and_lock(), but for an
>  	 * rwlock
>  	 */
> -	if (atomic_add_unless(&cset->refcount, -1, 1))
> +	spin_lock_irqsave(&css_set_lock, flags);
> +	if (refcount_read(&cset->refcount) != 1) {
> +		WARN_ON(refcount_dec_and_test(&cset->refcount));
> +		spin_unlock_irqrestore(&css_set_lock, flags);
>  		return;
> +	}

This isn't an equivalent conversion and should have been mentioned in
the patch description.  Hmm... and I'm not sure this is a good idea.
Can't we add the matching operation on refcount_t rather than adding
extra locking like this?

Thanks.

-- 
tejun
