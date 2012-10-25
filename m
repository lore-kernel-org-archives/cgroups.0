From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 08/18] memcg: infrastructure to match an allocation to
 the right cache
Date: Thu, 25 Oct 2012 11:06:52 -0700
Message-ID: <20121025180652.GM11442@htj.dyndns.org>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
 <1350656442-1523-9-git-send-email-glommer@parallels.com>
 <CAAmzW4N40MedsCfcj+eiM-i6cU65n3z7uy08YFyknXbBKj7Z-g@mail.gmail.com>
 <50891CF2.3030400@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DFUiJsfAHFAhEJUxmHs6bi0bY+OxYytZF8u8GY2O4Q0=;
        b=kCk9oSQX/4Vrt43kl5r/W+sv3GfynUZMIllewARRDr36FYhsPK/Hk7zWoU5AyiCI2W
         /bvBMl+5zpcXMPAHQwi+ApCFiGcC3vlu9jNK5n1ojIbI8anetDbHSuM+RAxFg9k7eYWK
         k8RWspWHCXLcrGEolvdc6n8Nu5UTV4Man9FyRTuL5NFqOhWSCt3aeorwRO2i55scrNZg
         G4BLKe1XWuTFjK/MzmAscQzvJ1jQ6E4KAZubHgFfRXENY90gQ324y3br0R7NZ6A8+Fy5
         CZZuHtOXFiuM8dZpH+qAD2aeqhmBtS1i+W4GFSB8LUMT9+zZDTE7i1QJ5zoFtTKAt592
         4gtw==
Content-Disposition: inline
In-Reply-To: <50891CF2.3030400-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: JoonSoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Glauber.

On Thu, Oct 25, 2012 at 03:05:22PM +0400, Glauber Costa wrote:
> > Is there any rmb() pair?
> > As far as I know, without rmb(), wmb() doesn't guarantee anything.
> > 
> 
> There should be. But it seems I missed it. Speaking of which, I should

You probably can use read_barrier_depends().

> wmb() after the NULL assignment in release cache as well.

And you probably don't need that.  dangling pointer is protected by
RCU and there isn't any memory accesses which can paired with that
anyway.

Thanks.

-- 
tejun
