From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 2 Mar 2015 11:09:03 -0500
Message-ID: <20150302160903.GE17694@htj.duckdns.org>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
 <1424882288-2910-3-git-send-email-riel@redhat.com>
 <54EEFE15.3010005@huawei.com>
 <20150226121231.6fcba7e8@annuminas.surriel.com>
 <20150302090933.GH21418@twins.programming.kicks-ass.net>
 <1425300290.5863.17.camel@gmail.com>
 <20150302152924.GD17694@htj.duckdns.org>
 <1425312177.12094.15.camel@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/rvn10bL/i2CCz4dRcFECCPlCQ6/4eVNLqG2M/2q1X0=;
        b=n6QpNBU/shXfcnhVkldkj7hMmNJPBq4j1CSoQOjyeHYAZPUsQexa5NrrugmV4oGyiF
         CPRAr2OSBnWcY8kwGB3Nq7TbY+MbFo7ccVzXdlycW8PzGZUsFsXYdLGw29iH4gTXTDOl
         73oZokdXHmnajEmFtHk5rPzJ6vTogSVYX7C9HGzgiP/X64Cg+tdiqiHIT1ekFmvSl7Bl
         2LGRj9LVp6XIIZSHVma45NT2zScoTqgXfY8FTa4RQBV7oavmOmYBnMq8IbYn9CmuO/za
         l08ZkHqESfFXBLmXf2xN+zIBngjxBqlJlEhGAuO7crGEbY+U0CqEKgVkS43ja8LFU3UO
         3iqw==
Content-Disposition: inline
In-Reply-To: <1425312177.12094.15.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 02, 2015 at 05:02:57PM +0100, Mike Galbraith wrote:
> Well, those are the only ones we can do anything about.  Dirt simple
> diddling of the workqueue default mask as sched domains are
> added/removed should do it I think.  Automatically moving any existing
> unbound worker away from isolated cores at the same time would be a
> bonus, most important is that no new threads sneak in.

Worker pools are immutable once created and configuraiton changes are
achieved by creating new pools and draining old ones but at any rate
making it follow config changes is almost trivial.  Figuring out
configuration policy might take a bit of effort tho.  Can you point me
to what specific configuration it should be following?

Thanks.

-- 
tejun
