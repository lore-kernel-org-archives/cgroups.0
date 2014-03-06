From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 00/11] userspace out of memory handling
Date: Thu, 6 Mar 2014 15:49:23 -0500
Message-ID: <20140306204923.GF14033@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GZgSmxHwzsLL5uiffmmyXZ8RKJ4cAMkpXt8S8M2mARg=;
        b=GyrU7kF2zx8+2/pVZp5hniNKE2iJ41lVD1H6IT88FCzy1LkpCTsdODiFZVVLJoUCEd
         u+WFq20rmgia5IxGMQS2M/32UB9iKvIzi9oJKdIiwPPcvK1oh2fo52/0xiEy8UNwGnR3
         qDWzdpMtRIRLyZpwilIoA0hUjGAk46wUU1y4as0KXO9nWz7vkVJ9ZzvJovmxlIC4/8Nr
         sRjmqIwYsq0vPITMh7N5FTL2jdKbYfOMSE/T2cEsyyT8PoXsshveYI2w97URIJTMuaPY
         ySz5Evf+dUbevOdw0qJIsCDu3H2drqVa9JuUp2IhEvglQYYF9BulkqtmZfPZvw8ep5k2
         CzgA==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Tue, Mar 04, 2014 at 07:58:38PM -0800, David Rientjes wrote:
> This patchset implements userspace out of memory handling.
> 
> It is based on v3.14-rc5.  Individual patches will apply cleanly or you
> may pull the entire series from
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git mm/oom
> 
> When the system or a memcg is oom, processes running on that system or
> attached to that memcg cannot allocate memory.  It is impossible for a
> process to reliably handle the oom condition from userspace.

ISTR the conclusion last time was nack on the whole approach.  What
changed between then and now?  I can't detect any fundamental changes
from the description.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
