From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH block/for-linus] block: blkg_destroy_all() should clear
 q->root_blkg and ->root_rl.blkg
Date: Tue, 8 Sep 2015 11:31:32 -0400
Message-ID: <20150908153132.GD13749@mtj.duckdns.org>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
 <20150902153255.GH22326@mtj.duckdns.org>
 <20150904104602.GN29283@redhat.com>
 <20150904171302.GE25329@mtj.duckdns.org>
 <20150904204244.GQ29283@redhat.com>
 <20150905153439.GA18461@redhat.com>
 <20150905154840.GA19460@redhat.com>
 <20150905183801.GA8231@mtj.duckdns.org>
 <20150905194736.GB8231@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EXWzJy6tHEgIf8+E6TlXpcJs+bFZJ5eEm3z+QqiEFT4=;
        b=rmzL4sldMqfpT9iKhYn2BGxjonVM5a9p0QGYIqToOYBC7UXTBXLpdVuIfuGbxwzMxv
         a0iql4cwz2mt+uVUvG0Nt8U0i9Vs1RepJ01uEuTq1ZbF0XXtYI32l4t8SH0WqTgjeADl
         MEEdC1tfB4VAUCyqGzMjiCgIBAImWqqOF8Nlvvg4tsaQa30FTpPN6v9Pdyil4c4dwyS+
         07OqpM14morR5dFzZG6nyy5z6UuoUYdYSr8AvAOVAcY6wt9AiyyoVPI/tShf0pnED5J0
         prQY+iqzOAMBQAKC0BC1TYqKFU2/v5qeh9KNp8gaHfm5PgdgiM1efU1sMx+I2zNxYSW1
         MMSw==
Content-Disposition: inline
In-Reply-To: <20150905194736.GB8231-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sat, Sep 05, 2015 at 03:47:36PM -0400, Tejun Heo wrote:
> While making the root blkg unconditional, ec13b1d6f0a0 ("blkcg: always
> create the blkcg_gq for the root blkcg") removed the part which clears
> q->root_blkg and ->root_rl.blkg during q exit.  This leaves the two
> pointers dangling after blkg_destroy_all().  blk-throttle exit path
> performs blkg traversals and dereferences ->root_blkg and can lead to
> the following oops.

Jens, can you please route this one w/ Richard's tested-by added?

Thanks!

-- 
tejun
