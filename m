From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: oomd with 6.0-rc1 has ridiculously high memory pressure stats wit
Date: Fri, 26 Aug 2022 11:11:23 -1000
Message-ID: <Ywk2+wKGu9NS/EbE@slm.duckdns.org>
References: <d0df567c-1f6a-418d-8db7-3f777bd109c8@www.fastmail.com>
 <YwUcGvE/rhHEZ+KO@slm.duckdns.org>
 <9412f39b-9ec1-4542-944c-19577a358b97@www.fastmail.com>
 <0a6105f9-012a-4b75-b741-6549d7e169d8@www.fastmail.com>
 <YwU0mLBMuxpZ7Zwq@slm.duckdns.org>
 <f354bbb3-6619-4ab0-b0fb-a0098ffb0205@www.fastmail.com>
 <a7a96563-fd07-4970-8c25-f0784c83c915@www.fastmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=NpDbARr9FROHsdpoRBEwA2TKj43VTAHXK/2AaJuQG0g=;
        b=HtOUvCv9/08/l1KV+VqsvseEILn8PnCzF6Cal0b/r8xNG9a2TVjbY2M5FQT1M1dj7L
         /jdcLjrPz29B+T5L6C8sUgz2u12B6VgF8kxHJUL62iZLT6RnELhDi3l42qNG0thuOjm1
         DWXhHMo6+xTL07u4I36LWvWWypm2iq68AwT7tgkeB7tul8WfiG9aGIyG25Jr2BMSkFUT
         lamFyfd1/E+dge2NllS8Z2dqXSygCGJYbYb3jvyGLJb5TFHwwnjOeJ8mgda7zXoqQ373
         9UOBVfKceRN2tYMyCaXMDka/hCBrwt3frnchZ1wLASopQ5lOxutylvRy9z04zmJj0h0R
         DXOQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a7a96563-fd07-4970-8c25-f0784c83c915-jFIJ+Wc5/Vo7lZ9V/NTDHw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Murphy <chris-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>
Cc: Chris Murphy <lists-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Fri, Aug 26, 2022 at 08:06:15AM -0400, Chris Murphy wrote:
> Patch has been in Rawhide without any failures, consider it fixed. Thanks!

Upstream fix is 2b97cf76289a ("Hao Jia <jiahao.os-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>") which was
already sitting in my queue by the time you reported the problem. -rc3
should have it fixed. I should have pushed that out earlier. Sorry about
that.

Thanks.

-- 
tejun
