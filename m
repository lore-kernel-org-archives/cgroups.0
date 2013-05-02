From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Date: Thu, 2 May 2013 11:49:53 -0700
Message-ID: <20130502184953.GP19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
 <20130502175701.GL19814@mtj.dyndns.org>
 <20130502181747.GH30020@redhat.com>
 <20130502182933.GN19814@mtj.dyndns.org>
 <20130502184514.GI30020@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=58lmOfS6jMStDCgTFzaiNH3h3dWtq4/u8sF59PtLBtc=;
        b=TkSMfCtLJ1a4GIiWhn1GoILc0PkDd2J2St23BXCmSxvNMav/rMkLPILOpT1ezthYst
         PZsuQjOkkon/SNllupuyhc0BIOLLbTd+nTrc/eIoVkmeFj4cC5ZqP1W9R/Hse2SdUzso
         MaNAyU9/YlFbaIoib9fuhhdxHDlR4DKYocscWomX00K178FoGdeqfjt1mqJXhXV0sAxS
         1SPm2srL5M5YDv8WBxQ1c3Eglyt1aDRg9LaPYNIpTWbegLU4pATKPhvBwZzIiX8B7U4X
         KAr814hO4w3UFHv725qbnpCU0qrsQXSoW6hcNCZiwpb6ynHy8PqwSulIXHsQ7hsMSBhG
         dTrg==
Content-Disposition: inline
In-Reply-To: <20130502184514.GI30020-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, May 02, 2013 at 02:45:14PM -0400, Vivek Goyal wrote:
> I did not understand this point. In flat model, application issuing
> at configured page will not get penalized.
> 
> This penalty is coming from the fact that we are moving bios after the
> wait and make them wait in another queue.
> 
> In flat model there is no such problem. So to me, it is the problem
> of how hierarchical scheduling is implemented. In flat model, I did
> not have to deal with it.

But seen from the parent, the child isn't different from any other
issuer in flat hierarchy.  It's just being repeated, so if you assume
a process which behaves in the exact same manner, that process would
get penalized too.  e.g. imagine an application which throttles itself
and issues exactly 1MB/s amount of data in direct IO.  It'd get
penalized the same way, right?

> Ok. Not having a perfect algorithm now is fine. We can always redo it
> later.

I think we can do source-based RR on bio_lists[] fetching which is
simple enough and should be able to avoid most of the problems, right?

Thanks.

-- 
tejun
