From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 33/51] writeback: make bdi_has_dirty_io() take multiple
 bdi_writeback's into account
Date: Wed, 1 Jul 2015 22:01:06 -0400
Message-ID: <20150702020106.GG26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-34-git-send-email-tj@kernel.org>
 <20150630164824.GU7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=J4diAoiwyVy0yarLRitmwrDYylVgFZwRrIoYe6abYxo=;
        b=QICO0G7Y/5/Ky2320kGLGsT+MdhdpXL+0MQ9X6YXM7qhfjyrXRTt59Z5rG9sXtFzxS
         tV5SuV70pWnU+Q5StaA+WMwDYTkz3DxMGtueURug/WUkSxByqNkmD0mYwUD2T9ePkfmz
         ZKseo0mMu7+Ks8chNEF/4u3Id9I2C5tAzCqyabDq+4fzqWGB4by+2TKTqEYKdnZW6xkw
         u5lmLWIcIay0Qtugu2vLlcMajPPIyo28BjCXbaPq1UnlLj0dL5lZXFN6MaQhh4bhmARk
         oncNjOlZDIX8qaVT62kNmuBVdGo1ppj2KR+ALWI0rl2eGrCxapvMDASOUDtJsfPfaEaj
         ZBdA==
Content-Disposition: inline
In-Reply-To: <20150630164824.GU7252-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

Hello, Jan.

On Tue, Jun 30, 2015 at 06:48:24PM +0200, Jan Kara wrote:
> It looks OK although I find using total write bandwidth to detect whether
> any wb has any dirty IO rather hacky. Frankly I'd prefer to just iterate
> all wbs from bdi_has_dirty_io() since that isn't performance critical
> and we iterate all wbs in those paths anyway... Hmm?

When there are wb's to write out, maybe walking it twice isn't too
bad; however, the problem, I think, is when there's nothing to do.
When there are enough number of devices and cgroups, we end up making
what used to be a trivial operation something which can be
computationally significant.  ie. userland behaviors which used to be
completely fine because things are very cheap when there's nothing to
do can become scalability liabilities.

I don't think it's highly likely that this would become a visible
issue but I feel pretty uneasy about making O(1) noops O(N),
especially given that we need to maintain per-bdi fraction anyway.

Thanks.

-- 
tejun
