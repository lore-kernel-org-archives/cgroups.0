From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 44/51] writeback: implement bdi_wait_for_completion()
Date: Wed, 1 Jul 2015 23:01:50 -0400
Message-ID: <20150702030150.GL26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-45-git-send-email-tj@kernel.org>
 <20150701160918.GH7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7LzuSCMsPsbFDJ8nbl4/fTyI0BmBvATzke0tP3AEHjw=;
        b=E9sfkYwaeg6NeVhuXeISkaO4GBl55n7PTMlT4qNCc89FO6Od0H8RShfLzWVIHYTqHz
         Ic26YZADV6cs4Maop2CaYjvXL8XJmDNFtbu0MQzNc0DZtXoLqTvvj0i0RT+Aih/dBqIU
         Vws9qM8K5DkkqvzJt7GTosGwQ1p8yLcwdk1KhZx5jrfcIitShX026VzW4XD0U855rQfC
         PSQ2PJqCcwjk9NJKgL2xtmkSy8iqqvPusKhh1bp0tqIJGqoqCseBrVvjLAqloQjlW1Cf
         kju4G0XaFU1JvrYSwx/Czqcv7Vnj/TSpQfmpzdHmj5fYdMdCSWechmLkyECDvGN/i1A/
         fhuw==
Content-Disposition: inline
In-Reply-To: <20150701160918.GH7252-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Wed, Jul 01, 2015 at 06:09:18PM +0200, Jan Kara wrote:
> > @@ -161,17 +178,34 @@ static void wb_queue_work(struct bdi_writeback *wb,
> >  	trace_writeback_queue(wb->bdi, work);
> >  
> >  	spin_lock_bh(&wb->work_lock);
> > -	if (!test_bit(WB_registered, &wb->state)) {
> > -		if (work->done)
> > -			complete(work->done);
> > +	if (!test_bit(WB_registered, &wb->state))
> >  		goto out_unlock;
> 
> This seems like a change in behavior. Previously unregistered wbs just
> completed the work->done, now you don't complete them. Is that intentional?

If nothing is queued, the cnt is never increased and the wait becomes
noop.  The default states are different between completion and
wb_completion.  There's no need to do anything to indicate that
nothing needs to be waited.

Thanks.

-- 
tejun
