From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 00/11] userspace out of memory handling
Date: Thu, 6 Mar 2014 12:55:43 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com> <20140306204923.GF14033@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=/rH/W7wB8/BuG5WVyIWnIZI0kkYyg200n2zvSeB/Qrs=;
        b=oFBX7xUlmifYHHDsW9jWRYcrakwHBQu53VRAyQ2j8q0ZO6DglxB9AjAitSe+Ix2yUE
         cBwA6Ag/DqG4SgKHO5tdpGwppRZMhBXfQGk+xaaPA8LQW+vOQdgNq/dvczjd1pGA1N4h
         8Hh28xUoGlvxcQmAWYy7EXvDRL3YNNqQNe8tFLjzUpX3poF89ByUD2QM9qCoqhKh/FEs
         WQ42nfswt1IoYiUOPPCe5IeDAMtV/2/G3g2fFU6fsBFpTH2FMNnoUM9++NhPrP0oAvxX
         BAVQQB3QB6xu4uy2MNaUzrtL28yt7ZBtX8FSpwyjcg7ViLNN706Hvp+90eC8l89LJ9Rd
         7tPQ==
In-Reply-To: <20140306204923.GF14033@htj.dyndns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Thu, 6 Mar 2014, Tejun Heo wrote:

> On Tue, Mar 04, 2014 at 07:58:38PM -0800, David Rientjes wrote:
> > This patchset implements userspace out of memory handling.
> > 
> > It is based on v3.14-rc5.  Individual patches will apply cleanly or you
> > may pull the entire series from
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/rientjes/linux.git mm/oom
> > 
> > When the system or a memcg is oom, processes running on that system or
> > attached to that memcg cannot allocate memory.  It is impossible for a
> > process to reliably handle the oom condition from userspace.
> 
> ISTR the conclusion last time was nack on the whole approach.  What
> changed between then and now?  I can't detect any fundamental changes
> from the description.
> 

This includes system oom handling alongside memcg oom handling.  If you 
have specific objections, please let us know, thanks!
