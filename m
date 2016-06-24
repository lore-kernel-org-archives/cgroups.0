From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] cgroup: pids: show number of failed forks since
 limit reset
Date: Fri, 24 Jun 2016 11:31:51 -0400
Message-ID: <20160624153151.GQ3262@mtj.duckdns.org>
References: <20160624030049.13341-1-asarai@suse.de>
 <20160624030049.13341-2-asarai@suse.de>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LJMEeQinl3TCUG4hw6RZAZLm7uQdMmn4vYKyJzgxgrU=;
        b=uzriPShavCrZu2SQsOoc8YR2i37BlBsfVxt3jiUpowziKvqPt121chHJXzhG++SvHz
         6OfqPfzVYOAEl6hb9Njv8aPfplLSAdxnddOSwjqr/mqA4UcdjHCfUH91Tosq/IFNizsa
         x+YuXIFyI3KwKMfqFB3fupmGSTRKP6V5VUsVUQOXyTlDTq7m8EWAjWlaY3+gzf4vIJCo
         qnodYGI81BSqUzE8PZ+6NzNDmpuSExDO773KsXTLon+FpabZh44zclxYxk+8u2jVmLxt
         bOg1yv3IQV6a1TEU6x3F2pvpPFsrCh2AYFL81hREnLLD3APJ/nDcq1JjCOjYAQmN3D5V
         7peg==
Content-Disposition: inline
In-Reply-To: <20160624030049.13341-2-asarai@suse.de>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Kenny Yu <kennyyu@fb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Fri, Jun 24, 2016 at 01:00:48PM +1000, Aleksa Sarai wrote:
> This allows users to dynamically adjust their limits based on how many
> failed forks happened since they last reset their limits, otherwise they
> would have to track (in a racy way) how many limit failures there were
> since the last limit change manually. In addition, we log the first
> failure since the limit was reset (which was the original semantics of
> the patchset).

Isn't that trivially achievable by reading the counter and then
calculating the diff?  I don't think it matters all that much whether
the log message is printed once per cgroup or per config-change.  It's
just a hint for the admin to avoid setting her off on a wild goose
chase.

Thanks.

-- 
tejun
