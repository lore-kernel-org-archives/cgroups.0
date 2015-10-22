From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4 3/3] cgroup: replace unified-hierarchy.txt
 with a proper cgroup v2 documentation
Date: Fri, 23 Oct 2015 00:29:26 +0900
Message-ID: <20151022152926.GH30579@mtj.duckdns.org>
References: <20151022012212.GA20931@mtj.duckdns.org>
 <20151022012302.GB20931@mtj.duckdns.org>
 <20151022012354.GC20931@mtj.duckdns.org>
 <20151022143427.GC20847@redhat.com>
 <20151022143605.GE30579@mtj.duckdns.org>
 <20151022144221.GD20847@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=tvkaqlsvMGjXR4EXxrUDmyN2obLitoXZbaisaHIoYdA=;
        b=thQXQDNmZq4jfCeToH0UNLDcDE0R/+1PGReTXC9pS0obshE5JtiOwrAIhUkgNR4c3m
         eaQnum1aElb0UmHdf7rpjRSWUjH6BUzPta3Klg+Xak23xCt9AWj6vEL+WzWeovPBq/19
         sX7o1hbk8FqXRHkB/QdapIbDWvNlPLzMmtyxu51TPeIldOIBgYwE5bGqhT+gols0OSv1
         9x2sthHt87ZTv3mUcSyhrcVQFUGfeOEtSL8fXc7+tUTn5yUxv095NdnG25Vv6AZ8SDCx
         wGtoPfFZrkYxlSvZq5P6ShRY81aSq05CFkBZMBBUbiQ/vwNRwImkzOGeJ7RozmIv8Mtz
         A0FQ==
Content-Disposition: inline
In-Reply-To: <20151022144221.GD20847-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Thu, Oct 22, 2015 at 10:42:21AM -0400, Vivek Goyal wrote:
> > It works with ext2 and 4 and btrfs.  Will document it.  Thanks.
> 
> Oh, nice. Are there any plans to make it work with xfs too?

Hmmm... not right now but it shouldn't be *too* difficult to add.

Thanks.

-- 
tejun
