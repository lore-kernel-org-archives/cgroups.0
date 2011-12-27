From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Date: Tue, 27 Dec 2011 08:35:35 -0800
Message-ID: <20111227163535.GA17712@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=T/XfaeTGAy34McVIG2lLHQzulksCmRLk9JvyUzXGZD8=;
        b=hHO3edatOMps0HAGq8AafzJYJHqqTMe5Y9sIyyX8DMr3VJkQuOodarBwNroSCSWeqp
         ZE0q+dgalZfFcniX5lWqzUa3O8nMeMFMhltsr67Sj/gn/IV5Efay1Wpe1a883riRHgEK
         N/dZNtnxrbA3qYSHsCFvCG/veQPnNfqBUmcsM=
Content-Disposition: inline
In-Reply-To: <4EF9291D.7030208-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Tue, Dec 27, 2011 at 10:10:37AM +0800, Li Zefan wrote:
> If we mount a hierarchy with a name specified, the name is unique,
> and we can use it to mount the hierarchy without specifying its
> set of subsystem names. This feature is documented is
> Documentation/cgroups/cgroups.txt section 2.3
> 
> Here's an example:
> 
> 	# mount -t cgroup -o cpuset,name=myhier xxx /cgroup1
> 	# mount -t cgroup -o name=myhier xxx /cgroup2
> 
> But it was broken by commit 32a8cf235e2f192eb002755076994525cdbaa35a
> (cgroup: make the mount options parsing more accurate)
> 
> This fixes the regression.

Hmmm... so that has been broken over a year and nobody complained?  Is
there any valid use case where specifying mount path as all other
filesystems wouldn't work?  Is this 'name' thing necessary at all?
Maybe we should rip it out instead of fixing it?  We can just leave it
as non-functional name which does nothing but being visible in mount
listing.

Thanks.

-- 
tejun
