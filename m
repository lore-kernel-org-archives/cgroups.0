From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroups: censor kernel pointer in debug files
Date: Mon, 6 Mar 2017 15:16:35 -0500
Message-ID: <20170306201635.GJ19696@htj.duckdns.org>
References: <20170225095648.GA4917@beast>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MPyy6KlBWkntRLq17IhCOMMB1BFSYuR/88yZzEKgPIk=;
        b=Jlf2MYu1CCtC0GYI2vmGLD7rjMIHRKUd2DT3Xew6KUWphHNzD5ShMI94J4NDMsGy7f
         D3oWDSXTJNAK506NhR0Xle2+uFyvru1QFbJAdS+Yw5zTjuAXWM331todhTaHRzZrob4U
         WQ1veqyskrGcI3saf00gLLHelPMYZI7ls8P6OYtyTufHEujBg62b1T6v/BdLbBlsY6Ab
         SYPeuUZAqIj91LIxIGnBUgWoNySm0siAQI0eigXmwj5WUzYVPTQtXkbM68jXgDb16tM1
         0Te3g3jjPTYzrOBlz0YYgLGgCtlxnu4agoWQnTuXrP1BEf/rF5yM9YpWxYUI3fdU9lGt
         rreg==
Content-Disposition: inline
In-Reply-To: <20170225095648.GA4917@beast>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org

On Sat, Feb 25, 2017 at 01:56:48AM -0800, Kees Cook wrote:
> As found in grsecurity, this avoids exposing a kernel pointer through
> the cgroup debug entries.
> 
> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Applied to cgroup/for-4.11-fixes.

Thanks.

-- 
tejun
