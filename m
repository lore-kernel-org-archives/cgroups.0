From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET block/for-4.2/writeback] block, cgroup: make cfq
 charge async IOs to the appropriate blkcgs
Date: Tue, 9 Jun 2015 12:03:27 +0900
Message-ID: <20150609030327.GL21465@mtj.duckdns.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
 <x491thmhtej.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PbWsQ2SwUCGWsA4OfGzh6rTPzoB49OZS6p9rWQD5/v0=;
        b=Tfdk+WZ8Sf/EtQ8lbJ69OlrG8iwOw6JP/6Ig1LXjs2Iq6Ol76487HhK4yoGjevYHz6
         S0HVfdlcsvisqD6EgjtbQ1y0LJqrHvso+EvY3ZyJs4mJ0PlLUAl6vGQzH1XtbCKEe2ac
         sPUBeIDXEiLeUe6hTqe6jg0BIaTt/gvuOkL/kM1FAXePp0tmTLZnCVjnhsF9HUcdrzCS
         f/o5pDQQg6P1CNhKBToRZVeXXiupjNHLSegpi039GJJey/EEe7bxAh1FJDe++sKEaaT6
         tSOdwUZA/6aiCoA37iTCw3GmQ2P54I1hPCC4A9jWOH7q1+k37A/4paB9dkkMm12NeovD
         UJaw==
Content-Disposition: inline
In-Reply-To: <x491thmhtej.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hey, Jeff.

On Mon, Jun 08, 2015 at 03:49:56PM -0400, Jeff Moyer wrote:
> Assuming you're ok with dropping patch 5, I'll review patches 6-8 once

I'll update it to use GPF_NOWAIT.  Can't drop it easily as that would
complicate group lookup more complicated w/ pinning and all.

> they've been reworked to account for that.  I took a look at them, and
> they look OK to me.  But, if they are going to change, I'd rather wait
> to ack the final versions.

Hmm... the changes will be simple s/GFP_ATOMIC/GFP_NOWAIT.  Shouldn't
affect reviewing, I think.

Thanks.

-- 
tejun
