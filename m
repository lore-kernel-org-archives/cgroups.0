From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 25 Feb 2016 16:42:01 +0200
Message-ID: <56CF12B9.5060709@mellanox.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
 <1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
 <56CDAC7A.6030206@mellanox.com>
 <CAG53R5Uof+Ve7CndWy=BrgtxxCisQpzP_Ls0kw=Q270DhoEsZw@mail.gmail.com>
 <56CEED81.7010507@mellanox.com>
 <CAG53R5UZb=9WR7zk2b5C_FuKmt+WdNkbcrVbW+g1-oAj6J=w_Q@mail.gmail.com>
 <CAG53R5WxXYZof4QzuJndakzvG1+t388pDRXL2O466eEDkYJ+bw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/uAANmIFz5jaI/oe/YlpeSJY2wgx1V71SiR4R1bEAss=;
 b=bfs12+zMTYKq1Xr3utX4zggnoXJodlxMn7rk6tgv7YfFeaDPp4yzp80lerMaYb4nFlvE45yL9BLD/kxMjfBnVdb51HcVm5YN3lHt6ycRrryaQxfDtOBTLdD83uS61qS0itS6Uo+bQX+/1SRklAMe0oHmf6zRe5Z8RslJkvsYLc4=
In-Reply-To: <CAG53R5WxXYZof4QzuJndakzvG1+t388pDRXL2O466eEDkYJ+bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 25/02/2016 16:26, Parav Pandit wrote:
>> Can we call kfree() with spin_lock held? All these years I tend to
>> avoid doing so.
> Also it doesn't look correct to hold the lock while freeing the memory
> which is totally unrelated to the lock.
> With that I think current code appears ok with exception that its
> duplicated at two place for code readability around lock.
> What say?
Yes, the only thing that bothered me there was the duplication.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
