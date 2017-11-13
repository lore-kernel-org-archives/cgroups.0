From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/7] blk-throtl: don't throttle the same IO multiple times
Date: Mon, 13 Nov 2017 07:57:45 -0800
Message-ID: <20171113155745.GI983427@devbig577.frc2.facebook.com>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-8-tj@kernel.org>
 <20171113040716.kaheegc4qub42n6z@kernel.org>
 <20171113111348.GF983427@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=axC+XJqglORw7X/Yvz7EUTTUPfHwZcwzbjdp7hLj1dY=;
        b=Jd14Qrvkcl8vdL+PMJ5/f+UXteHP6qTkmxK7KeV5mtGI2r4WjjXov7kfQkvXnm0Ul1
         ssFAQyuJamc3FkmSr22tYiGnemlvriIrgCWy5yW/LzMN6BfIQSJT0gg48/pUoJMX1/fi
         OgUeVDYDJtgYrpuJm3XfcaZcoOhrA/76pEf21wu7jpTp1zuULdtunwemF8H/EyuiumnH
         LY/YzJCkDvFvymu+GfEu4ou1TXL4R46+hofvtpkjq7aCTRMtvzSeRM3anXEEUqeDM3kf
         fYvZQ51SYMoOr1vU48SHvzNy+dxeWPtdU/cBPRK/ltXSWONxbAc1EQfJFPDs2+Q+rx6Q
         FK2w==
Content-Disposition: inline
In-Reply-To: <20171113111348.GF983427-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

On Mon, Nov 13, 2017 at 03:13:48AM -0800, Tejun Heo wrote:
> You're right.  If we wanna take this approach, we need to keep the
> throttled flag while cloning.  The clearing part is still correct tho.
> Without that, I get 1/4 bw limit enforced.  Hmm... I'm not quite sure
> where that 1/4 is coming from tho.  Will investigate more.

Okay, this is because when we spiit, the split bio is the first part
which gets issued and then the orignal bio is wound forward and
requeued.  So, for the splits, the original bio is the one which gets
trimmed in the front and requeued, so not clearing BIO_THROTTLED is
enough.  I think we should still copy BIO_THROTTLED on clones so that
we don't get suprises w/ other bio drivers.

Thanks.

-- 
tejun
