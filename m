From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 13/13] Documentation/admin-guide: xfs: drop doubled word
Date: Fri, 3 Jul 2020 20:28:46 -0700
Message-ID: <20200704032846.GU7625@magnolia>
References: <20200704032020.21923-1-rdunlap@infradead.org>
 <20200704032020.21923-14-rdunlap@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xICZg36pt8h/hSPa7Ni+oRU48F4QAE0rnESu93rms6E=;
 b=GaxIQ0mXCFQ9B6DI5XrlVJ4YDKWNcTEAYyAkaXWpBdBabGXejcQoYd4GKqlDXxFEsNo4
 Yo/c3Wfuq8Bw4rgxkS5QNGPANMnOo8YZnuQwi9uojng+/lIdi7QXgXeJdvJda5tvObfZ
 kj7/qfR9M8AcoqogpodLMo9sIgIlGjsaTGNcTUr/PCI8iQYD/cS/taCcIBAoH3eR/UWm
 j/VTxcPlSY7klKeppS+ktOLe3mEWoZ7UOLnwPkx3AlVQv+xpyFHkEQkOfqqwaZjIck5O
 63KkNipcYjh3ezk1M7oowSTgacTeIE9KYlijS2rkUSj6tVfB376DqN7ZNmHeLAXtfD7A dw== 
Content-Disposition: inline
In-Reply-To: <20200704032020.21923-14-rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 03, 2020 at 08:20:20PM -0700, Randy Dunlap wrote:
> Drop the doubled word "for".
> 
> Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

--D

> ---
>  Documentation/admin-guide/xfs.rst |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20200701.orig/Documentation/admin-guide/xfs.rst
> +++ linux-next-20200701/Documentation/admin-guide/xfs.rst
> @@ -133,7 +133,7 @@ When mounting an XFS filesystem, the fol
>  	logbsize must be an integer multiple of the log
>  	stripe unit configured at **mkfs(8)** time.
>  
> -	The default value for for version 1 logs is 32768, while the
> +	The default value for version 1 logs is 32768, while the
>  	default value for version 2 logs is MAX(32768, log_sunit).
>  
>    logdev=device and rtdev=device
