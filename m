From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] writeback, blkio: add documentation for cgroup
 writeback support
Date: Tue, 16 Jun 2015 17:54:36 -0400
Message-ID: <20150616215436.GE22637@mtj.duckdns.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
 <1434146254-26220-4-git-send-email-tj@kernel.org>
 <20150615172823.GA5783@redhat.com>
 <20150615182345.GB18517@mtj.duckdns.org>
 <20150615233519.GB30059@thunk.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Po623KFbkM5sJ1V6FE0Zyx/lX4btXX6LGsQMlLJUgFg=;
        b=mHTC6lDW80jfFvZllVnU90K0JCdjgDUEGNb0u7bDAhf9BKVW7iHLgZMAPac8VposPA
         ac5AFOyrjnLOQRBefWsKLBLHyOELE7yhMoRj3SimGtHaW3s8elq+NICtdyP5B0s5P8Me
         OyCgrlz01M5KHhuXQq6JTzl/a2UgsdksGEH1+ZT4XHtpWos2709NF8jwFcVr41EenQiL
         UlpWT+z5XSZsD3RZn9xomd6zFE62xg1NawsKD4dgjC2mhfWWU9uuW/2DBMltcTb3QFnl
         1a5e7n41gRA+2Ac0GGNpimLr5RUW04szq9I5b/oOEoAXjDtOD5yaytq3701u9mSD4NYa
         ekHg==
Content-Disposition: inline
In-Reply-To: <20150615233519.GB30059-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Ted.

On Mon, Jun 15, 2015 at 07:35:19PM -0400, Theodore Ts'o wrote:
> So if there is some way we can signal to any cgroup that that might be
> throttling writeback or disk I/O that the jbd/jbd2 process should be
> considered privileged, that would be a good since it would allow us to
> avoid a potential priority inversion problem. 

I see.  In the long term, I think we might need to come up with a way
to overcharge a slower cgroup to avoid blocking faster ones for cases
where some IOs are depended upon by more than one cgroups.  That'd
take quite a bit of work from blkcg side.  Will think more about it.

Thanks.

-- 
tejun
