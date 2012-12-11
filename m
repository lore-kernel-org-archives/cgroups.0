From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: performance drop after using blkcg
Date: Tue, 11 Dec 2012 08:27:29 -0800
Message-ID: <20121211162729.GK7084@htj.dyndns.org>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com>
 <20121211142742.GE7084@htj.dyndns.org>
 <20121211144336.GB5580@redhat.com>
 <20121211144718.GF7084@htj.dyndns.org>
 <20121211150234.GC5580@redhat.com>
 <20121211151412.GG7084@htj.dyndns.org>
 <20121211153725.GD5580@redhat.com>
 <20121211160137.GJ7084@htj.dyndns.org>
 <20121211161820.GE5580@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RWqajYFzXlrc4HlvG2UCzFWI1RCj5kfDdhXrpQgZ6pQ=;
        b=uIkJvVrnR3O/LTEV5HRlUF4id+SG3QpZIFCXNzb59f8hDKVQuQkof4NBAEYDqPE+dg
         exhgEb2jTcm2lNIzb+/7nMLyZBgg0ZyToft++oeYXzaMFuZPgzOxbyHk3dpLS4sanDJ9
         +PeYvKXFil13gOjlF12utnD6/JHjwOc4GEae/meFPD3/DzHuCGXZ70tX/2udpHwJsKPg
         MeFZvVPXpLZz7wxVotbjPJjoNEmOXlo7pwm9Vuimn8QiZ4LuKamJ7DK0EvQcvAh9cIv3
         m7SruVEBpjBtu9N7rqe9kcJL+MlDFFyywYsI03dBZYlANXngv+f28aWUJQ39mTddZfSb
         8d0A==
Content-Disposition: inline
In-Reply-To: <20121211161820.GE5580-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zhao Shuai <zhaoshuai-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Vivek.

On Tue, Dec 11, 2012 at 11:18:20AM -0500, Vivek Goyal wrote:
> - Controlling device queue should bring down throughput too as it
>   should bring down level of parallelism at device level. Also asking
>   user to tune device queue depth seems bad interface. How would a
>   user know what's the right queue depth. May be software can try to
>   be intelligent about it and if IO latencies cross a threshold then
>   try to decrese queue depth. (We do things like that in CFQ).

Yeah, it should definitely be something automatic.  Command completion
latencies are visible to iosched, so it should be doable.

> - Passing prio to device sounds something new and promising. If they
>   can do a good job at it, why not. I think at minimum they need to
>   make sure READs are prioritized over writes by default. And may
>   be provide a way to signal important writes which need to go to
>   the disk now.
> 
>   If READs are prioritized in device, then it takes care of one very
>   important use case. Then we just have to worry about other case of
>   fairness between different readers or fairness between different
>   writers and there we do not idle and try our best to give fair share.
>   In case group is not backlogged, it is bound to loose some share.

I think it can be good enough if we have queue at the head / tail
choice.  No idea how it'll actually fan out tho.

Thanks.

-- 
tejun
