From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 04/11] mm, memcg: add tunable for oom reserves
Date: Thu, 6 Mar 2014 16:04:27 -0500
Message-ID: <20140306210427.GH14033@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403041955050.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lhH9yLSyHHlCJ48ic+/5geF8HjLbXuJAEzya6xR00MA=;
        b=DgVcOVCm2boSVAUpNUMYuHH12yMqfcC/prMnmyvVeAXSOMkiAOoMzxyCltRPC6g/bD
         jFkV6ZnWAQu2SOzU/2G8oS+Bts2I8gTAgXtkfOnRgl0G3Kov/hxv35KWoREvOjkrkuf3
         DDknFoJrLNApDCzmzIic8iZMYdXY/dE7xEAKdrAPoXeUDH7uWR/CBCxOoWZv3mbnFR5s
         sSMSB3iyZZoLU6OW37jlNQEI+BGb02tUj/dUA0i2ehAJ1GkjN36WOeY+niUCTTtR6BN5
         4NuvfXMbz0DF8KQG2v5tpWkCbQcZRK+d9TLcm/bMjT6q/aZN1onSHj77oHjQI5tFyXZ6
         44Pw==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041955050.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Tue, Mar 04, 2014 at 07:59:19PM -0800, David Rientjes wrote:
> Userspace needs a way to define the amount of memory reserves that
> processes handling oom conditions may utilize.  This patch adds a per-
> memcg oom reserve field and file, memory.oom_reserve_in_bytes, to
> manipulate its value.
> 
> If currently utilized memory reserves are attempted to be reduced by
> writing a smaller value to memory.oom_reserve_in_bytes, it will fail with
> -EBUSY until some memory is uncharged.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

We're completely unsure this is the way we wanna be headed and this is
a huge commitment.  For now at least,

Nacked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
