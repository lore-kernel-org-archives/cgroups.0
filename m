From: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: Use fallthrough;
Date: Mon, 9 Mar 2020 15:20:46 +0900
Message-ID: <20200309062046.GA46830@google.com>
References: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
 <20200308031825.GB1125@jagdpanzerIV.localdomain>
 <5f297e8995b22c9ccf06d4d0a04f7d9a37d3cd77.camel@perches.com>
 <20200309041551.GA1765@jagdpanzerIV.localdomain>
 <84f3c9891d4e89909d5537f34ea9d75de339c415.camel@perches.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g75Qh0w0IMlX/zV9hQvw54yKT3VrtMDkZu/Q14Db4QQ=;
        b=oLuNqixNl1JxNVT152qOq/xNxOVKrrzZ6dbHvCBWH/+3doPheUSai4W8Asav3nC6uU
         qdEv2xwxy2lA/KdtQMkqQ5FFkvz4Q5F7Cq598Htvjw6tVym6ZXB5wFlesntytgI8+TSj
         3T0R+fC5Fyk9OrD2EaoizKfpnsFYktFYpsuD8L4qYUQvATxVO8f5L1/ezu7ZNh8U4a47
         4XEYWEVzUzKzoycFQQi+5nySgzPSrZQWph39MGZ5OJMn2QV0b/knhiraNQexExmY02pg
         yI5Ed4aPCD/hqzR2JiRjsQhrkwxv8OVH12+aZ9NL25gytbe/L7taOxw0caVyRszKWETB
         kR8w==
Content-Disposition: inline
In-Reply-To: <84f3c9891d4e89909d5537f34ea9d75de339c415.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On (20/03/08 21:51), Joe Perches wrote:
> On Mon, 2020-03-09 at 13:15 +0900, Sergey Senozhatsky wrote:
> > On (20/03/07 19:54), Joe Perches wrote:
> > > On Sun, 2020-03-08 at 12:18 +0900, Sergey Senozhatsky wrote:
> > > > On (20/03/06 23:58), Joe Perches wrote:
> > > > [..]

[..]

> > > Consecutive case labels do not need an interleaving fallthrough;
> > > 
> > > ie: ditto
> > 
> > I see. Shall this be mentioned in the commit message, maybe?
> 
> <shrug, maybe>  I've no real opinion about that necessity.
> 
> fallthrough commments are relatively rarely used as a
> separating element between case labels.
> 
> It's by far most common to just have consecutive case labels
> without any other content.
> 
> It's somewhere between 500:1 to 1000:1 in the kernel.

I thought that those labels were used by some static code analysis
tools, so that the removal of some labels raised questions. But I
don't think I have opinions otherwise.

	-ss
