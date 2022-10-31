From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Mon, 31 Oct 2022 07:57:05 -1000
Message-ID: <Y2AMcSPAJpj6obSA@slm.duckdns.org>
References: <20221031114520.10518-1-jirislaby@kernel.org>
 <Y1++fLJXkeZgtXR2@infradead.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oc04HoeSDvyZ00MBhetf0mLZqQi+t7KUCqjcURmh3jw=;
        b=jQlWLfja+D7d4A9Ytn7AA5c2SFo8aoOuU1Y/iuH5dqmpB7L2WpenUoZwgEhkhQJKpM
         rmfidvSjKdJu39KNzdOvPi5sCF8O3MWHCDs+6scuYyxo677vuN9UcAc9j0cmrfZq8tu+
         MU/ZdmUHZEI0Z2QO4hVcdxRZ1N5BKiBmDu76ViwKpVab6tl09FkylvVAUSKVy9Tk49aH
         LK2lixcaFn8/QVi7vPwHU2Pb9W7L337sd/G+3AbwRvRrhZKfstcL+/4mKhXg5il/n0tv
         cvhEfobQr07ErMCtNF4yNklmm2lTTJSEs6I+ishnlXDxpR7BhssFcyYDyBpjXEkK0u/a
         yZCQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <Y1++fLJXkeZgtXR2@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>, linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

On Mon, Oct 31, 2022 at 05:24:28AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 31, 2022 at 12:45:20PM +0100, Jiri Slaby (SUSE) wrote:
> > Cast the enum members to int when printing them.
> > 
> > Alternatively, we can cast them to ulong (to silence gcc < 12) and use %lu.
> > Alternatively, we can move VTIME_PER_SEC away from the enum.
> 
> Yes, either split the enum or just use a define.  But casts are a big
> code smell and should be avoided if there is a reasonable alternative.

enums are so much better for debugging and other instrumentation stuff. The
only requirement for the enum types is that they're big enough to express
all the members and we can use whatever printf format letter which matches
the type in use. The problem here is that the compiler behavior is different
depending on the compiler version, which kinda sucks.

I suppose the most reasonable thing to do here is just splitting them into
separate enum definitions. Does anyone know how this behavior change came to
be? Do we know whether clang is gonna be changed the same way?

Thanks.

-- 
tejun
