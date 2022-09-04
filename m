From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: add pids.peak interface for pids controller
Date: Sun, 4 Sep 2022 09:27:21 -1000
Message-ID: <YxT8GdAtMfZBOQgg@slm.duckdns.org>
References: <20220831224903.454303-1-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=hhOqEPi04AV0wzekaFieSTX5YqMIIS7ffO//I6J4RAA=;
        b=FEZwae9/shgAqtAoz1u27GSJjFWXeDqCSu1PMccOHcDQGVz5GYgDAzszVgxLj8iOaN
         +4a/mXPUPzWnZ/1pi7uSLMGBu6MIUap1IcF77lgwifRAdKKCVSTDN6JKxJpyD3YDT3qo
         0WSZf66SAVbfDjeVLGNMpiJoZSZuGl7hizBxZFoHQhsWbJbZJX1+eFgknt1yhiRo0kiW
         WHX5qZrHY0yLkrFdFhAH2DQwCXZkmt4oIKNTbojp889xacGf5uMxhRXzazD7mBmY8N49
         CRi/m0I1/MneBQ+MyLFdD7arbFBzRmE/XIhzduSiPDK7SW23TUukKKKXcVZdGQMJckAW
         g17Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220831224903.454303-1-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 31, 2022 at 03:49:03PM -0700, Josh Don wrote:
> pids.peak tracks the high watermark of usage for number of pids. This
> helps give a better baseline on which to set pids.max. Polling
> pids.current isn't really feasible, since it would potentially miss
> short-lived spikes.
> 
> This interface is analogous to memory.peak.
> 
> Signed-off-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.1.

Thanks.

-- 
tejun
