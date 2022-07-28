From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND v6 4/8] blk-throttle: fix io hung due to config
 updates
Date: Thu, 28 Jul 2022 06:55:33 -1000
Message-ID: <YuK/hXnFA+qu5EMB@slm.duckdns.org>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-5-yukuai1@huaweicloud.com>
 <YuGGVxdlOVk/eF2l@slm.duckdns.org>
 <20220728093346.GA2281@blackbody.suse.cz>
 <0bbf3d0c-88c4-8120-3df3-960dda041864@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=/v3Gcn+hTL0SOyI/tztq8lNP5D0RrTqazuF4o/1KF3k=;
        b=KhZWRDXn2xsiTaRpuC25WJC2oEAedK39KKmcClr8IAYxJKLTnKimRaDfLzkdZcQN0O
         yhKQ1DOrbZYICCUCx7cFxq0fQbI3q/V/4/IcFYnleE9gemq31ZU9e+Vf8sryx0qKVHu0
         taudKvAkkTIflxzG55p9RIeN1ji5KjqbvTr8wRNt6/ybqVSm9CLEIHsh0B6c3nrqeJkb
         kz2oJruSwXOeZdvyOieGQotwUPsfmJWgVM38LrcLHIVXo0UQdqgPLqOhyf9ErM1VP0Mq
         kyD9+JIyR7g/q/CNR7jAn/+uArIZcSFGqY3L0dUPjQBvffcMuHTqB9eMgI79oKVC8wSH
         /R1Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <0bbf3d0c-88c4-8120-3df3-960dda041864@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On Thu, Jul 28, 2022 at 06:34:44PM +0800, Yu Kuai wrote:
> Hi
> 
> 在 2022/07/28 17:33, Michal Koutný 写道:
> > On Wed, Jul 27, 2022 at 08:39:19AM -1000, Tejun Heo <tj@kernel.org> wrote:
> > > I'm not quiet sure this is correct. What if the limit keeps changing across
> > > different values? Then we'd be calculating the skipped amount based on the
> > > last configuration only which would be incorrect.
> > 
> > When one change of configuration is correct, then all changes must be
> > correct by induction. It's sufficient to take into account only the one
> > old config and the new one.
> > 
> > This __tg_update_skipped() calculates bytes_skipped with the limit
> > before the change and bytes_skipped are used (divided by) the new limit
> > in tg_with_in_bps_limit().
> > The accumulation of bytes_skipped across multiple changes (until slice
> > properly ends) is proportional to how bytes_allowed would grow over
> > time.
> > That's why I find this correct (I admit I had to look back into my
> > notes when this was first discussed).
> > 
> > HTH,
> > Michal
> > 
> 
> Hi, Tejun
> 
> Michal already explain it very well, please let me know if you still
> thinks there are better ways.

Ah, I see, so it's integrating into the skipped counters across multiple
updates. I think it can definitely use comments explaining how it's working
but that looks okay.

Thanks.

-- 
tejun
