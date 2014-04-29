From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Protection against container fork bombs [WAS: Re: memcg with
 kmem limit doesn't recover after disk i/o causes limit to be hit]
Date: Tue, 29 Apr 2014 18:51:16 +0200
Message-ID: <20140429165114.GE6129@localhost.localdomain>
References: <20140420142830.GC22077@alpha.arachsys.com>
 <20140422143943.20609800@oracle.com>
 <20140422200531.GA19334@alpha.arachsys.com>
 <535758A0.5000500@yuhu.biz>
 <20140423084942.560ae837@oracle.com>
 <20140428180025.GC25689@ubuntumail>
 <20140429072515.GB15058@dhcp22.suse.cz>
 <20140429130353.GA27354@ubuntumail>
 <20140429154345.GH15058@dhcp22.suse.cz>
 <CAO_RewYZDGLBAKit4CudTbqVk+zfDRX8kP0W6Zz90xJh7abM9Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=m5WOYY5HOp173G3voapZGBSw3W62+oSndqgsUNAQXHU=;
        b=QzZBmuBDVL3vtELJUB3nYVMAPF2HurwVfp8H0ifbVaLIjx6yqhXNC4tMPFJWCZEVja
         OO9WptJqA2YwcOYFnBjyzFe3bDzkE8bLnDXOGzmUItEGB/jnRh0MCq1VIRqiRjtYAQDQ
         uVVIkgw6jXEfK3+Sptg3HCRVeiM9LEIAlz04g4e8pCJ8HAi9lCllERZCazgFbLU/qRdf
         ZADjCjlsxmilo0sld02xKTzthwyfPN4LtfQlDPyFYBJnJIxy5FWJCi3I9L0wGyMSpkbz
         dEp0/XS992vDWx0eB3jq6J8JL8EWNaeTLV5V1oMwcfBOgK1B84EFRFvH0CjDt2NzVjp9
         vvnA==
Content-Disposition: inline
In-Reply-To: <CAO_RewYZDGLBAKit4CudTbqVk+zfDRX8kP0W6Zz90xJh7abM9Q@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Serge Hallyn <serge.hallyn@ubuntu.com>, Richard Davies <richard@arachsys.com>, Vladimir Davydov <vdavydov@parallels.com>, Marian Marinov <mm@yuhu.biz>, Max Kellermann <mk@cm4all.com>, Tim Hockin <thockin@hockin.org>, containers@lists.linux-foundation.org, Daniel Walsh <dwalsh@redhat.com>, cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, William Dauchy <wdauchy@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>

On Tue, Apr 29, 2014 at 09:06:22AM -0700, Tim Hockin wrote:
> Why the insistence that we manage something that REALLY IS a
> first-class concept (hey, it has it's own RLIMIT) as a side effect of
> something that doesn't quite capture what we want to achieve?

It's not a side effect, the kmem task stack control was partly
motivated to solve forkbomb issues in containers.

Also in general if we can reuse existing features and code to solve
a problem without disturbing side issues, we just do it.

Now if kmem doesn't solve the issue for you for any reason, or it does
but it brings other problems that aren't fixable in kmem itself, we can
certainly reconsider this cgroup subsystem. But I haven't yet seen
argument of this kind yet.

> 
> Is there some specific technical reason why you think this is a bad
> idea?
> I would think, especially in a more unified hierarchy world,
> that more cgroup controllers with smaller sets of responsibility would
> make for more manageable code (within limits, obviously).

Because it's core code and it adds complications and overhead in the
fork/exit path. We just don't add new core code just for the sake of
slightly prettier interfaces.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
