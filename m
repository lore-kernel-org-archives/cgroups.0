From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: cleanup comments
Date: Sun, 13 Mar 2022 19:20:28 -1000
Message-ID: <Yi7QnANYByb+8aSS@slm.duckdns.org>
References: <20220305204657.707070-1-trix@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ziHLpQ3BSJG9uN5+hBB/K6gEy6fyUA7DHi/ja3cIYfM=;
        b=q00xIdHjpKrgKFRyR7NWEIHcwWV9iQlp7ojYRaJVhqNPsW8IakgsMbDhLXKoO2fyMm
         L40MTzx1rNEjjJ+CzfnU3WMxC5v7DI8cQtMqPxxvQZFC9+5LKhGXRghAOSvSUC1jqjdK
         4aa6E9xjaNtqVpZmwcBYJwXWsxu5e9Cn8zLt9bieBt4Kawq1UgTrW0MjTNLKZxeMNO99
         /vdOQN2yQS+f+1MgrodpMUb4Zjj8qVz7yVFH/40/9ocAejfaX0SbcFtwsmfmC3j7HhKM
         AteOHOZv8LgeY609Eka+n4NfJOwKapW1PWiYuHvofNlQQG5jcPkCnD5RFFgaO773uoFp
         Kinw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220305204657.707070-1-trix@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trix@redhat.com
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Mar 05, 2022 at 12:46:57PM -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> for spdx, add a space before //
> 
> replacements
> judgement to judgment
> transofrmed to transformed
> partitition to partition
> histrical to historical
> migratecd to migrated
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied to cgroup/for-5.18.

Thanks.

-- 
tejun
