From: 'Tejun Heo' <tj@kernel.org>
Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Mon, 12 Dec 2022 11:46:59 -1000
Message-ID: <Y5ehU524daymEKgf@slm.duckdns.org>
References: <20221031114520.10518-1-jirislaby@kernel.org>
 <Y1++fLJXkeZgtXR2@infradead.org>
 <Y2AMcSPAJpj6obSA@slm.duckdns.org>
 <d833ad15-f458-d43d-cab7-de62ff54a939@kernel.org>
 <Y2FNa4bGhJoevRKT@slm.duckdns.org>
 <2b975ee3117e45aaa7882203cf9a4db8@AcuMS.aculab.com>
 <Y2Kaghnu/sPvl0+g@slm.duckdns.org>
 <Y2KePvYRRMOrqzOe@slm.duckdns.org>
 <320c939e-a3f0-1b1e-77e4-f3ecca00465d@kernel.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6qiAQ7WTwZr4dVTtMKJayehUb8HIRKe6ZlI8Mkp+Y78=;
        b=bQdgiHkGAhLziF8YrE6lY1CbCjAd+Q93tt3s7B8OuQurw+fBLJSpXapeoQaWoGZaCu
         pW23g/hLxu3YE+Ri3icoxByE0NpQbPuYRKm0O44+zvDAKNWI4dZPRINx9W16HsUoSdCB
         mDygSc6MDZPTYGJWHfRTLiZugJJLsljMh9rjcxrw5rIm3xd4N2+rOrwUJVhkj4WFAt9O
         ps7VSjNuawEnABvIeNBm++nfKVPatwvO+Yt/cH+xxUCqdqlwTio2ARN+cmMZ3TnCRgL8
         HMNsEYRtDBw2k4+p9EeEBSbg9SZxYykoFL4ShGXYiCZ683mFThj8DLxwmff6vHfGqwzS
         q1uA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <320c939e-a3f0-1b1e-77e4-f3ecca00465d@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jirislaby@kernel.org>
Cc: David Laight <David.Laight@aculab.com>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Martin Liska <mliska@suse.cz>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On Mon, Dec 12, 2022 at 01:14:31PM +0100, Jiri Slaby wrote:
> > If so, my suggestion is just sticking with the old behavior until we switch
> > to --std=g2x and then make one time adjustment at that point.
> 
> So is the enum split OK under these circumstances?

Oh man, it's kinda crazy that the compiler is changing in a way that the
same piece of code can't be compiled the same way across two adjoining
versions of the same compiler. But, yeah, if that's what gcc is gonna do and
splitting enums is the only way to be okay across the compiler versions,
there isn't any other choice we can make.

Thanks.

-- 
tejun
