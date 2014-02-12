From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: convert to kernfs
Date: Wed, 12 Feb 2014 14:53:16 -0500
Message-ID: <20140212195316.GD26809@htj.dyndns.org>
References: <20140212192753.GA5217@elgon.mountain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7AraF+RCLyHuGjF2GQgMCDc+h4TqA71cYsqXivDaYLg=;
        b=IPZZu3zrfuXQL7AOlIMplz36bapeg4ycjPPNSr4aq2wAGT372d+o4rdWjVXz17ZSc/
         PKAfva90rBmq/wZZnvrEuYmQ7NQf5nvYK3ukrgeGA5n8wt9RUG3ZOgrOU8Wil3qs+7Sg
         k9JXYNK6yz3qv8ffIYFiRdTBHu312A17LFK/P6YMZtx0JixD28jQvOuXWNMVfAbivYqf
         W741G2KseRuOJcFwMP6BmH7UxAygI+C/2iR/x7sfVqCMvA3v/Kf0Tyf5WU1RzcBQy8St
         cFcJUGiEGTFXWKwv8b7dNEcAHzBGGqm1f7wcbqtmnSS+Usj1WAEmzZG7h3W3sOoIPqNB
         b5kQ==
Content-Disposition: inline
In-Reply-To: <20140212192753.GA5217-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Dan.

On Wed, Feb 12, 2014 at 10:27:53PM +0300, Dan Carpenter wrote:
> kernel/cgroup.c
>   2431  int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
>   2432  {
>   2433          struct cftype_set *set;
>   2434          int ret;
>   2435  
>   2436          set = kzalloc(sizeof(*set), GFP_KERNEL);
>   2437          if (!set)
>   2438                  return -ENOMEM;
>   2439  
>   2440          ret = cgroup_init_cftypes(ss, cfts);
>   2441          if (ret)
> 
> kfree(set);

Oops, thanks for the report; however, the whole cftype_set handling
gets removed by a later patch which is already committed, so the issue
shouldn't exist anymore.

Thanks!

-- 
tejun
