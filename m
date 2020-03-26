From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/3] blkcg: add blk-iotrack
Date: Thu, 26 Mar 2020 12:14:41 -0400
Message-ID: <20200326161328.GN162390@mtj.duckdns.org>
References: <cover.1584728740.git.zhangweiping@didiglobal.com>
 <20200324182725.GG162390@mtj.duckdns.org>
 <CAA70yB7a7VjgPLObe-rzfV0dLAumeUVy0Dps+dY5r-Guq2Susg@mail.gmail.com>
 <20200325141236.GJ162390@mtj.duckdns.org>
 <CAA70yB5yH9H6-gaKfRSTmgd6vvzP4T9N7v-NAD0MsRL+YTexHw@mail.gmail.com>
 <CAA70yB4e65nbV=ZA8OT-SUkq+ZQOGGB9e-3QKJ_PqXjVaXGvFA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8IKwyciStCgZpdnJkZlUrSTPI/Vlrtv9Ag4mNeyNDVc=;
        b=dqoznUEMpvZVbysLF5hQNKMHq3mH4oGS/Ao7V5rSK91a9khv579x9UUPWAKgJXHEzZ
         bkgfHuz2YJeG7Yp/3psz+pFlIGC7HdE3FJzN1Gf91FKM8wJmYykfwG2QlifcFmT9UiiV
         /zCa+fUOmXlYnrUrSkMwFusZ2N0ld4ebN0Oj38etpkldHa22keV1IUzjucTAuJiuvFnh
         z65g6ZaxHni7zfalSC00WM+U/FDTbzutOFD75hykMUHPNOg6/N8d04qNpZkyJxFO3muo
         p7gcmx0C6SRpqJnUJi3HloGGQmWDlFIQ7i0EfZzuThvv4AnPzTYw47dvI6ozAPLj0IP9
         yl6w==
Content-Disposition: inline
In-Reply-To: <CAA70yB4e65nbV=ZA8OT-SUkq+ZQOGGB9e-3QKJ_PqXjVaXGvFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Weiping Zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 26, 2020 at 11:08:45PM +0800, Weiping Zhang wrote:
> But iocost_test1 cannot get 8/(8+1) iops,  and the total disk iops
> is 737559 < 79388, even I change rrandiops=637000.

iocost needs QoS targets set especially for deep queue devcies. W/o QoS targets,
it only throttles when QD is saturated, which might not happen at all depending
on fio job params.

Can you try with sth like the following in io.cost.qos?

  259:0 enable=1 ctrl=user rpct=95.00 rlat=5000 wpct=50.00 wlat=10000

In case you see significant bw loss, step up the r/wlat params.

Thanks.

-- 
tejun
