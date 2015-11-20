From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/7] kernfs: implement kernfs_walk_and_get()
Date: Fri, 20 Nov 2015 16:12:54 -0500
Message-ID: <20151120211254.GE1574@mtj.duckdns.org>
References: <1447959171-20749-1-git-send-email-tj@kernel.org>
 <1447959171-20749-3-git-send-email-tj@kernel.org>
 <20151120044104.GA10693@kroah.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=3L5MkjvcwYIzeZUP42cBLCK5p6DWMp4XcHlAybY1ip4=;
        b=Od+faykgHYMp6l4F6ouW3L6YU+QZpLfGHrFyx1lG7twDjz6KoiDiuju9IpshmlajkG
         +fJ01QkHmdrdR31M/DbNFL6YTnKS25cOq2QukwJf/RFchJz78uDSfJWD5rcnkkDXVa2G
         vVyFqw7WEJHB8kMLVacLtJepCNJnMVxKL/M93KUa9fBt710GqwlZFyrU/z2HZ/qpKBpg
         +YC0Uosp9CIAmjmSIPmQb96YamuQTVb6YRpMyxlCrjkGnmEv1SpWCZ9UiMq7B5N+pTWa
         amIllu1HZOd2QgNDe9bmqNcfIWz0k5IUsSJ9xNl6hPd85kwgBTP3k9fQ8VxNqCm37fNU
         s3zA==
Content-Disposition: inline
In-Reply-To: <20151120044104.GA10693@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: davem@davemloft.net, pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu, lizefan@huawei.com, hannes@cmpxchg.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, daniel@iogearbox.net, daniel.wagner@bmw-carit.de, nhorman@tuxdriver.com

On Thu, Nov 19, 2015 at 08:41:04PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Nov 19, 2015 at 01:52:46PM -0500, Tejun Heo wrote:
> > Implement kernfs_walk_and_get() which is similar to
> > kernfs_find_and_get() but can walk a path instead of just a name.
> > 
> > v2: Use strlcpy() instead of strlen() + memcpy() as suggested by
> >     David.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: David Miller <davem@davemloft.net>
> > ---
> >  fs/kernfs/dir.c        | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/kernfs.h | 12 ++++++++++++
> >  2 files changed, 58 insertions(+)
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Greg, would it be okay to route this one through either cgroup or net
tree?

Thanks.

-- 
tejun
