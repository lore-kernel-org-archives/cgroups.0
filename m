From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Staring with 3.14 devices.allow can't be opened in read-write
 mode
Date: Mon, 12 May 2014 11:19:08 -0400
Message-ID: <20140512151908.GC1421@htj.dyndns.org>
References: <CANaxB-xUm3rJ-Cbp72q-rQJO5mZe1qK6qXsQM=vh0U8upJ44+A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5dH6JHCdJrV3Pr6tg4xwzuHR9lXVCycaq1wnZqMrDCw=;
        b=rjur3nd4HX5AnDweNy5c0kUEL8U5v6F/M+V9WVnnrrAOhQGZjYksz/mO8qusGnBEPt
         FTOsLDNp92yUe2XT2cPRV/ZD0faKondgc3Tyav5AxMeGLAR6RdcGw5ZtGIUkrS46gpLK
         RQMz4hHGy8Utqoq0Uu6mBmqDl/iccZw1hsdSxmaqlFZ2OVJT71WbmX9ppBEND8nuDtoW
         xaGNx45IGCO5JxV4bi+VvFQcprfq+5Mpg1htg12+TYRS2tGVrCgZTLUuVD8bFhQaXeBp
         X/x29tI57bN3nciJOcV2djuwtM4OVOqvAKJCqBXgrC6Dk7iTu5JWsRcAyfLkrpNn070l
         iBWw==
Content-Disposition: inline
In-Reply-To: <CANaxB-xUm3rJ-Cbp72q-rQJO5mZe1qK6qXsQM=vh0U8upJ44+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libcg-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org

Hello,

On Mon, May 12, 2014 at 03:10:12PM +0400, Andrey Wagin wrote:
> I found the "devices.allow" file can't be opened in read-write mode on
> the 3.14 kernel. I uses libcgroup, which opens devices.allow with
> O_RDWR. This works fine before 3.14 and fails one 3.14. This files has

Urgh... great.

> write-only permissions. I have tried to create a regular file with the
> same permission and kernel allows to open it with O_RDWR.
> So what do you think is it a problem, which must be fixed?

That's vfs skipping permission check because the opener is root.
sysfs traditionally enforced the same permission check on root too.
cgroup switched over to kernfs and now share the same open logic with
sysfs and is now getting open failure from permission check on root
opens too.

I'll bring kernfs's behavior closer to regular files.

Thanks.

-- 
tejun
