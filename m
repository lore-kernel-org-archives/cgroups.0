From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Tue, 5 Apr 2022 12:09:06 +0200
Message-ID: <20220405100906.GB13806@blackbody.suse.cz>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <CAAPL-u8g2qkhdTQtFtBS3GNYz0WnyahWEXvR4g_OSaKv+7EozA@mail.gmail.com>
 <YkcYq8F6MYlMi+yS@cmpxchg.org>
 <CAAPL-u-za-TTyyC5uMVev9eQyhxZS7q3pVqaUxCFjqk+Sv9+ig@mail.gmail.com>
 <CALvZod4-fKfv6vbZPZ3nCE=Bue4FUnC+9t27wsznmyd+JKgDbg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649153348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s2JAhA7wRXjstDGSBxsda1XlMcvrnOLvDvnRGSGBhWQ=;
        b=VUzkhbo1IP8rBXBSTb+xi5+IO+JKiwE8GKiq1RV8GvLLp621TtLgWINmac+lMjA3AxHC7/
        U+KDroTz7bzqhgUsS1Gvm4ACqI7ELwJOUTcIP0zkEutls9EakN7ohOic0E9tlWNymY7qr2
        xEeaJnx+CzP6OJK8UrMwCtA0b8swnf8=
Content-Disposition: inline
In-Reply-To: <CALvZod4-fKfv6vbZPZ3nCE=Bue4FUnC+9t27wsznmyd+JKgDbg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Cgroups <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Greg Thelen <gthelen@google.com>

On Mon, Apr 04, 2022 at 10:08:43AM -0700, Shakeel Butt <shakeelb@google.com> wrote:
> What would be the challenge on returning the number of bytes reclaimed
> through cgroup interface?

You'd need an object that represents the write size:

> bfd = open("/sys/kernel/mm/reclaim/balloon", O_RDWR);
> dprintf(bfd, "type=file nodemask=1-2 timeout=30\n")
> 
> fd = open("/sys/kernel/fs/cgroup/foo/memory.reclaim", O_WRONLY);
> reclaimed = splice(bfd, NULL, fd, NULL, reclaim_size);

(I'm joking with this API but it is a resembling concept.)

Michal
