From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: correct the disoder comment of two functions
Date: Mon, 29 Jul 2013 14:13:36 -0400
Message-ID: <20130729181336.GB26076@mtj.dyndns.org>
References: <51F34505.9010505@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5r2nG57Fz7q6MmeHQKj16mEN8XUGVA0LeSZGQuSY3d4=;
        b=alyJFBKp9Mz/LlTn7PeGTwlhGomQuy4gL6e8hHe6ewmR52tD2urTKZ8tPqu4E75cvf
         PaZtsMG9hlvWXA7mjrS76E7sen5yRYiaBRWvs1exI6wIhBOHRtv31xLxPKXjnm7zypf0
         Fca5oC4boW4YJWOCBTknT+3WacgV47Qc/+3qLAc/fgPTxxOjE4jfiVkJfS3lBms8npan
         CluqP9Ep2UuuqEwstipVsqTOFj3Yh/wHqt+UZZmGgjeXEyxpO9srWEFbCVyWH9syf2bT
         EIocAbI/an+zBPnu9xhk/xPXJaz59oc7Y5FR5SVnXWs8eNUmHxOnAYHo0jCzJ9Pf7Wmb
         WElg==
Content-Disposition: inline
In-Reply-To: <51F34505.9010505-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jul 27, 2013 at 11:56:53AM +0800, Zhao Hongjiang wrote:
> correct the disoder comment between cpuset_css_offline() and
> cpuset_css_free() functions.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
