From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] writeback and cgroup
Date: Thu, 5 Apr 2012 09:38:54 -0700
Message-ID: <20120405163854.GE12854@google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404145134.GC12676@redhat.com>
 <20120404184909.GB29686@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1cjqeiAwSjsZD7Ed1MKpCi8Fi9f6PTQPeT8VKwxSv6g=;
        b=y5TZBXFwxK/sFAU20wCgiq5EVEeqZuM6aRPTsW3j49rIRemySnJP++J8D+EXg2sUp3
         GLzLWu7oT/8cxTj2YkCq7biLL1p7nM96vnN68mNs5m/nXsvCOwljtm5ZNkjV5R/EKVFX
         POJORwthEMlqktChFcbz06u7uyfW551TPFeZ+NSQFi3q2oUfCFTr9bluveqpdloRGB9h
         sJE/C+W4cAYS7D2Phaq7ESKt63fvxX0wvuU7NmbOho67ZVZncQ6Lu40y6c7CibCD28g9
         jf+bdYZiklRk68w7nuRLrLAaRTsfuzX78bHqrWDEJZQkHZt/oH5j2SWrsBMeEy8zqpEh
         h1hw==
Content-Disposition: inline
In-Reply-To: <20120404184909.GB29686-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, sjayaraman-IBi9RG/b67k@public.gmane.org, andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lsf-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hey, Vivek.

On Wed, Apr 04, 2012 at 11:49:09AM -0700, Tejun Heo wrote:
> > I am not sure what are you trying to say here. But primarily blk-throttle
> > will throttle read and direct IO. Buffered writes will go to root cgroup
> > which is typically unthrottled.
> 
> Ooh, my bad then.  Anyways, then the same applies to blk-throttle.
> Our current implementation essentially collapses at the face of
> write-heavy workload.

I went through the code and couldn't find where blk-throttle is
discriminating async IOs.  Were you saying that blk-throttle currently
doesn't throttle because those IOs aren't associated with the dirtying
task?  If so, note that it's different from cfq which explicitly
assigns all async IOs when choosing cfqq even if we fix tagging.

Thanks.

-- 
tejun
