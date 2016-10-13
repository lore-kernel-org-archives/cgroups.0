From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 13 Oct 2016 19:14:13 -0400
Message-ID: <20161013231413.GA32534@mtj.duckdns.org>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <20161005112206.GC9282@leon.nu>
 <CAG53R5VNVb=8-LJbDRqjtOZG347ucPuc420bcfnDgBKMoKqU-w@mail.gmail.com>
 <20161010044623.GI9282@leon.nu>
 <CAG53R5UM6nSTZ7=0S9reKGX45CpNBi8soSDVZyXkN-z0_XXWWQ@mail.gmail.com>
 <20161010122545.GA27360@mtj.duckdns.org>
 <CAG53R5V5yE4PsDBjP9BieG_=39M0G1kx-AfBEzWK4LUCxNnYBA@mail.gmail.com>
 <20161010132014.GD29742@mtj.duckdns.org>
 <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WHsxgM9Ug7IyTaG9I7gvizd1+B6R+Oy2V4cLT/DozDk=;
        b=pEgx328ECQfgXT3QKZLQ6nEuHTdzPJDDl0I6I9P5Q/oIBAIhTnoTUPtn3Tyu/n1njG
         1hvwOmRarCLc0o+5GXZZVC7cqtqzD2R1WLSJGU25mMMbate91NbbZgDtArmozK+C5CKU
         GUdf2s4a3RGtZ8D2X+p1qvmZd9HkDsvCXM9fos5S4Z4bo01z7+OBRW2+NxAaqiADnHSn
         +E1glj6i5/yHORyavdIFO7WqKP5k/RAuqWgm+jszT8nXaFCu5Vgv3U0NoknEDmb57xbY
         EL1VeUl+kgxq24yYgf3nXgEH+n1LJdhf3HJvPMAA0HEpKsVxLqxeGmisw1C/AmYMiQ+c
         nJsg==
Content-Disposition: inline
In-Reply-To: <CAG53R5ULKCqtw45E6t4hYdRV+y_OQqVazf=7A7Ax_XAJ2K0_dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello, Parav.

On Mon, Oct 10, 2016 at 07:02:11PM +0530, Parav Pandit wrote:
> Give me some more time, I will think more and take feeback from Leon
> and others on
> (a) how can we implement or want to implement weight like
> functionality for non-work-conversing resource

I think what you want is just a way to specify absolute limits using
percentages of what's available at the time of configuration -
e.g. being able to say "allow upto 30% of what's available in the
parent".  If so, the simplest way would be simply updating the
existing knobs to accept % inputs in addition to absolute values on
writes.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
