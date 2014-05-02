From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: fix the comment format for recently added
 functions
Date: Fri, 2 May 2014 11:30:28 -0400
Message-ID: <20140502153028.GG10204@htj.dyndns.org>
References: <20140424193321.GS29214@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4ZnqhU7Jb1+I8DhzKe8ax7wd6IycbH/qb0mmpvP+R4w=;
        b=mo+PPoFgP0BtxHEt5XAmqjtGfHritpWKfwEu14Ti3dJ1dGeawbt0jrDcXQD+0Kubq6
         2NYo+v8PrKvIUxKnaELn6v8s9eHEogOYkelr+PvdxgbWN0kkoNsbI/TcQMaBqmKOazPa
         CBhaTbO+L13ld/yCngCloL3e8KAWHprkWGSbzlNX7w8961zZ32IZDe3A4HkIncP+MsQJ
         m+e8DWTb5KkCLSUI8gU4RfWpHUvPpLhptTMkFEhgXMp7GQQ7DqaB0quQReavtipZoeUz
         cVSJdlw8Cbz+F1dKDNgzwmyd1iC+TXILHt8eqKUAQbcUxz1LKCAR9tgsJ2jm7Lfluvln
         DTXw==
Content-Disposition: inline
In-Reply-To: <20140424193321.GS29214-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Apr 24, 2014 at 03:33:21PM -0400, Aristeu Rozanski wrote:
> @@ -306,17 +306,17 @@ static int devcgroup_seq_show(struct seq_file *m, void *v)
>  }
>  
>  /**
> - * match_exception	- iterates the exception list trying to match a rule
> - * 			  based on type, major, minor and access type. It is
> - * 			  considered a match if an exception is found that
> - * 			  will contain the entire range of provided parameters.
> + * match_exception	- iterates the exception list trying to find a complete match
>   * @exceptions: list of exceptions
>   * @type: device type (DEV_BLOCK or DEV_CHAR)
>   * @major: device file major number, ~0 to match all
>   * @minor: device file minor number, ~0 to match all
>   * @access: permission mask (ACC_READ, ACC_WRITE, ACC_MKNOD)
>   *
> - * returns: true in case it matches an exception completely
> + * It is considered a complete match if an exception is found that will
> + * contain the entire range of provided parameters.
> + *
> + * Return: true in case it matches an exception completely

Can you just merge "Return: " section into the paragraph?  Just go
"Returns true blah blah".

Thanks.

-- 
tejun
