From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] memcg: Limit the number of events registered on
 oom_control
Date: Wed, 7 Aug 2013 10:01:03 -0400
Message-ID: <20130807140103.GH27006@htj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
 <20130807130836.GB27006@htj.dyndns.org>
 <20130807133746.GI8184@dhcp22.suse.cz>
 <20130807134741.GF27006@htj.dyndns.org>
 <20130807135734.GK8184@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=sCTdI0Y6OUG+oOwwDc/akoQ088K8L/LxnQCmH7mJLnc=;
        b=UAiUr3vFr/DCCJbcs1RbYgzfEcn/yNkLOI5BQXKJLQZBdWCSvrPQoexoU3zO4QRzLz
         RD1BShUbD5fQgy/bV5jdlzKuvdut0UoZO1lgA8S3f2faLndXvMGHo2TCRUOGy6KyryHY
         bowDdcvFsGLj52o9DhQBaah6Jb/AF198PXZtfCZb4jCs/sl3P9c0SzpJ1gMBGaCp3WY5
         ypmo+3LMqeeDyjohUQzLqdDkcf7SbRq7UOii2LVkdY0ziu/+XHpRzyynyQ5A/CqH803L
         SyT5zobdJ6Fjmw0oOmHUlP82T+7PFFRzwNpe0/5nYaeq+xWM34F42AiO/UV/ncKxaUrE
         q2mg==
Content-Disposition: inline
In-Reply-To: <20130807135734.GK8184@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Anton Vorontsov <anton.vorontsov@linaro.org>

On Wed, Aug 07, 2013 at 03:57:34PM +0200, Michal Hocko wrote:
> On Wed 07-08-13 09:47:41, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Aug 07, 2013 at 03:37:46PM +0200, Michal Hocko wrote:
> > > > It isn't different from listening from epoll, for example.
> > > 
> > > epoll limits the number of watchers, no?
> > 
> > Not that I know of.  It'll be limited by max open fds but I don't
> > think there are other limits. 
> 
> max_user_watches seems to be a limit (4% of lowmem in maximum).

That's per *user* not per event source.  The problem here is creating
a global (across securit domains) resource shared by all users.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
