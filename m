From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Query regarding deadlock involving cgroup_threadgroup_rwsem and
 cpu_hotplug_lock
Date: Wed, 27 Jul 2022 09:33:24 -1000
Message-ID: <YuGTBLkFerUboctl@slm.duckdns.org>
References: <8245b710-8acb-d8e6-7045-99a5f71dad4e@oracle.com>
 <26d0e4cc-be0e-2c12-6174-dfbb1edb1ed6@oracle.com>
 <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com>
 <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
 <YthDz4BnfYHce1od@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=84;0;0cto:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:from:date:sender:from:to:cc;
        bh=6pnTblxCyJMu4c6E/4UqG0qh2Y7YbnKnimTleXn2d64=;
        b=JrjKtZg0AWloTpMMF1BWDJo8qbcS/l1KoteqVQntHR87K9jNSXqRl1tmDCq7pgkQ7Y
         W5UoJsZ8ypj+r8vmNk7aXOoh1fPNs5umdWf4mdKl7PqRFbzlxlEIb2S4HIjaYZCxMA+z
         g7/9MYr9YNJP1OFIYZb8qpI34w15h3v8rA5QtBfEu57mL+J0uLkAxz0sYTzfhFVQ08Q+
         9E8G3lgnEEzxX+r1ZNlVg1h90WP3uVjsM7oQeNCm1MWCpKjDc0nTLcY/dsMgZV6JBtIt
         8LzxiF7pv6ihLoNey3IiHkBANXEL7CSaQ9fHIFxA8f/qt2F9Nbg9jh/jQGTP1f8zYVOP
         5nTQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YthDz4BnfYHce1od-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 20, 2022 at 08:05:03AM -1000, Tejun Heo wrote:
> On Wed, Jul 20, 2022 at 05:31:51PM +0530, Mukesh Ojha wrote:
> > Looks like these patches are the fixes.
> > 
> > https://lore.kernel.org/all/YtDvN0wJ6CKaEPN8-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/#r
> > 
> > Would let Tejun confirm this .
> 
> Yeah, looks like the same issue. I'll write up a patch later this week /
> early next unless someone beats me to it.

https://lore.kernel.org/lkml/20220705123705.764-1-xuewen.yan-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org/ is
the thread with the same issue. Let's follow up there.

Thanks.

-- 
tejun
