From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Date: Mon, 22 Sep 2014 00:02:14 -0400
Message-ID: <20140922040214.GE23583@htj.dyndns.org>
References: <541F9C96.10705@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FfhwwmL8P+RjzL9Iy20urNy+JpAl0A5EfR2ODSpzNkQ=;
        b=JEENWmhJEyWIXWhZKi1kjIpSyNfjhZ/TbShCqs+Ez2bZG4rrccJT4Dtm9AgPNklQ7h
         Ra09RM8sdZAAEoVk5DVj3o5MMb+o8wwH3qMN0zUXBrJ4zg303xRIcYPM8i3i46UoLKj5
         DC4+HfQ7WUE57xla+nb0DWEIjTRu5lzRIZyiTWNAN3no8FhOOwZZ5IiUpSkdcZgeKVh2
         zVs747FRGaelZFJi+6P7TZLHVVZHZT5kwCRbfy7gKCrHMamHc4Ydqj1L0LLBFsSCttJy
         JnffV6xUnR7mWM6BfkqidT2mb8BDNKh7EfBqCgXc6KtEkSljrJQNBYkD6tmWuCvgeWGr
         TW6w==
Content-Disposition: inline
In-Reply-To: <541F9C96.10705-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>

On Mon, Sep 22, 2014 at 11:50:46AM +0800, Zefan Li wrote:
> From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> 
> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
> because it is used as bit number. Redefine it as decimal bit number.

It's also changing the bit position, which is fine but should be
mentioned in the description.

Thanks.

-- 
tejun
