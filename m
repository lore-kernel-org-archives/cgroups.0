From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] jump_label: make static_key_enabled() work on
 static_key_true/false types too
Date: Thu, 17 Sep 2015 11:27:52 -0400
Message-ID: <20150917152752.GD7205@mtj.duckdns.org>
References: <1442368285-16306-1-git-send-email-tj@kernel.org>
 <1442368285-16306-2-git-send-email-tj@kernel.org>
 <20150917085957.GI3816@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vcouzAvVbr1Rx+8YEOHdo2qkuoLkoIcLT31S86iSVfw=;
        b=WhpBvK9mr+A3bR8QFUqmm1qvYyRROAIeUFSLSXyF6FO+AzRkdfLMX2B5QEYV+i9+Kl
         LETnqvNqEDoG9IaeqlZ+RwWX7CdycA+AUMXHl29vFfLu2fCyWl5yqx+QbfMT+Ckp5fw+
         dM3DGRSnRBKrXgeUYZ4ZSXIpXUc+0GQxH9ES0Owyky6JRAnbtk678SVVVwQ58253GDCg
         ipwcxVwMxstGSGKD/ZerYDYwcBYPMas6KXM+34+YOlkX6f1uQ7Ng+cu6rTVFENGzENeT
         BtOOMLqkOsuPVh5fFqCP5DYEaYNq6MFlNhoztEcdEMsTWJ/tmnF4dt5WsxnexsGLjB9o
         ZyVw==
Content-Disposition: inline
In-Reply-To: <20150917085957.GI3816-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Sep 17, 2015 at 10:59:57AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 15, 2015 at 09:51:22PM -0400, Tejun Heo wrote:
> > static_key_enabled() can be used on struct static_key but not on its
> > wrapper types static_key_true and static_key_false.  The function is
> > useful for debugging and management of static keys.  Update it so that
> > it can be used for the wrapper types too.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > ---
> > Hello,
> > 
> > If this patch is acceptable, please let me know how it should be
> > routed.
> > 
> 
> Yeah, no problem with this, I'm assuming there's dependencies in the
> patches you didn't send me? 

Yeap, later patches add static_keys for testing whether a controller
is enabled and whether it's on the new or old hierarchy and management
path in cgroup core needs to index the keys and test them.

Thanks.

-- 
tejun
