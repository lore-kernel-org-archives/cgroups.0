From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] writeback and cgroup
Date: Tue, 17 Apr 2012 14:48:31 -0700
Message-ID: <20120417214831.GE19975@google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404145134.GC12676@redhat.com>
 <20120407080027.GA2584@quack.suse.cz>
 <20120410180653.GJ21801@redhat.com>
 <20120410210505.GE4936@quack.suse.cz>
 <20120410212041.GP21801@redhat.com>
 <20120410222425.GF4936@quack.suse.cz>
 <20120411154005.GD16692@redhat.com>
 <20120411154531.GE16692@redhat.com>
 <20120411170542.GB16008@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SmzTi3YvooJ0B5XEg+seG/clYLW3RAogsbZVIPnkY7o=;
        b=BpP2gNO8U5khV4zQxyIHRLNzruqVJT1+WXapd/u4PmFYBcwbXQdkjWygGLhUKq4ZxK
         nSEZObsmabxseJcMJGo7yx7H7Fi4q+2ojhIhtqWKmGTX+IPjyzv6GjDjx4yXF6VpNgra
         sdJp+cVCgcf2ba6LvSXeRyZffz0jjQwEizDS1PIhfxlX5uYPYqBTMQh/F/xrUsQYcNmg
         JSnlMa5OiDeKEqGTls+DMYiGOsDrAjBW2gou1ooNhWka9Qqy7tXq/1TVJinbb410GMva
         k2n9Krb4+frMYkniDoYuPNQpZRrq6jJSV510DVrAJrCrK6vkQ+x7ICyinJNd/woZIs3Y
         x7qA==
Content-Disposition: inline
In-Reply-To: <20120411170542.GB16008-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, sjayaraman-IBi9RG/b67k@public.gmane.org, andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lsf-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello,

On Wed, Apr 11, 2012 at 07:05:42PM +0200, Jan Kara wrote:
> > The additional feature for buffered throttle (which never went upstream),
> > was synchronous in nature. That is we were actively putting writer to
> > sleep on a per cgroup wait queue in the request queue and wake it up when
> > it can do further IO based on cgroup limits.
>
>   Hmm, but then there would be similar starvation issues as with my simple
> scheme because async IO could always use the whole available bandwidth.
> Mixing of sync & async throttling is really problematic... I'm wondering
> how useful the async throttling is. Because we will block on request
> allocation once there are more than nr_requests pending requests so at that
> point throttling becomes sync anyway.

I haven't thought about the interface too much yet but, with the
synchronous wait at transaction start, we have information both ways -
ie. lower layer also knows that there are synchrnous waiters.  At the
simplest, not allowing any more async IOs when sync writers exist
should solve the starvation issue.

As for priority inversion through shared request pool, it is a problem
which needs to be solved regardless of how async IOs are throttled.
I'm not determined to which extent yet tho.  Different cgroups
definitely need to be on separate pools but do we also want
distinguish sync and async and what about ioprio?  Maybe we need a
bybrid approach with larger common pool and reserved ones for each
class?

Thanks.

-- 
tejun
