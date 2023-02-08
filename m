From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Wed, 8 Feb 2023 14:43:45 +0100
Message-ID: <20230208134345.77bdep3kzp52haxu@quack3>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
 <8c068af3-7199-11cf-5c69-a523c7c22d9a@acm.org>
 <4f7dcb3e-2d5a-cae3-0e1c-a82bcc3d2217@huaweicloud.com>
 <b6b3c498-e90b-7d1f-6ad5-a31334e433ae@acm.org>
 <beb7782e-72a4-c350-3750-23a767c88753@huaweicloud.com>
 <aedc240d-7c9e-248a-52d2-c9775f3e8ca1@acm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1675863826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WXjM/s4PhtaTVW4aiVsTAUAHDUvK2wieBkKbPD6AkWk=;
        b=2D010aeo1gILwXKexBL/H6YeET0ts/vT4M7BCnWuKvynMFw5ep7OJ0Xa25MaH/hW5tWE1+
        xa+9zp/k13p2fvffFznXRS+HNe8kUteOBo0xNsodoVXkiaeo4cU3FYezFAf/GWmkQtOF8Z
        UIhQ36DDm0ysHsF12At4bZ6c/bpL/hI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1675863826;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WXjM/s4PhtaTVW4aiVsTAUAHDUvK2wieBkKbPD6AkWk=;
        b=HYuwSpnsyaTUN5uRxgrezcT+Rs0EYLoKxKybHs0UMdQxjwcVFJPGjarxi1zBkQ9ciulsX7
        2Ek8luOYzvi3URBQ==
Content-Disposition: inline
In-Reply-To: <aedc240d-7c9e-248a-52d2-c9775f3e8ca1-HInyCGIudOg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Hou Tao <houtao-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri 03-02-23 11:45:32, Bart Van Assche wrote:
> On 2/2/23 17:48, Hou Tao wrote:
> > I don't get it on how to remove IOPRIO_POL_PROMOTION when calculating the final
> > ioprio for bio. IOPRIO_POL_PROMOTION is not used for IOPRIO_CLASS values but
> > used to determinate on how to calculate the final ioprio for bio: choosing the
> > maximum or minimum between blkcg ioprio and original bio bi_ioprio.
> 
> Do the block layer code changes shown below implement the functionality
> that you need?

Just one question guys: So with my a78418e6a04c ("block: Always initialize
bio IO priority on submit") none-to-rt policy became effectively a noop as
Hou properly noticed. Are we aware of any users that were broken by this?
Shouldn't we rather fix the code so that none-to-rt starts to operate
correctly again? Or maybe change the none-to-rt meaning to be actually
promote-to-rt?

I have to admit I'm wondering a bit what was the intended usecase behind
the introduction of none-to-rt policy. Can someone elaborate? promote-to-rt 
makes some sense to me - we have a priviledged cgroup we want to provide
low latency access to IO but none-to-rt just does not make much sense to
me...

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
