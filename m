From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: do not use rule acceptance function to
 validate access
Date: Mon, 14 Apr 2014 15:07:43 -0400
Message-ID: <20140414190743.GA16835@htj.dyndns.org>
References: <20140414144736.GS29214@redhat.com>
 <20140414180323.GC15249@htj.dyndns.org>
 <20140414181611.GU29214@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=S1vEyg+Jk0WCLoP/1rEbYfmROqpVzp3gqHUD98CYhVo=;
        b=P9/STWPp5a8GC/tmKWxCstWRYMEI+TFke2sgV32pRm0A6O8Kn5uYhkYEtOiVjvvaD0
         ttHV2i42Lv96Uw0v1N8IeIIC8RQ2lflHTRyTxd34udy8gPILk+TmPDwLFM5v6uWqnr/L
         nrifky7l03RyrROO8yIBluFYbslV3MJopebkqM9OkbYFetAodhfy84xWhfFcvtRylMvI
         DYdl3NQNednFHqtasgf5rCIYMEUNSM1hYGFbET1G+GAeu42pnD7DKpwOyOLowEmKmH5Q
         Wa8gKgn/ERjFwBaLQ2vAjrmOU1yWyeXFEXYFQfu6qDBhgBbZ8B/EODQBQzEfLcGOd9v3
         h9mg==
Content-Disposition: inline
In-Reply-To: <20140414181611.GU29214-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hey,

On Mon, Apr 14, 2014 at 02:16:12PM -0400, Aristeu Rozanski wrote:
> > Currently, there's a lot of duplication in rather
> > delicate code and it's not clear where they differ and why.
> 
> Are you referring to the duplication in this patch or other areas too?

In this patch but if you can reduce duplications in reasonable way in
other areas, that'd also be great. :)

Thanks!

-- 
tejun
