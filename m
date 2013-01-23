From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: don't grab mutex in rcu callback
Date: Wed, 23 Jan 2013 09:18:54 -0800
Message-ID: <20130123171854.GD2373@mtj.dyndns.org>
References: <1358961426-8482-1-git-send-email-jerry.snitselaar@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=mFEJPcxiBVCmgDiRI7WI06KKOIvIWhzKfSa+hXdLOnQ=;
        b=EDvK1+oL7ETn9GWEL2MRWSvjk9ojdn5aKlnDU7jX2BmS7TeejR31cWXDTCzmgQQrko
         /DM9k7S6NmedU6urb83a+j4x8M7vnaUmleR1bVib1eEP4xQETIz0sCC0HzqUQGmJM8x7
         XLjepuLMJQIMn10N/AezA+cBO5nZHEyzlE0R9/2xB0ZYXAssRtMaBn+Z0MaN05AoeE17
         is6M7TWVOfHqR6VaIBdBEBnQwzTVquvI0JHb5PDyYtYtGfnaiLZXVGXXTAI7k+AGpvt8
         GJl7LVqmcpmV6bi61gylr8pwYvtwfWUjWY5otH9dA/FalO/g+yf2Bq2u97C/vGZrjlRS
         x+1Q==
Content-Disposition: inline
In-Reply-To: <1358961426-8482-1-git-send-email-jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 23, 2013 at 10:17:06AM -0700, Jerry Snitselaar wrote:
> commit 103a197 "security/device_cgroup: lock assert fails in
> dev_exception_clean()" grabs devcgroup_mutex to fix assert failure,
> but mutex can't be grabbed in rcu callback. Since there shouldn't be
> any other references when css_free is called, mutex isn't needed for
> list cleanup in devcgroup_css_free().
> 
> Signed-off-by: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

-- 
tejun
