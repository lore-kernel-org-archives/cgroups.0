From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 10/11] mm, memcg: add memory.oom_control notification for
 system oom
Date: Thu, 6 Mar 2014 16:15:06 -0500
Message-ID: <20140306211506.GD17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403041957140.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0IbXMSxiFVy+amaDjGZWE5CZ8HmSbg6oavMghoDPBx4=;
        b=I+hDg+YmfQHdhcnhm8NY7xC6+VBhvTyd0BHzpp+AbNu09Hgkn6gLkHI5NsDVxDBsVn
         qYn9U5jM5yVMRuKYSxatJp1BQdeLZNVTCxMxhNWdRkJ542rLCxTpj988OgeO6Cb0ahga
         UHVW5Ca5F+RW/HMzd73D8p/EGRgSma7VQaSQm6JEYb7KTgFK8pbud013otd/ChvSwCtl
         yRk5fMp26D0sns7f76WHuSp13saZeg/YgZTuZn9Rd5fDRSQIrJjqYAVj1i9onJAiZ5Sm
         huboQKIpXaz31ELNzD3unIzngOeSJfOeHyofxhC3ydZZuC6ioGI0AyqAbMopdklD4xkG
         ji7w==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041957140.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Tue, Mar 04, 2014 at 07:59:41PM -0800, David Rientjes wrote:
> Now that process handling system oom conditions have access to a small
> amount of memory reserves, we need a way to notify those process on
> system oom conditions.
> 
> When a userspace process waits on the root memcg's memory.oom_control, it
> will wake up anytime there is a system oom condition.
> 
> This is a special case of oom notifiers since it doesn't subsequently
> notify all memcgs under the root memcg (all memcgs on the system).  We
> don't want to trigger those oom handlers which are set aside specifically
> for true memcg oom notifications that disable their own oom killers to
> enforce their own oom policy, for example.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Until consensus on the whole approach can be reached,

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
