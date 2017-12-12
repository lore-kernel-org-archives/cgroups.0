From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] writeback: synchronize sync(2) against cgroup writeback
 membership switches
Date: Tue, 12 Dec 2017 08:30:59 -0800
Message-ID: <20171212163059.GB3919388@devbig577.frc2.facebook.com>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
 <20171205182007.GV2421075@devbig577.frc2.facebook.com>
 <8844b550-d91c-38d5-997a-a899d1e4aa42@gmail.com>
 <20171211195052.GN2421075@devbig577.frc2.facebook.com>
 <ca999c10-5e8d-2bb1-c872-70bf13666849@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+FoXeDSDA/h78JZ5OgSpOtvlCYUqJIgXPIzyWdn3Hmo=;
        b=dx2YcyClCHebK/BRjcGYkLGltJbiWmS+JX6/BV4nmxbbsr6qnDJDgSi+3x0zfG3A0B
         9EUr9PahMOVLS/LInD1dycH3+qwuPVKic24PkIFaZt+xNQGh3pnFR6ksrX0PKzcUPH8L
         7glvql9hlWZlZV6+aqLLT8P7He+CTUrpoZX0aUaRj3b+aoMjU27WQVrmInkqD7ay0/+H
         puFEFEkT47YhKjzI6EkxM0KBE+HEL5uO9VhcPu4rHV1Q6UvjwsayFDgbphzcP+wpdBSo
         5Rrw8uIRjrFdZPHLGY/5qi/WLBhepjPKhiH9V6UHGCgQpprDAmCPMM91tS8ROm2MLcPY
         ejWQ==
Content-Disposition: inline
In-Reply-To: <ca999c10-5e8d-2bb1-c872-70bf13666849-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Dec 12, 2017 at 02:04:45PM +0800, xuejiufei wrote:
> The initialization of wb_switch_rwsem should be in
> the conditional compilation of CONFIG_CGROUP_WRITEBACK,
> right?

Oops, you're right.  Will update the patch.

Thanks.

-- 
tejun
