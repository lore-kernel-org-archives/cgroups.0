From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol: return 1 from cgroup.memory __setup()
 handler
Date: Thu, 3 Mar 2022 23:32:32 +0100
Message-ID: <YiFCAFZwG//aeQP2@blackbook>
References: <20220222005811.10672-1-rdunlap@infradead.org>
 <20220302185300.GA19699@blackbody.suse.cz>
 <9f8d4ddb-81ce-738a-d1f7-346ff9bf8ebd@infradead.org>
 <20220303101406.GE10867@blackbody.suse.cz>
 <5130da56-0f22-8212-0ea3-6ddb8a8f5455@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646346754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zAFiVjWnJwrSeWw65bTJP2sI95/1TY2jdAcpRUDQbtM=;
        b=VXV9PxiWVt8ldki0V+S8Sfj7c687p9Om5DqH1miJtWATf4hOxUPcw4msG056PF7h12uXyy
        GWj1nCH353Ix4TRBSPj5zbqaiNNKWcpteUC6PB+wNzUtAyrK9wDUgyAz+Iitv1dv9f5T6o
        RcbOrMACuKsRmhFFczzmGXgR6mCyiAw=
Content-Disposition: inline
In-Reply-To: <5130da56-0f22-8212-0ea3-6ddb8a8f5455-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Igor Zhbanov <i.zhbanov-4G3FwjhnV40EXkLx5dDeUA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 03, 2022 at 01:53:03PM -0800, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > Isn't mere presence of the handler sufficient to filter those out? [1]
> 
> What is [1] here?

Please ignore, too much editing on my side.

> I don't know of any case where "foo=2" should be passed to init if
> there is a setup function for "foo=" defined.

Good. I was asking because of the following semantics:
- absent handler -- pass to init,
- returns 0 -- filter out,
- returns negative -- filter out, print message.

> > (Richer reporting or -EINVAL is by my understanding now a different
> > problem.)

Regards,
Michal
