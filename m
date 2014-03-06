From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 00/11] userspace out of memory handling
Date: Thu, 6 Mar 2014 16:29:38 -0500
Message-ID: <20140306212938.GF17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <20140306204923.GF14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com>
 <20140306205911.GG14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061301020.25499@chino.kir.corp.google.com>
 <20140306211136.GA17902@htj.dyndns.org>
 <alpine.DEB.2.02.1403061312020.25499@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OWV29C0pMJ698UITZKlPhZ68i2mHLDfTysGMvlcyb3c=;
        b=KAj6F4CAqpwlhwdOW4wZItRqeg5YxTBSLgJ8Qxh2FsvjJlIRXQthIXhpu7Kxt6IQ6D
         uylzHRJEAD7TuQu9Hyi7HKDhWInd2rm0/3Wrls9m2qH0UkYR5K4EBQvq3vScaK7bdC5Z
         6vaIZPbdgc3bajg7dmKFck0IkERK2Ac542SHIDbyvaULxCMxyfb2VUsSmGqrz0BjeJZA
         39t8m4DsN8F2yuneiJGt+euFkXjaLtdfJUntekN5QLUXXh5AoMsv0wKpuu37dRSCQFHT
         9EkO3M+KffXQbrLcxUvXjRqxEXgu5u4iH/M8DmWVlpqpVZKCxHHIjnexfoPu8VOmlnd0
         ZvVg==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403061312020.25499@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Thu, Mar 06, 2014 at 01:23:57PM -0800, David Rientjes wrote:
> I'm referring to system oom handling as an example above, in case you 
> missed my earlier email a few minutes ago: the previous patchset did not 
> include support for system oom handling.  Nothing that I wrote above was 
> possible with the first patchset.  This is the complete support.

But we were talking about system oom handling.  Yes, the patch didn't
exist back then but the fundamental premises stay unchanged.  There's
no point in restarting the whole thread.  You can refer to this
patchset from that thread.  It's a logical thing to do.  We have all
the context there.  I don't really understand why you're resisting it.
It doesn't change the basis of the discussion.  The issues brought up
before should still be addressed and it only makes sense to retain the
context.

If you have more to add, including the existence of this
implementation, let's please talk in the original thread.  It was long
thread with a lot of points raised.  Let's please not replay that
whole thread here unnecessarily.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
