From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 4/4] blk-cgroup: Document the design of new lockless
 iostat_cpu list
Date: Thu, 2 Jun 2022 09:05:14 -1000
Message-ID: <YpkJ6rDTR24ScuEq@slm.duckdns.org>
References: <20220602133543.128088-2-longman@redhat.com>
 <20220602185401.162937-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ErkdigvWJC7gN35TT0Xai2a2txPxDnW6A23kYtrzY/M=;
        b=NNZemRytfEOcVt9JCTksweDQQDt81iD8tK+Ty4aZJywf8A7xvEXGpdyZF6PH87xFnr
         8dZwvXFWWQy8oU9PeEZMDpmwEiasGU8yj1jZEZ72W/V9rbsCPw4qtl5+Gil3MfPROT4X
         tmf5gxBDK8odvuXWg8zyxNwf1ktizZcbcP8wzxGlt2kBYuDCp3jk1TgjI+EtocvTW5ju
         mSJv+h/dHVcy9ufFRY8gy1Eb0MPqjZL0vW5yim5PxacPhhL0LqkICfdUMeiqK7QRMwan
         rC0uEztTTcXSodh4PcYysHxue8AAl5rIHTM6YjJh+CV7vEh7obsvjqJZYb9uTbIYB2rN
         YdTw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220602185401.162937-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Thu, Jun 02, 2022 at 02:54:01PM -0400, Waiman Long wrote:
> A set of percpu lockless lists per block cgroup (blkcg) is added to
> track the set of recently updated iostat_cpu structures. Add comment
> in the code to document the design of this new set of lockless lists.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
