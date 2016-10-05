From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 5 Oct 2016 11:36:13 -0400
Message-ID: <20161005153613.GD26977@htj.duckdns.org>
References: <20160911175235.GB13442@obsidianresearch.com>
 <20160912050717.GE8812@leon.nu>
 <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
 <20160915185629.GF26069@leon.nu>
 <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
 <20160921142645.GB10734@htj.duckdns.org>
 <CAG53R5WMuojhzFGmqk6nHfypd9Hq4dGsWRKjtUyMZ=RezU-LhQ@mail.gmail.com>
 <CAG53R5VqQ6UzsuzcovsD+ufv3HaEQEbUpaf3kDo4zLOrAf__8A@mail.gmail.com>
 <20161005063735.GC3086@lst.de>
 <20161005112257.GD9282@leon.nu>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tr9DZQqCTNGEfaHWVL+CYG8ZrWevclxyzsYSL1tc1Xg=;
        b=taWISCzVrX2f3Vb1eau61Trvjpfm2/YV6I72iuWKpJez5zlT7aAvpADjlDrjgXWbyC
         UppLPLYRnUTTGvlwi9rsNjQXaGNgnoguVKLjn5XUMnJX/pGm1Pp7VHaWNLsjHOvXZkQM
         b5LIUFTMG4GOueonl6bqk58NDkL8bjnf03u5FPT5tkLJH07cfHSe8ox6OIaQS12WDlGY
         zBdSzsei01y35Ic0eI1DiEfBzR9brVYvJlXUclrLR7LYSKS24BUndpEfjnQlkxbvLvTX
         vFdiweWbgxXi7j6vlcaDqnWs3JD3ahLh3NRf3pN8+v6KspgpxqUZqaU+8+jYzzhT+HnX
         2UFg==
Content-Disposition: inline
In-Reply-To: <20161005112257.GD9282@leon.nu>
Sender: owner-linux-security-module@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Parav Pandit <pandit.parav@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Matan Barak <matanb@mellanox.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

Hello,

On Wed, Oct 05, 2016 at 02:22:57PM +0300, Leon Romanovsky wrote:
> On Wed, Oct 05, 2016 at 08:37:35AM +0200, Christoph Hellwig wrote:
> > FYI, the patches look fine to me:
> >
> > Acked-by: Christoph Hellwig <hch@lst.de>
> >
> > but we're past the merge window for 4.9 now unfortunately.
> 
> IMHO, it still can make it.

Most likely, we only have three / four days till rc1 opens, I think
it's too late.  Let's target the next one.

Thanks.

-- 
tejun
