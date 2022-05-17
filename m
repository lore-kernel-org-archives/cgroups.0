From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next] block: fix io hung of setting throttle limit
 frequently
Date: Mon, 16 May 2022 18:18:44 -1000
Message-ID: <YoMiJIUehq1UyzgQ@slm.duckdns.org>
References: <20220516014429.33723-1-zhangwensheng5@huawei.com>
 <YoKmCOAzwzw3Lz7g@slm.duckdns.org>
 <ca251645-8d52-7a93-6ac2-579d97922a9e@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xf0kL1+XuM7P75yKi5gORiIETclggCfCwYHC9O/komI=;
        b=dGfNWhVuygx3lxtV8htZeLUSrHPK74n/4zuspp12F3Ej9aM1jDUfauaeUEwwflxDd1
         cVfzVfCyiXz6HsQHbH3uqnCyETM0yGfbehqOfgpZjYrkRamWiLEAjUjU/N6XUCAGMwTg
         e46ZvTeAHHkSFMQ3fJwFLWMW7AwEaAJJGbRZdKmJB+TENAhuzW3836VbZX0SLgkxvjQw
         dwvW5/dOX/UeN8Rz/zat7MKgFD1Z3C5YP+RjOmCefWIW+Hfi05TAW6USx06+pNFf9TEl
         SSiNgdWmlpUg386INY5i3wS7xQT1lUyDL2rOcTJJurcX6Q7JtYvwt6mfdCqGBBFKud9e
         euTw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ca251645-8d52-7a93-6ac2-579d97922a9e@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "yukuai (C)" <yukuai3@huawei.com>
Cc: Zhang Wensheng <zhangwensheng5@huawei.com>, "ming.lei@redhat.com >> Ming Lei" <ming.lei@redhat.com>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Tue, May 17, 2022 at 11:12:28AM +0800, yukuai (C) wrote:
> Ming added a condition in tg_with_in_bps_limit():
> -       if (bps_limit == U64_MAX) {
> +       /* no need to throttle if this bio's bytes have been accounted */
> +       if (bps_limit == U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
> 
> Which will let the first throttled bio to be issued immediately once
> the config if updated.
> 
> Do you think this behaviour is OK? If so, we can do the same for
> tg_with_in_iops_limit.

So, the current behavior is that if the user is being silly, it will get
slower and slower. The new behavior would be that if the user is being
silly, it can issue IOs faster and faster, which creates a perverse
incentive to be silly.

Probably the right thing to do is probably something like translating the
existing budget in light of the new configuration so that config change
neither gives or takes away the budget which has already accumulated. That
said, are you guys seeing this becoming an issue in practice?

Thanks.

-- 
tejun
